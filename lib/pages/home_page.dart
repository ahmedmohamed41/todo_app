import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/constaints.dart';
import 'package:todo_app/modules/archived_task/archived_task_screen.dart';
import 'package:todo_app/modules/done_task/done_task_screen.dart';
import 'package:todo_app/modules/new_task/new_task_screen.dart';
import 'package:todo_app/shared/custom_text_from_filed.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int value = 0;
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isShowBottomSheet = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  List<Widget> listScreen = const [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> listTitle = const [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(
          listTitle[value],
        ),
      ),
      body: ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) => listScreen[value],
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: appbarColor,
        onPressed: () {
          if (isShowBottomSheet) {
            if (formKey.currentState!.validate()) {
              insertDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                Navigator.pop(context);
                setState(() {
                  isShowBottomSheet = false;

                  setState(() {
                    fabIcon = Icons.edit;
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState!
                .showBottomSheet(
                  (context) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextFormField(
                            prefixIcon: const Icon(
                              Icons.title,
                            ),
                            controller: titleController,
                            inputType: TextInputType.text,
                            labelText: 'Task Title',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'title must not be empty';
                              }
                              return null;
                            },
                          ),
                          CustomTextFormField(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text = value!.format(context);
                                print(value.format(context));
                              });
                            },
                            prefixIcon: const Icon(
                              Icons.timer,
                            ),
                            controller: timeController,
                            inputType: TextInputType.text,
                            labelText: 'Task Time',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Time must not be empty';
                              }
                              return null;
                            },
                          ),
                          CustomTextFormField(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2025-05-03'),
                              ).then((value) {
                                dateController.text = DateFormat.yMMMd()
                                    .format(value as DateTime)
                                    .toString();
                              });
                            },
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                            ),
                            controller: dateController,
                            inputType: TextInputType.text,
                            labelText: 'Task Date',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 30.0,
                )
                .closed
                .then((value) {
              isShowBottomSheet = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isShowBottomSheet = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: value,
        onTap: (index) {
          setState(() {
            value = index;
          });
        },
        items: [
          customBottomNavigationBarItem(icon: Icons.list, label: 'Tasks'),
          customBottomNavigationBarItem(
              icon: Icons.task_alt_sharp, label: 'Done'),
          customBottomNavigationBarItem(icon: Icons.archive, label: 'Archived'),
          // const BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.task_alt_sharp,
          //   ),
          //   label: 'Done',
          // ),
          // const BottomNavigationBarItem(
          //   icon: Icon(Icons.archive),
          //   label: 'Archived',
          // ),
        ],
      ),
    );
  }

  BottomNavigationBarItem customBottomNavigationBarItem(
      {@required IconData? icon, @required String? label}) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
      ),
      label: label,
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('created database');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((e) {
          print('Error when creating table ${e.toString()}');
        });
      },
      onOpen: (database) {
        getDatabase(database).then((value) {
          tasks = value;
          print(tasks);
        }).catchError((e) {
          print('Error when get data ${e.toString()}');
        });
        print('opened database');
      },
    );
  }

  Future insertDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted data');
      }).catchError((e) {
        print('Error when inserted data ${e.toString()}');
      });
      return Future(() => null);
    });
  }

  Future<List<Map>> getDatabase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}

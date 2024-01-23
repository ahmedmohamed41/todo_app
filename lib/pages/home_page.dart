import 'package:flutter/material.dart';
import 'package:todo_app/constaints.dart';
import 'package:todo_app/modules/archived_task/archived_task_screen.dart';
import 'package:todo_app/modules/done_task/done_task_screen.dart';
import 'package:todo_app/modules/new_task/new_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int value = 0;
  List<Widget> screen = const [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> title = const [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(
          title[value],
        ),
      ),
      body: screen[value],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: appbarColor,
        onPressed: () {
          // try {
          //   var name = await getName();
          //   print(name);
          //   print('osama');
          //   //throw ('some error ????');
          // } catch (e) {
          //   print('error : ${e.toString()}');
          // }
          getName().then((value) {
            print(value);
            print('osama');
            throw ('some error ????');
          }).catchError((e) {
            print('error: ${e.toString()}');
           
          });
        },
        child: const Icon(
          Icons.add,
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
          customBottomNavigationBarItem(Icons.list, 'Tasks'),
          customBottomNavigationBarItem(Icons.task_alt_sharp, 'Done'),
          customBottomNavigationBarItem(Icons.archive, 'Archived'),
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
      IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
      ),
      label: label,
    );
  }

Future<String> getName() async {
  return 'Ahmed Ali';
}
 
}


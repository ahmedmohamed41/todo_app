import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/constaints.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';
import 'package:todo_app/widgets/custom_text_from_filed.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDataState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: kAppbarColor,
              title: Text(
                // listTitle[currentIndex],
                cubit.listTitle[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataLoadingState,
              builder: (context) =>
                  cubit.listScreen[AppCubit.get(context).currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: kAppbarColor,
              onPressed: () {
                if (cubit.isShowBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
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
                                      timeController.text =
                                          value!.format(context);
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
                    cubit.changeBottomSheetState(Icons.edit, false);
                  });
                  cubit.changeBottomSheetState(Icons.add, true);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                AppCubit.get(context).getIndex(index);
              },
              items: [
                customBottomNavigationBarItem(icon: Icons.list, label: 'Tasks'),
                customBottomNavigationBarItem(
                    icon: Icons.task_alt_sharp, label: 'Done'),
                customBottomNavigationBarItem(
                    icon: Icons.archive, label: 'Archived'),
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
        },
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
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/constaints.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';
import 'package:todo_app/widgets/custom_condition_builder.dart';

import 'package:todo_app/widgets/custom_text_from_filed.dart';

class NewTaskScreen extends StatelessWidget {
  NewTaskScreen({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: CustomConditionalBuilder(task: cubit.newTasks,),
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
        );
      },
    );
  }
}

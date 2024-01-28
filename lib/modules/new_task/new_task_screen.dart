import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';

import 'package:todo_app/widgets/custom_task_item.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          itemCount: AppCubit.get(context).tasks.length,
          itemBuilder: (context, index) {
            return TaskItem(
              model: AppCubit.get(context).tasks[index],
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: 0.3,
              color: Colors.grey,
            );
          },
        );
      },
    );
  }
}

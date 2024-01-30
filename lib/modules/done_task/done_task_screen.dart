import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/state.dart';
import 'package:todo_app/widgets/custom_condition_builder.dart';

class DoneTaskScreen extends StatelessWidget {
   const DoneTaskScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return CustomConditionalBuilder(task:cubit.doneTasks,);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/constaints.dart';

import 'package:todo_app/widgets/custom_task_item.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(model: tasks[index],);
      },
      separatorBuilder: (context, index) {
        return Container(
          width: double.infinity,
          height: 0.3,
          color: Colors.grey,
        );
      },
    );
  }
}

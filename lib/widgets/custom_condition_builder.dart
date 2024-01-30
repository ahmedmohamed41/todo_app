import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/custom_task_item.dart';

class CustomConditionalBuilder extends StatelessWidget {
  const CustomConditionalBuilder({
    super.key,
    required this.task,
  });

  final List<Map<dynamic, dynamic>> task;
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: task.isNotEmpty,
      builder: (context) => ListView.separated(
        itemCount: task.length,
        itemBuilder: (context, index) {
          return TaskItem(
            model: task[index],
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 0.3,
            color: Colors.grey,
          );
        },
      ),
      fallback: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet ,Please Add Some Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/constaints.dart';

import 'custom_bottom.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.model,
  });
  final Map model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundColor: kAppbarColor,
            child: Text('${model['time']}'),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 2,
                  '${model['title']}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  maxLines: 2,
                  '${model['date']}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
           const CustomBottom(
            color: Colors.green,
            icon: Icons.check_box,
          ),
            const CustomBottom(
               color: Colors.grey,
            icon: Icons.archive_sharp,
          ),
        ],
      ),
    );
  }
}

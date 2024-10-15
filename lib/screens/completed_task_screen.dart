import 'package:flutter/material.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/widgets/task_list.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      List<Task> tasksList = state.completedTasks;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Chip(label: Text('${tasksList.length} Task')),
          Expanded(child: TaskList(taskList: tasksList))
        ],
      );
    });
  }
}

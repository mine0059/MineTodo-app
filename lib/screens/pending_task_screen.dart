import 'package:flutter/material.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/widgets/task_list.dart';

class PendingTaskScreen extends StatelessWidget {
  const PendingTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      List<Task> tasksList = state.pendingTasks;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: Chip(
          //       label: Text(
          //     '${tasksList.length} Pending | ${state.completedTasks.length} Completed',
          //   )),
          // ),
          Expanded(
              child: TaskList(
            taskList: tasksList,
          ))
        ],
      );
    });
  }
}

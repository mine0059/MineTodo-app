import 'package:flutter/material.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/widgets/custom_app_bar.dart';
import 'package:mine_todo_app/widgets/task_list.dart';

class FavoriteTaskScreen extends StatelessWidget {
  const FavoriteTaskScreen({super.key});

  static const id = 'favorite_task_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      // this dynamically computes the list of favorite tasks based on the
      // current state of the pendingTasks and completedTasks
      List<Task> favoriteTasks = context.read<TaskBloc>().favoriteTasks;
      return Scaffold(
        appBar: const CustomAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Chip(
                label: Text('${favoriteTasks.length} Bookmarked'),
              ),
            ),
            Expanded(child: TaskList(taskList: favoriteTasks))
          ],
        ),
      );
    });
  }
}

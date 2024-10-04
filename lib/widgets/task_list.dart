import 'package:flutter/material.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/utils/app_strings.dart';
import 'package:mine_todo_app/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  final List<Task> taskList;
  const TaskList({
    super.key,
    required this.taskList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        return task.isDeleted == false
            ? Dismissible(
                direction: DismissDirection.horizontal,
                onDismissed: (_) {
                  context.read<TaskBloc>().add(RemoveTask(task: task));
                },
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    Text(
                      AppStr.deletedTask,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )
                  ],
                ),
                key: Key(task.id),
                child: TaskTile(
                  task: task,
                ),
              )
            : TaskTile(
                task: task,
              );
      },
    );
  }
}

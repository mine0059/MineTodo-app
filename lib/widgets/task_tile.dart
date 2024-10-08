import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/screens/add_task_screen.dart';
import 'package:mine_todo_app/widgets/note_settings.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../utils/app_strings.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  void _editTask() {
    Navigator.of(context).pushNamed(
      AddTaskScreen.id,
      arguments: widget.task,
    );
  }

// Delete A Task Dialog
  dynamic deleteTaskDialog(BuildContext context) {
    return PanaraConfirmDialog.show(
      context,
      title: AppStr.areYouSure,
      message: "Do you really want to delete this task?",
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        // Delete Task Logic Here
        context.read<TaskBloc>().add(DeleteTask(task: widget.task));
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: widget.task.isCompleted!
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 4),
              blurRadius: 5,
            )
          ]),
      duration: const Duration(milliseconds: 600),
      child: ListTile(
        leading: GestureDetector(
          onTap: widget.task.isDeleted == false
              ? () {
                  context.read<TaskBloc>().add(UpdateTask(task: widget.task));
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              color: widget.task.isCompleted!
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 4),
            ),
            child: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        // Task title
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 3),
          child: Text(
            widget.task.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w500,
              decoration:
                  widget.task.isCompleted! ? TextDecoration.lineThrough : null,
            ),
          ),
        ),

        // Task subtitle
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w500,
                decoration: widget.task.isCompleted!
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(widget.task.createdAtTime),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMEd().format(widget.task.createdAtDate),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          widget.task.isFavorite!
              ? const Icon(Icons.bookmark)
              : const Icon(Icons.bookmark_add_outlined),
          NoteSettings(
            task: widget.task,
            editTaskCallBack: _editTask,
            favoriteOrUnfavorite: () => context
                .read<TaskBloc>()
                .add(MarkFavoriteOrUnFavoriteTask(task: widget.task)),
            restoreTaskCallback: () =>
                context.read<TaskBloc>().add(RestoreTask(task: widget.task)),
            deleteForever: () {
              deleteTaskDialog(context);
            },
          )
        ]),
      ),
    );
  }
}

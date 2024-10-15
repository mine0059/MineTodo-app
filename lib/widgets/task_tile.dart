import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: widget.task.isCompleted!
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 3),
      ),
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.task.isDeleted == false
                          ? () {
                              context
                                  .read<TaskBloc>()
                                  .add(UpdateTask(task: widget.task));
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        decoration: BoxDecoration(
                          color: widget.task.isCompleted!
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 3),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.gotu(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: widget.task.isCompleted!
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.task.isFavorite!
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_add_outlined),
                    NoteSettings(
                      task: widget.task,
                      editTaskCallBack: _editTask,
                      favoriteOrUnfavorite: () => context
                          .read<TaskBloc>()
                          .add(MarkFavoriteOrUnFavoriteTask(task: widget.task)),
                      restoreTaskCallback: () => context
                          .read<TaskBloc>()
                          .add(RestoreTask(task: widget.task)),
                      deleteForever: () {
                        deleteTaskDialog(context);
                      },
                    )
                  ],
                ),
              ],
            ),
            Text(
              widget.task.subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                decoration: widget.task.isCompleted!
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMEd().format(widget.task.createdAtDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(widget.task.createdAtTime),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mine_todo_app/models/task.dart';

class NoteSettings extends StatelessWidget {
  final Task task;
  final VoidCallback favoriteOrUnfavorite;
  final VoidCallback editTaskCallBack;
  final VoidCallback restoreTaskCallback;
  const NoteSettings(
      {super.key,
      required this.task,
      required this.editTaskCallBack,
      required this.favoriteOrUnfavorite,
      required this.restoreTaskCallback});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
              color: Theme.of(context).colorScheme.surface,
              textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface))),
      child: PopupMenuButton(
          itemBuilder: task.isDeleted == false
              ? ((context) => [
                    PopupMenuItem(
                      onTap: null,
                      child: TextButton.icon(
                        onPressed: editTaskCallBack,
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        label: Text(
                          'Edit',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: favoriteOrUnfavorite,
                      child: TextButton.icon(
                          onPressed: null,
                          icon: task.isFavorite!
                              ? Icon(
                                  Icons.bookmark_remove,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                )
                              : Icon(
                                  Icons.bookmark_add_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                          label: task.isFavorite!
                              ? Text(
                                  'Remove from bookmarks',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                )
                              : Text(
                                  'Add to bookmarks',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                )),
                    ),
                  ])
              : (context) => [
                    PopupMenuItem(
                      onTap: null,
                      child: TextButton.icon(
                        onPressed: restoreTaskCallback,
                        icon: Icon(
                          Icons.restore_from_trash,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        label: Text(
                          'Restore',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                  ]),
    );
  }
}

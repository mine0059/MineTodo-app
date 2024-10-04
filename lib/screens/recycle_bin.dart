import 'package:flutter/material.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/widgets/custom_app_bar.dart';
import 'package:mine_todo_app/widgets/task_list.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({super.key});

  static const id = 'recycle_bin_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      List<Task> removedTaskList = state.removeTasks;
      return Scaffold(
        appBar: const CustomAppBar(showDeleteIcon: true),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child:
                  Chip(label: Text('${removedTaskList.length}Recycled Tasks')),
            ),
            Expanded(child: TaskList(taskList: removedTaskList)),
          ],
        ),
      );
    });
  }
}

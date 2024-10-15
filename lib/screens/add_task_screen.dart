import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/utils/app_strings.dart';
import 'package:mine_todo_app/utils/constants.dart';
import 'package:mine_todo_app/widgets/custom_app_bar.dart';
import 'package:mine_todo_app/widgets/date_time_selection.dart';
import 'package:mine_todo_app/widgets/rep_textfield.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

class AddTaskScreen extends StatelessWidget {
  final Task? task;
  const AddTaskScreen({super.key, this.task});

  static const id = 'task_screen.dart';

  @override
  Widget build(BuildContext context) {
    TextEditingController titleTaskController =
        TextEditingController(text: task?.title ?? '');
    TextEditingController descriptionTaskController =
        TextEditingController(text: task?.subtitle ?? '');

    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      DateTime? selectedTime = state.selectedTime ?? task?.createdAtTime;
      DateTime? selectedDate = state.selectedDate ?? task?.createdAtDate;

      // DateTime? time;
      // DateTime? date;

      // // show selected Date as DateFormat fot int Time
      // DateTime showDateAsDateTime(DateTime? date) {
      //   if (task?.createdAtTime == null) {}
      // }

      // Main function for adding Task
      dynamic handleTask() {
        String title = titleTaskController.text.trim();
        String subtitle = descriptionTaskController.text.trim();

        if (title.isNotEmpty && subtitle.isNotEmpty) {
          // Add new task
          if (task == null) {
            var task = Task(
              title: title,
              subtitle: subtitle,
              createdAtTime: selectedTime ?? DateTime.now(),
              createdAtDate: selectedDate ?? DateTime.now(),
            );
            context.read<TaskBloc>().add(AddTask(
                  task: task,
                  selectedDate: selectedDate ?? DateTime.now(),
                  selectedTime: selectedTime ?? DateTime.now(),
                ));
          } else {
            // Edit existing Task
            var updatedTask = task!.copyWith(
              title: title,
              subtitle: subtitle,
              createdAtDate: selectedTime ?? DateTime.now(),
              createdAtTime: selectedTime ?? DateTime.now(),
            );
            context.read<TaskBloc>().add(EditTask(
                oldtask: task!,
                newTask: updatedTask,
                selectedDate: selectedDate ?? DateTime.now(),
                selectedTime: selectedTime ?? DateTime.now()));
          }
          Navigator.pop(context);
          //   var task = Task(
          //     title: title,
          //     subtitle: subtitle,
          //     createdAtTime: selectedTime ?? DateTime.now(),
          //     createdAtDate: selectedDate ?? DateTime.now(),
          //   );
          //   context.read<TaskBloc>().add(AddTask(
          //         task: task,
          //         selectedDate: selectedDate ?? DateTime.now(),
          //         selectedTime: selectedTime ?? DateTime.now(),
          //       ));
          //   Navigator.pop(context);
        } else {
          emptyFieldsWarning(context);
        }
      }

      var textTheme = Theme.of(context).textTheme;
      return Scaffold(
        appBar: const CustomAppBar(),

        //body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(children: [
              // Top side Text
              _buildTopSideTexts(textTheme),

              // Main task view Activity
              _buildMainTaskViewActivity(
                textTheme,
                context,
                titleTaskController,
                descriptionTaskController,
                selectedDate,
                selectedTime,
              ),

              // Bottom side Botton
              _buildBottomSideButtons(
                context,
                handleTask,
              ),
            ]),
          ),
        ),
      );
    });
  }

  // Top side Task
  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(thickness: 2),
          ),

          // According to the task condition it will Add or Update Task
          RichText(
              text: TextSpan(
                  text: task == null
                      ? AppStr.addNewTask
                      : AppStr.updateCurrentTask,
                  style: textTheme.headlineMedium,
                  children: const [
                TextSpan(
                  text: AppStr.taskStrnig,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ])),
          const SizedBox(
            width: 70,
            child: Divider(thickness: 2),
          ),
        ],
      ),
    );
  }

  // Bottom Task View Activity
  Widget _buildBottomSideButtons(BuildContext context, Function handleTask) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: task == null
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          task == null
              ? Container()
              :
              // Delete current task button
              MaterialButton(
                  onPressed: () {
                    context.read<TaskBloc>().add(RemoveTask(task: task!));
                    Navigator.pop(context);
                  },
                  minWidth: 150,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 55,
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        AppStr.deleteTask,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

          // Add or Update Task button
          MaterialButton(
            onPressed: () => handleTask(),
            minWidth: 150,
            color: Theme.of(context).colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Text(
              task == null ? AppStr.addTaskString : AppStr.updateTaskString,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }

  // main task view Activity
  Widget _buildMainTaskViewActivity(
    TextTheme textTheme,
    BuildContext context,
    TextEditingController titleTaskController,
    TextEditingController descriptionTaskController,
    DateTime? selectedDate,
    DateTime? selectedTime,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of TexeField
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.titleMedium,
            ),
          ),

          // Task title
          RepTextfield(
            controller: titleTaskController,
          ),
          const SizedBox(height: 70),
          // title title
          RepTextfield(
            controller: descriptionTaskController,
            isForDescription: true,
          ),

          Row(
            children: [
              // Date selection
              Expanded(
                child: DateTimeSelectionWidget(
                  title: AppStr.dateString,
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      initialDateTime: selectedDate ?? DateTime.now(),
                      maxDateTime: DateTime(2030, 4, 5),
                      minDateTime: DateTime.now(),
                      onConfirm: (dateTime, _) {
                        context
                            .read<TaskBloc>()
                            .add(SelectDate(selectedDate: dateTime));
                      },
                      pickerTheme: DateTimePickerTheme(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        confirmTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        itemTextStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary, // Picker item text color
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  isTime: true,
                  time: selectedDate != null
                      ? DateFormat.yMMMd().format(selectedDate)
                      : DateFormat.yMMMd().format(DateTime.now()).toString(),
                ),
              ),

              // Time selection
              Expanded(
                child: DateTimeSelectionWidget(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => SizedBox(
                              height: 280,
                              child: TimePickerWidget(
                                initDateTime: selectedTime ?? DateTime.now(),
                                onChange: (_, __) {},
                                dateFormat: 'HH:mm',
                                onConfirm: (dateTime, _) {
                                  context
                                      .read<TaskBloc>()
                                      .add(SelectTime(selectedTime: dateTime));
                                },
                                pickerTheme: DateTimePickerTheme(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  confirmTextStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  itemTextStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary, // Picker item text color
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ));
                  },
                  title: 'Time',
                  time: selectedTime != null
                      ? DateFormat('hh:mm a').format(selectedTime)
                      : DateFormat('hh:mm a').format(DateTime.now()).toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

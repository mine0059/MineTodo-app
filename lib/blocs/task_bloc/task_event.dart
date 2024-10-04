// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;
  final DateTime selectedDate;
  final DateTime selectedTime;
  const AddTask({
    required this.task,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  List<Object> get props => [task, selectedDate, selectedTime];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class RemoveTask extends TaskEvent {
  final Task task;
  const RemoveTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class RestoreTask extends TaskEvent {
  final Task task;
  const RestoreTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final Task task;
  const DeleteTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class MarkFavoriteOrUnFavoriteTask extends TaskEvent {
  final Task task;
  const MarkFavoriteOrUnFavoriteTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class EditTask extends TaskEvent {
  final Task oldtask;
  final Task newTask;
  final DateTime selectedDate; // New selected date
  final DateTime selectedTime; // New selected time
  const EditTask({
    required this.oldtask,
    required this.newTask,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  List<Object> get props => [oldtask, newTask, selectedDate, selectedTime];
}

class SelectTime extends TaskEvent {
  final DateTime selectedTime;
  const SelectTime({
    required this.selectedTime,
  });

  @override
  List<Object> get props => [selectedTime];
}

class SelectDate extends TaskEvent {
  final DateTime selectedDate;
  const SelectDate({
    required this.selectedDate,
  });

  @override
  List<Object> get props => [selectedDate];
}

class LoadTasksFromPreferences extends TaskEvent {}

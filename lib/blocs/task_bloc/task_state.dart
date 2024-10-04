// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'task_bloc.dart';

class TaskState extends Equatable {
  final List<Task> pendingTasks;
  final List<Task> completedTasks;
  final List<Task> favoriteTasks;
  final List<Task> removeTasks;
  final DateTime? selectedTime;
  final DateTime? selectedDate;
  const TaskState({
    this.pendingTasks = const <Task>[],
    this.completedTasks = const <Task>[],
    this.favoriteTasks = const <Task>[],
    this.removeTasks = const <Task>[],
    this.selectedTime,
    this.selectedDate,
  });

  // copywith method to avoid reducdancy in your state
  // update and ensure immutability more efficiently
  TaskState copyWith({
    List<Task>? pendingTasks,
    List<Task>? completedTasks,
    List<Task>? favoriteTasks,
    List<Task>? removeTasks,
    DateTime? selectedTime,
    DateTime? selectedDate,
  }) {
    return TaskState(
      pendingTasks: pendingTasks ?? this.pendingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      favoriteTasks: favoriteTasks ?? this.favoriteTasks,
      removeTasks: removeTasks ?? this.removeTasks,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        pendingTasks,
        completedTasks,
        favoriteTasks,
        removeTasks,
        selectedTime,
        selectedDate,
      ];
}

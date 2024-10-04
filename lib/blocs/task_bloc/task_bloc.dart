import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/services/shared_preferences.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskPreferences taskPreferences = TaskPreferences();

  TaskBloc() : super(const TaskState()) {
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
    on<AddTask>(_onAddTask);
    on<EditTask>(_onEditTask);
    on<UpdateTask>(_onUpdateTask);
    on<MarkFavoriteOrUnFavoriteTask>(_onMarkFavoriteOrUnFavoriteTask);
    on<RemoveTask>(_onRemoveTask);
    on<RestoreTask>(_onRestoreTask);

    _loadTasksFromPreferences();
  }

  Future<void> _loadTasksFromPreferences() async {
    List<Task> loadedTasks = await taskPreferences.loadTasks();

    List<Task> pendingTasks =
        loadedTasks.where((task) => task.isCompleted == false).toList();
    List<Task> completedTasks =
        loadedTasks.where((task) => task.isCompleted == true).toList();

    emit(state.copyWith(
        pendingTasks: pendingTasks, completedTasks: completedTasks));
  }

  Future<void> _saveTasksToPreferences(
      List<Task> pendingTasks, List<Task> completedTask) async {
    List<Task> allTasks = [...pendingTasks, ...completedTask];
    await taskPreferences.saveTasks(allTasks);
  }

  void _onSelectDate(SelectDate event, Emitter<TaskState> emit) {
    emit(state.copyWith(selectedDate: event.selectedDate));
  }

  void _onSelectTime(SelectTime event, Emitter<TaskState> emit) {
    emit(state.copyWith(selectedTime: event.selectedTime));
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    final newTask = event.task.copyWith(
      createdAtDate: event.selectedDate,
      createdAtTime: event.selectedTime,
    );

    final List<Task> updatedPendingTasks = List.from(state.pendingTasks)
      ..add(newTask);

    emit(state.copyWith(pendingTasks: updatedPendingTasks));

    _saveTasksToPreferences(updatedPendingTasks, state.completedTasks);
  }

  void _onEditTask(EditTask event, Emitter<TaskState> emit) {
    final state = this.state;
    final Task oldTask = event.oldtask;
    final Task newTask = event.newTask.copyWith(
      createdAtDate: event.selectedDate,
      createdAtTime: event.selectedTime,
    );

    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);

    // Handle for pending task
    if (oldTask.isCompleted == false) {
      pendingTasks
        ..remove(oldTask)
        ..add(newTask);
    }

    // Handle for completed task
    if (oldTask.isCompleted == true) {
      completedTasks
        ..remove(oldTask)
        ..add(newTask);
    }
    // Handle for favorite tasks

    emit(state.copyWith(
        pendingTasks: pendingTasks, completedTasks: completedTasks));

    _saveTasksToPreferences(pendingTasks, completedTasks);
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);

    if (task.isCompleted == false) {
      pendingTasks..remove(task);
      completedTasks..insert(0, task.copyWith(isCompleted: true));
      if (!completedTasks.contains(task.copyWith(isCompleted: true))) {
        completedTasks..insert(0, task.copyWith(isCompleted: true));
      }
    } else {
      completedTasks..remove(task);
      if (!pendingTasks.contains(task.copyWith(isCompleted: false))) {
        pendingTasks..insert(0, task.copyWith(isCompleted: false));
      }
    }

    emit(state.copyWith(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
    ));

    _saveTasksToPreferences(pendingTasks, completedTasks);
  }

  void _onMarkFavoriteOrUnFavoriteTask(
      MarkFavoriteOrUnFavoriteTask event, Emitter<TaskState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);

    // Treat null as false, then toggle isFavorite
    Task updatedTask = task.copyWith(isFavorite: !(task.isFavorite ?? false));

    if (task.isCompleted == false) {
      int index = pendingTasks.indexOf(task);
      if (index != -1) {
        pendingTasks[index] = updatedTask;
      }
    } else {
      int index = completedTasks.indexOf(task);
      if (index != -1) {
        completedTasks[index] = updatedTask;
      }
    }

    // Emit the new state with updated tasks
    emit(state.copyWith(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
    ));

    _saveTasksToPreferences(pendingTasks, completedTasks);
  }

// Use a computed getter to return favorite tasks dynamically
  List<Task> get favoriteTasks {
    return [
      ...state.pendingTasks.where((task) => task.isFavorite == true),
      ...state.completedTasks.where((task) => task.isFavorite == true),
    ];
  }

  void _onRemoveTask(RemoveTask event, Emitter<TaskState> emit) {
    final state = this.state;
    final task = event.task;
    final updatedTask = task.copyWith(isDeleted: true);

    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);
    List<Task> removeTasks = List.from(state.removeTasks);

    if (pendingTasks.contains(task)) {
      pendingTasks.remove(task);
    } else if (completedTasks.contains(task)) {
      completedTasks.remove(task);
    }

    removeTasks.add(updatedTask);

    emit(state.copyWith(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      removeTasks: removeTasks,
    ));

    _saveTasksToPreferences(pendingTasks, completedTasks);
  }

  void _onRestoreTask(RestoreTask event, Emitter<TaskState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = List.from(state.pendingTasks);
    List<Task> completedTasks = List.from(state.completedTasks);
    List<Task> removeTasks = List.from(state.removeTasks);

    removeTasks.remove(task);

    if (task.isCompleted!) {
      completedTasks.add(task.copyWith(isDeleted: false));
    } else {
      pendingTasks.add(task.copyWith(isDeleted: false));
    }

    emit(state.copyWith(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      removeTasks: removeTasks,
    ));

    _saveTasksToPreferences(pendingTasks, completedTasks);
  }
}

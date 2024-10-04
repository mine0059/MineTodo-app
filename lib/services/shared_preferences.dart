import 'dart:convert';

import 'package:mine_todo_app/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const themeKey = 'theme_mode';

  Future<void> saveTheme(bool isLightMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isLightMode);
  }

  Future<bool> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? true;
  }
}

class TaskPreferences {
  static const tasksKey = 'tasks';

  // save the list of task to sharedPreference
  Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksJsonList =
        tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList(tasksKey, tasksJsonList);
  }

  // Load the List of Tasks from sharedPreferences
  Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasksJsonList = prefs.getStringList(tasksKey);

    if (tasksJsonList != null) {
      return tasksJsonList
          .map((taskJson) => Task.fromJson(json.decode(taskJson)))
          .toList(); // convert the list of json to list of Task
    }

    return [];
  }
}

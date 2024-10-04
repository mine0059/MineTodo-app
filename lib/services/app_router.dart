import 'package:flutter/material.dart';
import 'package:mine_todo_app/screens/favorite_task_screen.dart';
import 'package:mine_todo_app/screens/recycle_bin.dart';
import 'package:mine_todo_app/screens/tabs_screen.dart';
import 'package:mine_todo_app/screens/add_task_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case FavoriteTaskScreen.id:
        return MaterialPageRoute(
          builder: (_) => const FavoriteTaskScreen(),
        );
      case RecycleBin.id:
        return MaterialPageRoute(
          builder: (_) => const RecycleBin(),
        );
      case AddTaskScreen.id:
        return MaterialPageRoute(
          builder: (_) => const AddTaskScreen(),
        );
      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (_) => const TabsScreen(),
        );
      default:
        return null;
    }
  }
}

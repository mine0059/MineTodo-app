import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/models/task.dart';
import 'package:mine_todo_app/screens/favorite_task_screen.dart';
import 'package:mine_todo_app/screens/recycle_bin.dart';
import 'package:mine_todo_app/screens/tabs_screen.dart';
import 'package:mine_todo_app/widgets/drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Column(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/img/pic1.jpg'),
                radius: 50,
              ),
              const SizedBox(height: 8),
              const Text('Angela Mu'),
              const Text('Software developer'),
              const SizedBox(
                height: 30,
              ),

              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  thickness: 2,
                  indent: 40,
                ),
              ),

              // task
              BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
                return DrawerTile(
                  title: 'My Task',
                  leading: const Icon(CupertinoIcons.folder),
                  trailing:
                      '${state.pendingTasks.length}|${state.completedTasks.length}',
                  onTap: () => Navigator.of(context).pushNamed(TabsScreen.id),
                );
              }),

              BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
                List<Task> favoriteTasks =
                    context.read<TaskBloc>().favoriteTasks;
                return DrawerTile(
                  title: 'Favorite Task',
                  leading: const Icon(Icons.folder_special),
                  trailing: '${favoriteTasks.length}',
                  onTap: () =>
                      Navigator.of(context).pushNamed(FavoriteTaskScreen.id),
                );
              }),

              // Bin
              BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
                return DrawerTile(
                  title: 'Bin',
                  leading: const Icon(CupertinoIcons.trash),
                  trailing: '${state.removeTasks.length}',
                  onTap: () => Navigator.of(context).pushNamed(RecycleBin.id),
                );
              }),

              // Profile
              DrawerTile(
                title: 'Profile',
                leading: const Icon(CupertinoIcons.person_fill),
                onTap: () {},
              ),

              // Profile
              DrawerTile(
                title: 'Setings',
                leading: const Icon(CupertinoIcons.settings),
                onTap: () {},
              ),

              const SizedBox(
                height: 30,
              ),
              BlocBuilder<SwitchBloc, SwitchState>(
                builder: (context, state) {
                  return CupertinoSwitch(
                    value: state.switchValue,
                    onChanged: (newValue) {
                      newValue
                          ? context.read<SwitchBloc>().add(SwitchOnEvent())
                          : context.read<SwitchBloc>().add(SwitchOffEvent());
                    },
                  );
                },
              )
            ],
          ),
        ));
  }
}

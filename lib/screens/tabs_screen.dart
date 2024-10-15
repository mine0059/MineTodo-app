import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mine_todo_app/blocs/bloc_exports.dart';
import 'package:mine_todo_app/screens/completed_task_screen.dart';
import 'package:mine_todo_app/screens/favorite_task_screen.dart';
import 'package:mine_todo_app/screens/pending_task_screen.dart';
import 'package:mine_todo_app/screens/add_task_screen.dart';
import 'package:mine_todo_app/utils/app_strings.dart';
import 'package:mine_todo_app/widgets/my_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  static const id = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasksFromPreferences());
  }

  final List<Map<String, dynamic>> _pageDetails = [
    {
      'pageName': const PendingTaskScreen() as Widget,
      'title': 'Pending Page',
    },
    {
      'pageName': const CompletedTaskScreen() as Widget,
      'title': 'Completed Page',
    },
    {
      'pageName': const FavoriteTaskScreen() as Widget,
      'title': 'Favorite Page',
    },
  ];

  var _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          _selectedPageIndex == 0 ? 'My Tasks' : 'Completed Tasks',
          style: GoogleFonts.gotu(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: _selectedPageIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddTaskScreen.id);
              },
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            )
          : null,
      drawer: const MyDrawer(),
      body: buildHomeBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions_outlined),
            label: 'Pending Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: 'Completed Tasks',
          ),
        ],
      ),
    );
  }

  // Home body
  Widget buildHomeBody() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              final int totalTasks =
                  state.pendingTasks.length + state.completedTasks.length;
              double progress = 0;
              String percentageText = '0%';
              if (totalTasks > 0) {
                progress = (state.completedTasks.length / totalTasks);
                percentageText = '${(progress * 100).toStringAsFixed(0)}%';
              }
              return Container(
                  margin: const EdgeInsets.only(left: 18, top: 10),
                  child: _selectedPageIndex == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.grey),
                                    ),
                                  ),
                                  Text(
                                    percentageText,
                                    style: GoogleFonts.gotu(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Text(
                                '${state.completedTasks.length} of ${state.pendingTasks.length} Task',
                                style: GoogleFonts.gotu(
                                  fontSize: 17,
                                ),
                              ),
                            ])
                      : null);
            },
          ),

          // Tasks
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return Expanded(
                  child: _selectedPageIndex == 0 && state.pendingTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeIn(
                                child: SizedBox(
                                  width: 250,
                                  height: 200,
                                  child: SvgPicture.asset(
                                    'assets/vectors/undraw_add_tasks.svg',
                                  ),
                                ),
                              ),
                              FadeInUp(
                                from: 30,
                                child: SizedBox(
                                  width: 300,
                                  child: Text(
                                    AppStr.noTask,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _pageDetails[_selectedPageIndex]['pageName']);
            },
          )
        ],
      ),
    );
  }
}

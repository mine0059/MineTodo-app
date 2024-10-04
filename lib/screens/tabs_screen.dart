import 'package:flutter/material.dart';
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
        // title: Text('Mine Todo app'),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle_sharp),
            label: 'Pending Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle_sharp),
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
          // Custom App Bar
          BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
            final int totalTasks =
                state.pendingTasks.length + state.completedTasks.length;
            double progress = 0;
            String percentageText = '0%';
            if (totalTasks > 0) {
              progress = (state.completedTasks.length / totalTasks);
              percentageText = '${(progress * 100).toStringAsFixed(0)}%';
            }
            return Container(
              margin: const EdgeInsets.only(top: 60),
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // progress indicator
                  if (_selectedPageIndex == 0)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: progress,
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.grey),
                          ),
                        ),
                        Text(
                          percentageText,
                          style: GoogleFonts.dmSerifText(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  const SizedBox(width: 25),
                  // Top Level Task Info
                  _selectedPageIndex == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStr.mainTitle,
                              style: GoogleFonts.dmSerifText(
                                fontSize: 50.0,
                              ),
                            ),
                            Text(
                              '${state.completedTasks.length} of ${state.pendingTasks.length} Task',
                              style: GoogleFonts.dmSerifText(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Completed',
                              style: GoogleFonts.dmSerifText(
                                fontSize: 50.0,
                              ),
                            ),
                            Text(
                              'Task',
                              style: GoogleFonts.dmSerifText(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                ],
              ),
            );
          }),
          // if (_selectedPageIndex == 0)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),

          // Tasks
          Expanded(
            child: _pageDetails[_selectedPageIndex]['pageName'],
          )
        ],
      ),
    );
  }
}

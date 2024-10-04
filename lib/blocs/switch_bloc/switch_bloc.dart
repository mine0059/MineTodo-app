import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mine_todo_app/services/shared_preferences.dart';

part 'switch_event.dart';
part 'switch_state.dart';

class SwitchBloc extends Bloc<SwitchEvent, SwitchState> {
  final ThemePreferences themePreferences = ThemePreferences();

  SwitchBloc() : super(SwitchInitial(switchValue: true)) {
    on<SwitchOnEvent>((event, emit) async {
      await themePreferences.saveTheme(true);
      emit(
        const SwitchState(switchValue: true),
      );
    });

    on<SwitchOffEvent>((event, emit) async {
      await themePreferences.saveTheme(false);
      emit(
        const SwitchState(switchValue: false),
      );
    });

    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isLightTheme = await themePreferences.loadTheme();
    // ignore: invalid_use_of_visible_for_testing_member
    emit(SwitchState(switchValue: isLightTheme));
  }
}

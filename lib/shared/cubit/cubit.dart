import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/archived_task/archived_task_screen.dart';
import 'package:todo_app/modules/done_task/done_task_screen.dart';
import 'package:todo_app/shared/cubit/state.dart';

import '../../modules/new_task/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

// create object from AppCubit
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> listScreen = const [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> listTitle = const [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void getIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomBarState());
  }
}

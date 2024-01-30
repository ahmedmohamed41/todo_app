import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_task/archived_task_screen.dart';
import 'package:todo_app/modules/done_task/done_task_screen.dart';
import 'package:todo_app/shared/cubit/state.dart';

import '../../modules/new_task/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

// create object from AppCubit
  static AppCubit get(context) => BlocProvider.of(context);
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;
  int currentIndex = 0;
  bool isShowBottomSheet = false;
  IconData fabIcon = Icons.edit;
  List<Widget> listScreen = [
    NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedTaskScreen(),
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

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('created database');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((e) {
          print('Error when creating table ${e.toString()}');
        });
      },
      onOpen: (database) {
        getDatabase(database);
        print('opened database');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataState());
    });
  }

  insertDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted data');

        emit(AppInsertDataState());
        getDatabase(database);
      }).catchError((e) {
        print('Error when inserted data ${e.toString()}');
      });
      return Future(() => null);
    });
  }

  void updataData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDatabase(database);
      emit(AppUpdateDataState());
    });
  }

  void getDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDataLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataState());
    });
    ;
  }

  void deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDatabase(database);
      emit(AppDeleteDataState());
    });
  }

  void changeBottomSheetState(IconData icon, bool isShowBottom) {
    isShowBottomSheet = isShowBottom;
    fabIcon = icon;
    emit(AppChangeBottomBarState());
  }
}

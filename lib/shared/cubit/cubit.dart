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
  List<Map> tasks = [];
  late Database database;
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
        getDatabase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDataState());
        });
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
        getDatabase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDataState());
        });
      }).catchError((e) {
        print('Error when inserted data ${e.toString()}');
      });
      return Future(() => null);
    });
  }

  Future<List<Map>> getDatabase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }

  bool isShowBottomSheet = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState(IconData icon, bool isShowBottom) {
    isShowBottomSheet = isShowBottom;
    fabIcon = icon;
    emit(AppChangeBottomBarState());
  }
}

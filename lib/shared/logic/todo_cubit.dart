import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archive_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/modules/new_tasks.dart';


part 'todo_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;


  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];


void changeIndex(int index){
  currentIndex = index;
  emit(AppChangeBottomNavBarState());
}

  late Database database;

  List<Map> tasks = [];



  void createDatabase() {
     openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created ');
          database
              .execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)',
          )
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('Error when created first table ${error.toString()}');
          });
        }, onOpen: (database) {
          getDataFromDatabase(database).then((value) {

            tasks = value;
            print(tasks);
            emit(AppGetDataBaseState());
          });
          print('database opened ');


        },
     ).then((value) {
       database = value ;
       emit(AppCreateDataBaseState());
     });
  }

insertDatabase(
      {
        required String title,
        required String time,
        required String date}) async {
    await database.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO tasks(title , date , time , status) VALUES ("$title" , "$time" , "$date", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDataBaseState());


        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting new record: $error');
      });
      return await null;
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    
    emit(AppGetDataBaseLoadingState());
    print(tasks);
    return await database.rawQuery('SELECT * FROM tasks');
  }


  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

void changeBottomSheetState({required bool isShow, required IconData icon }){

  isBottomSheetShow =isShow;
  fabIcon = icon;
  emit(AppChangeBottomSheetState());
}


void updateData({
    required String status,
    required int id,
}) async{
 database.rawUpdate(
      'UPDATE tasks SET status = ?, value = ? WHERE id = ?',
      ['$status', id]).then((value)  {
        emit(AppUpdateDataBaseState());

 });

}
}



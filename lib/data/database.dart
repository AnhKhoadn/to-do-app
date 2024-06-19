import 'package:hive_flutter/adapters.dart';

class ToDoDatabase {
  List toDoList = [];

  final _toDoBox = Hive.box('TodoBox');

  //first time ever opening the app
  void createInitialData() {
    toDoList = [
      ['wake up', false],
      ['brush teeth', false],
      ['do exercise', false]
    ];
  }

  //load database
  void loadData() {
    toDoList = _toDoBox.get('TODOLIST');
  }

  //update database
  void updateData() {
    _toDoBox.put('TODOLIST', toDoList);
  }
}

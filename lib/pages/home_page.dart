import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/components/modal_box.dart';
import 'package:to_do_app/components/to_do_title.dart';
import 'package:to_do_app/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _toDoBox = Hive.box('ToDoBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    //first time ever opening the app
    if(_toDoBox.get('TODOLIST') == null){
      db.createInitialData();
    } else {
      //data exists
      db.loadData();
    }

    super.initState();
  }

  final TextEditingController _controller = TextEditingController();


  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void saveNewTask(){
    setState(() {
      if(_controller.text.isEmpty){
        return;
      }
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewTask(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ModalBox(
          controller: _controller,
          onAddTask: saveNewTask,
        );
      }
    );
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  void editTask(int index) {
    _controller.text = db.toDoList[index][0];
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ModalBox(
            controller: _controller,
            onAddTask: () {
              saveEditedTask(index);
            },
          );
        }
    );
  }

  void saveEditedTask(int index) {
    setState(() {
      db.toDoList[index][0] = _controller.text;
      _controller.clear();
    });
    db.updateData();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Center(child: Text('TO DO LIST')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.amberAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30)
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTitle(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
            editFunction: (context) => editTask(index)
          );
        },
      ),
    );
  }
}

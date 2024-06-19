import 'package:flutter/material.dart';
import 'package:to_do_app/components/my_button.dart';

class ModalBox extends StatelessWidget {

  final controller;
  VoidCallback onAddTask;

  ModalBox({super.key, required this.controller, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 175,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: 'Enter task'
              ),
            ),
            const SizedBox(height: 10),
            MyButton(text: 'Add task',
                onPressed: onAddTask
            )
          ],
        ),
      ),
    );
  }
}

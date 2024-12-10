import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

//returns the homepage state, uses the createstate lifecycle method, the first to build the app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//Private state HomePageState
class _HomePageState extends State<HomePage> {
  final FirebaseFirestore db =
      FirebaseFirestore.instance; //new firestore instance
  final TextEditingController nameController =
      TextEditingController(); //captures textform input
  final List<Map<String, dynamic>> tasks = [];

//Function that adds new tasks to local state & firestore database
  Future<void> addTask() async {
    final taskName = nameController.text.trim();

    if (taskName.isNotEmpty) {
      final newTask = {
        'name': taskName,
        'completed': false,
        'timestamp': FieldValue.serverTimestamp(),
      };

      //docRef gives us the insertion id of the task from the database
      final docRef = await db.collection('tasks').add(newTask);

      //adding tasks locally
      setState(() {
        tasks.add({
          'id': docRef,
          ...newTask,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Image.asset('assets/rdplogo.png', height: 80),
            ),
            const Text(
              'Daily Planner',
              style: TextStyle(
                  fontFamily: 'Caveat', fontSize: 32, color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2024),
                    lastDay: DateTime(2025),
                  ),
                ],
              ),
            ),
          ),
          buildAddTaskSection(nameController, addTask), //modularization of code
        ],
      ),
      drawer: Drawer(),
    );
  }
}

//Build the section for adding tasks
Widget buildAddTaskSection(nameController, addTask) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Add Task',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      ElevatedButton(
        onPressed: addTask,
        child: const Text('Add Task'),
      ),
    ],
  );
}

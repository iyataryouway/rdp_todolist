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

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

//Fetch tasks from the firestore and update the local task list
  Future<void> fetchTasks() async {
    final snapshot = await db.collection('tasks').orderBy('timestamp').get();

    setState(() {
      tasks.clear();
      tasks.addAll(
        snapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc.get('name'),
              'completed': doc.get('completed') ?? false,
            }),
      );
    });
  }

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
          'id': docRef.id,
          ...newTask,
        });
      });
      nameController.clear();
    }
  }

//Updates the completion status of the task in Firestore & locally
  Future<void> updateTask(int index, bool completed) async {
    final task = tasks[index];
    await db
        .collection('tasks')
        .doc(task['id'])
        .update({'completed': completed});

    setState(() {
      tasks[index]['completed'] = completed;
    });
  }

//Delete the task locally & in the Firestore
  Future<void> removeTasks(int index) async {
    final task = tasks[index];

    await db.collection('tasks').doc(task['id']).delete();

    setState(() {
      tasks.removeAt(index);
    });
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
                  buildTaskList(tasks, removeTasks, updateTask)
                ],
              ),
            ),
          ),

          buildAddTaskSection(nameController, addTask), //modularization of code
        ],
      ),
      drawer: const Drawer(),
    );
  }
}

//Build the section for adding tasks
Widget buildAddTaskSection(nameController, addTask) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 32,
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Add Task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: addTask,
              child: const Text('Add Task'),
            ),
          ),
        ],
      ),
    ),
  );
}

//Widget that displays the task item on the UI
Widget buildTaskList(tasks, removeTasks, updateTask) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];
      final isEven = index % 2 == 0;

      return Padding(
          padding: const EdgeInsets.all(1.0),
          child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              tileColor: isEven ? Colors.blue : Colors.lightBlue,
              leading: Icon(
                task['completed'] ? Icons.check_circle : Icons.circle_outlined,
              ),
              title: Text(
                task['name'],
                style: TextStyle(
                    decoration:
                        task['completed'] ? TextDecoration.lineThrough : null,
                    fontSize: 22),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      value: task['completed'],
                      onChanged: (value) => updateTask(index, value!)),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeTasks(index),
                  ),
                ],
              )));
    },
  );
}

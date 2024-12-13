//code submitted by: Iyanah Camille Taryouway

//import essential flutter and firestore packages
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
  final FirebaseFirestore db = FirebaseFirestore
      .instance; //new firestore instance initialized, capture input to db
  final TextEditingController nameController =
      TextEditingController(); //captures textform input - text field controller
  final List<Map<String, dynamic>> tasks =
      []; //create list to fetch tasks to be added to firestore db

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

//Async function to fetch tasks from the firestore and update the task list
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

//Syncs the completion status of the task in Firestore
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

//Function to dlete the task locally & in the Firestore
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
              child: Image.asset('assets/rdplogo.png',
                  height: 80), // import rdp logo to decorate top app bar
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
              //Create scrollable instance with table calendar
              child: Column(
                children: [
                  TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2024),
                    lastDay: DateTime(2025),
                  ),
                  buildTaskList(tasks, removeTasks,
                      updateTask) //display list of tasks, call parameters to remove tasks and update tasks in the list
                ],
              ),
            ),
          ),

          buildAddTaskSection(nameController, addTask), //modularization of code
        ],
      ),
      drawer: const Drawer(), //add a drawer to the appbar
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

//Widget that displays the task item on the UI, includes options to delete tasks and update tasks as well (passed as parameters)
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
              tileColor: isEven
                  ? Colors.blue
                  : Colors
                      .lightBlue, //default background color of task when added to list. Alternating blue and light blue on the list
              leading: Icon(
                task['completed']
                    ? Icons.check_circle
                    : Icons
                        .circle_outlined, //If task is completed already, the circle icon will be checked. If not yet, it will remain outlined
              ),
              title: Text(
                task['name'],
                style: TextStyle(
                    decoration: task['completed']
                        ? TextDecoration.lineThrough
                        : null, // if item checked as completed already, draw a line through the text
                    fontSize: 22),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                      value: task['completed'],
                      onChanged: (value) => updateTask(index,
                          value!)), //if checkbox is checked, task status is updated as completed
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeTasks(
                        index), //if delete button is pressed, task is deleted
                  ),
                ],
              )));
    },
  );
}

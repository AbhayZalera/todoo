import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/auth_controller.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController controller = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final AuthController auth = AuthController();

  User? get user => FirebaseAuth.instance.currentUser;
  String? editTodoId;
  bool isCompleted = false;

  Future<void> addOrUpdate() async {
    if (controller.text.isEmpty) return;

    if (editTodoId == null) {
      await fireStore
          .collection('todos')
          .add({'task': controller.text, 'user': user?.uid,});
      editTodoId = null;
    } else {
      await fireStore
          .collection('todos')
          .doc(editTodoId)
          .update({'task': controller.text});
    }
    controller.clear();
  }

  void edit(String id, String currentTask) {
    setState(() {
      editTodoId = id;
      controller.text = currentTask;
    });
  }

  Future<void> delete(String id) async {
    await fireStore.collection('todos').doc(id).delete();
  }

  void cancel() {
    setState(() {
      editTodoId = null;
      controller.clear();
    });
  }
  void todoComplete(bool newValue) => setState(() {
    isCompleted = newValue;

    if (isCompleted) {
      isCompleted = true;
    } else {
      isCompleted = false;
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.email ?? 'TODO App'),
        actions: [
          IconButton(
              onPressed: () async => await auth.signOut(),
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText:
                      editTodoId == null ? 'Add new sask' : 'edit task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                if (editTodoId != null)
                  IconButton(onPressed: cancel, icon: const Icon(Icons.cancel)),
                IconButton(onPressed: addOrUpdate, icon: const Icon(Icons.save))
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: fireStore
                      .collection('todos')
                      .where('user', isEqualTo: user?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final todos = snapshot.data!.docs;
                    if (todos.isEmpty) {
                      return Center(child: Text('No Task'));
                    }
                    return ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return ListTile(
                          title: Text(todo['task']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Checkbox(
                              //     value:isCompleted,
                              //     onChanged: todoComplete(isCompleted)
                              // ),
                              IconButton(
                                onPressed: () => edit(todo.id, todo['task']),
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => delete(todo.id),
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }))
        ],
      ),
    );
  }
}

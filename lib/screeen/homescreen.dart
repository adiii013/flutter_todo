import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? username = FirebaseAuth.instance.currentUser!.email;
String name = username!.substring(0, username!.indexOf('.'));
final dbref = FirebaseDatabase.instance.ref();

TextEditingController todo = TextEditingController();

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void addtodo() {
    String task = todo.text.toString();
    var f = DateFormat.yMd().add_jm();
    String date = f.format(DateTime.now()).toString();
    dbref.child(name).push().set({'todo': task, 'date': date});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('TODO'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter Todo',
                border: UnderlineInputBorder(),
              ),
              controller: todo,
            ),
          ),
          ElevatedButton(onPressed: addtodo, child: Text('Add')),
          SizedBox(height: 10,),
          Container(
            height: MediaQuery.of(context).size.height - 300,
            child: FirebaseAnimatedList(
              shrinkWrap: true,
              query: dbref.child(name),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                var text1 = (snapshot.value as Map)['todo'];
                var text2 = (snapshot.value as Map)['date'];
                return ListTile(
                  title: Text(text1),
                  subtitle: Text(text2),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      dbref.child(name).child(snapshot.key as String).remove();
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20,),
         Text("Made with ❤ by Aditya")
        ],
      ),
    );
  }
}

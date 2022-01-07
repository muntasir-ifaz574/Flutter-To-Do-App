import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController taskController = TextEditingController();
  TextEditingController editingController = TextEditingController();

  var box = Hive.box('myBox');




  Future<void> addData() async{
    int num = box.length+1;
    if(taskController.text != ''){
      num++;
      setState(() {
        box.put(num, taskController.text);
      });
      taskController.clear();
      Navigator.pop(context);
    }
  }

  void editTask(int index){
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text('Edit Task'),
            content: TextFormField(
              controller: editingController,
              autofocus: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                hintText: box.getAt(index),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  editingController.clear();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                  onPressed: (){
                    if(editingController.text != ''){
                      setState(() {
                        box.putAt(index, editingController.text);
                        editingController.clear();
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text('Update'),
              ),
            ],
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: box.length,
          itemBuilder: (context, index){
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    onTap:() =>editTask(index),
                    tileColor: Colors.black12,
                    title: Text(box.getAt(index)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent,), onPressed:(){
                        setState(() {
                          box.deleteAt(index);
                        });
                    },
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context){
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text('Add Task',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        onEditingComplete: addData,
                        autofocus: true,
                        enableSuggestions: true,
                        controller: taskController,
                        decoration: InputDecoration(
                          labelText: 'Write here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            height: 45,
                            onPressed: addData,
                          color: Colors.blueGrey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.blue,),
                              Text('Add Data',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),),
                            ],
                          ),),
                      ),
                    ],
                  ),
                );
              }
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      )
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/screen/data_model.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../helper.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Users').snapshots();
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
          height: height,
          width: width,
          margin: EdgeInsets.all(height*0.02),
          padding: EdgeInsets.all(height*0.025).copyWith(right: 0),
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
            borderRadius: BorderRadius.circular(height*0.02),
          ),
          child: StreamBuilder(
              stream: _usersStream,
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List storeDocs = [];
                snapshot.data!.docs.map((DocumentSnapshot document){
                    Map a = document.data() as Map<String,dynamic>;
                    storeDocs.add(a);

                    a['id'] = document.id;
                }).toList();

                return
                  ListView.separated(
                    itemCount: storeDocs.length,
                    separatorBuilder: (context,i){
                      return SizedBox(height: height*0.035,);
                    },
                    itemBuilder: (context,i){
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(height*0.02),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(height*0.02),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getRow('Name :', storeDocs[i]['name']),
                                  getRow('Email :', storeDocs[i]['email']),
                                  getRow('DOB :', storeDocs[i]['dob']),
                                  getRow('Password :', storeDocs[i]['password']),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.edit),
                                  onPressed: (){
                                    index=i;
                                    userId= storeDocs[i]['id'];
                                    nameController.text = storeDocs[i]['name'];
                                    emailController.text = storeDocs[i]['email'];
                                    dateController.text = storeDocs[i]['dob'];
                                    passwordController.text = storeDocs[i]['password'];
                                    confirmController.text = storeDocs[i]['password'];
                                    DefaultTabController.of(context)!.animateTo(1);
                                    setState(() {});
                                  }
                              ),
                              IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.delete),
                                  onPressed: (){
                                    Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: "Delete Record",
                                        style: AlertStyle(
                                            titleStyle: TextStyle(fontWeight: FontWeight.w700)
                                        ),
                                        content: Text('Are you sure you want to delete ${storeDocs[i]['name']}?',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                        buttons: [
                                          DialogButton(
                                            child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold),),
                                            onPressed: () => Navigator.pop(context),
                                            color: Colors.blue.shade200,
                                          ),
                                          DialogButton(
                                            child: Text('Delete',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                            color: Colors.blue.shade200,
                                            onPressed: () {
                                              deleteUser(storeDocs[i]['id']);
                                              Navigator.of(context).pop();
                                              nameController.clear();
                                              emailController.clear();
                                              dateController.clear();
                                              passwordController.clear();
                                              confirmController.clear();
                                              setState(() {});

                                            },
                                          ),
                                        ]

                                    ).show();
                                  }
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
              }
          ),
        ),
    );
  }
}

Widget getRow(String name,String value){
     return Row(
       children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(name,style: TextStyle(fontSize: 16),),
          )),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(value,style: TextStyle(fontSize: 16),),
          )),
       ],
     );
}







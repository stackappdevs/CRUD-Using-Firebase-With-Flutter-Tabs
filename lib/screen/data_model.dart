import 'package:flutter/cupertino.dart';

class UserData{
     String? name,email,password,dob;

     UserData({this.name,this.email,this.password,this.dob});
}

List userList = [];

int index=-1;
String userId="";

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmController = TextEditingController();





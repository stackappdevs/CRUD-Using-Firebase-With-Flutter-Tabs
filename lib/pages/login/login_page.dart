import 'package:demoapp/constants/string_constrants.dart';
import 'package:demoapp/model/user_item.dart';
import 'package:demoapp/service/user_service.dart';
import 'package:demoapp/utills/validator.dart';
import 'package:demoapp/widget/common_elevated_button.dart';
import 'package:demoapp/widget/common_icon_button.dart';
import 'package:demoapp/widget/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  late String email, password;

  bool isPwdHide = true;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  Validation validation = Validation();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                padding: EdgeInsets.all(width * 0.055),
                decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(height * 0.02)),
                child: Form(
                  key: formKey1,
                  child: Column(
                    children: [
                      emailTextField(),
                      passwordTextField(),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      loginButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  emailTextField() {
    return CommonTextFormField(
      hintText: enterEmail,
      controller: loginEmailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (val) {
        return validation.validateEmail(val);
      },
      onSaved: (val) {
        setState(() {
          email = val!;
        });
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[ ]')),
      ],
    );
  }

  passwordTextField() {
    return CommonTextFormField(
      hintText: enterPassword,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      controller: loginPasswordController,
      isObscureText: isPwdHide,
      suffix: CommonIconButton(
        onPressed: () {
          isPwdHide = !isPwdHide;
          setState(() {});
        },
        isPwdHide: isPwdHide,
      ),
      onSaved: (val) {
        setState(() {
          password = val!;
        });
      },
      validator: (val) {
        return validation.validatePassword(val);
      },
    );
  }

  loginButton() {
    return CommonElevatedButton(
      child: Text('Login'),
      onPressed: () async {
        if (formKey1.currentState!.validate()) {
          formKey1.currentState!.save();
          for (int i = 0; i < userList.length; i++) {
            if (userList[i].email == email &&
                userList[i].password == password) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'dashboard', (route) => false,
                  arguments: userList[i]);

              isLogin = true;

              loginEmailController.clear();
              loginPasswordController.clear();
              break;

            }
          }

          if(!isLogin){
            for (int i = 0; i < userList.length; i++) {

              if (userList[i].email == email &&
                  userList[i].password != password) {

                loginPasswordController.clear();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(invalidPassword),
                  duration: Duration(seconds: 3),
                ));
                DefaultTabController.of(context)!.animateTo(0);
                break;
              }
              else{

                DefaultTabController.of(context)!.animateTo(1);
              }

            }
          }
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}

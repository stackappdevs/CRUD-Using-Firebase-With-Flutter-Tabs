import 'package:demoapp/constants/string_constrants.dart';
import 'package:demoapp/model/user_item.dart';
import 'package:demoapp/service/user_service.dart';
import 'package:demoapp/utills/validator.dart';
import 'package:demoapp/widget/common_elevated_button.dart';
import 'package:demoapp/widget/common_icon_button.dart';
import 'package:demoapp/widget/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserService userService = UserService();

  late String name, email, date, password;
  Validation validation = Validation();


  DateTime selectDate = DateTime.now();
  bool isPwdHide = true;
  bool isPwdHide1 = true;
  bool isEmailExist = false;

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
                  key: formKey,
                  child: Column(
                    children: [

                      nameTextField(),
                      emailTextField(),
                      dateOfBirthTextField(),
                      passwordTextField(),
                      confirmPasswordTextField(),

                      SizedBox(
                        height: height * 0.04,
                      ),

                      registrationButton(),
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


  void checkEmail({String? userEmail}) {

    if (userList.isNotEmpty) {
      userList.forEach((i) {
        if(index > -1){
          if (i.email == email &&  i.email != userEmail) {
            setState(() {
              isEmailExist = true;
            });
          }
        }
        else if(index == -1){
          if (i.email == email) {
            setState(() {
              isEmailExist = true;
            });
          }
        }
      });
    } else {
      setState(() {
        isEmailExist = false;
      });
    }
  }


  nameTextField(){
    return CommonTextFormField(
      hintText: enterName,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      controller: nameController,
      onSaved: (val) {
        setState(() {
          name = val!;
        });
      },
      validator: (val){
          return validation.validateName(val);
      },
    );
  }

  emailTextField() {
    return CommonTextFormField(
      hintText:  enterEmail,
      controller: emailController,
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

  dateOfBirthTextField(){
      return CommonTextFormField(
            hintText: enterDOB,
            controller: dateController,
            keyboardType: TextInputType.none,
            textInputAction: TextInputAction.next,
            onTap:  () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectDate,
                firstDate: DateTime(1950, 1),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectDate) {
                selectDate = picked;
                dateController.text =
                '${selectDate.day.toString()}/${selectDate.month.toString()}/${selectDate.year.toString()}';
                date = dateController.text;
              }
              setState(() {});
            },

            validator: (val) {
              late int dobYear;
              if (dateController.text.isEmpty) {
                return errorDOB;
              } else {
                if (selectDate.year == DateTime.now().year) {
                  int year =
                  int.parse(dateController.text.split('/')[2]);
                  dobYear = year;
                  date = dateController.text;

                } else {
                  dobYear = selectDate.year;
                }
                setState(() {});
                int age = DateTime.now().year - dobYear;
                if (val!.isEmpty) {
                  return errorDOB;
                } else if (age < 18) {
                  return errorAge;
                }
                return null;
              }
            },
      );
  }

  passwordTextField() {
    return CommonTextFormField(
      hintText: enterPassword,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: passwordController,
      isObscureText: isPwdHide,
      suffix:CommonIconButton(
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

  confirmPasswordTextField(){
    return CommonTextFormField(
        hintText: enterConfirmPassword,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        controller: confirmController,
        isObscureText: isPwdHide1,
        suffix:CommonIconButton(
        onPressed: () {
          isPwdHide1 = !isPwdHide1;
          setState(() {});
        },
        isPwdHide: isPwdHide1,
      ),
        validator: (val){
            return validation.validateConfirmPassword(val, passwordController.text);
        },
    );
  }

  registrationButton(){
    return CommonElevatedButton(
      child: Text((index > -1) ? 'Update' : 'Register'),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (index > -1) {
            checkEmail(userEmail: userList[index].email);
            if (!isEmailExist) {
              userService.updateUser(userId, name, email, date, password);
              userList[index].name = name;
              userList[index].email = email;
              userList[index].dob = date;
              userList[index].password = password;

              index = -1;
              selectDate = DateTime.now();

              nameController.clear();
              emailController.clear();
              dateController.clear();
              passwordController.clear();
              confirmController.clear();

              DefaultTabController.of(context)!.animateTo(2);
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(emailExist)));
              isEmailExist = false;
            }

          } else {
            checkEmail();
            if (!isEmailExist) {
              userService.addUser(name, email, date, password);
              userList.add(UserData(
                  name: name,
                  email: email,
                  dob: date,
                  password: password));
              nameController.clear();
              emailController.clear();
              dateController.clear();
              passwordController.clear();
              confirmController.clear();
              DefaultTabController.of(context)!.animateTo(2);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(emailExist)));
              isEmailExist = false;
            }
          }

          FocusScope.of(context).unfocus();
          setState(() {});
        }
      },
    );

  }
}

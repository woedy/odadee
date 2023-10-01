import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Authentication/SignIn/model/sign_in_model.dart';
import 'package:odadee/Screens/Dashboard/dashboard_screen.dart';
import 'package:odadee/constants.dart';
import 'package:http/http.dart' as http;

Future<SignInModel> signInUser(String email, String password) async {

  final response = await http.post(
    Uri.parse(hostName + "/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);
    if (result != null) {
      //print(result['meta']['token'].toString());
      //await saveIDApiKey(result['meta']['token'].toString());
    }
    return SignInModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 203) {
    print(jsonDecode(response.body));
    return SignInModel.fromJson(jsonDecode(response.body));
  }  else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return SignInModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to Sign In');
  }
}



class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  bool show_password = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/images/odadee_logo_1.png', ), height: 120,),
                    SizedBox(
                      height: 40,
                    ),

                    Text("We trudge along to Happy Victory", style: TextStyle(fontSize: 34, fontWeight: FontWeight.w400, color: bodyText1), textAlign: TextAlign.center, ),
                    SizedBox(
                      height: 40,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.4))),
                      child: TextFormField(
                        style: TextStyle(),
                        decoration: InputDecoration(
                          //hintText: 'Enter Username/Email',

                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelText: "Username/Email",
                          labelStyle:
                          TextStyle(fontSize: 15, color: bodyText2),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                          border: InputBorder.none,),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(225),
                          PasteTextInputFormatter(),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          if (value.length < 3) {
                            return 'Name too short';
                          }
                          String pattern =
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$";
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value))
                            return 'Enter a valid email address';

                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        onSaved: (value) {
                          setState(() {

                          });
                        },
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),


                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.4))),
                      child: TextFormField(
                        style: TextStyle(),
                        decoration: InputDecoration(
                          //hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                show_password = !show_password;
                              });
                            },
                            icon: Icon(
                              show_password
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: odaSecondary,
                            ),
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          labelText: "Password",
                          labelStyle:
                          TextStyle(fontSize: 15, color: bodyText2),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                          border: InputBorder.none,),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(225),
                          PasteTextInputFormatter(),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*])')
                              .hasMatch(value)) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("- Password must be at least 8 characters long\n- Must include at least one uppercase letter,\n- One lowercase letter, one digit,\n- And one special character"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return '';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        obscureText: show_password ? false : true,
                        onSaved: (value) {
                          setState(() {


                          });
                        },
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Forgot Password", style: TextStyle(fontSize: 16, color: odaSecondary,),),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Align(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: odaSecondary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {

                            /*   if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              KeyboardUtil.hideKeyboard(context);

                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUp2()));

                            }*/

                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DashboardScreen()));
                          },
                          child: Align(
                            child: Container(
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "Sign Up here",
                              style: TextStyle(
                                  color: odaSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            )
                          ])),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height:20,
              ),


            ],
          ),
        ),
      ),
    );
  }
}

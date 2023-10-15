import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Authentication/ForgetPassword/forgot_password.dart';
import 'package:odadee/Screens/Authentication/SignIn/model/sign_in_model.dart';
import 'package:odadee/Screens/Authentication/SignUp/sign_up_2.dart';
import 'package:odadee/Screens/Dashboard/dashboard_screen.dart';
import 'package:odadee/components/keyboard_utils.dart';
import 'package:odadee/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<SignInModel> signInUser(String user, String password, String logged_from) async {

  final response = await http.post(
    Uri.parse(hostName + "/api/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode({
      "user": user,
      "password": password,
      "device_token": "device_token",
      "logged_from": logged_from,
    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);
    if (result != null) {
      //print(result['meta']['token'].toString());
      await saveIDApiKey(result['token'].toString());
      await saveUserData(result['userData']);



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


Future<bool> saveIDApiKey(String apiKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("API_Key", apiKey);
  return prefs.commit();
}

Future<bool> saveUserData(Map<String, dynamic> userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("YearGroup", userData['yearGroup'].toString());
  prefs.setString("image", userData['image'].toString());
  prefs.setString("email", userData['email'].toString());
  prefs.setString("phone", userData['phone'].toString());
  prefs.setString("firstName", userData['firstName'].toString());
  prefs.setString("middleName", userData['middleName'].toString());
  prefs.setString("lastName", userData['lastName'].toString());
  return prefs.commit();
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  bool show_password = false;
  Future<SignInModel>? _futureSignIn;
  String? fcm_token;
  String? platformType;



  final _formKey = GlobalKey<FormState>();


  String? user;
  String? password;

/*  get_fcm_token() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log("FCMToken $fcmToken");
    fcm_token = fcmToken.toString();

  }*/

  String getPlatformType() {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return 'Unknown';
    }
  }

  @override
  void initState() {
    super.initState();

    //get_fcm_token();

    platformType = getPlatformType();
  }

  @override
  Widget build(BuildContext context) {
    return (_futureSignIn == null) ? buildColumn() : buildFutureBuilder();
  }



  buildColumn(){
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          //color: Colors.red,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
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
                              return 'Email/Username is required';
                            }
                            if (value.length < 3) {
                              return 'Email/Username too short';
                            }
                            /*  String pattern =
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                r"{0,253}[a-zA-Z0-9])?)*$";
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Enter a valid email address';
*/
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onSaved: (value) {
                            setState(() {

                              user = value;

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
                              password = value;


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
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ForgotPasswordScreen()));

                            },
                              child: Text("Forgot Password", style: TextStyle(fontSize: 16, color: odaSecondary,),)),
                        ],
                      ),
                    ],
                  ),
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

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              KeyboardUtil.hideKeyboard(context);

                              //_futureSignIn = signInUser(user!, password!, fcm_token!, platformType!);
                              _futureSignIn = signInUser(user!, password!, platformType!);


                            }

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


  FutureBuilder<SignInModel> buildFutureBuilder() {
    return FutureBuilder<SignInModel>(
        future: _futureSignIn,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Please Wait...")
                  ],
                ),
              ),
            );
          }
          else if(snapshot.hasData) {

            var data = snapshot.data!;

            print("#########################");
            print(data.error);
            print(data.token);

            if(data.error == "Your profile is not active") {


              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen())
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green,),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Error"),
                          ],
                        ),
                        content: Text(data.error.toString()),
                      );
                    }
                );

              });
            }
            else if(data.token != null) {

              if(data.userData!.hasBio == false || data.userData!.hasImage == false){


                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUp2(data: data.userData!))
                  );

                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green,),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Success"),
                            ],
                          ),
                          content: Text("Please Update your profile and proceed."),
                        );
                      }
                  );

                });



              }else{




                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green,),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Success"),
                            ],
                          ),
                          content: Text("User logged in successfully."),
                        );
                      }
                  );

                  Timer(Duration(seconds: 1), () {
                    Navigator.of(context).pop();


                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => DashboardScreen())
                    );

                  });




                });


              }


            }
            else if(data.error == "Please enter a valid Username or Email") {


              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen())
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.close, color: Colors.red,),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Error"),
                          ],
                        ),
                        content: Text(data.error.toString()),
                      );
                    }
                );

              });
            }
            else if(data.error == "Please enter the valid Password.") {


              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen())
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.close, color: Colors.red,),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Error"),
                          ],
                        ),
                        content: Text(data.error.toString()),
                      );
                    }
                );

              });
            }
            else if(data.error == "Your Login attempts is over") {


              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen())
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.close, color: Colors.red,),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Error"),
                          ],
                        ),
                        content: Text(data.error.toString()),
                      );
                    }
                );

              });
            }
         }

          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please Wait...")
                ],
              ),
            ),
          );


        }
    );
  }


  void dispose() {
    super.dispose();
  }


}

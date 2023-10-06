
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:odadee/Screens/Authentication/SignIn/sgin_in_screen.dart';
import 'package:odadee/Screens/Authentication/SignUp/models/sign_up_model.dart';
import 'package:odadee/Screens/Authentication/SignUp/sign_up_2.dart';
import 'package:odadee/components/keyboard_utils.dart';
import 'package:odadee/constants.dart';
import 'package:http/http.dart' as http;

Future<SignUpModel> registerUser(data) async {

  final response = await http.post(
    Uri.parse(hostName + "/api/register"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode({
      "country": data['country'],
      "username": data['username'],
      "yearGroup": data['yearGroup'],
      "firstName": data['firstName'],
      "middleName": data['middleName'],
      "lastName": data['lastName'],
      "email": data['email'],
      "password": data['password'],
      "device_token": " data['device_token']",
      "logged_from": data['logged_from'],

    }),
  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    final result = json.decode(response.body);
    if (result != null) {
      //print(result['meta']['token'].toString());
      //await saveIDApiKey(result['meta']['token'].toString());
    }
    return SignUpModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 203) {
    print(jsonDecode(response.body));
    return SignUpModel.fromJson(jsonDecode(response.body));
  }  else if (response.statusCode == 403) {
    print(jsonDecode(response.body));
    return SignUpModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return SignUpModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to Sign Up');
  }
}

class SignUp1 extends StatefulWidget {

  const SignUp1({Key? key,}) : super(key: key);

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  TextEditingController controller = TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();
  Future<SignUpModel>? _futureSignUp;

  bool show_password = false;

  bool hasError = false;

  FocusNode focusNode = FocusNode();

  String? fcm_token;
  String? platformType;

  String? _selectedCountry;
  String? yearGroup;
  String? username;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? password;


 /* get_fcm_token() async {
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
    return (_futureSignUp == null) ? buildColumn() : buildFutureBuilder();
  }


  buildColumn(){
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:30,
              ),
              Container(
                child:    InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),


                    ),
                    child: Icon(Icons.arrow_back, color: odaSecondary, size: 30,),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Form(
                        key: _formKey,
                        child: Container(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Let's get started", style: TextStyle(fontSize: 34),),
                              SizedBox(
                                height: 40,
                              ),


                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Country", style: TextStyle(fontSize: 12),),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      showCountryPicker(

                                          context: context,
                                          showPhoneCode: true,
                                          onSelect: (Country country) {
                                            setState(() {
                                              _selectedCountry = country.name;
                                            });
                                          },
                                          countryListTheme: CountryListThemeData(
                                              textStyle: TextStyle(color: Colors.black)
                                          )

                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 55,
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        //color: Colors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.grey.withOpacity(0.4))),
                                      child: Row(
                                        children: [
                                          if(_selectedCountry != null)...[
                                            Text(_selectedCountry.toString(), style: TextStyle(fontSize: 15, color: Colors.black)),
                                          ]else...[

                                            Text("Select Country", style: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(1))),

                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 20,
                              ),


                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Graduation Year", style: TextStyle(fontSize: 12),),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //_selectGraduationYear(context);
                                      _showGraduationYearModal(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.grey.withOpacity(0.4))
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            yearGroup ?? 'Select Year',
                                            style: TextStyle(fontSize: 15, color: bodyText2),
                                          ),
                                          Icon(Icons.calendar_today_outlined, size: 22, color: odaSecondary,),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
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
                                    //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    labelText: "First Name",
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
                                      return 'First name is required';
                                    }
                                    if (value.length < 3) {
                                      return 'First name too short';
                                    }

                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  onSaved: (value) {
                                    setState(() {

                                      firstName = value;

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
                                    //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    labelText: "Middle Name",
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
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  onSaved: (value) {
                                    setState(() {

                                      middleName = value;

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
                                    //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    labelText: "Last Name",
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
                                      return 'Last name is required';
                                    }
                                    if (value.length < 3) {
                                      return 'Last name too short';
                                    }

                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  onSaved: (value) {
                                    setState(() {

                                      lastName = value;

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
                                    //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    labelText: "Username",
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
                                      return 'Username is required';
                                    }
                                    if (value.length < 3) {
                                      return 'Username too short';
                                    }

                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  autofocus: false,
                                  onSaved: (value) {
                                    setState(() {

                                      username = value;

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
                                    //hintText: 'Enter Username/Email',

                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    labelText: "Email Address",
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

                                      email = value.toString().toLowerCase();

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

                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    }
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
                                      labelText: "Confirm Password",
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

                                      if (value != password) {
                                        return 'Passwords do not match';
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
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    }
                                ),
                              ),


                              SizedBox(
                                height: 20,
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

                                              print("##############");

                                              var _data = {
                                                "username": username,
                                                "yearGroup": yearGroup,
                                                "firstName": firstName,
                                                "middleName": middleName,
                                                "lastName": lastName,
                                                "country": _selectedCountry,
                                                "email": email,
                                                "password": password,
                                                "device_token": "fcm_token",
                                                "logged_from": platformType,
                                              };

                                              _futureSignUp = registerUser(_data);

                                              print(_data);

                                              // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUp2(data: _data)));

                                            }


                                          },
                                          child: Align(
                                            child: Container(
                                              child: Text(
                                                "Continue",
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

                                        /*   Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                              (route) => false,
                        );*/

                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
                                      },
                                      child: Text.rich(TextSpan(
                                          text: "Already have an account? ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: "Sign In here",
                                              style: TextStyle(
                                                  color: odaSecondary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
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
                      )
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


  FutureBuilder<SignUpModel> buildFutureBuilder() {
    return FutureBuilder<SignUpModel>(
        future: _futureSignUp,
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


            if(data.successTopMessage == "Your Account has been Created") {


              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignUp2(data: data.userData))
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
                            Expanded(child: Text("Your Account has been Created")),
                          ],
                        ),
                        content: Text(data.successMessage.toString()),
                      );
                    }
                );

              });
            }
            if(data.successTopMessage == null) {



              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignUp1())
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
                        content: Text("The username/email has already been taken."),
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





  void _showGraduationYearModal (BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: odaPrimary,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)
                  )
                ),
                height: 300,
              ),
              Positioned(
                top: 15,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.05)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Select Graduation Year", style: TextStyle(color: Colors.black, fontSize: 20),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      Container(
                        //color: Colors.red,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,

                          children: [


                            SizedBox(
                              height: 150, // Adjust the height as needed
                              child: ListView.builder(
                                itemCount: 100, // Number of years to display
                                itemBuilder: (BuildContext context, int index) {
                                  final year = 1960 + index;
                                  return InkWell(
                                    onTap: (){
                                      print(year.toString());
                                      setState(() {
                                        yearGroup = year.toString();
                                        Navigator.of(context).pop(year.toString());

                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      child: Column(
                                        children: [
                                          Text(year.toString(), style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            width: 150,
                                            child: Divider(
                                              color: Colors.black,
                                              thickness: 1,

                                            ),

                                          ),


                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),



                          ],
                        ),
                      )


                    ],

                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }



}


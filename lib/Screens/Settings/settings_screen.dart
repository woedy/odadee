import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Profile/user_profile_screen.dart';
import 'package:odadee/Screens/Projects/models/project_detail_model.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Radio/radio_screen.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;

import '../Dashboard/dashboard_screen.dart';
import '../Radio/playing_screen.dart';





class SettingsScreen extends StatefulWidget {

  const SettingsScreen({Key? key,}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? state;

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }


  Future<void> fetchDataFromServer() async {
    var token = await getApiPref();

    final response = await http.get(
        Uri.parse(hostName + '/api/settings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final pushNotificationValue = jsonData['setting']['push_notification'];
      setState(() {
        if (pushNotificationValue == "1"){
          state = true;
        }else {
          state = false;
        }

      });
    } else {
      // Handle any errors when fetching data
      // You might want to set a default value for 'state' in case of an error.
    }
  }

  Future<void> updateNotificationStatus(bool value) async {
    var token = await getApiPref();

    final response = await http.post(
      Uri.parse(hostName + '/api/settings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString(),
      },
      body: json.encode({'push_notification': value ? "1" : "0"}),
    );

    if (response.statusCode == 200) {
      // Successfully updated the notification status
      setState(() {
        state = value;
      });
    } else {
      // Handle errors in updating the status
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildColumn();

  }




  buildColumn(){
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
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
                              width: 10,
                            ),
                            Text("Settings", style: TextStyle(fontSize: 20, color: Colors.black),),
                          ],
                        ),
                        Stack(
                          children: [
                            Icon(Icons.notifications_none_outlined, color: odaSecondary, size: 30,),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: odaSecondary,
                                radius: 5,
                              ),
                            )
                          ],
                        )
                      ],

                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Notification", style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                  CupertinoSwitch(
                                    value: state ?? false,
                                    onChanged: (value) {
                                      // Call the function to update the notification status
                                      updateNotificationStatus(value);
                                    },
                                    thumbColor: CupertinoColors.white,
                                    activeColor: CupertinoColors.systemGreen,
                                  )
                                ],
                              ),

                              SizedBox(
                                height: 100,
                              ),

                            ],
                          ),
                        ),
                      )
                  )

                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DashboardScreen()));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.home, color: Colors.grey,),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Home', style: TextStyle(color: Colors.grey, fontSize: 12),),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RadioScreen()));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.radio, color: Colors.grey),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Radio', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayDuesScreen()));
                        },
                        child: Column(
                          children: [
                            Icon(Icons.phone_android, color: Colors.grey,),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Pay Dues', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){


                        },
                        child: Column(
                          children: [
                            Icon(Icons.settings, color: odaSecondary,),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Settings', style: TextStyle(color: odaSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){

                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen()));

                        },
                        child: Column(
                          children: [
                            Icon(Icons.person, color: Colors.grey,),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Profile', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),


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









}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Projects/models/project_detail_model.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Radio/radio_screen.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;

import '../Radio/playing_screen.dart';





class SettingsScreen extends StatefulWidget {

  const SettingsScreen({Key? key,}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


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
                          /*      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DashboardScreen()));
                      */  },
                        child: Column(
                          children: [
                            Icon(Icons.home, color: odaSecondary,),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Home', style: TextStyle(color: odaSecondary, fontSize: 12),),
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
                            Icon(Icons.settings, color: Colors.grey,),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Settings', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){


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

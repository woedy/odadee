import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Events/event_details.dart';
import 'package:odadee/Screens/Events/models/events_model.dart';
import 'package:odadee/Screens/Projects/models/all_projects_model.dart';
import 'package:odadee/Screens/Projects/project_details.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'package:http/http.dart' as http;



Future<AllEventsModel> getAllEvents() async {

  var token = await getApiPref();

  final response = await http.get(
    Uri.parse(hostName + "/api/events"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
    },

  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));

    return AllEventsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return AllEventsModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to load data');
  }
}



class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  bool show_filter = false;
  String? graduation_year;
  final _formKey = GlobalKey<FormState>();

  Future<AllEventsModel>? _futureGetAllEvents;


  @override
  void initState() {
    super.initState();
    _futureGetAllEvents = getAllEvents();

  }


  @override
  Widget build(BuildContext context) {
    return (_futureGetAllEvents == null) ? buildColumn() : buildFutureBuilder();

  }


  buildColumn(){
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }





  FutureBuilder<AllEventsModel> buildFutureBuilder() {
    return FutureBuilder<AllEventsModel>(
        future: _futureGetAllEvents,
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
            var events = data.events!.data!;

            print("#########################");

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
                                    Text("Events", style: TextStyle(fontSize: 20, color: Colors.black),),
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
                              child: Container(

                                child: ListView.builder(
                                    itemCount: events.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(15),
                                        width: MediaQuery.of(context).size.width,

                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 89,

                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: odaSecondary.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  GradientText(
                                                      extractDateInfo(events[index].startDate!)['day'].toString(),
                                                      style: const TextStyle(fontSize: 36, color: odaSecondary),
                                                      colors: [
                                                        odaPrimary,
                                                        odaSecondary,
                                                      ]
                                                  ),

                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(extractDateInfo(events[index].startDate!)['month'].toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                                      Text(extractDateInfo(events[index].startDate!)['year'].toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Container(
                                                //color: Colors.red,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(events[index].title!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, color: Colors.black),),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(events[index].content!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventDetailsScreen(data: events[index])));

                                                      },
                                                      child: Container(
                                                        width: 110,
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: odaPrimary,
                                                          borderRadius: BorderRadius.circular(5)

                                                        ),
                                                        child: Center(
                                                          child: Text("Event Detail", style: TextStyle(color: Colors.white),),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
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
                              Column(
                                children: [
                                  Icon(Icons.home, color: odaSecondary,),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text('Home', style: TextStyle(color: odaSecondary, fontSize: 12),),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.radio, color: Colors.grey),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text('Radio', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.phone_android, color: Colors.grey,),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text('Pay Dues', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.settings, color: Colors.grey,),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text('Settings', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Icons.person, color: Colors.grey,),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text('Settings', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
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








}

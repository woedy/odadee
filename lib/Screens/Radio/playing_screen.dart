import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:odadee/Screens/Dashboard/dashboard_screen.dart';
import 'package:odadee/Screens/Profile/user_profile_screen.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Radio/RadioConfig/frp_player.dart';
import 'package:odadee/Screens/Radio/models/radios_models.dart';
import 'package:odadee/Screens/Settings/settings_screen.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;



Future<RadiosModel> getRadioStations() async {

  var token = await getApiPref();

  final response = await http.post(
    Uri.parse(hostName + "/api/stations"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
    },

  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));

    return RadiosModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return RadiosModel.fromJson(jsonDecode(response.body));
  }  else {
    print(jsonDecode(response.body));

    throw Exception('Failed to load data');
  }
}



class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {


  Future<RadiosModel>? _futureGetAllStations;

  final FlutterRadioPlayer _flutterRadioPlayer = FlutterRadioPlayer();


  bool isPlaying = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;


  final FRPSource frpSource = FRPSource(
    mediaSources: <MediaSources>[
      MediaSources(
        url: "https://stream.zeno.fm/b51ep03x438uv",
        description: "Connecting of current student body and Administration directly with Alumni both locally and those in the diaspora.",
        isPrimary: true,
        title: "ODADEƐ Radio",
        isAac: false,
      ),
    ],
  );




  @override
  void initState() {
    super.initState();
    _futureGetAllStations = getRadioStations();

    _flutterRadioPlayer.initPlayer();
    _flutterRadioPlayer.addMediaSources(frpSource);
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return (_futureGetAllStations == null) ? buildColumn() : buildFutureBuilder();

  }



  buildColumn(){
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }



  FutureBuilder<RadiosModel> buildFutureBuilder() {
    return FutureBuilder<RadiosModel>(
        future: _futureGetAllStations,
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
            var stations = data.response!.hits!;

            print("#########################");

            return Scaffold(
              body: SafeArea(
                //padding: EdgeInsets.all(20),
                bottom: false,
                child: Stack(
                  children: [
                    Column(
                      children: [
                       /* FRPlayer(
                          flutterRadioPlayer: _flutterRadioPlayer,
                          frpSource: frpSource,
                          useIcyData: true,
                        ),*/
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
                                  Text("Playing", style: TextStyle(fontSize: 20, color: Colors.black),),
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
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                    height: 340,
                                    width: 340,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(stations[0].logo!.toString()),
                                            fit: BoxFit.cover
                                        )
                                    ),
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),
                                  GradientText(stations[0].name!.toString(), style: TextStyle(fontSize:16, fontWeight: FontWeight.w900), colors: [odaPrimary, odaSecondary]),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("www.odadeeradio.com", style: TextStyle(fontSize:24, fontWeight: FontWeight.w900, color: Colors.black)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Akan, English (UK)", style: TextStyle(fontSize:14,)),
                                  //Text((duration - position).toString(), style: TextStyle(fontSize:14,)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 2,
                                        width: 290,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  odaPrimary,
                                                  odaSecondary
                                                ]
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),



                                  FRPlayer(
                                    flutterRadioPlayer: _flutterRadioPlayer,
                                    frpSource: frpSource,
                                    useIcyData: true,
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),


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
                                /*    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RadioScreen()));
                     */ },
                              child: Column(
                                children: [
                                  Icon(Icons.radio, color: odaSecondary),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text('Radio', style: TextStyle(color: odaSecondary, fontSize: 12)),
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
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingsScreen()));


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

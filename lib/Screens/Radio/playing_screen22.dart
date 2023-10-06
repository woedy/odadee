import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Dashboard/dashboard_screen.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {

  bool show_password = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //padding: EdgeInsets.all(20),
        bottom: false,
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
                                image: AssetImage("assets/images/playing.png"),
                                fit: BoxFit.cover
                              )
                            ),
                          ),

                          SizedBox(
                            height: 30,
                          ),
                          GradientText("Thomas Larson", style: TextStyle(fontSize:16, fontWeight: FontWeight.w900), colors: [odaPrimary, odaSecondary]),
                          SizedBox(
                            height: 20,
                          ),
                          Text("The Future Everything", style: TextStyle(fontSize:24, fontWeight: FontWeight.w900, color: Colors.black)),
                          SizedBox(
                            height: 20,
                          ),
                          Text("1h 23min - 2 EP", style: TextStyle(fontSize:14,)),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              SizedBox(),
                             Image(image: AssetImage("assets/images/back.png"), height: 22),
                             Container(
                               height: 60,
                               width: 60,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(100),
                                 gradient: LinearGradient(
                                   colors: [
                                     odaPrimary,
                                     odaSecondary
                                   ]
                                 )
                               ),
                               child: Center(
                                 child: Icon(Icons.play_arrow_outlined, color: Colors.white, size: 40,),
                               ),
                             ),
                             Image(image: AssetImage("assets/images/forward.png"), height: 22,),
                              SizedBox(),
                              SizedBox(),
                            ],
                          )


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
    );
  }
}





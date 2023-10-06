import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Dashboard/dashboard_screen.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Radio/playing_screen.dart';
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
                      Text("Radio", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black),  ),

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(

                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  odaPrimary.withOpacity(0.2),
                                  odaSecondary.withOpacity(0.2)
                                ]
                              )
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Find your suitable Radio"),
                                  Icon(Icons.search, color: odaSecondary,)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Recently Played", style: TextStyle( fontSize: 20, color: odaSecondary),),


                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PlayingScreen()));

                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          width: 220,

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Container(
                                                width: 220,
                                                height: 220,

                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: AssetImage("assets/images/radio.png",),
                                                    fit: BoxFit.cover
                                                  )
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(child: Text("The Future Everything", style: TextStyle( fontSize: 16, color: Colors.black),)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text("1h 23min - 2 EP", style: TextStyle( fontSize: 12, color:Colors.grey),),


                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Recommended for you", style: TextStyle( fontSize: 20, color: odaSecondary),),

                                  GradientText(
                                      'View All',
                                      style: const TextStyle(fontSize: 12, color: odaSecondary),
                                      colors: [
                                        odaPrimary,
                                        odaSecondary,
                                      ]
                                  ),
                                ],
                              ),

                              Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        width: 130,

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Container(
                                              width: 130,
                                              height: 130,

                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: AssetImage("assets/images/radio2.png",),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Text("Healthy Life", style: TextStyle( fontSize: 16, color: Colors.black),)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Harlow Hadid", style: TextStyle( fontSize: 12, color:Colors.grey),),


                                          ],
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
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

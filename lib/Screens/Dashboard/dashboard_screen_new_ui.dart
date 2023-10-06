import 'package:flutter/material.dart';
import 'package:odadee/Screens/AllUsers/all_users_screen.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Projects/project_details.dart';
import 'package:odadee/Screens/Projects/projects_screen.dart';
import 'package:odadee/Screens/Radio/radio_screen.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dashboard", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),),
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("95 year group", style: TextStyle( fontSize: 20, color: odaSecondary),),

                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllRegisteredUsers()));

                                },
                                child: Container(
                                  child: GradientText(
                                      'View All',
                                      style: const TextStyle(fontSize: 12, color: odaSecondary),
                                      colors: [
                                        odaPrimary,
                                        odaSecondary,
                                      ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            //color: Colors.red,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.all(10),

                                        width: 60,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                              colors: [
                                                odaPrimary,
                                                odaSecondary,
                                              ],begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                        ),
                                        child: Center(
                                          child: Image.asset("assets/images/pring.png", height: 30,),
                                        ),
                                      ),
                                    ),
                                    Text("", style: TextStyle( fontSize: 16, color: odaSecondary),),


                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                height: 20,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/dash_user.png")
                                                    )
                                                ),
                                              ),
                                            ),
                                            Text("Taller", style: TextStyle( fontSize: 16, color: odaSecondary),),


                                          ],
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                    Container(
                      color: odaSecondary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Latest Events", style: TextStyle( fontSize: 20, color: odaSecondary),),


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


                              SizedBox(
                                height: 10,
                              ),


                              Container(
                                height: 140,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        width: 140,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Row(
                                                children: [
                                                  GradientText(
                                                      '28',
                                                      style: const TextStyle(fontSize: 36, color: odaSecondary),
                                                      colors: [
                                                        odaPrimary,
                                                        odaSecondary,
                                                      ]
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("November", style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                                      Text("2023", style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Text("Report for tenure of office", style: TextStyle( fontSize: 16, color: Colors.black),)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),


                                          ],
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // color: odaSecondary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Projects", style: TextStyle( fontSize: 20, color: odaSecondary),),

                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProjectsScreen()));

                                    },
                                    child: GradientText(
                                        'View All',
                                        style: const TextStyle(fontSize: 12, color: odaSecondary),
                                        colors: [
                                          odaPrimary,
                                          odaSecondary,
                                        ]
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                height: 280,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProjectDetailsScreen(data: {},)));

                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          width: 296,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Image(image: AssetImage("assets/images/project-img.png", ), height: 169,),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(child: Text("Apeadu House", style: TextStyle( fontSize: 16, color: Colors.black),)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text("140 Bed Hostel named Apeadu House...", style: TextStyle( fontSize: 12, color:Colors.grey),),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        color: odaPrimary,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Center(
                                                      child: Text("View Project", style: TextStyle(color: Colors.white),),
                                                    ),
                                                  ),

                                                  Text("\$10", style: TextStyle(color: odaSecondary, fontWeight: FontWeight.w900, fontSize: 20),)
                                                ],
                                              )


                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // color: odaSecondary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Projects", style: TextStyle( fontSize: 20, color: odaSecondary),),

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
                                height: 270,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        width: 296,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Image(image: AssetImage("assets/images/dash_news.png", ), height: 169,),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Text("Report for tenure of office", style: TextStyle( fontSize: 16, color: Colors.black),)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Aug 12, 2022", style: TextStyle( fontSize: 12, color:Colors.grey),),


                                          ],
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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

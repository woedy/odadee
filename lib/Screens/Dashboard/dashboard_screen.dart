import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odadee/Screens/AllUsers/all_users_screen.dart';
import 'package:odadee/Screens/AllUsers/models/all_users_model.dart';
import 'package:odadee/Screens/AllUsers/user_detail_screen.dart';
import 'package:odadee/Screens/Articles/all_news_screen.dart';
import 'package:odadee/Screens/Articles/models/all_articles_model.dart';
import 'package:odadee/Screens/Articles/news_details.dart';
import 'package:odadee/Screens/Events/event_details.dart';
import 'package:odadee/Screens/Events/events_list.dart';
import 'package:odadee/Screens/Events/models/events_model.dart';
import 'package:odadee/Screens/Profile/user_profile_screen.dart';
import 'package:odadee/Screens/Projects/models/all_projects_model.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Projects/project_details.dart';
import 'package:odadee/Screens/Projects/projects_screen.dart';
import 'package:odadee/Screens/Radio/radio_screen.dart';
import 'package:odadee/Screens/Settings/settings_screen.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;

import '../Authentication/SignIn/sgin_in_screen.dart';
import '../Radio/playing_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  Future<AllUsersModel> _fetchAllUsersData() async {

    var token = await getApiPref();

    final response = await http.get(
      Uri.parse(hostName + "/api/users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },

    );


    if (response.statusCode == 200) {

      return AllUsersModel.fromJson(jsonDecode(response.body));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));

      throw Exception('Failed to fetch user data');
    }
  }


  Future<AllEventsModel> _fetchAllEventsData() async {

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

      return AllEventsModel.fromJson(jsonDecode(response.body));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));

      throw Exception('Failed to fetch events data');
    }
  }

  Future<AllProjectsModel> _fetchAllProjectsData() async {

    var token = await getApiPref();

    final response = await http.get(
      Uri.parse(hostName + "/api/projects"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },

    );


    if (response.statusCode == 200) {

      print(response.body);

      return AllProjectsModel.fromJson(jsonDecode(response.body));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));

      throw Exception('Failed to fetch projects data');
    }
  }


  Future<AllArticlesModel> _fetchAllArticlesData() async {

    var token = await getApiPref();

    final response = await http.get(
      Uri.parse(hostName + "/api/articles"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },

    );


    if (response.statusCode == 200) {

      print(response.body);

      return AllArticlesModel.fromJson(jsonDecode(response.body));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));

      throw Exception('Failed to fetch articles data');
    }
  }

  String? user_year_group;

  @override
  void initState() {
    get_user_year_group();
    super.initState();

  }



  get_user_year_group() async {
    user_year_group = await getUserYearGroup();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          _fetchAllUsersData(),
          _fetchAllEventsData(),
          _fetchAllProjectsData(),
          _fetchAllArticlesData(),

        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final userData = snapshot.data![0];


            final eventsData = snapshot.data![1];

            final projectsData = snapshot.data![2];

            final articlesData = snapshot.data![3];
            print(articlesData.toJson());

            // Check if any of the data is null (indicating an error)
            if (userData == null || eventsData == null || projectsData == null || articlesData == null ) {
              return Center(
                child: Text('Error: Some data could not be fetched'),
              );
            }


            return SafeArea(
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
                                    Text(user_year_group!.substring(user_year_group!.length - 2) + " year group", style: TextStyle( fontSize: 20, color: odaSecondary),),

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
                                   /*   Column(
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
                                      ),*/
                                      Expanded(
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: userData.users.data.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: (){
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserDetailScreen(data: userData.users.data[index])));

                                                },
                                                child: Column(
                                                  children: [

                                                    if(userData.users.data[index].image != "")...[
                                                      Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.all(10),
                                                          height: 30,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(userData.users.data[index].image),
                                                                  fit: BoxFit.cover
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                    ]else...[
                                                      Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.all(10),
                                                          height: 30,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                            color: odaPrimary.withOpacity(0.1)
                                                          ),
                                                          child: Center(
                                                            child: Text(userData.users.data[index].firstName.toString().substring(0, 1) + userData.users.data[index].lastName.toString().substring(0, 1), style: TextStyle( fontSize: 19, color: Colors.grey),),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    Text(userData.users.data[index].firstName, style: TextStyle( fontSize: 16, color: Colors.grey),),

                                                  ],
                                                ),
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

                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventsScreen()));

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

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Container(
                                      height: 130,
                                      width: MediaQuery.of(context).size.width,
                                      //color: Colors.red,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: eventsData.events.data.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EventDetailsScreen(data: eventsData.events.data[index])));

                                              },
                                              child: Container(
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
                                                              extractDateInfo(eventsData.events.data[index].startDate!)['day'].toString(),
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
                                                              Text(extractDateInfo(eventsData.events.data[index].startDate!)['month'].toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),),
                                                              Text(extractDateInfo(eventsData.events.data[index].startDate!)['year'].toString(), style: const TextStyle(fontSize: 12, color: Colors.grey),),
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
                                                        Expanded(child: Text(eventsData.events.data[index].title,maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: Colors.black),)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),


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
                                    SizedBox(
                                      height: 10,
                                    ),


                                    Container(
                                      height: 280,
                                      width: MediaQuery.of(context).size.width,
                                      //color: Colors.red,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: projectsData.projects.data.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProjectDetailsScreen(data: projectsData.projects.data[index])));

                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                //color: Colors.red,
                                                width: 296,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [
                                                    Container(
                                                        height: 169,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            image: DecorationImage(
                                                                image: NetworkImage(projectsData.projects.data[index].image),fit: BoxFit.cover
                                                            )
                                                        )),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(child: Text(projectsData.projects.data[index].title,maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: Colors.black),)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(projectsData.projects.data[index].content, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color:Colors.grey),),
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

                                                        Text("\$" + projectsData.projects.data[index].fundingTargetDollar, style: TextStyle(color: odaSecondary, fontWeight: FontWeight.w900, fontSize: 20),)
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
                                        Text("Latest News", style: TextStyle( fontSize: 20, color: odaSecondary),),

                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllNewsScreen()));

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

                                    SizedBox(
                                      height: 10,
                                    ),


                                    Container(
                                      height: 270,
                                      width: MediaQuery.of(context).size.width,
                                      //color: Colors.red,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: articlesData.news.data.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NewsDetailsScreen(data: articlesData.news.data[index])));

                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                width: 296,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [
                                                    Container(
                                                        height: 169,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            image: DecorationImage(
                                                                image: NetworkImage(articlesData.news.data[index].image),fit: BoxFit.cover
                                                            )
                                                        )),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(child: Text(articlesData.news.data[index].title, style: TextStyle( fontSize: 16, color: Colors.black),)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(articlesData.news.data[index].createdTime, style: TextStyle( fontSize: 12, color:Colors.grey),),


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
                          SizedBox(
                            height: 80,
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
          } else {
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }

}

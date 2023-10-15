
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odadee/Screens/Articles/models/all_articles_model.dart';
import 'package:odadee/Screens/Profile/user_profile_screen.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Radio/playing_screen.dart';
import 'package:odadee/Screens/Settings/settings_screen.dart';
import 'package:odadee/constants.dart';
import 'package:http/http.dart' as http;

import 'news_details.dart';

class AllNewsScreen extends StatefulWidget {
  @override
  _AllNewsScreenState createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  List newsList = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchNewsData(currentPage);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (currentPage < lastPage && !isLoading) {
        currentPage++;
        _fetchNewsData(currentPage);
      }
    }
  }

  Future<void> _fetchNewsData(int page) async {
    setState(() {
      isLoading = true;
    });

    var token = await getApiPref();


    final response = await http.get(
      Uri.parse(hostName + '/api/articles?page=$page'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newsData = News.fromJson(data['news']); // Map the top-level 'news' object

      setState(() {
        lastPage = newsData.lastPage!;
        newsList.addAll(newsData.data!);
        isLoading = false;
      });
      print(newsData);
    } else {
      throw Exception('Failed to load news data');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            Text("All News", style: TextStyle(fontSize: 20, color: Colors.black),),
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
                        controller: _scrollController,
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          final newsItem = newsList[index];
                          return Container(
                            margin: EdgeInsets.all(20),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  height: 169,
                                  decoration: BoxDecoration(
                                      color:odaSecondary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(newsItem.image.toString()),
                                          fit: BoxFit.cover

                                      )
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text(newsItem.title.toString(), maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 18, color: Colors.black),)),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.access_time_outlined, size: 20, color: Colors.grey,),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(convertToFormattedDate(newsItem.createdTime.toString()), style: TextStyle( fontSize: 12, color:Colors.grey),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.person_outlined, size: 20, color: Colors.grey,),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(newsItem.createdTime.toString(), style: TextStyle( fontSize: 12, color:Colors.grey),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                Text(newsItem.createdTime.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 15, color:Colors.black54),),
                                SizedBox(
                                  height: 10,
                                ),

                                InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NewsDetailsScreen(data: newsItem)));

                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: odaPrimary,
                                        borderRadius: BorderRadius.circular(5)

                                    ),
                                    child: Center(
                                      child: Text("Read More", style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 75,
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
      ),
    );
  }
}

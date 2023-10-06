import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:odadee/Screens/Articles/models/all_articles_model.dart';
import 'package:odadee/Screens/Articles/news_details.dart';

import 'package:odadee/constants.dart';

import 'package:http/http.dart' as http;



Future<AllArticlesModel> getAllNews() async {

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
    print(jsonDecode(response.body));

    return AllArticlesModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return AllArticlesModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to load data');
  }
}



class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({Key? key}) : super(key: key);

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {

  bool show_filter = false;
  String? graduation_year;
  final _formKey = GlobalKey<FormState>();

  Future<AllArticlesModel>? _futureGetAllNews;


  @override
  void initState() {
    super.initState();
    _futureGetAllNews = getAllNews();

  }


  @override
  Widget build(BuildContext context) {
    return (_futureGetAllNews == null) ? buildColumn() : buildFutureBuilder();

  }


  buildColumn(){
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }





  FutureBuilder<AllArticlesModel> buildFutureBuilder() {
    return FutureBuilder<AllArticlesModel>(
        future: _futureGetAllNews,
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
            var news = data.news!.data!;

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
                                    itemCount: news.length,
                                    itemBuilder: (context, index) {
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
                                                  image: NetworkImage(news[index].image!.toString()),
                                                  fit: BoxFit.cover

                                                )
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Text(news[index].title!.toString(), maxLines: 2,overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 18, color: Colors.black),)),
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
                                                      Text(convertToFormattedDate(news[index].createdTime!.toString()), style: TextStyle( fontSize: 12, color:Colors.grey),),
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
                                                      Text("By Jones", style: TextStyle( fontSize: 12, color:Colors.grey),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(news[index].summary!.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 15, color:Colors.black54),),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            InkWell(
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NewsDetailsScreen(data: news[index])));

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

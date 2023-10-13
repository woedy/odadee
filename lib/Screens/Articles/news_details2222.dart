import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:odadee/Screens/Articles/models/comment_model.dart';
import 'package:odadee/Screens/Projects/fund_for_screen.dart';
import 'package:odadee/Screens/Projects/models/project_detail_model.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/Screens/Radio/radio_screen.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../Radio/playing_screen.dart';
import 'package:http/http.dart' as http;


Future<CommentModel> getAllComments(comment_id) async {

  var token = await getApiPref();

  final response = await http.get(
    Uri.parse(hostName + "/api/comments/" + comment_id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token.toString()
    },

  );

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));

    return CommentModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return CommentModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to load data');
  }
}

class NewsDetailsScreen extends StatefulWidget {
  final data;

  const NewsDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {

  final _formKey = GlobalKey<FormState>();
  Future<CommentModel>? _futureGetAllComments;



  @override
  void initState() {
    super.initState();
    _futureGetAllComments = getAllComments(widget.data.id.toString());

  }

  @override
  Widget build(BuildContext context) {
    return (_futureGetAllComments == null) ? buildColumn() : buildFutureBuilder();

  }

  buildColumn(){
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }




  FutureBuilder<CommentModel> buildFutureBuilder() {
    return FutureBuilder<CommentModel>(
        future: _futureGetAllComments,
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
            var comments = data.comments!.data!;

            print("#########################");

            return Scaffold(
              body: SafeArea(
                bottom: false,
                child: Container(
                  child: Stack(
                    children: [
                      // ... Your existing UI here

                      // Display comments
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          var comment = comments[index];
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: odaSecondary.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5),
                                      // You can use the commenter's image here
                                        image: DecorationImage(
                                            image: AssetImage("assets/images/avatar.png"),
                                            fit: BoxFit.cover
                                        )

                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(comment.author.toString(), style: TextStyle(fontSize: 16, color: Colors.black),),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(comment.createdTime.toString(), style: TextStyle(fontSize: 14, color: Colors.grey),),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(comment.content.toString(), style: TextStyle(fontSize: 14, color: Colors.grey),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 70,
                              ),
                            ],
                          );
                        },
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

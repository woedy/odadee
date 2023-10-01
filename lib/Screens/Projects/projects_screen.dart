import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/Projects/models/all_projects_model.dart';
import 'package:odadee/Screens/Projects/project_details.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'package:http/http.dart' as http;



Future<AllProjectsModel> getAllProjects() async {

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
    print(jsonDecode(response.body));

    return AllProjectsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return AllProjectsModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to load data');
  }
}



class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {

  bool show_filter = false;
  String? graduation_year;
  final _formKey = GlobalKey<FormState>();

  Future<AllProjectsModel>? _futureGetAllProjects;


  @override
  void initState() {
    super.initState();
    _futureGetAllProjects = getAllProjects();

  }


  @override
  Widget build(BuildContext context) {
    return (_futureGetAllProjects == null) ? buildColumn() : buildFutureBuilder();

  }


  buildColumn(){
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }





  FutureBuilder<AllProjectsModel> buildFutureBuilder() {
    return FutureBuilder<AllProjectsModel>(
        future: _futureGetAllProjects,
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
            var projects = data.projects!.data!;

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
                                    Text("Projects (" + projects.length.toString() + ")", style: TextStyle(fontSize: 20, color: Colors.black),),
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
                                  itemCount: projects.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 200,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(projects[index].image!..toString()),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(projects[index].title!.toString(), style: TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(projects[index].content!.toString(), overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle( fontSize: 14, color: Colors.grey ),),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProjectDetailsScreen(data: projects[index])));

                                                  },
                                                  child: Container(
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
                                                ),
                                                Text("\$10", style: TextStyle( fontSize: 20, color: odaSecondary, fontWeight: FontWeight.bold),),

                                              ],
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

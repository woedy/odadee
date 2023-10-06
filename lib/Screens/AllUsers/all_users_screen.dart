import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odadee/Screens/AllUsers/models/all_users_model.dart';
import 'package:odadee/Screens/AllUsers/user_detail_screen.dart';
import 'package:odadee/Screens/Projects/pay_dues.dart';
import 'package:odadee/constants.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'package:http/http.dart' as http;

import '../Radio/playing_screen.dart';


Future<AllUsersModel> getAllRegisteredUsers() async {

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
    print(jsonDecode(response.body));

    return AllUsersModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 422) {
    print(jsonDecode(response.body));
    return AllUsersModel.fromJson(jsonDecode(response.body));
  }  else {

    throw Exception('Failed to load data');
  }
}


class AllRegisteredUsers extends StatefulWidget {
  const AllRegisteredUsers({Key? key}) : super(key: key);

  @override
  State<AllRegisteredUsers> createState() => _AllRegisteredUsersState();
}

class _AllRegisteredUsersState extends State<AllRegisteredUsers> {

  bool show_filter = false;
  String? graduation_year;
  final _formKey = GlobalKey<FormState>();

  Future<AllUsersModel>? _futureGetAllUsers;


  @override
  void initState() {
    super.initState();
    _futureGetAllUsers = getAllRegisteredUsers();

  }

  @override
  Widget build(BuildContext context) {
    return (_futureGetAllUsers == null) ? buildColumn() : buildFutureBuilder();

  }



  buildColumn(){
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }





  FutureBuilder<AllUsersModel> buildFutureBuilder() {
    return FutureBuilder<AllUsersModel>(
        future: _futureGetAllUsers,
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
            var users = data.users!.data!;

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
                                    Text("All Registered Users", style: TextStyle(fontSize: 20, color: Colors.black),),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {

                                    if(show_filter){
                                      setState(() {
                                        show_filter = false;
                                      });
                                    }else {
                                      setState(() {
                                        show_filter = true;
                                      });
                                    }

                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: odaPrimary,
                                        borderRadius: BorderRadius.circular(5)

                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.filter_list_alt, size: 15, color: Colors.white,),
                                        SizedBox(
                                          width:3 ,
                                        ),
                                        Text("Filter", style: TextStyle(color: Colors.white, fontSize: 14),)
                                      ],
                                    ),
                                  ),
                                )
                              ],

                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      //color: Colors.red,
                                      child: ListView.builder(
                                          itemCount: 10,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index){
                                            return Container(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    margin: EdgeInsets.all(5),

                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text("95 Year Group", style: TextStyle(fontSize: 16),),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 17,
                                                          height: 17,
                                                          padding: EdgeInsets.all(1),

                                                          child: Center(child: Text("x", style: TextStyle(color: Colors.white, fontSize: 12),)),
                                                          decoration: BoxDecoration(
                                                              color: odaSecondary.withOpacity(0.3),
                                                              borderRadius: BorderRadius.circular(5)
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: odaBorder,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                      ),

                                    ),
                                    Expanded(
                                      child: Container(
                                        //height: MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                            itemCount: users.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: (){
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UserDetailScreen(data: users[index])));

                                                },
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 70,
                                                          width: 70,
                                                          margin: EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                              color: odaSecondary.withOpacity(0.2),
                                                              borderRadius: BorderRadius.circular(10),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(users[index].image.toString()),
                                                                  fit: BoxFit.cover
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(users[index].firstName.toString() + " " +users[index].lastName.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(users[index].email.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text("View Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: odaSecondary),),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      //width: 150,
                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                      child: Divider(
                                                        color: Colors.black.withOpacity(0.2),
                                                        thickness: 1,

                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                if(show_filter == true)...[
                                  Stack(
                                    children: [
                                      Container(
                                        height: 530,
                                        padding: EdgeInsets.all(20),
                                        width: MediaQuery.of(context).size.width,

                                        decoration: BoxDecoration(
                                            color: odaPrimary,
                                            borderRadius: BorderRadius.circular(10)
                                        ),

                                      ),
                                      Container(
                                        height: 520,
                                        padding: EdgeInsets.all(20),
                                        width: MediaQuery.of(context).size.width,

                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10)
                                        ),

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GradientText(
                                                'All Registered Year Groups',
                                                style: const TextStyle(fontSize: 24, color: odaSecondary),
                                                colors: [
                                                  odaPrimary,
                                                  odaSecondary,
                                                ]
                                            ),

                                            Expanded(

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,

                                                children: [

                                                  Form(
                                                    key: _formKey,
                                                    child: Container(

                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Year Group", style: TextStyle(fontSize: 12),),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  _showGraduationYearModal(context);
                                                                },
                                                                child: Container(
                                                                  padding: EdgeInsets.all(10),
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      border: Border.all(
                                                                          color: Colors.grey.withOpacity(0.4))
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        graduation_year ?? 'Select Year',
                                                                        style: TextStyle(fontSize: 15, color: bodyText2),
                                                                      ),
                                                                      Icon(Icons.calendar_today_outlined, size: 22, color: odaSecondary,),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                            decoration: BoxDecoration(
                                                              //color: Colors.white,
                                                                borderRadius: BorderRadius.circular(5),
                                                                border: Border.all(
                                                                    color: Colors.grey.withOpacity(0.4))),
                                                            child: TextFormField(
                                                              style: TextStyle(),
                                                              decoration: InputDecoration(
                                                                //hintText: 'Enter Username/Email',

                                                                hintStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.normal),
                                                                labelText: "House",
                                                                labelStyle:
                                                                TextStyle(fontSize: 15, color: bodyText2),
                                                                enabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                                                                border: InputBorder.none,),
                                                              inputFormatters: [
                                                                LengthLimitingTextInputFormatter(225),
                                                                PasteTextInputFormatter(),
                                                              ],
                                                              validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return 'House required';
                                                                }
                                                                if (value.length < 3) {
                                                                  return 'House short';
                                                                }

                                                                return null;
                                                              },
                                                              textInputAction: TextInputAction.next,
                                                              autofocus: false,
                                                              onSaved: (value) {
                                                                setState(() {

                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),

                                                          Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                            decoration: BoxDecoration(
                                                              //color: Colors.white,
                                                                borderRadius: BorderRadius.circular(5),
                                                                border: Border.all(
                                                                    color: Colors.grey.withOpacity(0.4))),
                                                            child: TextFormField(
                                                              style: TextStyle(),
                                                              decoration: InputDecoration(
                                                                //hintText: 'Enter Username/Email',

                                                                hintStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.normal),
                                                                labelText: "Location",
                                                                labelStyle:
                                                                TextStyle(fontSize: 15, color: bodyText2),
                                                                enabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                                                                border: InputBorder.none,),
                                                              inputFormatters: [
                                                                LengthLimitingTextInputFormatter(225),
                                                                PasteTextInputFormatter(),
                                                              ],
                                                              validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return 'Location required';
                                                                }
                                                                if (value.length < 3) {
                                                                  return 'Location short';
                                                                }

                                                                return null;
                                                              },
                                                              textInputAction: TextInputAction.next,
                                                              autofocus: false,
                                                              onSaved: (value) {
                                                                setState(() {

                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),


                                                          Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                            decoration: BoxDecoration(
                                                              //color: Colors.white,
                                                                borderRadius: BorderRadius.circular(5),
                                                                border: Border.all(
                                                                    color: Colors.grey.withOpacity(0.4))),
                                                            child: TextFormField(
                                                              style: TextStyle(),
                                                              decoration: InputDecoration(
                                                                //hintText: 'Enter Username/Email',

                                                                hintStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.normal),
                                                                labelText: "User Profession",
                                                                labelStyle:
                                                                TextStyle(fontSize: 15, color: bodyText2),
                                                                enabledBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                                                                focusedBorder: UnderlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))),
                                                                border: InputBorder.none,),
                                                              inputFormatters: [
                                                                LengthLimitingTextInputFormatter(225),
                                                                PasteTextInputFormatter(),
                                                              ],
                                                              validator: (value) {
                                                                if (value!.isEmpty) {
                                                                  return 'Location required';
                                                                }
                                                                if (value.length < 3) {
                                                                  return 'Location short';
                                                                }

                                                                return null;
                                                              },
                                                              textInputAction: TextInputAction.next,
                                                              autofocus: false,
                                                              onSaved: (value) {
                                                                setState(() {

                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),

                                                          Align(
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width,
                                                              padding: EdgeInsets.all(15),
                                                              decoration: BoxDecoration(
                                                                  color: odaSecondary,
                                                                  borderRadius: BorderRadius.circular(10)),
                                                              child: Material(
                                                                color: Colors.transparent,
                                                                child: InkWell(
                                                                  onTap: () {

                                                                    /*   if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      KeyboardUtil.hideKeyboard(context);

                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUp2()));

                                    }*/

                                                                    //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUp2()));

                                                                  },
                                                                  child: Align(
                                                                    child: Container(
                                                                      child: Text(
                                                                        "Apply Filter",
                                                                        style: TextStyle(
                                                                            fontSize: 22, color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),


                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ]

                              ],
                            ),
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









  void _showGraduationYearModal (BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: odaPrimary,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0)
                    )
                ),
                height: 300,
              ),
              Positioned(
                top: 15,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0)
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.05)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Select Graduation Year", style: TextStyle(color: Colors.black, fontSize: 20),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      Container(
                        //color: Colors.red,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,

                          children: [
                            Text("1993", style: TextStyle( fontSize: 20),),
                            Container(
                              width: 150,
                              child: Divider(
                                color: Colors.black,
                                thickness: 1,

                              ),
                            ),
                            Text("1994", style: TextStyle(color: Colors.black, fontSize: 20),),
                            Container(
                              width: 150,
                              child: Divider(
                                color: Colors.black,
                                thickness: 1,

                              ),
                            ),
                            Text("1995", style: TextStyle(fontSize: 20),),

                          ],
                        ),
                      )


                    ],

                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }



}

// @dart=2.12
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:odadee/Screens/Dashboard/dashboard_screen.dart';

import 'package:odadee/Screens/SplashScreen/splash_screen.dart';

import 'package:odadee/constants.dart';

import 'Components/theme.dart';

import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  /*await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  //log("FCMToken $fcmToken");*/

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => {runApp(MyApp())});
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping outside the text field
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Odade3',
        theme: theme(),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? api_key = "";
  Future? _user_api;

  @override
  void initState() {
    super.initState();
    _user_api = apiKey();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _user_api,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return NewsScreen();
          return api_key == null ? SplashScreen() : DashboardScreen();



        });
  }

  Future apiKey() async {
    api_key = await getApiPref();
  }
}



class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
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
      Uri.parse('http://api.odadee.net/api/articles?page=$page'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token.toString()
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newsData = data['news']['data'];

      setState(() {
        lastPage = data['news']['last_page'];
        newsList.addAll(newsData);
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
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final newsItem = newsList[index];
          return ListTile(
            title: Text(newsItem['title']),
            subtitle: Text(newsItem['summary']),
            // Add other UI elements to display the news item
          );
        },
      ),
    );
  }
}

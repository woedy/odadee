

import 'dart:convert';
import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:odadee/Screens/Authentication/SignIn/sgin_in_screen.dart';
import 'package:odadee/Screens/Authentication/SignUp/models/update_image_model.dart';
import 'package:odadee/Screens/Authentication/SignUp/sign_up_3.dart';
import 'package:odadee/components/keyboard_utils.dart';
import 'package:odadee/components/photos/select_photo_options_screen.dart';
import 'package:odadee/constants.dart';

import 'package:http/http.dart' as http;



Future<UpdateImageModel> updateProfileImage(data, user) async {

  var token = await getApiPref();

  final url = Uri.parse(hostName + "/api/upload-image");
  final request = http.MultipartRequest('POST', url);

  request.headers['Accept'] = 'application/json';
  //request.headers['Authorization'] = 'Bearer ' + token.toString();



  request.files.add(await http.MultipartFile.fromPath('image', data.path));
  request.fields['user'] = user;
  final response = await request.send();
  if (response.statusCode == 200) {
    return UpdateImageModel.fromJson(jsonDecode(await response.stream.bytesToString()));
  } else if (response.statusCode == 422) {
    return UpdateImageModel.fromJson(jsonDecode(await response.stream.bytesToString()));

  }  else {

    throw Exception('Failed to Update profile image');
  }
}



class SignUp2 extends StatefulWidget {
  final data;

  const SignUp2({Key? key, required this.data}) : super(key: key);

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  TextEditingController controller = TextEditingController(text: "");

  Future<UpdateImageModel>? _futureUpdateImage;


  final _formKey = GlobalKey<FormState>();
 bool show_password = false;

  bool hasError = false;
  String? password;
  String? graduation_year;
  File? _image;


  FocusNode focusNode = FocusNode();



  @override
  Widget build(BuildContext context) {
    return (_futureUpdateImage == null) ? buildColumn() : buildFutureBuilder();
  }


  buildColumn(){

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:30,
              ),
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
                height: 20,
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
                            Text("Welcome", style: TextStyle(fontSize: 27),),
                            SizedBox(
                              height: 5,
                            ),
                            Text(widget.data.firstName, style: TextStyle(fontSize: 34,fontWeight: FontWeight.w900),),
                            SizedBox(
                              height: 10,
                            ),
                            Text.rich(TextSpan(
                                text: "Now it’s time, ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: widget.data.firstName + " " + widget.data.lastName,
                                    style: TextStyle(
                                        color: odaPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(
                                    text: " to make your profile glow!",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ])),
                            SizedBox(
                              height: 40,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 220,
                                  child: _image == null ? Stack(
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            _showSelectPhotoOptions(context);
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  // color: Colors.red,
                                                    borderRadius: BorderRadius.circular(20),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Color(0xff0017D7),
                                                        Color(0xffBD8D43),
                                                      ],
                                                    )
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                left: 10,
                                                child: Container(
                                                  height: 180,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.7),
                                                    borderRadius: BorderRadius.circular(20),

                                                  ),
                                                  child: Icon(Icons.person_outline, size: 50, color: Colors.grey,),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 80,

                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(100),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xff0017D7),
                                                  Color(0xffBD8D43),
                                                ],
                                              )
                                          ),
                                          child: Center(
                                            child: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) :
                                  Stack(
                                    children: [
                                      Container(
                                        height: 220,
                                        width: 220,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            image: DecorationImage(image: FileImage(_image!), fit: BoxFit.contain)),
                                      ),
                                      if (_image != null)
                                        Positioned(
                                          /* bottom: 0,
                                                  right: 0,
                                                  left:0,
                                                  top: 0,*/
                                          child:
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _image =
                                                null;
                                              });
                                            },
                                            child: Icon(
                                              Icons
                                                  .delete_forever,
                                              color: Colors
                                                  .white,
                                            ),
                                            style: ElevatedButton
                                                .styleFrom(
                                              primary:
                                              Colors
                                                  .red,
                                              shape:
                                              CircleBorder(),
                                              padding:
                                              EdgeInsets
                                                  .all(
                                                  2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 40,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Text("Upload a photo that captures your spark", style: TextStyle(fontSize: 16, color: odaSecondary),),
                              ],
                            ),





                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),



              Column(
                children: [
                  if (_image != null)...[
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

                              //widget.data["image"] = _image!;
                              setState(() {
                                _futureUpdateImage = updateProfileImage(_image!, widget.data.email);

                              });

                              print("##############");
                              //print(widget.data.toString());



                              //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SignUp3(data: widget.data)));


                            },
                            child: Align(
                              child: Container(
                                child: Text(
                                  "Continue",
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
                  SizedBox(
                    height: 20,
                  ),
                  /*  Align(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));

                      },
                      child: Text.rich(TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: "Sign In here",
                              style: TextStyle(
                                  color: odaSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ])),
                    ),
                  ),*/
                ],
              ),

              SizedBox(
                height:20,
              ),

            ],
          ),
        ),
      ),
    );

  }


  FutureBuilder<UpdateImageModel> buildFutureBuilder() {
    return FutureBuilder<UpdateImageModel>(
        future: _futureUpdateImage,
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
            var _data = snapshot.data!.userData!;

            print("#########################");


            if(data.message == "Image Uploaded Successfully") {


              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignUp3(data: _data))
                );

                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green,),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text("Success")),
                          ],
                        ),
                        content: Text("Image Uploaded Successfully"),
                      );
                    }
                );

              });
            }

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





  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }


  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }


  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }








}


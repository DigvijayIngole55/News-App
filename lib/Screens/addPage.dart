
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:gx_file_picker/gx_file_picker.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  bool isImp = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.amberAccent,
          title: Text(
            'Add News',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          color: Color(0xFF2C2C2E),
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 3,
                  child: dmage == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await UploadImage();
                                setState(() {});
                              },
                              child: Container(
                                child: Icon(
                                  Icons.add,
                                  size: 60.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(
                              child: Text(
                                'Upload Image Here',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () async {
                            await UploadImage();
                            setState(() {});
                          },
                          child: Image.network(dmage))),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      onChanged: (value) {
                        newstitle = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter news Title",
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          )),
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      onChanged: (value) {
                        newsdesc = value;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: "Enter news Description",
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          )),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                      onChanged: (value) {
                        aurthor = value;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: "Enter author",
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          )),
                    ),
                  ),
                ),
              ),

              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Is Headline news?',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                      SizedBox(width: 20.0,),
                      MaterialButton(
                        color: isImp == true? Colors.green:Colors.red,
                        onPressed: (){
                        setState(() {
                          if(isImp == true)
                            {isImp = false;}
                          else{isImp = true;}
                          IsImp = isImp;
                        });
                      }, child: Text(
                          isImp?'Yes':'No',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0
                      ),),),
                    ],
                  ),
                ),
              )

              ),
              FlatButton(
                onPressed: () async {
                  if(durl == null||
                  newstitle ==null||
                  newsdesc == null)
                    {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Feilds are missing try again",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Exit",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    }
                  else {
                    await UploadCloud();

                    Alert(
                      context: context,
                      type: AlertType.success,
                      title: "News has been added Successfully",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Exit",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          width: 120,
                        )
                      ],
                    ).show();

                  }
                  dmage = null;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadiusDirectional.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                  child: Text(
                    "Upload",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
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

var durl = null;
var dmage = null;
var newstitle;
var newsdesc;
var aurthor;
bool IsImp = false;
var vurl;
UploadImage() async {
  final picker = ImagePicker();
  PickedFile image;
  image = await picker.getImage(source: ImageSource.gallery);
  var file = File(image.path);
  print(file);
  print('yo');
  int rn = Random().nextInt(10000000);
  if (image != null) {
    var snapshot;
    await FirebaseStorage.instance
        .ref()
        .child('$rn.jpeg')
        .putFile(file)
        .then((value) => snapshot = value);
    var downloadurl = await snapshot.ref.getDownloadURL();
    durl = downloadurl;
    dmage = durl;
  }
}
UploadVideo() async{
  File file = await FilePicker.getFile();
  print(file.path);
  var filev = File(file.path);
  int rn = Random().nextInt(10000000);
  if (file != null) {
    var snapshot;
    await FirebaseStorage.instance
        .ref()
        .child('$rn')
        .putFile(filev)
        .then((value) => snapshot = value);
     vurl = await snapshot.ref.getDownloadURL();
     print(vurl);
     FirebaseFirestore.instance.collection('video').doc().set({'url':vurl});
  }
}

UploadCloud() async {
  DateTime now = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('impnews').doc().set({
      'newstitle': newstitle,
      'newsdesc': newsdesc,
      'imgurl': durl,
      'author': aurthor,
      'timestamp': now
    });

 
}

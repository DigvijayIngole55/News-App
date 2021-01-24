import 'homepage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class EditPage extends StatefulWidget {
  String NewsTitle;
  String NewsDescription;
  String ImageUrl;
  var timestamp;
  String author;
  var docid;
  bool isImp;
  EditPage({this.NewsTitle, this.NewsDescription, this.ImageUrl, this.timestamp, this.author, this.docid, this.isImp});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    dmage = widget.ImageUrl;
    newstitle = widget.NewsTitle;
    newsdesc = widget.NewsDescription;
    aurthor = widget.author;

    super.initState();
  }

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
            'Edit News',
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
                      ? GestureDetector(
                          onTap: () async {
                            await UploadImage();
                            setState(() {});
                          },
                          child: Image.network(widget.ImageUrl))
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
                    child: TextFormField(
                      initialValue: newstitle,
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
                    child: TextFormField(
                      initialValue: newsdesc,
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
                    child: TextFormField(
                      initialValue: aurthor,
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
              FlatButton(
                onPressed: () async {
                  print(newsdesc);
                  print(dmage);
                  print(newstitle);
                  await UploadCloud();

                  Alert(
                    context: context,
                    type: AlertType.success,
                    title: "News has been edited Successfully",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Exit",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        width: 120,
                      )
                    ],
                  ).show();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadiusDirectional.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                  child: Text(
                    "Upload",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var durl;
  var dmage;
  var newstitle;
  var newsdesc;
  var aurthor;
  bool IsImp;

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
      await FirebaseStorage.instance.ref().child('$rn.jpeg').putFile(file).then((value) => snapshot = value);
      var downloadurl = await snapshot.ref.getDownloadURL();
      durl = downloadurl;
      if (durl != null) dmage = durl;
    }
  }

  UploadCloud() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (widget.isImp == true) {
      await firestore.collection('impnews').doc(widget.docid).update({
        'newstitle': newstitle,
        'newsdesc': newsdesc,
        'imgurl': dmage,
        'author': aurthor,
      });
    } else {
      await firestore.collection('news').doc(widget.docid).update({
        'newstitle': newstitle,
        'newsdesc': newsdesc,
        'imgurl': dmage,
        'author': aurthor,
      });
    }
  }
}

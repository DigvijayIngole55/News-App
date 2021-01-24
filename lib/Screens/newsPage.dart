import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'editPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewsPage extends StatefulWidget {
  String NewsTitle;
  String NewsDescription;
  String ImageUrl;
  var timestamp;
  String author;
  var docid;
  bool isImp;
  NewsPage({this.NewsTitle, this.NewsDescription, this.ImageUrl, this.timestamp, this.author, this.docid, this.isImp});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  var date;

  void initState() {
    converttime();
    super.initState();
  }

  void converttime() {
    date = widget.timestamp.toDate();
    date = DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amberAccent,
        title: Text(
          'News',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditPage(
                              NewsTitle: widget.NewsTitle,
                              NewsDescription: widget.NewsDescription,
                              ImageUrl: widget.ImageUrl,
                              timestamp: widget.timestamp,
                              author: widget.author,
                              docid: widget.docid,
                              isImp: widget.isImp,
                            )));
              },
              child: Icon(Icons.mode_edit)),
          SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () async {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "Do you want to DELETE the news",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      if (widget.isImp == true)
                        await FirebaseFirestore.instance.collection('impnews').doc(widget.docid).delete();
                      else
                        await FirebaseFirestore.instance.collection('news').doc(widget.docid).delete();
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            },
            child: Icon(Icons.delete),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF2C2C2E),
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                widget.ImageUrl,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Date: $date',
                style: TextStyle(color: Colors.white70, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Author: ${widget.author}',
                style: TextStyle(color: Colors.white70, fontSize: 15.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                widget.NewsTitle,
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                widget.NewsDescription,
                style: TextStyle(color: Colors.white70, fontSize: 19.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

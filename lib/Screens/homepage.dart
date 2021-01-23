import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'newsPage.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
VideoPlayerController _controller;
Future<void> _initiliazeVideoPlayerFuture;
QuerySnapshot impsnapshot;
class _HomePageState extends State<HomePage> {
  Future getnews() async {
    var firebase = await FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firebase
        .collection('news')
        .orderBy('timestamp', descending: true).limit(20).where('newstitle',isNotEqualTo: null)
        .get();
    return snapshot;
  }

   void getimpnews() async{
    var firebase = await FirebaseFirestore.instance;
     impsnapshot = await firebase
        .collection('impnews')
        .orderBy('timestamp', descending: true).limit(1).where('newstitle',isNotEqualTo: null)
        .get();
     print(impsnapshot.docs[0].data()['imgurl']);
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getnews();
      getimpnews();
    });
  }
@override
  void initState() {
    getnews();
    getimpnews();
    _controller = VideoPlayerController.network('https://firebasestorage.googleapis.com/v0/b/news-e2d62.appspot.com/o/1023316?alt=media&token=a42cf8a7-3650-4842-8f90-d22f8b1998d4');
    _initiliazeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(2.0);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: Text(
              'News',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPage()));
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          body: Container(
            color: Color(0xFF2C2C2E),
            child: FutureBuilder(
              future: getnews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text(
                      'Data is loading',
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: Column(
                      children: [
                        Expanded(flex:3 ,child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsPage(
                                      NewsTitle:
                                      impsnapshot.docs[0].data()['newstitle'],
                                      NewsDescription:
                                      impsnapshot.docs[0].data()['newsdesc'],
                                      ImageUrl: impsnapshot.docs[0].data()['imgurl'],
                                      timestamp: impsnapshot.docs[0].data()['timestamp'],
                                      author: impsnapshot.docs[0].data()['author'],
                                      docid: impsnapshot.docs[0].id,
                                      isImp: true,
                                    )));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Image.network(impsnapshot.docs[0].data()['imgurl'],
                                    height: 190.0,
                                    width: MediaQuery.of(context).size.width-40,
                                    fit: BoxFit.cover,),
                                ),
                                SizedBox(height: 10.0,),
                                Text(
                                  impsnapshot.docs[0].data()['newstitle'],
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                        Expanded(
                          flex: 4,
                          child: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot newsdoc = snapshot.data.docs[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewsPage(
                                                NewsTitle:
                                                    newsdoc.data()['newstitle'],
                                                NewsDescription:
                                                    newsdoc.data()['newsdesc'],
                                                ImageUrl: newsdoc.data()['imgurl'],
                                            timestamp: newsdoc.data()['timestamp'],
                                            author: newsdoc.data()['author'],
                                            docid: impsnapshot.docs[0].id,
                                            isImp: false,
                                              )));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2C2C2E),
                                  ),
                                  height: 100.0,
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal:10.0),
                                          child: ClipRRect(
                                            child: newsdoc.data()['imgurl']!=null?Image.network(
                                              newsdoc.data()['imgurl'],
                                              height: 150.0,
                                              fit: BoxFit.cover,
                                            ):Text(''),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                              '${newsdoc.data()['newstitle']}',
                                                maxLines: 3,
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Expanded(child: GestureDetector(
                        //   onTap: (){
                        //     if(_controller.value.isPlaying)
                        //       {
                        //         _controller.pause();
                        //       }
                        //     else{
                        //       _controller.play();
                        //     }
                        //   },
                        //   child: FutureBuilder(
                        //     future: _initiliazeVideoPlayerFuture,
                        //     builder: (context, snapshot){
                        //       if(snapshot.connectionState == ConnectionState.done)
                        //         {
                        //           return AspectRatio(aspectRatio: _controller.value.aspectRatio,
                        //           child: VideoPlayer(_controller),);
                        //         }
                        //       else{
                        //         return Center(child:CircularProgressIndicator(),);
                        //       }
                        //     }
                        //   ),
                        // ),
                        // ),
                      ],
                    ),
                  );
                }
              },
            ),
          )),
    );
  }
}

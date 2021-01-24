import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, GridFS;

class MongoImage extends StatefulWidget {
  MongoImage({Key key}) : super(key: key);

  @override
  _MongoImageState createState() => _MongoImageState();
}

class _MongoImageState extends State<MongoImage> with SingleTickerProviderStateMixin {
  final url =
      "mongodb+srv://admin-preetam:pam%21%40%23QW@cluster0-bq71x.mongodb.net:27017/newsDB?ssl=true&authSource=admin&retryWrites=true&w=majority";

  final picker = ImagePicker();
  File _image;
  GridFS bucket;
  Animation<Color> _colorTween;
  ImageProvider provider;
  var flag = false;

  @override
  void initState() {
    connection();
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var _cmpressed_image;
      try {
        _cmpressed_image =
            await FlutterImageCompress.compressWithFile(pickedFile.path, format: CompressFormat.heic, quality: 70);
      } catch (e) {
        _cmpressed_image =
            await FlutterImageCompress.compressWithFile(pickedFile.path, format: CompressFormat.jpeg, quality: 70);
      }
      setState(() {
        flag = true;
      });

      Map<String, dynamic> image = {"_id": pickedFile.path.split("/").last, "data": base64Encode(_cmpressed_image)};
      print(image);
      var res = await bucket.chunks.insert(image);
      var img = await bucket.chunks.findOne({"_id": pickedFile.path.split("/").last});
      print("UPLOAD SUCCESSFUL");
      setState(() {
        provider = MemoryImage(base64Decode(img["data"]));
        flag = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              provider == null
                  ? Text('No image selected.')
                  : Image(
                      image: provider,
                    ),
              SizedBox(
                height: 10,
              ),
              if (flag == true) CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: getImage,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Select Image', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future connection() async {
    Db _db = await Db.create(url);
    await _db.open(secure: true);
    bucket = GridFS(_db, "image");
    print("CONNECTION ESTABLISHED");
  }
}

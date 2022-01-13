import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognizerDemo extends StatefulWidget {
  const TextRecognizerDemo({Key? key}) : super(key: key);

  @override
  _TextRecognizerDemoState createState() => _TextRecognizerDemoState();
}

class _TextRecognizerDemoState extends State<TextRecognizerDemo> {

  late String pathOfImage;
  String finalText='';
  bool isLoaded=false;
  late File imageFile;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognizer'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: isLoaded?Image.file(imageFile,fit: BoxFit.cover,):Center(child: Text('No image selected.'),),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(finalText==null?
                    'This is extracted data':finalText,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async{
              finalText='';
              await getImage_camera();

              await RecognizeText(imageFile);
            },
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async{
              finalText='';
              await getImage_gallery();

              await RecognizeText(imageFile);
            },
            child: Icon(Icons.image),
          )
        ],
      ),
    );
  }

  Future<void> getImage_gallery()async{
    XFile? image=await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile=File(image!.path);
      isLoaded=true;
      pathOfImage=image.path.toString();
    });
  }

  Future<void> getImage_camera()async{
    XFile? image=await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile=File(image!.path);
      isLoaded=true;
      pathOfImage=image.path.toString();
    });
  }

  Future<void> RecognizeText(path)async{
    final inputImage=await InputImage.fromFile(path);
    final textDetector=GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText=await textDetector.processImage(inputImage);

    setState(() {
      for(TextBlock block in recognisedText.blocks){
        for(TextLine line in block.lines){
          for(TextElement element in line.elements){
            finalText=finalText+' '+element.text;
          }
          finalText=finalText+"\n";
        }
      }
    });
  }
}

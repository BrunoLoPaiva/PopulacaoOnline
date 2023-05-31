import 'package:flutter/material.dart';
import '/mobile/create_step2.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

ImagePicker imagePicker = ImagePicker();

class Create1 extends StatefulWidget {
  const Create1({Key? key}) : super(key: key);

  @override
  State<Create1> createState() => _Create1State();
}

class _Create1State extends State<Create1> {
  var _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('1º Passo')),
      body: Center(
        child: Column(children: [
          Spacer(),
          Text(
            'Adicione uma Imagem',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 30),
          // Container(
          //   width: 350,
          //   height: 350,
          //   decoration: BoxDecoration(
          //       color: Color.fromARGB(255, 196, 196, 196),
          //       borderRadius: BorderRadius.circular(10)),
          //   child: _image != null
          //       ? Image.file(
          //           _image,
          //           width: 200.0,
          //           height: 200.0,
          //           fit: BoxFit.fitHeight,
          //         )
          //       : Container(
          //           decoration: BoxDecoration(
          //               color: Color.fromARGB(255, 196, 196, 196),
          //               borderRadius: BorderRadius.circular(10)),
          //           width: 200,
          //           height: 200,
          //           child: Icon(
          //             Icons.image,
          //             color: Colors.grey[800],
          //           ),
          //         ),
          // ),
          SizedBox(height: 20),
          // _image == null
          //     ?
          GestureDetector(
            child: Icon(Icons.add_a_photo_rounded, size: 80),
            onTap: () async {
              XFile? image = await imagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  preferredCameraDevice: CameraDevice.front);
              setState(() {
                if (image != null) {
                  _image = File(image.path);

                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Create2(image: _image);
                      },
                    ),
                  );
                }
              });
            },
          ),
          // : Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Spacer(flex: 2),
          //       GestureDetector(
          //         child: Icon(Icons.add_a_photo_rounded, size: 40),
          //         onTap: () async {
          //           XFile? image = await imagePicker.pickImage(
          //               source: ImageSource.camera,
          //               imageQuality: 50,
          //               preferredCameraDevice: CameraDevice.front);
          //           setState(() {
          //             if (_image == null) {
          //               _image = File(image!.path);
          //               //print(image.path);
          //             }
          //           });

          //           Navigator.push(
          //             context,
          //             MaterialPageRoute<void>(
          //               builder: (BuildContext context) {
          //                 return Create2(image: _image);
          //               },
          //             ),
          //           );
          //         },
          //       ),
          //       Spacer(),
          //       GestureDetector(
          //         child: Icon(Icons.done, size: 40),
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute<void>(
          //               builder: (BuildContext context) {
          //                 return Create2(image: _image);
          //               },
          //             ),
          //           );
          //         },
          //       ),
          //       Spacer(flex: 2),
          //     ],
          //   ),
          Spacer(),
        ]),
      ),
    );
  }
}

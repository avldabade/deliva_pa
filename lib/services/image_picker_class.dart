import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtility{
  File image;
  File cameraImage;
  File video;
  File cameraVideo;
  File document;
  BuildContext context;

  bool isImage = true;
  bool isDoc = false;

  static Future<File> getImageFromGallery() async {
    File _image=null;
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = image;
    print('_image:: $_image');
    return _image;
  }
  static Future<File> getImageFromCamera() async {
    File _image=null;
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _image = image;

    return _image;
  }
  // This funcion will helps you to pick and Image from Gallery
  Future<File> pickImageFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    isImage = true;
    isDoc = false;
    return this.image = image;
    // setState(() {});
    // updateUiAndCompressAndUploadMedia(_image, false);
  }

  // This funcion will helps you to pick and Image from Camera
  Future<File> pickImageFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    isImage = true;
    isDoc = false;
    return cameraImage = image;
    // setState(() {});
    // updateUiAndCompressAndUploadMedia(_cameraImage, false);
  }
}

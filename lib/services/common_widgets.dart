import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonWidgets{
  static Widget getLoader(BuildContext context) {
    final spinkit = Center(
      child: Container(
          color: Colors.black54,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //width: 100.0,
          //height: 100.0,
          child: SpinKitFadingCircle(color: Colors.white)),
    );
    /* SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );*/
    return spinkit;
  }
}
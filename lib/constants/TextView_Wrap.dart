import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
class TextViewWrap {

 static Text textView(text,txtAlign,txtColour,txtSize,txtFontWeight){
   String fontFamily="customRegular";
   if(txtFontWeight==FontWeight.normal){
     fontFamily="customRegular";
   }else{
     fontFamily="customBold";
   }
   return new Text(
     text,overflow: TextOverflow.ellipsis,maxLines: 1,
     textAlign: txtAlign,

     style: new TextStyle(
         color: txtColour,
         fontSize: txtSize,

         fontFamily: fontFamily),
   );
  }

 static Text textViewSingleLine(text,txtAlign,txtColour,txtSize,txtFontWeight){
   String fontFamily="customRegular";
   if(txtFontWeight==FontWeight.normal){
     fontFamily="customRegular";
   }else{
     fontFamily="customBold";
   }
   return new Text(
     text,overflow: TextOverflow.ellipsis,maxLines:1 ,
     textAlign: txtAlign,
     style: new TextStyle(
         color: txtColour,
         fontSize: txtSize,
         fontFamily: fontFamily),
   );
 }

 static Text textViewMultiLine(text,txtAlign,txtColour,txtSize,txtFontWeight,line){
   String fontFamily="customRegular";
   if(txtFontWeight==FontWeight.normal){
     fontFamily="customRegular";
   }else{
     fontFamily="customBold";
   }
   return new Text(
     text,overflow: TextOverflow.ellipsis,maxLines:line,
     textAlign: txtAlign,
     style: new TextStyle(
         color: txtColour,
         fontSize: txtSize,
         fontFamily: fontFamily),
   );
 }
}

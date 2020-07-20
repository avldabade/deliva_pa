import 'dart:ui';

import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class AddressObject {
  LatLng updatedPositionOfMarker;
  String aptHouseNoArea;
  int zipCode;
  String city;
  String state;
  String country;

  AddressObject(this.updatedPositionOfMarker, this.aptHouseNoArea, this.zipCode,this.city,this.state,this.country);
}
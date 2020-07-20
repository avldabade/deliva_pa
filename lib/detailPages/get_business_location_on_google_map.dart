import 'dart:async';
import 'dart:typed_data';

import 'package:deliva_pa/detailPages/gps_service_util.dart';
import 'package:deliva_pa/home_screen/AddressObject.dart';
import 'package:deliva_pa/values/ColorValues.dart';
import 'package:deliva_pa/values/StringValues.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart'
    show DeviceOrientation, EventChannel, MethodChannel, PlatformException, SystemChrome, rootBundle;
import 'package:location/location.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class GetBusinessLocationOnMap extends StatefulWidget {
  Coordinates currentCoordinates;


  //PAResourceData data;

  GetBusinessLocationOnMap(this.currentCoordinates);

  @override
  _GetBusinessLocationOnMapState createState() => _GetBusinessLocationOnMapState();
}

class _GetBusinessLocationOnMapState extends State<GetBusinessLocationOnMap> implements GpsUtilListener {
  final Set<Marker> _markers = {};
  GoogleMapController controller;
  static LatLng _lat1 = LatLng(22.253244, 76.040792); //barwaha
  String googleAPIKey = "AIzaSyCxa30b5GZrzVDrwcpsIoO6kWp28LVCRbI";
  LatLng _lastMapPosition = _lat1;
  //GooglePlaces googlePlaces;
  GpgUtils gpgUtils;
  GoogleMapController mapController;

  BitmapDescriptor customIcon;

  var markers;

  Map<MarkerId, Marker> _markers1 = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();

  LatLng updatedPositionOfMarker;

  @override
  void initState() {
    super.initState();

    gpgUtils = new GpgUtils(this);
    gpgUtils.init();


    print('widget.currentCoordinates:: ${widget.currentCoordinates}');
    _lat1 = LatLng(widget.currentCoordinates.latitude,
        widget.currentCoordinates.longitude);
    updatedPositionOfMarker=_lat1;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        //fontFamily: Constants.LatoRegular,
        fontSize: 20.0,
        color: Color(ColorValues.grey_light_text));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top:24.0),
        child: Stack(
          children: <Widget>[
           // 2nd method
            /*GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition:CameraPosition(
                target: _lat1,
                zoom: 12.0,
              ),
              onMapCreated: _onMapCreated,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: ((_position) => _updatePosition1(_position)),
            ),
*/
            GoogleMap(
              markers: Set<Marker>.of(_markers1.values),
              onMapCreated: _onMapCreated1,
              initialCameraPosition: CameraPosition(
                target: _lat1,
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              onCameraMove: (CameraPosition position) {
                if(_markers1.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker marker = _markers1[markerId];
                  Marker updatedMarker = marker.copyWith(
                    positionParam: position.target,
                  );

                  setState(() {
                    _markers1[markerId] = updatedMarker;
                    updatedPositionOfMarker=position.target;
                    //print('marker position:: latitude: ${position.target.latitude}, longitude: ${position.target.longitude}');
                    //print('Address>>>> ${getCompleteAddressFromMarkerPosition(updatedPositionOfMarker)}');
                  });
                }
              },
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              //right: 20.0,
              child:  IconButton(
                icon:  Image(
                  image: new AssetImage(
                      'assets/images/left_black_arrow.png'),
                  width: 20.0,
                  height: 24.0,
                  //fit: BoxFit.fitHeight,
                ),
                onPressed: () {
                  Navigator.pop(context, null);
                },
              ),
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 80.0, left: 0.0, right: 0.0),
                //margin: const EdgeInsets.only(top: 24.0),
                //padding: const EdgeInsets.only(top: 50.0),
                decoration: new BoxDecoration(
                  color: Color(ColorValues.white),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image(
                            image:
                                new AssetImage('assets/images/loaction_grey.png'),
                            width: 20.0,
                            height: 20.0,
                            //fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'address',
                              style: TextStyle(
                                color: Color(ColorValues.black),
                                fontSize: 18.0,
                                fontFamily: StringValues.customLight,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 16.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Continue clicked');
                          AddressObject addressObject = new AddressObject(updatedPositionOfMarker,'102 MG Road',454545,'Indore','MP','India');
                          Navigator.pop(context,addressObject);
                          //Utils().getMapNavigation(origin,destination);
                        },
                        child: Container(
                          //width: 140.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            color: Color(ColorValues.primaryColor),
                            //Color(ColorValues.primaryColor),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color(ColorValues.accentColor),
                              width: 0.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    StringValues.CONTINUE,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorValues.white),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                Image(
                                  image: new AssetImage(
                                      'assets/images/arrow_white_forward.png'),
                                  width: 18.0,
                                  height: 18.0,
                                  //fit: BoxFit.fitHeight,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getMapMarker() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _lat1,
        zoom: 8,
      ),
    ));
    /*_markers.add(
        Marker(
        onTap: () {
      print('Tapped');
    },
    draggable: true,
    markerId: MarkerId('Marker'),
    position: _lat1,//LatLng(value.latitude, value.longitude),
    onDragEnd: ((value) {
    print('value.latitude::: ${value.latitude}');
    print('value.longitude:: ${value.longitude}');
    }))
    );*/
    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: _lat1,
        draggable: true,
        //icon: _searchMarkerIcon,
      ),
    );
    setState(() {
      _markers;
    });
  }

  @override
  onLocationChange(Map<String, double> location) {
    // TODO: implement onLocationChange
    print("onLocationChange location:::" + location.toString());
    //_lastMapPosition = LatLng(location['latitude'], location['longitude']);
    return null;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
  /*  ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();*/
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    Marker marker = markers["1"];

    setState(() {
      markers["1"] = marker.copyWith(
          positionParam: LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
    });
  }
  void _updatePosition1(CameraPosition _position) {
    print(
        'inside updatePosition ${_position.target.latitude} ${_position.target.longitude}');
    Marker marker = _markers.firstWhere(
            (p) => p.markerId == MarkerId('marker_2'),
        orElse: () => null);

    _markers.remove(marker);
    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
        //icon: _searchMarkerIcon,
      ),
    );
    //getCompleteAddressFromMarkerPosition(_position.target);
    setState(() {});
  }

  void _onMapCreated1(GoogleMapController controller) async {
    _mapController.complete(controller);
    if (_lat1 != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = _lat1;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
        icon: BitmapDescriptor.fromAsset('assets/images/marker_icon.png'),
      );
      setState(() {
        _markers1[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
      });
    }
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    //print('_markerIdVal val:: $val');
    return val;
  }

 /* Future<String> getCompleteAddressFromMarkerPosition(LatLng myLocation) async {
    String address = "";
    final coordinates = new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');

    address =
    '${first.addressLine},${first.featureName},${first.subAdminArea},${first.adminArea}';
    print('Address:: $address');
    return address;
  }*/
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/fleetOrders/bloc.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_tempLatLng.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:http/http.dart' as http;
import 'package:orderly/Utils/googleMapServices.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Widgets/app_dialogs.dart';


class FleetMap extends StatefulWidget {
  int index;
  List<FleetOrdersDet> orderDet;
  FleetMap({Key key,@required this.orderDet,@required this.index}):super(key: key);


  @override
  _FleetMapState createState() => _FleetMapState();
}

class _FleetMapState extends State<FleetMap> {
  Completer<GoogleMapController> _controller = Completer();
  static Position _currentPosition;
  Set<Marker> _markers = {};
  final Set<Polyline> _polyLines={};
  GoogleMapsServices _googleMapsServices=GoogleMapsServices();


  var currentAddress;
  String updatedAddress="";
  bool isconnectedToInternet = false;
  List<CurrentLocation> _fleetOrderDetListMap;
 static double latitude,longitude,sourcelat,sourcelng,destlat,destlng;
  Timer timer;
  int timerCount=0;

  static const LatLng showLocation = const LatLng(27.7089427, 85.3086209); //location to show in map


  @override
  void initState(){
    super.initState();
    // _getCurrentLocation();
    fetchMap(widget.orderDet[widget.index]);
    startTimer();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();

  }
  startTimer() {
    // return new Timer.periodic(const Duration(seconds: 15), updateDataSource);
    timer = Timer.periodic(Duration(minutes: 5), (timer) {
      timerCount++;
      if( timerCount == 12 ) { //to fetch for 1 hour and hit api for every 5 minutes i.e 1hour =12 hits
        timer.cancel();
        setState(() {});
      }else{
       fetchMap(widget.orderDet[widget.index]);
      }

    });
  }


  Future<void> fetchMap(FleetOrdersDet orderDet) async {
    _fleetOrderDetListMap=[];
    PsProgressDialog.showProgressWithoutMsg(context);
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      Map<String,String> params={
        'order_details_id':orderDet.orderDetailsId.toString(),
        'order_status':"3",
      };
      var response = await http.post(Uri.parse(Api.GET_FLEET_ORDER_DET_TEMP),
        body: params,
      );

      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body);
          var orderTemp=resp['ordertemp'];
          final Iterable refactorCategory =orderTemp['current_location'] ?? [];
          _fleetOrderDetListMap = refactorCategory.map((item) {
            return CurrentLocation.fromJson(item);
          }).toList();
          latitude=double.parse(_fleetOrderDetListMap[0].latitude);
          longitude=double.parse(_fleetOrderDetListMap[0].longitude);
          sourcelat=double.parse(orderTemp['source_latitude']);
          sourcelng=double.parse(orderTemp['source_longitude']);
          destlat=double.parse(orderTemp['destination_latitude']);
          destlng=double.parse(orderTemp['destination_longitude']);
          LatLng source=LatLng(sourcelat,sourcelng);
          LatLng destination=LatLng(destlat,destlng);

          _setMarker();
          String route=await _googleMapsServices.getRouteCoordinates(source, destination);
          _createRoute(route);
          setState(() {

          });
        }

      }
      catch(e){

      }
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }



  static final CameraPosition _kGooglePlex = CameraPosition(
//    target: LatLng(37.42796133580664, -122.085749655962),
//     target: LatLng(showLocation.latitude, showLocation.longitude),
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

//get current location
  void _getCurrentLocation() {
    final Geolocator geolocator = Geolocator();
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() async {
        _currentPosition = position;
        currentAddress = await _getAddress(_currentPosition);
//        await _moveToPosition(_currentPosition);
        _setMarker();
      });
    }).catchError((e) {
      print(e);
    });


  }

//get address
  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await GeocodingPlatform.instance
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  Future<void> _moveToPosition(Position pos) async {
    final GoogleMapController mapController = await _controller.future;
    if(mapController == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 15.0,
        )
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body:Container(
        child:
        latitude==null&&longitude==null?
            // _currentPosition==null?
        Container(child: Center(child:Text('loading map..',
          style: TextStyle(
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              color: Colors.black
          ),
        ),
        ),
        )
            :
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers:_markers,
//         Set<Marker>.of(
//              <Marker>[
//                Marker(
//                  draggable: true,
//                  markerId: MarkerId("_marker_2"),
//                  position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
//                  icon: BitmapDescriptor.defaultMarker,
//                  infoWindow: const InfoWindow(
//                    title: 'Usted está aquí',
//                  ),
//                )
//              ],
//            ),

          // onCameraMove: ((_position) => _updatePosition(_position)),
          polylines: _polyLines,
        ),

      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _goToTheLake,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //add polyLines
  void _createRoute(String encodedPolyLine){
   LatLng lastPos=LatLng(sourcelat,sourcelng);
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId(lastPos.toString()),
          width: 10,
          points: convertToLatLng(_decodePoly(encodedPolyLine)),
          color: Colors.black
      ));
    });
  }


  //this method will convert List of doubles into LatLng
  List<LatLng> convertToLatLng(List points){
    List<LatLng> result=<LatLng>[];
    for(int i=0;i<points.length;i++){
      if(i%2==0){
        result.add(LatLng(points[i-1],points[i]));
      }
    }
    return result;
  }
  // DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;


      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }


  void _setMarker() {
    setState(() {
      //1st marker
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("marker_1"),
        draggable: true,
        position: LatLng(latitude,longitude),
        // position: LatLng(27.7089427, 85.3086209),
        infoWindow: InfoWindow(
          title: currentAddress,
//          snippet: 'Inducesmile.com',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      //2 marker
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("marker_2"),
        draggable: true,
        // position: LatLng(_currentPosition.latitude,_currentPosition.longitude),
        position: LatLng(sourcelat, sourcelng),
        infoWindow: InfoWindow(
          title: "Source LatLng",
//          snippet: 'Inducesmile.com',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
//       //3rd marker
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("marker_3"),
        draggable: true,
        // position: LatLng(_currentPosition.latitude,_currentPosition.longitude),
        position: LatLng(destlat, destlng),
        infoWindow: InfoWindow(
          title: "Destination LatLng",
//          snippet: 'Inducesmile.com',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  //get address by coordinates
  void getAddressByCoordinates(CameraPosition _position) async{
    final coordinates = new Coordinates(_position.target.latitude, _position.target.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      updatedAddress=addresses.first.addressLine;

    });


  }

  //to update camera position
  void _updatePosition(CameraPosition _position) async {
    //to get address from co-ordinates
    getAddressByCoordinates(_position);
//    final coordinates = new Coordinates(_position.target.latitude, _position.target.longitude);
//    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
//    var updatedAddress = addresses.first.addressLine;
//    print(updatedAddress.toString());
//    print(
//        'inside updatePosition ${_position.target.latitude} ${_position.target.longitude}');
    Marker marker = _markers.firstWhere(
            (p) =>
        p.markerId == MarkerId('marker_2')||
            p.infoWindow==InfoWindow(title: currentAddress),
        orElse: () => null);

    _markers.remove(marker);

    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,
        infoWindow: InfoWindow(
            onTap: (){
              updatedAddress.toString();
            },
            title:updatedAddress
//          snippet: 'Inducesmile.com',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
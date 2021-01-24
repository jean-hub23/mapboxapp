import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';


class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MapboxMapController mapController;
  final center = LatLng(-9.076537551818774, -78.58725601615002);
  String selectedStyle = 'mapbox://styles/jchunga/ckjam1ckm3qox19phzmr1tg9r';

  final oscuroStyle    = 'mapbox://styles/jchunga/ckjam1ckm3qox19phzmr1tg9r';
  final streetStyle    = 'mapbox://styles/jchunga/ckjam9j535dtn19nwe0k3nxyt';
  final salelliteStyle = 'mapbox://styles/jchunga/ckjamd1gt3qzk19ph1mzoowy8';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, String url) async {
  var response = await get(url);
  return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: botonesFlotantes(),
      body: _crearMapa()
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
        //Simbolos
        FloatingActionButton(
          child: Icon(Icons.sentiment_very_satisfied),
          onPressed: () {
            mapController.addSymbol( SymbolOptions(
              geometry: center,
              iconSize: 3,
              iconImage: 'networkImage',
              textField: "Simbolo creada aqui",
              textColor: '#296457',
              textOffset: Offset(0,3),

            ));
          },
        ),
        SizedBox(height:5),
        //zoomin
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
        ),
        SizedBox(height:5),
        //zoomout
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),
        SizedBox(height:5),
        //cambiar estilo
        FloatingActionButton(
          child: Icon(Icons.add_to_home_screen),
          onPressed: (){
            if ( selectedStyle == oscuroStyle ) {
              selectedStyle = streetStyle;
            }else if(selectedStyle == streetStyle){
              selectedStyle = salelliteStyle;
            }else{
              selectedStyle = oscuroStyle;
            }
            _onStyleLoaded();
            setState(() {});
          },
        ),        

      ],
    );
  }

  MapboxMap _crearMapa() {
    return MapboxMap(
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: 
      CameraPosition(
        target: center,
        zoom: 16
      )
    );
  }
}
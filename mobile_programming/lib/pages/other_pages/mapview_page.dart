import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final Function(LatLng) onSelectLocation;

  const MapView({Key? key, required this.onSelectLocation}) : super(key: key);

  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> markers = {};
  LatLng selectedLocation = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Haritalar Örneği'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onMapTap,
        initialCameraPosition: CameraPosition(
          target: LatLng(38.0263503, 32.509136),
          zoom: 12.0,
        ),
        markers: markers,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (selectedLocation != LatLng(0, 0)) {
                widget.onSelectLocation(selectedLocation);
                Navigator.pop(context);
              } else {
                // Eğer konum seçilmediyse kullanıcıya uyarı ver
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lütfen bir konum seçin.'),
                  ),
                );
              }
            },
            child: Icon(Icons.check),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void _onMapTap(LatLng location) {
    setState(() {
      // Her tıklamada yeni bir Marker ekleyin
      markers = {
        Marker(
          markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()),
          position: location,
          infoWindow: InfoWindow(title: 'Yeni Marker'),
        ),
      };
      selectedLocation = location;
    });
  }
}

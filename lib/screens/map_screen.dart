import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.initialLocation});
  final PlaceLocation initialLocation;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PlaceLocation? pickedLocation;
  void saveLocation() {
    if (pickedLocation == null) return;
    Navigator.of(context).pop(pickedLocation);
  }

  @override
  void initState() {
    super.initState();
    pickedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select the Location'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(onPressed: saveLocation, icon: const Icon(Icons.check)),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 14,
        ),
        onTap: (pos) async {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            pos.latitude,
            pos.longitude,
          );
          final place = placemarks[0];
          final address =
              "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
          setState(() {
            pickedLocation = PlaceLocation(
              latitude: pos.latitude,
              longitude: pos.longitude,
              address: address,
            );
          });
        },
        markers: {
          Marker(
            markerId: const MarkerId("location"),
            position: LatLng(
              pickedLocation!.latitude,
              pickedLocation!.longitude,
            ),
          ),
        },
      ),
    );
  }
}

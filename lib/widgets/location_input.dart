import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
//import 'package:http/http.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool locationLoading = false;
  PlaceLocation? _pickedLocation;
  GoogleMapController? _mapController;

  Future<void> getCurrentLocation() async {
<<<<<<< HEAD
=======
    
>>>>>>> f32743470021fa139b0ca0b3dfe0e718229b9153
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      locationLoading = true;
    });
    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) return;

    List<Placemark> placemarks = await placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );
    final place = placemarks[0];
    final address =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    setState(() {
      locationLoading = false;
      _pickedLocation = PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        address: address,
      );
    });
    widget.onSelectLocation(_pickedLocation!);
  }

  void selectOnMap() async {
    final tempLocation = _pickedLocation;
    if (_pickedLocation == null) await getCurrentLocation();
    if (_pickedLocation == null) return;
    if (!mounted) return;
    final selectedLocation = await Navigator.of(context).push<PlaceLocation?>(
      MaterialPageRoute(
        builder: (context) => MapScreen(initialLocation: _pickedLocation!),
      ),
    );
    if (selectedLocation == null) {
      setState(() {
        _pickedLocation = tempLocation;
      });
    } else {
      setState(() {
        _pickedLocation = selectedLocation;
        widget.onSelectLocation(_pickedLocation!);
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
          ),
        );
      });
    }
    if (_pickedLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget containerContent = Text(
      'No location Chosen',
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
    );
    if (locationLoading) {
      containerContent = CircularProgressIndicator();
    }
    if (!locationLoading && _pickedLocation != null) {
      containerContent = GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(_pickedLocation!.latitude, _pickedLocation!.longitude),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("loc"),
            position: LatLng(
              _pickedLocation!.latitude,
              _pickedLocation!.longitude,
            ),
          ),
        },
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
      );
    }

    return Column(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          child: Center(child: containerContent),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              label: Text('Get Current Location'),
              icon: Icon(Icons.place),
            ),

            TextButton.icon(
              onPressed: selectOnMap,
              label: Text('Select on Map'),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 10,
            left: 5,
            right: 5,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  child: ClipOval(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          place.location.latitude,
                          place.location.longitude,
                        ),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("location"),
                          position: LatLng(
                            place.location.latitude,
                            place.location.longitude,
                          ),
                        ),
                      },
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  place.location.address,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

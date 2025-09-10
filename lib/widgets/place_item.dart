import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: FileImage(place.image),
        ),
        title: Text(
          place.title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
        subtitle: Text(
          place.location.address,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        onTap:
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlaceDetailsScreen(place: place),
              ),
            ),
      ),
    );
  }
}

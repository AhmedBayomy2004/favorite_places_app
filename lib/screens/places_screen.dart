import 'package:favorite_places/providers/places_list_provider.dart';
import 'package:favorite_places/screens/new_place.dart';
import 'package:favorite_places/widgets/place_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _futurePlaces;
  @override
  void initState() {
    super.initState();
    _futurePlaces = ref.read(placesListProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(placesListProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => NewPlace()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _futurePlaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return placesList.isEmpty
              ? const Center(
                child: Text(
                  'No places added yet',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                itemBuilder:
                    (context, index) => PlaceItem(place: placesList[index]),
                itemCount: placesList.length,
              );
        },
      ),
    );
  }
}

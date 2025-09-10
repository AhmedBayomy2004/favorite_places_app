import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sqlite.getDatabasesPath();
  final db = await sqlite.openDatabase(
    path.join(dbPath, 'favorite_places.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places (id TEXT PRIMARY KEY, title TEXT, image Text, lat REAL, lng REAL, address TEXT)',
      );
    },
  );
  return db;
}

class PlacesListNotifier extends StateNotifier<List<Place>> {
  PlacesListNotifier() : super([]);
  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places =
        data
            .map(
              (row) => Place(
                id: row['id'] as String,
                title: row['title'] as String,
                image: File(row['image'] as String),
                location: PlaceLocation(
                  latitude: row['lat'] as double,
                  longitude: row['lng'] as double,
                  address: row['address'] as String,
                ),
              ),
            )
            .toList();
    state = places;
  }

  void addPlace(Place place) async {
    final sysDir = await syspaths.getApplicationDocumentsDirectory();
    final imageName = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${sysDir.path}/$imageName');
    place = Place(
      title: place.title,
      image: copiedImage,
      location: place.location,
    );
    state = [...state, place];
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });
  }
}

final placesListProvider =
    StateNotifierProvider<PlacesListNotifier, List<Place>>((ref) {
      return PlacesListNotifier();
    });

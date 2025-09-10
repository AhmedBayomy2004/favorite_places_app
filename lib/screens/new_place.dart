import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_list_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlace extends ConsumerWidget {
  NewPlace({super.key});
  static final _formKey = GlobalKey<FormState>();
  static final _titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selectedLocation;
  void onPickImage(File image) {
    selectedImage = image;
  }

  void onSelectLocation(PlaceLocation location) {
    selectedLocation = location;
  }

  void addPlace(WidgetRef ref, BuildContext context) {
    final title = _titleController.text;

    if (title.trim().isEmpty ||
        selectedImage == null ||
        selectedLocation == null) {
      return;
    }
    _titleController.clear();
    ref
        .read(placesListProvider.notifier)
        .addPlace(
          Place(
            title: title,
            image: selectedImage!,
            location: selectedLocation!,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Place'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(label: Text('Title')),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              ImageInput(onPickImage: onPickImage),
              SizedBox(height: 8),
              LocationInput(onSelectLocation: onSelectLocation),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => addPlace(ref, context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 4),
                    Text('Add Place'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

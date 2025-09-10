import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final imagePicker = ImagePicker();
  File? takenPicture;
  void takeImage() async {
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 500,
    );
    if (pickedImage == null) return;

    setState(() {
      takenPicture = File(pickedImage.path);
    });
    widget.onPickImage(takenPicture!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: takeImage,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          ),
        ),
        child:
            takenPicture != null
                ? Image.file(
                  takenPicture!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                : TextButton.icon(
                  onPressed: takeImage,
                  label: Text('Take picture'),
                  icon: Icon(Icons.camera_alt),
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                ),
      ),
    );
  }
}

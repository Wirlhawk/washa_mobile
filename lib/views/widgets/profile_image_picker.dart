import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/widgets/header.dart';

class ProfileImagePicker extends StatefulWidget {
  final Map user;
  const ProfileImagePicker({super.key, required this.user});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _imageFile;
  final AuthService _authService = AuthService();

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });

      // ignore: use_build_context_synchronously
      _showSnackBar(context);
    }
  }

  Future uploadImage() async {
    if (_imageFile == null) return;

    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final String path = 'uploads/$fileName';

    await _authService.uploadProfileImage(path, _imageFile).then(
          (value) =>
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Header("Imaged Saved sucessfully")),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          //   backgroundImage:  NetworkImage(widget.user['image']),
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : NetworkImage(widget.user['image']),
          backgroundColor: Colors.grey[400],
          // child: Icon(
          //   Iconsax.user,
          //   size: 40,
          //   color: Colors.white,
          // ),
        ),
        Positioned(
          bottom: -1,
          right: -1,
          child: GestureDetector(
            onTap: pickImage,
            // onTap: () {
            //   final snackbar = SnackBar(
            //     content: Text("Edit image"),
            //     behavior: SnackBarBehavior.floating,
            //     backgroundColor: Style.primary,
            //     shape: StadiumBorder(),
            //   );

            //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
            // },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                color: Style.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.edit,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context) {
    final snackbar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Edit image"),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  uploadImage();
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text("Save", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Style.primary,
      shape: StadiumBorder(),
      duration: Duration(days: 1), // Stays visible until user interacts
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

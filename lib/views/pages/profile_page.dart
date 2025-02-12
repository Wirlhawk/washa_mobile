import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/custom_list_tile.dart';
import 'package:washa_mobile/views/widgets/header.dart';
import 'package:washa_mobile/views/widgets/profile_image_picker.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: AppbarTitle("Profile"),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20), child: _buildProfilePage(context)),
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return FutureBuilder(
      future: _authService.getCurrentUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          debugPrint("${snapshot.error}");
          return Text('Error: ${snapshot.error}');
        }

        final Map<String, dynamic> user = snapshot.data!;

        return Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            _buildProfileImage(context, user),
            _buildProfileSetting(context, user)
          ],
        );
      },
    );
  }

  Widget _buildProfileImage(BuildContext context, user) {
    return Center(
      child: Column(
        spacing: 10,
        children: [
          ProfileImagePicker(user: user),
          Header(
            "@${user['username']}",
          )
        ],
      ),
    );
  }

  Widget _buildProfileSetting(BuildContext context, user) {
    return Column(
      spacing: 20,
      children: [
        CustomListTile(
          label: "Blk F no 25.",
          labelIcon: Iconsax.location5,
          buttonIcon: Iconsax.edit,
          onTap: () {},
        ),
        CustomListTile(
          label: "Log Out",
          labelIcon: Iconsax.user,
          buttonIcon: Iconsax.logout,
          onTap: () => _authService.signOut(),
        )
      ],
    );
  }
}

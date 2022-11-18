import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petilla_app_project/core/constants/other_constant/icon_names.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/app_sized_box.dart';
import 'package:petilla_app_project/core/constants/string_constant/app_firestore_field_names.dart';
import 'package:petilla_app_project/core/constants/string_constant/project_firestore_collection_names.dart';
import 'package:petilla_app_project/core/constants/string_constant/project_lottie_urls.dart';
import 'package:petilla_app_project/core/extension/string_extension.dart';
import 'package:petilla_app_project/core/init/lang/locale_keys.g.dart';
import 'package:petilla_app_project/general/general_view/profile_view/profile_view_model.dart';
import 'package:petilla_app_project/general/general_widgets/textfields/main_textfield.dart';
import 'package:petilla_app_project/core/init/theme/light_theme/light_theme_colors.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/project_padding.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  final smallWidthSizedBox = AppSizedBoxs.smallWidthSizedBox;
  final smallHeightSizedBox = AppSizedBoxs.smallHeightSizedBox;

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _streamBodyBuilder(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      foregroundColor: LightThemeColors.miamiMarmalade,
      title: Text(_ThisPageTexts.title),
      actions: [
        _profileAction(context),
        smallWidthSizedBox,
      ],
    );
  }

  GestureDetector _profileAction(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ProfileViewModel().logOut(context);
      },
      child: _exitIcon(),
    );
  }

  Icon _exitIcon() => const Icon(AppIcons.exitAppIcon, color: LightThemeColors.black);

  StreamBuilder<DocumentSnapshot> _streamBodyBuilder() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore
          .collection(AppFirestoreCollectionNames.usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String name = snapshot.data![AppFirestoreFieldNames.nameField];
          String email = snapshot.data![AppFirestoreFieldNames.emailField];
          return _hasDataScreen(snapshot, name, email);
        } else {
          return _loadingScreen();
        }
      },
    );
  }

  Center _loadingScreen() {
    return Center(
      child: Lottie.network(ProjectLottieUrls.loadingLottie),
    );
  }

  SingleChildScrollView _hasDataScreen(snapshot, String name, String email) {
    return SingleChildScrollView(
      padding: ProjectPaddings.horizontalMainPadding,
      child: Column(
        children: [
          _circleAvatar(snapshot, name),
          smallHeightSizedBox,
          _nameTextfield(snapshot, name),
          smallHeightSizedBox,
          _emailTextfield(snapshot, email),
        ],
      ),
    );
  }

  MainTextField _emailTextfield(snapshot, String email) {
    return MainTextField(
      enabled: false,
      prefixIcon: const Icon(AppIcons.emailOutlinedIcon),
      hintText: email,
    );
  }

  MainTextField _nameTextfield(snapshot, String name) {
    return MainTextField(
      enabled: false,
      prefixIcon: const Icon(AppIcons.personOutlineIcon),
      hintText: name,
    );
  }

  CircleAvatar _circleAvatar(snapshot, String name) {
    return CircleAvatar(
      radius: 60,
      child: Center(
        child: Text(
          name.substring(0, 1),
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

class _ThisPageTexts {
  static String title = LocaleKeys.profile.locale;
}

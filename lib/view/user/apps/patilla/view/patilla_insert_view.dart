import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patily/core/base/view/status_view.dart';
import 'package:patily/core/constants/enums/status_keys_enum.dart';
import 'package:patily/core/constants/sizes_constant/project_padding.dart';
import 'package:patily/core/constants/string_constant/app_firestore_field_names.dart';
import 'package:patily/core/constants/string_constant/project_firestore_collection_names.dart';
import 'package:patily/core/extension/string_lang_extension.dart';
import 'package:patily/core/init/lang/locale_keys.g.dart';
import 'package:patily/view/user/apps/patilla/core/components/pet_widgets/large_pet_widget.dart';
import 'package:patily/view/user/apps/patilla/service/models/pet_model.dart';

class PatillaInsertView extends StatelessWidget {
  const PatillaInsertView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(_ThisPageTexts.myInserts),
      automaticallyImplyLeading: false,
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(AppFirestoreCollectionNames.petsCollection)
            .where(
              AppFirestoreFieldNames.currentUidField,
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
              return _notPetYet(context);
            }

            return _inserts(snapshot);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return _connectionError();
          }
          if (snapshot.hasError) {
            return _errorLottie();
          }

          return _loadingLottie();
        },
      ),
    );
  }

  _connectionError() {
    return const StatusView(status: StatusKeysEnum.CONNECTION_ERROR);
  }

  ListView _inserts(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
      padding: ProjectPaddings.horizontalMainPadding,
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        return _petWidget(snapshot.data!.docs[index]);
      },
    );
  }

  _loadingLottie() {
    return const StatusView(status: StatusKeysEnum.LOADING);
  }

  _errorLottie() {
    return const StatusView(status: StatusKeysEnum.ERROR);
  }

  _notPetYet(BuildContext context) {
    return const StatusView(status: StatusKeysEnum.EMPTY);
  }

  LargePetWidget _petWidget(document) {
    return LargePetWidget(
      petModel: _petModel(document),
    );
  }

  PetModel _petModel(DocumentSnapshot<Object?> document) {
    return PetModel(
      currentUid: document[AppFirestoreFieldNames.currentUidField],
      currentUserName: document[AppFirestoreFieldNames.currentNameField],
      currentEmail: document[AppFirestoreFieldNames.currentEmailField],
      ilce: document[AppFirestoreFieldNames.ilceField],
      gender: document[AppFirestoreFieldNames.genderField],
      name: document[AppFirestoreFieldNames.nameField],
      description: document[AppFirestoreFieldNames.descriptionField],
      imagePath: document[AppFirestoreFieldNames.imagePathField],
      ageRange: document[AppFirestoreFieldNames.ageRangeField],
      city: document[AppFirestoreFieldNames.cityField],
      petBreed: document[AppFirestoreFieldNames.petBreedField],
      price: document[AppFirestoreFieldNames.priceField],
      petType: document[AppFirestoreFieldNames.petTypeField],
      docId: document.id,
    );
  }
}

class _ThisPageTexts {
  static String myInserts = LocaleKeys.patillaPages_my_inserts.locale;
}
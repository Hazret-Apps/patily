// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petilla_app_project/apps/main_petilla/main_petilla.dart';
import 'package:petilla_app_project/apps/main_petilla/petilla_main_service/firebase_crud/crud_service.dart';
import 'package:petilla_app_project/apps/main_petilla/petilla_main_service/models/jsons/city_model.dart';
import 'package:petilla_app_project/apps/main_petilla/petilla_main_service/models/pet_model.dart';
import 'package:petilla_app_project/apps/main_petilla/petilla_main_view/main_view/add_view/city/city_select_view.dart';
import 'package:petilla_app_project/apps/main_petilla/petilla_main_view/main_view/add_view/city/ilce_select_view.dart';
import 'package:petilla_app_project/constant/localization/localization.dart';
import 'package:petilla_app_project/constant/sizes_constant/app_sized_box.dart';
import 'package:petilla_app_project/constant/sizes_constant/project_button_sizes.dart';
import 'package:petilla_app_project/constant/sizes_constant/project_padding.dart';
import 'package:petilla_app_project/general/general_widgets/button.dart';
import 'package:petilla_app_project/general/general_widgets/dialogs/default_dialog.dart';
import 'package:petilla_app_project/general/general_widgets/textfields/main_textfield.dart';
import 'package:petilla_app_project/theme/light_theme/light_theme_colors.dart';

class AddViewTwo extends StatefulWidget {
  const AddViewTwo({
    Key? key,
    required this.name,
    required this.description,
    required this.radioValue,
    required this.image,
  }) : super(key: key);

  final String name;
  final String description;
  final XFile image;
  final int radioValue;

  @override
  _AddViewTwoState createState() => _AddViewTwoState();
}

class _AddViewTwoState extends State<AddViewTwo> {
  bool _yuklemeTamamlandiMi = false;

  late String _secilenIl;
  late String _secilenIlce;

  bool _ilSecilmisMi = false;
  bool _ilceSecilmisMi = false;

  List<dynamic> _illerListesi = [];

  List<String> _ilIsimleriListesi = [];
  List<String> _ilceIsimleriListesi = [];

  late int _secilenIlIndexi;
  late int _secilenIlceIndexi;

  Future<void> _illeriGetir() async {
    String jsonString = await rootBundle.loadString('assets/jsons/il-ilce.json');

    final jsonResponse = json.decode(jsonString);

    _illerListesi = jsonResponse.map((x) => Il.fromJson(x)).toList();
  }

  void _ilIsimleriniGetir() {
    _ilIsimleriListesi = [];

    for (var element in _illerListesi) {
      _ilIsimleriListesi.add(element.ilAdi);
    }

    setState(() {
      _yuklemeTamamlandiMi = true;
    });
  }

  void _secilenIlinIlceleriniGetir(String secilenIl) {
    _ilceIsimleriListesi = [];
    for (var element in _illerListesi) {
      if (element.ilAdi == secilenIl) {
        element.ilceler.forEach((element) {
          _ilceIsimleriListesi.add(element.ilceAdi);
        });
      }
    }
  }

  Future<void> _ilSecmeSayfasinaGit() async {
    if (_yuklemeTamamlandiMi) {
      _secilenIlIndexi = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IlSecimiSayfasi(ilIsimleri: _ilIsimleriListesi),
          ));

      _ilSecilmisMi = true;
      _secilenIl = _ilIsimleriListesi[_secilenIlIndexi];
      _secilenIlinIlceleriniGetir(_illerListesi[_secilenIlIndexi].toString());
      setState(() {});
    }
  }

  Future<void> _ilceSecmeSayfasinaGit() async {
    if (_ilSecilmisMi) {
      _secilenIlinIlceleriniGetir(_ilIsimleriListesi[_secilenIlIndexi]);
      _secilenIlceIndexi = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IlceSecmeSayfasi(ilceIsimleri: _ilceIsimleriListesi),
          ));
      _ilceSecilmisMi = true;
      _secilenIlce = _ilceIsimleriListesi[_secilenIlceIndexi];
      setState(() {});
    }
  }

  final pets = [
    _ThisPageTexts.dog,
    _ThisPageTexts.cat,
    _ThisPageTexts.fish,
    _ThisPageTexts.rabbit,
    _ThisPageTexts.other,
  ];

  final List<String> gender = [
    _ThisPageTexts.male,
    _ThisPageTexts.female,
  ];

  final List<String> ageRange = [
    _ThisPageTexts.zeroThreeMonths,
    _ThisPageTexts.threeSixMonths,
    _ThisPageTexts.sixMonthsOneYear,
    _ThisPageTexts.oneThreeYears,
    _ThisPageTexts.moreThanThreeYears,
  ];

  String? petSelectedValue;
  String? genderSelectedValue;
  String? ageRangeSelectedValue;

  final TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _illeriGetir().then((value) => _ilIsimleriniGetir());
  }

  String imageUrl = "";
  var mainSizedBox = AppSizedBoxs.mainHeightSizedBox;

  bool _isSubmitButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return ListView(
      padding: ProjectPaddings.horizontalMainPadding,
      children: [
        mainSizedBox,
        citySelect(),
        mainSizedBox,
        districtSelect(),
        mainSizedBox,
        _petTypeDropDown(),
        mainSizedBox,
        _petGenderDropDown(),
        mainSizedBox,
        _petAgeRangeDropDown(),
        mainSizedBox,
        _textField(),
        mainSizedBox,
        widget.radioValue == 1 ? const SizedBox() : _textField(),
        _submitButton(context),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(_ThisPageTexts.addAPetTwoForTwo),
      foregroundColor: LightThemeColors.miamiMarmalade,
    );
  }

  DropdownButtonFormField<String> _petAgeRangeDropDown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 3, color: LightThemeColors.miamiMarmalade),
        ),
      ),
      hint: Text(
        _ThisPageTexts.petAgeRange,
      ),
      value: ageRangeSelectedValue,
      items: ageRange
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (val) {
        setState(() {
          ageRangeSelectedValue = val;
        });
      },
    );
  }

  DropdownButtonFormField<String> _petGenderDropDown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 3, color: LightThemeColors.miamiMarmalade),
        ),
      ),
      hint: Text(_ThisPageTexts.petGender),
      value: genderSelectedValue,
      items: gender
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (val) {
        setState(() {
          genderSelectedValue = val;
        });
      },
    );
  }

  DropdownButtonFormField<String> _petTypeDropDown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 3, color: LightThemeColors.miamiMarmalade),
        ),
      ),
      hint: Text(_ThisPageTexts.petType),
      value: petSelectedValue,
      items: pets
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (val) {
        setState(() {
          petSelectedValue = val;
        });
      },
    );
  }

  _textField() {
    return MainTextField(
      controller: _typeController,
      hintText: _ThisPageTexts.petRace,
    );
  }

  SizedBox districtSelect() {
    return SizedBox(
      width: 175,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _ilceSecilmisMi ? LightThemeColors.burningOrange : LightThemeColors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        onPressed: () async {
          await _ilceSecmeSayfasinaGit();
        },
        child: Center(
          child: Text(
            _ilceSecilmisMi ? _secilenIlce : _ThisPageTexts.selectDistrict,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox citySelect() {
    return SizedBox(
      width: 175,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _ilSecilmisMi ? LightThemeColors.burningOrange : LightThemeColors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        onPressed: () async {
          await _ilSecmeSayfasinaGit();
          _ilceSecilmisMi = false;
        },
        child: Center(
          child: Text(
            _ilSecilmisMi ? _secilenIl : _ThisPageTexts.selectCity,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Align _submitButton(context) {
    return Align(
      child: Button(
        onPressed: () {
          _isSubmitButtonClicked ? false : _onSubmitButton(context);
        },
        text: _ThisPageTexts.addPet,
        width: ProjectButtonSizes.mainButtonWidth,
        height: ProjectButtonSizes.mainButtonHeight,
      ),
    );
  }

  _onSubmitButton(context) {
    setState(() {
      _isSubmitButtonClicked = true;
    });
    showDefaultLoadingDialog(false, context);
    CrudService()
        .createPet(
          widget.image,
          imageUrl,
          PetModel(
            currentUserName: FirebaseAuth.instance.currentUser!.displayName!,
            currentUid: FirebaseAuth.instance.currentUser!.uid,
            currentEmail: FirebaseAuth.instance.currentUser!.email.toString(),
            gender: genderSelectedValue ?? _ThisPageTexts.error,
            name: widget.name,
            description: widget.description,
            imagePath: imageUrl,
            ageRange: ageRangeSelectedValue ?? _ThisPageTexts.error,
            city: _secilenIl,
            ilce: _secilenIlce,
            petBreed: _typeController.text,
            price: widget.radioValue == 1 ? "0" : _typeController.text,
            petType: petSelectedValue ?? _ThisPageTexts.error,
          ),
          context,
        )
        .then(
          (value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPetilla()),
            (route) => false,
          ),
        );
  }
}

class _ThisPageTexts {
  static String dog = Localization.dog;
  static String cat = Localization.cat;
  static String fish = Localization.fish;
  static String rabbit = Localization.rabbit;
  static String other = Localization.other;
  static String male = Localization.male;
  static String female = Localization.female;
  static String zeroThreeMonths = Localization.zeroThreeMonths;
  static String threeSixMonths = Localization.threeSixMonths;
  static String sixMonthsOneYear = Localization.sixMonthsOneYear;
  static String oneThreeYears = Localization.oneThreeYears;
  static String moreThanThreeYears = Localization.moreThanThreeYears;
  static String petAgeRange = Localization.petAgeRange;
  static String petGender = Localization.petGender;
  static String petType = Localization.petType;
  static String petRace = Localization.race;
  static String selectDistrict = Localization.selectDistrict;
  static String selectCity = Localization.citySelect;
  static String addPet = Localization.addAPet;
  static String error = Localization.error;
  static String addAPetTwoForTwo = Localization.addPetTwoForTwo;
}
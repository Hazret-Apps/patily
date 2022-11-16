import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petilla_app_project/apps/main_petilla/petilla_main_service/models/pet_model.dart';
import 'package:petilla_app_project/apps/main_petilla/petilla_main_view/other_view/petilla_detail_view/petilla_detail_view.dart';
import 'package:petilla_app_project/constant/localization/localization.dart';
import 'package:petilla_app_project/constant/other_constant/icon_names.dart';
import 'package:petilla_app_project/constant/sizes_constant/app_sized_box.dart';
import 'package:petilla_app_project/constant/sizes_constant/project_radius.dart';
import 'package:petilla_app_project/constant/strings_constant/project_firestore_collection_names.dart';
import 'package:petilla_app_project/theme/light_theme/light_theme_colors.dart';
import 'package:petilla_app_project/utility/widget_utility/fav_button_service.dart';

class LargePetWidget extends StatefulWidget {
  const LargePetWidget({Key? key, required this.petModel}) : super(key: key);

  final PetModel petModel;

  @override
  State<LargePetWidget> createState() => _LargePetWidgetState();
}

class _LargePetWidgetState extends State<LargePetWidget> {
  late bool _isClaim;
  late bool _isMe;
  bool? _isFav;
  var smallHeightSizedBox = AppSizedBoxs.smallHeightSizedBox;

  //* Fav Button Commands
  favButton(docId) async {
    _isFav = await FavButtonService().favButton(docId);
  }

  addFav(docId) async {
    _isFav = await FavButtonService().addFav(docId);
  }

  removeFav(docId) async {
    _isFav = await FavButtonService().removeFav(docId);
  }

  changeFav(docId) async {
    setState(() {
      FavButtonService().changeFav(docId, _isFav);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.petModel.price == "0" ? _isClaim = true : _isClaim = false;
    widget.petModel.currentUid == FirebaseAuth.instance.currentUser!.uid ? _isMe = true : _isMe = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          _callDetailView();
        },
        child: _mainContainer(context),
      ),
    );
  }

  void _callDetailView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailView(
          petModel: _petModel(),
        ),
      ),
    );
  }

  PetModel _petModel() {
    return widget.petModel;
  }

  Container _mainContainer(BuildContext context) {
    return Container(
      decoration: _boxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: _imageContainer(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallHeightSizedBox,
                Row(
                  children: [
                    _nameText(context),
                    const Spacer(),
                    _isMe ? _deleteIconButton() : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _paidText(context),
                    const Spacer(),
                    _location(),
                    const SizedBox(width: 12),
                  ],
                ),
                smallHeightSizedBox,
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _descriptionText(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconButton _deleteIconButton() {
    return IconButton(
      onPressed: () {
        FirebaseFirestore.instance
            .collection(AppFirestoreCollectionNames.petsCollection)
            .doc(widget.petModel.docId)
            .delete();
      },
      icon: const Icon(AppIcons.deleteIcon),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: LightThemeColors.snowbank,
      borderRadius: ProjectRadius.buttonAllRadius,
    );
  }

  Text _nameText(BuildContext context) {
    return Text(widget.petModel.name, style: Theme.of(context).textTheme.headline6);
  }

  Text _paidText(BuildContext context) {
    return Text(
      _isClaim ? Localization.claim : "${widget.petModel.price} TL",
      style: _isClaim
          ? Theme.of(context).textTheme.subtitle2?.copyWith(color: LightThemeColors.miamiMarmalade)
          : Theme.of(context).textTheme.subtitle2,
    );
  }

  SizedBox _descriptionText(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        widget.petModel.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey[600]),
      ),
    );
  }

  Container _imageContainer() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: LightThemeColors.miamiMarmalade,
        borderRadius: ProjectRadius.allRadius,
        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.petModel.imagePath)),
      ),
      child: _isMe ? null : _favButton(),
    );
  }

  Row _location() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _placeIcon(),
        Text(widget.petModel.city, overflow: TextOverflow.clip, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }

  Icon _placeIcon() {
    return const Icon(
      AppIcons.locationOnOtlinedIcon,
      size: 20,
      color: LightThemeColors.pastelStrawberry,
    );
  }

  FutureBuilder<Object?> _favButton() {
    return FutureBuilder(
      future: favButton(widget.petModel.docId),
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              changeFav(widget.petModel.docId);
            },
            icon: _isFav ?? false
                ? const Icon(AppIcons.favoriteIcon, color: Colors.red)
                : const Icon(AppIcons.favoriteBorderIcon),
          ),
        );
      },
    );
  }
}

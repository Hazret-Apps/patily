// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:petilla_app_project/admob/banner_ad_service.dart';
import 'package:petilla_app_project/apps/main_petilla/main_petilla.dart';
import 'package:petilla_app_project/apps/pet_form/main_pet_form.dart';
import 'package:petilla_app_project/general/general_view/profile_view.dart';
import 'package:petilla_app_project/general/general_widgets/select_app_widget.dart';
import 'package:petilla_app_project/theme/sizes/project_padding.dart';

class SelectAppView extends StatefulWidget {
  const SelectAppView({Key? key}) : super(key: key);

  @override
  State<SelectAppView> createState() => _SelectAppViewState();
}

class _SelectAppViewState extends State<SelectAppView> {
  BannerAd? _ad;
  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  void initBannerAd() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _ad!.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _profileAction(context),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: ProjectPaddings.horizontalMainPadding,
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 2,
                    child: _selectPetilla(),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.5,
                    child: _selectPetform(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _ad != null
      //     ? Container(
      //         width: double.infinity,
      //         height: 55,
      //         alignment: Alignment.center,
      //         child: AdWidget(ad: _ad!),
      //       )
      //     : null,
    );
  }

  SelectAppWidget _selectPetform() {
    return const SelectAppWidget(
      title: 'Petform',
      imagePath: "assets/images/petform.png",
      onTap: MainPetForm(),
    );
  }

  SelectAppWidget _selectPetilla() {
    return const SelectAppWidget(
      isBig: true,
      title: 'Petilla',
      imagePath: "assets/images/petilla_image.png",
      onTap: MainPetilla(),
    );
  }

  GestureDetector _profileAction(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _callProfileView(context);
      },
      child: const Icon(Icons.person_outline),
    );
  }

  void _callProfileView(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileView()));
  }
}

class ThisPageTexts {
  static const String title = "Petilla";
}

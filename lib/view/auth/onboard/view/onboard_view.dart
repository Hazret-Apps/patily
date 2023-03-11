import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/app_sized_box.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/project_padding.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/project_radius.dart';
import 'package:petilla_app_project/core/extension/string_lang_extension.dart';
import 'package:petilla_app_project/core/gen/assets.gen.dart';
import 'package:petilla_app_project/core/init/lang/locale_keys.g.dart';
import 'package:petilla_app_project/core/init/theme/light_theme/light_theme_colors.dart';
import 'package:petilla_app_project/view/auth/onboard/viewmodel/onboarding_view_model.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: ProjectPaddings.mainAllPadding,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemCount: onboardItems.length,
                  controller: _pageController,
                  itemBuilder: (context, index) => OnboardContent(
                    image: onboardItems[index].image,
                    title: onboardItems[index].title,
                    description: onboardItems[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    onboardItems.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex == 2) {
                          OnboardingViewModel().onGetStartedButton(context);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        elevation: 0,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: LightThemeColors.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 16 : 12,
      width: 12,
      decoration: BoxDecoration(
        color: isActive
            ? LightThemeColors.miamiMarmalade
            : LightThemeColors.miamiMarmalade.withOpacity(0.4),
        borderRadius: ProjectRadius.minAllRadius,
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          image,
          height: 250,
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        AppSizedBoxs.xsmallHeightSizedBox,
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: LightThemeColors.grey,
            fontSize: 16,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class OnboardModel {
  final String image, title, description;

  OnboardModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardModel> onboardItems = [
  OnboardModel(
    image: Assets.svg.onboardingOne,
    title: LocaleKeys.onboardTitles_onboardingTitleOne.locale,
    description: LocaleKeys.onboardTexts_onboarding_msg_one.locale,
  ),
  OnboardModel(
    image: Assets.svg.onboardingTwo,
    title: LocaleKeys.onboardTitles_onboardingTitleTwo.locale,
    description: LocaleKeys.onboardTexts_onboarding_msg_three.locale,
  ),
  OnboardModel(
    image: Assets.svg.onboardingThree,
    title: LocaleKeys.onboardTitles_onboardingTitleThree.locale,
    description: LocaleKeys.onboardTexts_onboarding_msg_three.locale,
  ),
];

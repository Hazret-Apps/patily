import 'package:flutter/material.dart';
import 'package:petilla_app_project/core/components/buttons/button.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/app_sized_box.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/project_button_sizes.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/project_padding.dart';
import 'package:petilla_app_project/core/init/theme/light_theme/light_theme_colors.dart';
import 'package:petilla_app_project/view/auth/service/auth_service.dart';

class DeleteAccountConfirmView extends StatelessWidget {
  const DeleteAccountConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    SizedBox mainHeightSizedBox = AppSizedBoxs.mainHeightSizedBox;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: LightThemeColors.red,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ProjectPaddings.horizontalMainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hesabınızı Silmek istediğinize emin misiniz?",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: LightThemeColors.red),
              ),
              mainHeightSizedBox,
              Text(
                "Bu işlem geri alınamaz ve hesabınıza dair olan bütün veriler silinir.",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              mainHeightSizedBox,
              Align(
                child: Button(
                  onPressed: () {
                    AuthService().deleteUser(context);
                  },
                  height: ProjectButtonSizes.mainButtonHeight,
                  width: ProjectButtonSizes.mainButtonWidth,
                  text: "Hesabı Sil",
                  color: LightThemeColors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
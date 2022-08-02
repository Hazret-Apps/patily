import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:petilla_app_project/view/auth_view/login_view.dart';
import 'package:petilla_app_project/view/theme/light_theme_colors.dart';
import 'package:petilla_app_project/view/theme/sizes/project_button_sizes.dart';
import 'package:petilla_app_project/view/theme/sizes/project_card_sizes.dart';
import 'package:petilla_app_project/view/theme/sizes/project_padding.dart';
import 'package:petilla_app_project/view/theme/strings/project_lottie_urls.dart';
import 'package:petilla_app_project/view/widgets/button.dart';
import 'package:petilla_app_project/view/widgets/textfields/auth_textfield.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_ThisPageTexts.title),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: Get.height * 0.9,
              child: Padding(
                padding: ProjectPaddings.horizontalLargePadding,
                child: Column(
                  children: [
                    Lottie.network(
                      ProjectLottieUrls.registerLottie,
                      width: ProjectCardSizes.bigLottieWidth,
                      height: ProjectCardSizes.bigLottieHeight,
                    ),
                    AuthTextField(
                      false,
                      controller: _nameController,
                      hintText: _ThisPageTexts.nameHint,
                      isNext: true,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person, color: LightThemeColors.cherrywoord),
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      false,
                      controller: _emailController,
                      hintText: _ThisPageTexts.mailHint,
                      isNext: true,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.mail_outlined, color: LightThemeColors.cherrywoord),
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      false,
                      controller: _passwordController,
                      hintText: _ThisPageTexts.passwordHint,
                      isNext: false,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock_outline, color: LightThemeColors.cherrywoord),
                    ),
                    const Spacer(),
                    _registerButton(),
                    const SizedBox(height: 24),
                    _alreadyHaveAnAccount(),
                    _logInButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Button _registerButton() {
    return Button(
      onPressed: () {},
      width: ProjectButtonSizes.mainButtonWidth,
      height: ProjectButtonSizes.mainButtonHeight,
      text: _ThisPageTexts.title,
    );
  }

  Text _alreadyHaveAnAccount() {
    return Text(
      _ThisPageTexts.alreadyHaveAnAccount,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  TextButton _logInButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
            (route) => false);
      },
      child: const Text(_ThisPageTexts.logIn),
    );
  }
}

class _ThisPageTexts {
  static const String title = "Kayıt Ol";
  static const String nameHint = "Adınız";
  static const String mailHint = "E-posta Adresiniz";
  static const String passwordHint = "Şifreniz";
  static const String alreadyHaveAnAccount = "Zaten hesabın var mı?";
  static const String logIn = "Giriş Yap";
}

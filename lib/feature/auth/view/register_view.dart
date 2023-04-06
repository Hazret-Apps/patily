// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:patily/core/base/view/base_view.dart';
import 'package:patily/product/constants/sizes_constant/project_padding.dart';
import 'package:patily/product/widgets/buttons/auth_button.dart';
import 'package:patily/product/widgets/textfields/auth_textfield.dart';
import 'package:patily/product/constants/other_constant/icon_names.dart';
import 'package:patily/product/constants/sizes_constant/app_sized_box.dart';
import 'package:patily/product/extension/string_lang_extension.dart';
import 'package:patily/product/init/lang/locale_keys.g.dart';
import 'package:patily/product/init/theme/light_theme/light_theme_colors.dart';
import 'package:patily/core/gen/assets.gen.dart';
import 'package:patily/feature/auth/viewmodel/register_view_model.dart';

class RegisterView extends StatelessWidget {
  RegisterView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var mainSizedBox = AppSizedBoxs.mainHeightSizedBox;

  late RegisterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      onModelReady: (model) {
        model.setContext(context);
        viewModel = model;
      },
      viewModel: RegisterViewModel(),
      onPageBuilder: (context, value) => Scaffold(
        body: _body(context),
      ),
    );
  }

  SafeArea _body(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _loginDecorationImage(),
            const SizedBox(height: 24),
            Padding(
              padding: ProjectPaddings.horizontalMainPadding,
              child: Column(
                children: [
                  _nameTextField(),
                  mainSizedBox,
                  _emailTextField(),
                  mainSizedBox,
                  _passwordTextField(),
                  mainSizedBox,
                  _registerButton(context),
                  mainSizedBox,
                  _alreadyHaveAnAccount(context),
                  _logInButton(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded _loginDecorationImage() {
    return Expanded(
      flex: 4,
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.loginBackgroundImage.path),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 64, left: 32),
          child: _welcomeText(),
        ),
      ),
    );
  }

  Text _welcomeText() {
    return Text(
      LocaleKeys.auth_welcome.locale,
      style: const TextStyle(
        color: LightThemeColors.white,
        fontWeight: FontWeight.w700,
        fontSize: 55,
      ),
    );
  }

  AuthTextField _passwordTextField() {
    return AuthTextField(
      true,
      controller: _passwordController,
      hintText: _ThisPageTexts.passwordHint,
      isNext: false,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: AppIcons.lockOutlinedIcon,
    );
  }

  AuthTextField _emailTextField() {
    return AuthTextField(
      false,
      controller: _emailController,
      hintText: _ThisPageTexts.mailHint,
      isNext: true,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: AppIcons.emailOutlinedIcon,
    );
  }

  AuthTextField _nameTextField() {
    return AuthTextField(
      false,
      controller: _nameController,
      hintText: _ThisPageTexts.nameHint,
      isNext: true,
      keyboardType: TextInputType.name,
      prefixIcon: AppIcons.personOutlineIcon,
    );
  }

  AuthButton _registerButton(context) {
    return AuthButton(
      onPressed: () {
        _onRegister(context);
      },
      text: _ThisPageTexts.register,
    );
  }

  void _onRegister(context) {
    if (_formKey.currentState!.validate()) {
      viewModel.onRegisterButton(
        _emailController,
        _passwordController,
        _nameController,
      );
    }
  }

  Text _alreadyHaveAnAccount(context) {
    return Text(
      _ThisPageTexts.alreadyHaveAnAccount,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  TextButton _logInButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        viewModel.callLoginView();
      },
      child: Text(
        _ThisPageTexts.logIn,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
      ),
    );
  }
}

class _ThisPageTexts {
  static String nameHint = LocaleKeys.name.locale;
  static String mailHint = LocaleKeys.auth_mail.locale;
  static String passwordHint = LocaleKeys.auth_password.locale;
  static String alreadyHaveAnAccount =
      LocaleKeys.auth_alreadyHaveAnAccount.locale;
  static String logIn = LocaleKeys.auth_login.locale;
  static String register = LocaleKeys.auth_register.locale;
}

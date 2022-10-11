import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:petilla_app_project/constant/other_constant/icon_names.dart';
import 'package:petilla_app_project/constant/sizes_constant/project_radius.dart';
import 'package:petilla_app_project/theme/light_theme/light_theme_colors.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField(
    this.isPassword, {
    Key? key,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.keyboardType,
    this.isNext,
  }) : super(key: key);

  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  final bool? isNext;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool? _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText!,
      textInputAction: widget.isNext == true ? TextInputAction.next : TextInputAction.done,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        filled: true,
        fillColor: LightThemeColors.summerDay,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword ? _visibilityIcon() : null,
        border: OutlineInputBorder(
          borderRadius: ProjectRadius.mainAllRadius,
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "fill_all_area".tr();
        }
        return null;
      },
    );
  }

  IconButton _visibilityIcon() {
    return IconButton(
      icon: Icon(
        _obscureText! ? AppIcons.visibilityOutlinedIcon : AppIcons.visibilityOffOutlinedIcon,
        color: LightThemeColors.cherrywoord,
      ),
      onPressed: () {
        _changeVisibility();
      },
    );
  }

  void _changeVisibility() {
    return setState(() {
      _obscureText = !_obscureText!;
    });
  }
}

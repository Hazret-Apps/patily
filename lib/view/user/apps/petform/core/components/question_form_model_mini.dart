import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:petilla_app_project/core/constants/sizes_constant/app_sized_box.dart';
import 'package:petilla_app_project/core/extension/string_lang_extension.dart';
import 'package:petilla_app_project/core/gen/assets.gen.dart';
import 'package:petilla_app_project/core/init/lang/locale_keys.g.dart';
import 'package:petilla_app_project/view/user/apps/petform/core/models/question_form_model.dart';

class QuestionFormModelMini extends StatefulWidget {
  const QuestionFormModelMini({super.key, required this.formModel});

  final QuestionFormModel formModel;

  @override
  State<QuestionFormModelMini> createState() => _QuestionFormModelMiniState();
}

class _QuestionFormModelMiniState extends State<QuestionFormModelMini> {
  late final String animalIconPath;
  late final String formattedDate;

  final SizedBox xsmallWidthSizedBox = AppSizedBoxs.xsmallWidthSizedBox;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat(
      DateFormat.YEAR_MONTH_DAY,
    ).format(widget.formModel.createdTime);
    if (widget.formModel.animalType == LocaleKeys.animalNames_dog.locale) {
      animalIconPath = Assets.svg.dog;
    } else if (widget.formModel.animalType ==
        LocaleKeys.animalNames_cat.locale) {
      animalIconPath = Assets.svg.cat;
    } else if (widget.formModel.animalType ==
        LocaleKeys.animalNames_fish.locale) {
      animalIconPath = Assets.svg.fish;
    } else if (widget.formModel.animalType ==
        LocaleKeys.animalNames_rabbit.locale) {
      animalIconPath = Assets.svg.rabbit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {},
      title: Row(
        children: [
          _animalIcon(),
          xsmallWidthSizedBox,
          _titleText(context),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          xsmallWidthSizedBox,
          _descriptionText(context),
          xsmallWidthSizedBox,
          Text(formattedDate),
        ],
      ),
    );
  }

  Text _descriptionText(BuildContext context) {
    return Text(
      widget.formModel.description,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
    );
  }

  Text _titleText(BuildContext context) {
    return Text(
      widget.formModel.title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  SvgPicture _animalIcon() {
    return SvgPicture.asset(
      animalIconPath,
      height: 24,
    );
  }
}

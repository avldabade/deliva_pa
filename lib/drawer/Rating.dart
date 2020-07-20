import 'dart:ui';

import 'package:deliva_pa/customize_predefine_widgets/custom_alert_dialogs.dart';



class Rating {
  String comment;
  int rate;
  TwoButtonSelection selectedButton;
  Rating(this.comment, this.rate, this.selectedButton);
}
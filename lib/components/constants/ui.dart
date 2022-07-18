import 'dart:io';

import 'package:flutter/material.dart';
import '../extensions/int.dart';

const kBlackColor = Color(0xff000022);
const kBackgroundColor = Colors.white;
const kPrimaryTextColor = Color(0xff333333);
const kSecondaryTextColor = Color(0xff878787);
const kSecondaryTextColor2 = Color(0xff555555);
final kGreyColor = Colors.grey[400]!;
const kBorderColor = Colors.black12;
const kShapeColor = Color(0xfff1f1f1);
const kOrangeColor = Colors.orange;
const kBlueColor = Color(0xff426ab3);

const double kDefaultFont = 14; // 普通文字
const double kSmallFont = 12;
double get kButtonFont => Platform.isMacOS ? 14 : 16;
double get kWordFont => Platform.isMacOS ? 30 : 50;

final double kDefaultPadding = (Platform.isMacOS ? 5 : 15).toPadding;
final double kSpacePadding = (Platform.isMacOS ? 2 : 8).toPadding;

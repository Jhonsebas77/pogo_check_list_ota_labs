library com.pogo_check_list_ota_labs.app.utils;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import '../constants/constants.dart';

part 'logger.dart';
part 'type_chart.dart';

String paddingDexNumber({int dexNumber = 0}) {
  String number =
      '${dexNumber < 10
          ? '000'
          : dexNumber < 100
          ? '00'
          : dexNumber < 1000
          ? '0'
          : ''}$dexNumber';
  return '#$number';
}

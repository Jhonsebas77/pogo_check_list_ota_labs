library com.pogo_check_list_ota_labs.app.views;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screenshot/screenshot.dart';

import '../../core/enums/enums.dart';
import '../../core/models/models.dart';
import '../../core/providers/providers.dart';
import '../../core/state/state.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/type_chart.dart';
import '../navigator.dart';
import '../theme.dart';
import '../typography.dart';
import '../widgets/widgets.dart';

part 'details/details.dart';
part 'home/home.dart';
part 'home/pokedex_view.dart';
part 'home/settings.dart';
part 'list/dex_list.dart';
part 'login/login.dart';
part 'list/gigantamax_dex_list.dart';
part 'list/megaevolution_dex_list.dart';
part 'list/shiny_dex_list.dart';
part 'settings/color_scheme.dart';
part 'settings/edit_profile.dart';
part 'settings/lucky_friends.dart';
part 'settings/lucky_friends_editor.dart';
part 'settings/type_chart.dart';
part 'settings/wanted_for_trade/editor.dart';
part 'settings/wanted_for_trade/wanted_for_trade_view.dart';
part 'zygarde/zygarde_details.dart';

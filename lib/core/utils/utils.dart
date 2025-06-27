library com.pogo_check_list_ota_labs.app.utils;

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

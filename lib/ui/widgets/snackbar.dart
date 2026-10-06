part of com.pogo_check_list_ota_labs.app.widgets;

void showInformationSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar(
      context: context,
      label: message,
      type: SnackbarType.information,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar(context: context, label: message, type: SnackbarType.error),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    CustomSnackBar(
      context: context,
      label: message,
      type: SnackbarType.success,
    ),
  );
}

Color backgroundColorType(SnackbarType type) => switch (type) {
  SnackbarType.information => Colors.blueGrey.shade700,
  SnackbarType.success => Colors.green.shade800,
  SnackbarType.error => Colors.red.shade700,
};

IconData defaultIcon(SnackbarType type) => switch (type) {
  SnackbarType.error => Icons.error_outline_outlined,
  SnackbarType.information => Icons.info_outline_rounded,
  _ => Icons.check_circle_outline_outlined,
};

const double _kMaxSnackBarWidth = 556;

bool _useFixedWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= _kMaxSnackBarWidth + 32;

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    required BuildContext context,
    required String label,
    SnackbarType type = SnackbarType.information,
    IconData? prefixIcon,
    ThemeData? themeData,
    Key? key,
  }) : super(
         key: key,
         elevation: 2,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
         behavior: SnackBarBehavior.floating,
         // `width` y `margin` son excluyentes: el ancho fijo solo aplica si
         // cabe con 16px a cada lado; si no, se usa el margen lateral.
         margin:
             _useFixedWidth(context) ? null : const EdgeInsetsGeometry.all(16),
         width: _useFixedWidth(context) ? _kMaxSnackBarWidth : null,
         backgroundColor: backgroundColorType(type),
         content: Theme(
           data: themeData ?? Theme.of(context),
           child: SnackBarContent(
             label: label,
             type: type,
             prefixIcon: prefixIcon,
           ),
         ),
       );
}

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    required this.label,
    required this.type,
    this.prefixIcon,
    super.key,
  });

  final String label;
  final SnackbarType type;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Icon(prefixIcon ?? defaultIcon(type), color: Colors.white),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          label,
          softWrap: true,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      const SizedBox(width: 8),
    ],
  );
}

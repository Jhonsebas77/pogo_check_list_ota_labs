part of com.pogo_check_list_ota_labs.app.widgets;

class SimpleErrorChip extends StatelessWidget {
  const SimpleErrorChip({
    required this.iconData,
    this.error,
    this.text,
    this.stackTrace,
    this.isSmall = false,
    super.key,
  });

  final String? text;
  final String? error;
  final StackTrace? stackTrace;
  final IconData iconData;
  final bool? isSmall;

  @override
  Widget build(BuildContext context) {
    debugPrint('\x1B[33m=================\x1B[0m');
    debugPrint('\x1B[32m[SimpleErrorChip]\x1B[0m');
    debugPrint('\x1B[31m[error]: $error\x1B[0m');
    debugPrint('\x1B[31m[stackTrace]: $stackTrace\x1B[0m');
    debugPrint('\x1B[33m=================\x1B[0m');
    Color foreground = Theme.of(context).colorScheme.onError;
    return Center(
      child: Padding(
        padding: (isSmall ?? false) ? EdgeInsets.zero : const EdgeInsets.all(8),
        child: Card(
          color: Theme.of(context).colorScheme.error,
          child:
              (isSmall ?? false)
                  ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(iconData, color: foreground, size: 14),
                        Text('Error', style: TextStyle(color: foreground)),
                      ],
                    ),
                  )
                  : ListTile(
                    style: ListTileStyle.list,
                    leading: Icon(iconData, color: foreground, size: 14),
                    title: Text(
                      'Lo sentimos, algo salio mal',
                      style: TextStyle(
                        fontSize: 14,
                        color: foreground,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    subtitle:
                        text != null
                            ? Text(
                              text!,
                              style: TextStyle(
                                fontSize: 10,
                                color: foreground.withValues(alpha: 0.85),
                                fontWeight: FontWeight.normal,
                              ),
                            )
                            : null,
                  ),
        ),
      ),
    );
  }
}

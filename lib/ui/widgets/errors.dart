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
    return Center(
      child: Padding(
        padding: (isSmall ?? false) ? EdgeInsets.zero : const EdgeInsets.all(8),
        child: Card(
          color: Colors.redAccent,
          child:
              (isSmall ?? false)
                  ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(iconData, color: Colors.black87, size: 14),
                        const Text('Error'),
                      ],
                    ),
                  )
                  : ListTile(
                    style: ListTileStyle.list,
                    leading: Icon(iconData, color: Colors.black87, size: 14),
                    title: const Text(
                      'Lo sentimos, algo salio mal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    subtitle:
                        text != null
                            ? Text(
                              text!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
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

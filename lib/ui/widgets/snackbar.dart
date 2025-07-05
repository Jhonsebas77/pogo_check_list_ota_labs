part of com.pogo_check_list_ota_labs.app.widgets;

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(child: Text(message, textAlign: TextAlign.center)),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.fixed,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(child: Text(message, textAlign: TextAlign.center)),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.fixed,
    ),
  );
}

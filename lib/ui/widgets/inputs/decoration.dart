part of com.pogo_check_list_ota_labs.app.widgets;

InputDecoration inputDecoration(
  BuildContext context, {
  required IconData icon,
  String label = '',
}) => InputDecoration(
  labelText: label,
  filled: true,
  fillColor: Colors.black12,
  labelStyle: const TextStyle(color: Colors.white70),
  prefixIcon: Icon(icon, color: Colors.white70),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(32),
    borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
  ),
  
);

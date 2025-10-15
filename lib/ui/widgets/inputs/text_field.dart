part of com.pogo_check_list_ota_labs.app.widgets;

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.validator,
    this.inputType,
    this.maxLines = 1,
    this.fieldWidth,
    super.key,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType? inputType;
  final int? maxLines;
  final double? fieldWidth;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: fieldWidth ?? MediaQuery.sizeOf(context).width,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        keyboardType: inputType ?? TextInputType.name,
        decoration: inputDecoration(context, label: label, icon: icon),
      ),
    ),
  );
}

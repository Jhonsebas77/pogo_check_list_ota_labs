part of com.pogo_check_list_ota_labs.app.widgets;

class DexHeaderLeading extends StatelessWidget {
  const DexHeaderLeading({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      if (CustomNavigator().canPop(context)) {
        CustomNavigator().pop(context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF5A79C8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child:
            CustomNavigator().canPop(context)
                ? const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white),
                )
                : null,
      ),
    ),
  );
}

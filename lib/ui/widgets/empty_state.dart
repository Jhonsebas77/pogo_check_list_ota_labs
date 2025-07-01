part of com.pogo_check_list_ota_labs.app.widgets;

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/empty_state.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                const Center(
                  child: Text(
                    'Lo sentimos, aun no tenemos registros',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

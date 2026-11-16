part of 'widgets.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    this.message = 'Lo sentimos, aun no tenemos registros',
    super.key,
  });

  final String message;

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/empty_state.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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

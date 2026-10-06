part of com.pogo_check_list_ota_labs.app.utils;

class Logger {
  const Logger(this.name);

  final String? name;

  String get formattedName => ReCase(name ?? '').titleCase;

  String get formattedDate => DateFormat.yMd().add_jm().format(DateTime.now());

  // `debugPrint` no se elimina en modo release (a diferencia de `assert` o
  // los `kDebugMode`-gated de Flutter), así que sin este guard los logs de
  // error de auth, etc. terminarían en la consola del navegador/dispositivo
  // en producción. No hay backend de crash reporting hoy a donde mandarlos,
  // así que en release simplemente no se emiten.
  void info(String msg) {
    if (kReleaseMode) return;
    debugPrint('\x1B[32m$formattedDate [$formattedName]: $msg\x1B[0m');
  }

  void error(String msg) {
    if (kReleaseMode) return;
    debugPrint('\x1B[31m$formattedDate [$formattedName]: $msg\x1B[0m');
  }

  void warning(String msg) {
    if (kReleaseMode) return;
    debugPrint('\x1B[33m$formattedDate [$formattedName]: $msg\x1B[0m');
  }

  /// Solo se emite en modo debug (ni en profile ni en release). Pensado para
  /// trazas ruidosas como las llamadas a URLs externas.
  void debug(String msg) {
    if (!kDebugMode) return;
    debugPrint('\x1B[36m$formattedDate [$formattedName]: $msg\x1B[0m');
  }
}

part of com.pogo_check_list_ota_labs.app.widgets;

/// Ancho máximo del contenido de la app en pantallas anchas (web/desktop).
///
/// La app es mobile-first; por encima de este ancho el contenido se centra
/// en una columna fija para que listas, tarjetas y modales no se estiren.
const double kMaxContentWidth = 800;

/// Ancho máximo de los inputs (campos de texto, dropdowns, botones de acción).
const double kMaxInputWidth = 500;

/// Limita el ancho del contenido de una pantalla a [kMaxContentWidth] y lo
/// centra horizontalmente. Se usa en el `body` de cada [Scaffold] para que el
/// header y el fondo ocupen todo el ancho mientras el contenido no se estira.
///
/// Sobrescribe el [MediaQuery] con el ancho limitado para que los widgets que
/// calculan tamaños con `MediaQuery.sizeOf(context).width` se comporten igual
/// que en un dispositivo móvil.
class WebContent extends StatelessWidget {
  const WebContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth.clamp(0, kMaxContentWidth);
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: MediaQuery(
              data: mediaQuery.copyWith(
                size: Size(width, mediaQuery.size.height),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Limita el ancho de un input a [kMaxInputWidth] y lo alinea dentro del
/// espacio disponible. En pantallas angostas ocupa todo el ancho.
class MaxWidthInput extends StatelessWidget {
  const MaxWidthInput({
    required this.child,
    this.alignment = Alignment.center,
    this.maxWidth = kMaxInputWidth,
    super.key,
  });

  final Widget child;
  final AlignmentGeometry alignment;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: alignment,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}

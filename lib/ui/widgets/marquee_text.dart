part of com.pogo_check_list_ota_labs.app.widgets;

/// Texto de una línea que, si no cabe, se desliza de derecha a izquierda para
/// mostrarse completo, con una pausa en cada extremo.
///
/// Solo anima cuando el texto se desborda; si cabe es un [Text] normal. El
/// desplazamiento usa [Transform] dentro de un [RepaintBoundary], así que cada
/// frame solo repinta el texto (sin recalcular layout), y el ticker se detiene
/// cuando la ruta no está visible. Si el sistema pide reducir animaciones, usa
/// elipsis.
class MarqueeText extends StatefulWidget {
  const MarqueeText(this.text, {this.style, super.key});

  final String text;
  final TextStyle? style;

  /// Velocidad del desplazamiento en píxeles lógicos por segundo.
  static const double _speed = 40;
  static const Duration _pause = Duration(milliseconds: 1500);

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double> _offset = const AlwaysStoppedAnimation<double>(0);
  double _distance = 0;

  @override
  void initState() {
    super.initState();
    // Sin arrancar no genera frames; solo corre si el texto se desborda.
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Ajusta la animación al desborde medido; se llama tras el layout.
  void _sync(double distance) {
    if (distance == _distance) return;
    _distance = distance;
    if (distance <= 0) {
      _controller.stop();
      return;
    }
    int scrollMs = (distance / MarqueeText._speed * 1000).round();
    int pauseMs = MarqueeText._pause.inMilliseconds;
    _controller.duration = Duration(milliseconds: scrollMs + pauseMs * 2);
    _offset = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0),
        weight: pauseMs.toDouble(),
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0,
          end: distance,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: scrollMs.toDouble(),
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(distance),
        weight: pauseMs.toDouble(),
      ),
    ]).animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = DefaultTextStyle.of(context).style.merge(widget.style);
    bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        TextPainter painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        double distance =
            reduceMotion || !constraints.hasBoundedWidth
                ? 0
                : painter.width - constraints.maxWidth;
        Size textSize = painter.size;
        painter.dispose();
        // Solo cuando cambia el desborde (nuevo texto, ancho o escala), para
        // no reconstruir en cada frame.
        if (distance != _distance) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && distance != _distance) {
              setState(() => _sync(distance));
            }
          });
        }

        if (distance <= 0 || _distance != distance) {
          return Text(
            widget.text,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
        return Semantics(
          label: widget.text,
          excludeSemantics: true,
          child: SizedBox(
            width: constraints.maxWidth,
            height: textSize.height,
            child: ClipRect(
              child: RepaintBoundary(
                child: OverflowBox(
                  alignment: AlignmentDirectional.centerStart,
                  maxWidth: double.infinity,
                  child: AnimatedBuilder(
                    animation: _offset,
                    builder:
                        (BuildContext context, Widget? child) =>
                            Transform.translate(
                              offset: Offset(-_offset.value, 0),
                              child: child,
                            ),
                    child: Text(
                      widget.text,
                      style: style,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

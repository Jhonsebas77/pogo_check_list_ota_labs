part of com.pogo_check_list_ota_labs.app.widgets;

class ModalBase extends StatelessWidget {
  const ModalBase({
    this.children,
    this.maxHeightFactor = 0.8,
    this.maxWidthFactor,
    this.showScrollbar = true,
    this.showExitIcon = true,
    this.title,
    this.centerTitle = false,
    this.titleStyle,
    this.paragraphStyle,
    this.mainParagraph,
    this.centerParagraph = false,
    this.childrenPadding,
    this.childrenGap,
    this.button,
    this.listViewController,
    this.isDismissible = true,
    this.onPressedExitIcon,
    this.onTapDismissible,
    this.onPressedExitIconOverride,
    super.key,
  });

  final List<Widget>? children;
  final double maxHeightFactor;
  final double? maxWidthFactor;
  final bool showScrollbar;
  final bool showExitIcon;
  final String? title;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final TextStyle? paragraphStyle;
  final String? mainParagraph;
  final bool centerParagraph;
  final EdgeInsetsGeometry? childrenPadding;
  final double? childrenGap;
  final Widget? button;
  final ScrollController? listViewController;
  final bool isDismissible;
  final void Function()? onPressedExitIcon;
  final void Function()? onPressedExitIconOverride;
  final void Function()? onTapDismissible;

  static const double defaultMobileFactor = 0.9;

  static const double defaultWebSize = 536;

  double getMaxWidth(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;

    double defaultMobileSize = screenSize * defaultMobileFactor;

    if (maxWidthFactor != null) {
      return screenSize * maxWidthFactor!;
    }
    if (kIsWeb) {
      return MediaQuery.of(context).size.width < 720
          ? defaultMobileSize
          : defaultWebSize;
    }
    return defaultMobileSize;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap:
        isDismissible
            ? () {
              Navigator.of(context).pop();
              onTapDismissible?.call();
            }
            : null,
    child: Material(
      color: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
            maxWidth: getMaxWidth(context),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white12,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromRGBO(198, 73, 52, 1),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Icon(
                      Icons.catching_pokemon,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 28,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (showExitIcon) ...<Widget>[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                onPressed:
                                    onPressedExitIconOverride ??
                                    () {
                                      Navigator.of(context).pop();
                                      onPressedExitIcon?.call();
                                    },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        const SizedBox(height: 16),
                      Flexible(
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(
                            overscroll: false,
                          ),
                          child: RawScrollbar(
                            controller: listViewController,
                            crossAxisMargin: 4,
                            thumbColor: Colors.black26,
                            trackColor: Colors.transparent,
                            thickness: showScrollbar ? 4 : 0,
                            radius:
                                showScrollbar ? const Radius.circular(2) : null,
                            child: ListView(
                              shrinkWrap: true,
                              primary: true,
                              controller: listViewController,
                              padding: childrenPadding,
                              children: <Widget>[
                                if (title != null)
                                  Text(
                                    title!,
                                    style: titleStyle,
                                    textAlign:
                                        centerTitle
                                            ? TextAlign.center
                                            : TextAlign.start,
                                  ),
                                if (children != null)
                                  ...children!.mapIndexed(
                                    (int index, Widget child) => Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: child,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (button != null) button!,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

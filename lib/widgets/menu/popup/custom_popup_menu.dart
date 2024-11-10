import 'package:amphi/widgets/menu/popup/custom_popup_menu_route.dart';
import 'package:flutter/material.dart';

const double _kMenuWidthStep = 56.0;

class CustomPopupMenu<T> extends StatefulWidget {
  const CustomPopupMenu({
    super.key,
    required this.route,
    required this.semanticLabel,
    this.constraints,
    required this.clipBehavior,
    required this.child
  });

  final CustomPopupMenuRoute<T> route;
  final String? semanticLabel;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final Widget child;

  @override
  State<CustomPopupMenu<T>> createState() => _CustomPopupMenuState<T>();
}

class _CustomPopupMenuState<T> extends State<CustomPopupMenu<T>> {


  @override
  Widget build(BuildContext context) {
    //final double unit = 1.0 / (widget.route.items.length + 1.5); // 1.0 for the width and 0.5 for the last item's fade.
    final sex = 5;
    final double unit = 1.0 / (sex + 1.5);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
   // final ThemeData theme = Theme.of(context);
  // final PopupMenuThemeData defaults = theme.useMaterial3 ? _PopupMenuDefaultsM3(context) : _PopupMenuDefaultsM2(context);

    final CurveTween opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    // final CurveTween height = CurveTween(curve: Interval(0.0, unit * widget.route.items.length));
    final CurveTween height = CurveTween(curve: Interval(0.0, unit * sex));

    final Widget child = IntrinsicWidth(
      stepWidth: _kMenuWidthStep,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: widget.semanticLabel,
        child: SingleChildScrollView(
          // padding: widget.route.menuPadding ?? popupMenuTheme.menuPadding ?? defaults.menuPadding,
          padding: widget.route.menuPadding ?? popupMenuTheme.menuPadding,
          child: widget.child,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: widget.route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(widget.route.animation!),
          child: Material(
            // shape: widget.route.shape ?? popupMenuTheme.shape ?? defaults.shape,
            // color: widget.route.color ?? popupMenuTheme.color ?? defaults.color,
            shape: widget.route.shape ?? popupMenuTheme.shape ?? const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
            color: widget.route.color ?? popupMenuTheme.color,
            clipBehavior: widget.clipBehavior,
            type: MaterialType.card,
            // elevation: widget.route.elevation ?? popupMenuTheme.elevation ?? defaults.elevation!,
            // shadowColor: widget.route.shadowColor ?? popupMenuTheme.shadowColor ?? defaults.shadowColor,
            // surfaceTintColor: widget.route.surfaceTintColor ?? popupMenuTheme.surfaceTintColor ?? defaults.surfaceTintColor,
            elevation: widget.route.elevation ?? popupMenuTheme.elevation ?? 8.0,
            shadowColor: widget.route.shadowColor ?? popupMenuTheme.shadowColor,
            surfaceTintColor: widget.route.surfaceTintColor ?? popupMenuTheme.surfaceTintColor,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              widthFactor: width.evaluate(widget.route.animation!),
              heightFactor: height.evaluate(widget.route.animation!),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
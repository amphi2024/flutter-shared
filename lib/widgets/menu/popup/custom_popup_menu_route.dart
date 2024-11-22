import 'package:amphi/widgets/menu/popup/custom_popup_menu.dart';
import 'package:amphi/widgets/menu/popup/custom_popup_menu_route_layout.dart';
import 'package:flutter/material.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;

void showCustomPopupMenu(BuildContext context, Widget child) {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

  Navigator.push(context, CustomPopupMenuRoute(
      position: RelativeRect.fromLTRB(position.dx, position.dy + button.size.height, position.dx, 0),
      barrierLabel: MaterialLocalizations.of(context).menuDismissLabel,
      clipBehavior: Clip.none,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      child: child
  ));
}

void showCustomPopupMenuByPosition(BuildContext context, RelativeRect position, Widget child) {

  Navigator.push(context, CustomPopupMenuRoute(
      position: position,
      barrierLabel: MaterialLocalizations.of(context).menuDismissLabel,
      clipBehavior: Clip.none,
      popUpAnimationStyle: AnimationStyle.noAnimation,
      child: child
  ));
}

class CustomPopupMenuRoute<T> extends PopupRoute<T> {

  CustomPopupMenuRoute({
    required this.position,
    this.elevation,
    this.surfaceTintColor,
    this.shadowColor,
    required this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.menuPadding,
    this.color,
    this.constraints,
    required this.clipBehavior,
    super.settings,
    this.popUpAnimationStyle,
    required this.child
  }) :
  // Menus always cycle focus through their items irrespective of the
  // focus traversal edge behavior set in the Navigator.
        super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  final Widget child;
  final RelativeRect position;
  final double? elevation;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? menuPadding;
  final Color? color;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final AnimationStyle? popUpAnimationStyle;

  CurvedAnimation? _animation;

  @override
  Animation<double> createAnimation() {
    if (popUpAnimationStyle != AnimationStyle.noAnimation) {
      return _animation ??= CurvedAnimation(
        parent: super.createAnimation(),
        curve: popUpAnimationStyle?.curve ?? Curves.linear,
        reverseCurve: popUpAnimationStyle?.reverseCurve ?? const Interval(0.0, _kMenuCloseIntervalEnd),
      );
    }
    return super.createAnimation();
  }

  @override
  Duration get transitionDuration => popUpAnimationStyle?.duration ?? _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {

    final Widget menu = CustomPopupMenu<T>(
      route: this,
      semanticLabel: semanticLabel,
      constraints: constraints,
      clipBehavior: clipBehavior,
      child: child,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: PopupMenuRouteLayout(
              position,
              Directionality.of(context),
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
            ),
          // child: Container(
          //   width: 300,
          //   height: 500,
          //   color: Colors.black,
          // ),
           // child: capturedThemes.wrap(menu),
            child: menu,
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }

  @override
  void dispose() {
    _animation?.dispose();
    super.dispose();
  }
}
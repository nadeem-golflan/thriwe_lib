import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAnimatedOpacity extends ImplicitlyAnimatedWidget {
  /// Creates a widget that animates its opacity implicitly.
  ///
  /// The [opacity] argument must not be null and must be between 0.0 and 1.0,
  /// inclusive. The [curve] and [duration] arguments must not be null.
  const CustomAnimatedOpacity({
    Key? key,
    this.child,
    this.opacityResult,
    required this.opacity,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
    this.alwaysIncludeSemantics = false,
  })  : assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// The target opacity.
  ///
  /// An opacity of 1.0 is fully opaque. An opacity of 0.0 is fully transparent
  /// (i.e., invisible).
  ///
  /// The opacity must not be null.
  final double opacity;

  /// Whether the semantic information of the children is always included.
  ///
  /// Defaults to false.
  ///
  /// When true, regardless of the opacity settings the child semantic
  /// information is exposed as if the widget were fully visible. This is
  /// useful in cases where labels may be hidden during animations that
  /// would otherwise contribute relevant semantics.
  final bool alwaysIncludeSemantics;
  final Function(double)? opacityResult;

  @override
  _CustomAnimatedOpacityState createState() => _CustomAnimatedOpacityState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('opacity', opacity));
  }
}

class _CustomAnimatedOpacityState
    extends ImplicitlyAnimatedWidgetState<CustomAnimatedOpacity> {
  Tween<double>? _opacity;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.opacityResult != null) {
      _opacityAnimation.addListener(callback);
    }
  }

  void callback() {
    widget.opacityResult!(_opacityAnimation.value);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _opacity = visitor(_opacity, widget.opacity,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _opacityAnimation = animation.drive(_opacity!);
  }

  @override
  void dispose() {
    if (widget.opacityResult != null) {
      _opacityAnimation.removeListener(callback);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: widget.child,
      alwaysIncludeSemantics: widget.alwaysIncludeSemantics,
    );
  }
}

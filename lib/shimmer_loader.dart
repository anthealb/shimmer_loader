import 'package:flutter/material.dart';

/// Based on the [isLoading] parameter, this Widget overlays a shimmer on a [child]
/// or shows it on its own.
/// When loading, a gray container will be created with the dimensions specified
/// in [placeholderSize] and the shimmer will be applied to it. However, should the
/// object be more complex, a [placeholder] con be supplied instead.
///
class ShimmerLoader extends StatefulWidget {
  const ShimmerLoader({
    super.key,

    /// Controls whether the shimmer should be showed or not.
    required this.isLoading,

    /// The final child, to be shown when the loading has finished.
    required this.child,

    /// This Widget should be a prototype of the final [child], made up of solid
    /// color [Container]s. The shimmer will be applied on it.
    ///
    /// If this parameter is not null, [placeholderSize] must be.
    this.placeholder,

    /// The size of the [child] to load. If [placeholder] is not supplied,
    /// this parameter must be.
    /// It will create a grey [Container] with the given dimensions.
    this.placeholderSize,

    /// The color of the placeholder container shown if [placeholder] is null.
    /// Default is gray.
    this.placeholderColor = const Color.fromARGB(255, 189, 189, 189),

    /// The radius of the placeholder container shown if [placeholder] is null.
    /// Default is a circular radius of 4.
    this.placeholderRadius = const BorderRadius.all(Radius.circular(4)),

    /// This color should have full opacity.
    /// Default is white.
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),

    /// This color should have low opacity
    /// Default is gray.
    this.shimmerColor = const Color.fromARGB(100, 255, 255, 255),
  }) : assert(placeholder == null ? placeholderSize != null : placeholderSize == null);

  final bool isLoading;
  final Widget child;
  final Widget? placeholder;
  final Size? placeholderSize;
  final Color placeholderColor;
  final BorderRadius placeholderRadius;
  final Color backgroundColor;
  final Color shimmerColor;

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
    _shimmerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return ShaderMask(
        blendMode: BlendMode.dstATop,
        shaderCallback: (bounds) {
          return _shimmerGradient.createShader(bounds);
        },
        child: widget.placeholder ?? loadingChild,
      );
    }

    return widget.child;
  }

  /// The shimmer used by the ShaderMask
  LinearGradient get _shimmerGradient => LinearGradient(
        colors: [
          widget.backgroundColor,
          widget.shimmerColor,
          widget.backgroundColor,
        ],
        stops: const [0.1, 0.5, 1.0],
        begin: const Alignment(-1.0, -0.5),
        end: const Alignment(1.0, 0.5),
        tileMode: TileMode.clamp,
        transform: _SlidingGradientTransform(slidePercent: _shimmerController.value),
      );

  /// A default container to draw in place of the actual content during the loading phase. Needs a [Size].
  Widget get loadingChild => Container(
        decoration: BoxDecoration(color: widget.placeholderColor, borderRadius: widget.placeholderRadius),
        height: widget.placeholderSize?.height,
        width: widget.placeholderSize?.width,
      );
}

/// Extension to [GradientTransform], to use in the [transform] paramenter in a [LinearGradient] constructor.
/// Used to turn a double in a configuration of such linear  gradient.
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

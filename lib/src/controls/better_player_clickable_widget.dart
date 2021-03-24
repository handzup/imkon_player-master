// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BetterPlayerMaterialClickableWidget extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  const BetterPlayerMaterialClickableWidget({
    Key? key,
    required this.onTap,
    required this.child,
  })  : assert(onTap != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class CustomAnimatedIcon extends StatefulWidget {
  final Widget child;
  final void Function() onTap;
  final Color color;
  final double size;
  const CustomAnimatedIcon(
      {Key? key,
      this.color = Colors.white,
      this.size = 18,
      required this.onTap,
      required this.child})
      : assert(onTap != null),
        assert(child != null),
        super(key: key);
  @override
  _CustomAnimatedIconState createState() => _CustomAnimatedIconState();
}

class _CustomAnimatedIconState extends State<CustomAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.5,
    ).animate(CurvedAnimation(curve: Curves.decelerate, parent: _controller));
    _scaleAnimation.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          break;
        case AnimationStatus.completed:
          _controller.reverse();
          break;

        default:
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateIcon() {
    widget.onTap();
    _controller.forward();
  }

  bool checked = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: animateIcon,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        ),
      );
}

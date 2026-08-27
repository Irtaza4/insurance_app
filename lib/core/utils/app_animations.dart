import 'package:flutter/material.dart';

/// Reusable smooth entrance animations for cards, rows, and list items.

/// Smoothly slides down from above with fade in (e.g. for hero cards and headers)
class SlideDownFade extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double verticalOffset;
  final Curve curve;

  const SlideDownFade({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 650),
    this.delay = Duration.zero,
    this.verticalOffset = -0.35,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SlideDownFade> createState() => _SlideDownFadeState();
}

class _SlideDownFadeState extends State<SlideDownFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.verticalOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Smoothly slides in from the right with fade in (e.g. for rows, carousels, lists)
class SlideRightFade extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double horizontalOffset;
  final Curve curve;

  const SlideRightFade({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 650),
    this.delay = Duration.zero,
    this.horizontalOffset = 0.25,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SlideRightFade> createState() => _SlideRightFadeState();
}

class _SlideRightFadeState extends State<SlideRightFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.horizontalOffset, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Smoothly slides up from bottom with fade in (e.g. for bottom action cards and footers)
class SlideUpFade extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double verticalOffset;
  final Curve curve;

  const SlideUpFade({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 650),
    this.delay = Duration.zero,
    this.verticalOffset = 0.35,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SlideUpFade> createState() => _SlideUpFadeState();
}

class _SlideUpFadeState extends State<SlideUpFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.verticalOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Smooth scale + pop animation (e.g. for badges, chips, FABs)
class ScaleFadePop extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const ScaleFadePop({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 550),
    this.delay = Duration.zero,
  });

  @override
  State<ScaleFadePop> createState() => _ScaleFadePopState();
}

class _ScaleFadePopState extends State<ScaleFadePop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

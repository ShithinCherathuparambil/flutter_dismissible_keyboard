import 'package:flutter/material.dart';

/// A widget that wraps a [child] (typically a TextField) and shows a
/// [customKeyboard] when the provided [focusNode] gains focus.
class DismissibleKeyboard extends StatefulWidget {
  /// The widget that should trigger the keyboard.
  final Widget child;

  /// The custom keyboard to show.
  final Widget customKeyboard;

  /// The focus node that is attached to the target TextField.
  final FocusNode focusNode;

  /// Creates a [DismissibleKeyboard].
  const DismissibleKeyboard({
    super.key,
    required this.child,
    required this.customKeyboard,
    required this.focusNode,
  });

  @override
  State<DismissibleKeyboard> createState() => _DismissibleKeyboardState();
}

class _DismissibleKeyboardState extends State<DismissibleKeyboard>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );

    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(DismissibleKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: _slideAnimation,
              child: widget.customKeyboard,
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _hideOverlay() {
    _animationController.reverse().then((_) {
      _removeOverlay();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

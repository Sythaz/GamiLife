import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class DraggableScrollUpButton extends StatefulWidget {
  final ScrollController scrollController;
  final double maxX;
  final double maxY;
  final bool isVisible;

  const DraggableScrollUpButton({
    super.key,
    required this.scrollController,
    required this.maxX,
    required this.maxY,
    required this.isVisible,
  });

  @override
  State<DraggableScrollUpButton> createState() =>
      _DraggableScrollUpButtonState();
}

class _DraggableScrollUpButtonState extends State<DraggableScrollUpButton> {
  Offset _fabOffset = const Offset(0, 0);
  final double fabSize = 56;

  @override
  Widget build(BuildContext context) {
    print('FAB Position: $_fabOffset');
    return Positioned(
      right: _fabOffset.dx,
      bottom: _fabOffset.dy,
      child: Visibility(
        visible: widget.isVisible,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              final double newDx = (_fabOffset.dx - details.delta.dx)
                  .clamp(0.0, (widget.maxX - fabSize))
                  .toDouble();
              final double newDy = (_fabOffset.dy - details.delta.dy)
                  .clamp(0.0, (widget.maxY - fabSize))
                  .toDouble();
              _fabOffset = Offset(newDx, newDy);
            });
          },
          child: FloatingActionButton(
            onPressed: () {
              widget.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.arrow_upward, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

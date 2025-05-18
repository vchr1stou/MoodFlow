import 'package:flutter/material.dart';
import '../presentation/log_screen/log_screen.dart';
import '../core/services/storage_service.dart';

class UnlockSlider extends StatefulWidget {
  final VoidCallback? onUnlock;
  final String text;
  final Color backgroundColor;
  final Color sliderColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final String? currentMood;

  const UnlockSlider({
    Key? key,
    this.onUnlock,
    this.text = "Slide to confirm",
    this.backgroundColor = Colors.white24,
    this.sliderColor = Colors.blue,
    this.textColor = Colors.white,
    this.height = 50,
    this.borderRadius = 25,
    this.currentMood,
  }) : super(key: key);

  @override
  State<UnlockSlider> createState() => _UnlockSliderState();
}

class _UnlockSliderState extends State<UnlockSlider> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragPosition = 0;
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getMoodWithEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'heavy':
        return 'Heavy 😔';
      case 'low':
        return 'Low 😢';
      case 'neutral':
        return 'Neutral 😐';
      case 'light':
        return 'Light 😃';
      case 'bright':
        return 'Bright 😊';
      default:
        return 'Neutral 😐';
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isUnlocked) return;

    setState(() {
      _dragPosition += details.delta.dx;
      if (_dragPosition < 0) _dragPosition = 0;
      if (_dragPosition > 342 - widget.height) _dragPosition = 342 - widget.height;
    });

    if (_dragPosition >= (342 - widget.height) * 0.9) {
      _isUnlocked = true;
      _controller.forward();
      if (widget.onUnlock != null) {
        widget.onUnlock!();
      }
      
      String? moodToUse;
      
      if (widget.currentMood != null) {
        moodToUse = _getMoodWithEmoji(widget.currentMood!);
        StorageService.saveCurrentMood(moodToUse, 'aiscreen');
      } else {
        moodToUse = StorageService.getCurrentMood();
      }
      
      if (moodToUse == null) {
        moodToUse = 'Neutral 😐';
      }
      
      final String finalMood = moodToUse;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogScreen(
            source: 'aiscreen',
            emojiSource: 'aiscreen',
            feeling: finalMood,
          ),
        ),
      );
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isUnlocked) {
      setState(() {
        _dragPosition = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxDrag = 342 - widget.height;
    final textOpacity = 1.0 - (_dragPosition / maxDrag).clamp(0.0, 1.0);

    return Container(
      width: 342,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: textOpacity,
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: widget.height,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 
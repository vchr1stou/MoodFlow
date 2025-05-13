import 'package:flutter/material.dart';
import 'dart:math' as math;

class DonutSegment {
  final Color color;
  final double value;
  final String? label;

  const DonutSegment({
    required this.color,
    required this.value,
    this.label,
  });
}

class AnimatedDonutChart extends StatefulWidget {
  final List<DonutSegment> segments;
  final double size;
  final double strokeWidth;
  final Duration animationDuration;
  final String centerTitle;
  final String centerValue;
  final Color centerColor;
  final List<Color> donutGradient;

  const AnimatedDonutChart({
    Key? key,
    required this.segments,
    this.size = 220,
    this.strokeWidth = 48,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.centerTitle = '',
    this.centerValue = '',
    this.centerColor = const Color(0xFFB97C8B),
    this.donutGradient = const [Color(0xFFFDE68A), Color(0xFFF6C270)],
  }) : super(key: key);

  @override
  State<AnimatedDonutChart> createState() => _AnimatedDonutChartState();
}

class _AnimatedDonutChartState extends State<AnimatedDonutChart> with SingleTickerProviderStateMixin {
  int? _selectedSegmentIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _getSelectedSegmentInfo() {
    if (_selectedSegmentIndex == null) return '';
    final segment = widget.segments[_selectedSegmentIndex!];
    final total = widget.segments.fold<double>(0, (sum, s) => sum + s.value);
    final percentage = (segment.value / total * 100).round();
    return '${segment.label}\n$percentage%';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final center = Offset(box.size.width / 2, box.size.height / 2);
        final radius = math.min(box.size.width, box.size.height) / 2;
        
        // Calculate distance from center
        final distanceFromCenter = math.sqrt(
          math.pow(localPosition.dx - center.dx, 2) + 
          math.pow(localPosition.dy - center.dy, 2)
        );
        
        // Only process taps within the donut area
        final innerRadius = radius - widget.strokeWidth;
        final outerRadius = radius;
        if (distanceFromCenter < innerRadius || distanceFromCenter > outerRadius) {
          setState(() {
            _selectedSegmentIndex = null;
          });
          return;
        }
        
        // Calculate angle from center to tap point
        final angle = math.atan2(
          localPosition.dy - center.dy,
          localPosition.dx - center.dx,
        );
        
        // Convert angle to 0-2π range and adjust for the starting position
        // Start from top (-π/2) and go clockwise
        double normalizedAngle = angle - (-math.pi / 2);
        if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;
        
        // Calculate which segment was tapped
        final total = widget.segments.fold<double>(0, (sum, segment) => sum + segment.value);
        if (total == 0) return; // Don't process taps if there's no data
        
        double currentAngle = 0.0; // Start from top (already normalized)
        final spacingAngle = 0.01; // 1% spacing between segments (must match painter)
        final totalSpacing = spacingAngle * widget.segments.length;
        final availableAngle = 2 * math.pi - totalSpacing;
        
        // Find the segment that contains the tap angle
        for (int i = 0; i < widget.segments.length; i++) {
          final segment = widget.segments[i];
          final sweepAngle = (segment.value / total) * availableAngle;
          
          // Check if the tap angle falls within this segment's range
          if (normalizedAngle >= currentAngle && 
              normalizedAngle < currentAngle + sweepAngle) {
            setState(() {
              _selectedSegmentIndex = i;
            });
            return;
          }
          currentAngle += sweepAngle + spacingAngle;
        }
        // If not found, clear selection
        setState(() {
          _selectedSegmentIndex = null;
        });
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Donut shadow
            Positioned(
              top: 8,
              left: 8,
              child: CustomPaint(
                size: Size(widget.size - 16, widget.size - 16),
                painter: _DonutShadowPainter(
                  strokeWidth: widget.strokeWidth,
                ),
              ),
            ),
            // Donut chart
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _DonutPainter(
                segments: widget.segments,
                strokeWidth: widget.strokeWidth,
                selectedIndex: _selectedSegmentIndex,
              ),
            ),
            // Center text for no data
            if (widget.segments.fold<double>(0, (sum, segment) => sum + segment.value) == 0)
              Positioned.fill(
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, -80), // Move up by 80 pixels
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            // Center speech bubble for data
            if (widget.segments.fold<double>(0, (sum, segment) => sum + segment.value) > 0)
              _SpeechBubble(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedSegmentIndex != null 
                          ? widget.segments[_selectedSegmentIndex!].label ?? ''
                          : widget.centerTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _selectedSegmentIndex != null
                          ? '${(widget.segments[_selectedSegmentIndex!].value).round()}%'
                          : widget.centerValue,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double strokeWidth;
  final int? selectedIndex;

  _DonutPainter({
    required this.segments,
    required this.strokeWidth,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    final total = segments.fold<double>(0, (sum, segment) => sum + segment.value);
    
    // If there's no data (total is 0), draw a gray circle
    if (total == 0) {
      final paint = Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      
      canvas.drawCircle(center, radius, paint);
      return;
    }
    
    // If there's only one segment with 100%, draw a complete circle
    if (segments.length == 1 && segments[0].value == 100) {
      final paint = Paint()
        ..color = segments[0].color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      
      canvas.drawCircle(center, radius, paint);
      return;
    }
    
    final spacingAngle = 0.01; // 1% spacing between segments for crispness
    final totalSpacing = spacingAngle * segments.length;
    final availableAngle = 2 * math.pi - totalSpacing;
    
    double startAngle = -math.pi / 2; // Start from top
    
    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final sweepAngle = (segment.value / total) * availableAngle;
      final isSelected = (i == selectedIndex);
      
      // Draw shadow for selected segment
      if (isSelected) {
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 13
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
          shadowPaint,
        );
      }
      
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      
      startAngle += sweepAngle + spacingAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

class _DonutShadowPainter extends CustomPainter {
  final double strokeWidth;
  _DonutShadowPainter({required this.strokeWidth});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * math.pi,
      false,
      paint,
    );
  }
  @override
  bool shouldRepaint(_DonutShadowPainter oldDelegate) => false;
}

class _SpeechBubble extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;
  const _SpeechBubble({required this.width, required this.height, required this.color, required this.child});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeechBubblePainter(color: color),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(child: child),
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final Color color;
  _SpeechBubblePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    // Remove the background painting, only keep the text
  }
  @override
  bool shouldRepaint(_SpeechBubblePainter oldDelegate) => false;
} 
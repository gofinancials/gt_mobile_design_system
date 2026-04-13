import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gt_mobile_ui/common/assets/gt_fonts.dart';

/// A centralized class to hold all colors used in the design
class CoverColors {
  static const Color background = Color(0xFF094043);
  static const Color primaryGreen = Color(0xFF2BE175);
  static const Color warningYellow = Color(0xFFFFCA28);
  static const Color white = Colors.white;
}

/// The main entry screen that delegates everything to CustomPaint
class DesignSystemCover extends StatelessWidget {
  const DesignSystemCover({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: min(16, size.width * 1)),
            color: CoverColors.background,
            child: CustomPaint(
              size: Size.fromHeight(max(300, size.height * 0.5)),
              painter: DesignSystemPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

/// The CustomPainter that draws the entire UI
class DesignSystemPainter extends CustomPainter {
  // Common Paddings
  final double paddingX = 48.0;
  final double paddingY = 40.0;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Top Header ("go" and "01")
    _drawTopHeader(canvas, size);

    // Now we calculate Y positions from the bottom up to respect the design's Spacer() behavior

    // Bottom Row: Tags / Chips
    final double chipHeight = 48.0;
    final double tagsTopY = size.height - paddingY - chipHeight;
    _drawTagsRow(canvas, Offset(paddingX, tagsTopY));

    // Main Title: "FOUNDATION"
    final foundationTp = _layoutText(
      'FOUNDATION',
      const TextStyle(
        color: CoverColors.primaryGreen,
        fontSize: 110,
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: -1.0,
      ),
    );
    final double foundationY = tagsTopY - 32.0 - foundationTp.height;

    // Handle fitting/scaling if text is wider than screen (mimicking FittedBox)
    final double availableWidth = size.width - (paddingX * 2);
    if (foundationTp.width > availableWidth) {
      canvas.save();
      canvas.translate(paddingX, foundationY);
      final scale = availableWidth / foundationTp.width;
      canvas.scale(scale, scale);
      foundationTp.paint(canvas, Offset.zero);
      canvas.restore();
    } else {
      foundationTp.paint(canvas, Offset(paddingX, foundationY));
    }

    // Divider Line
    final double dividerY = foundationY - 24.0;
    canvas.drawLine(
      Offset(paddingX, dividerY),
      Offset(size.width - paddingX, dividerY),
      Paint()
        ..color = CoverColors.primaryGreen
        ..strokeWidth = 1.5,
    );

    // Info Row ("DESIGN SYSTEM" and Team Members) bottom-aligned to the divider
    final double infoBottomY = dividerY - 16.0;
    _drawInfoRow(canvas, size, infoBottomY);
  }

  void _drawTopHeader(Canvas canvas, Size size) {
    final goTp = _layoutText(
      'go',
      const TextStyle(
        color: CoverColors.primaryGreen,
        fontSize: 64,
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: -2.0,
      ),
    );

    final numberTp = _layoutText(
      '01',
      const TextStyle(
        color: CoverColors.primaryGreen,
        fontSize: 64,
        fontWeight: FontWeight.w900,
        height: 1.0,
      ),
    );

    goTp.paint(canvas, Offset(paddingX, paddingY));
    numberTp.paint(
      canvas,
      Offset(size.width - paddingX - numberTp.width, paddingY),
    );
  }

  void _drawTagsRow(Canvas canvas, Offset startOffset) {
    double currentX = startOffset.dx;
    final double currentY = startOffset.dy;

    // Draw "In progress"
    currentX +=
        _drawStatusChip(canvas, 'In progress', Offset(currentX, currentY)) +
        16.0;
    // Draw "Brand Assets"
    currentX +=
        _drawFeatureChip(canvas, 'Brand Assets', Offset(currentX, currentY)) +
        16.0;
    // Draw "Guides"
    _drawFeatureChip(canvas, 'Guides', Offset(currentX, currentY));
  }

  void _drawInfoRow(Canvas canvas, Size size, double bottomY) {
    // Draw "DESIGN SYSTEM" on the left
    final designSystemTp = _layoutText(
      'DESIGN SYSTEM',
      const TextStyle(
        color: CoverColors.primaryGreen,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
    designSystemTp.paint(
      canvas,
      Offset(paddingX, bottomY - designSystemTp.height),
    );
  }

  /// Draws the yellow status chip. Returns the width consumed.
  double _drawStatusChip(Canvas canvas, String text, Offset position) {
    final textTp = _layoutText(
      text,
      const TextStyle(
        color: CoverColors.background,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );

    final double hPadding = 20.0;
    final double vPadding = 12.0;
    final double width = textTp.width + (hPadding * 2);
    final double height = textTp.height + (vPadding * 2);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(position.dx, position.dy, width, height),
      const Radius.circular(8),
    );

    canvas.drawRRect(rrect, Paint()..color = CoverColors.warningYellow);
    textTp.paint(
      canvas,
      Offset(position.dx + hPadding, position.dy + vPadding),
    );

    return width;
  }

  /// Draws the white feature chip with an icon. Returns the width consumed.
  double _drawFeatureChip(Canvas canvas, String text, Offset position) {
    final iconTp = _layoutIcon(
      Icons.check_circle,
      20,
      CoverColors.primaryGreen,
    );
    final textTp = _layoutText(
      text,
      const TextStyle(
        color: CoverColors.background,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );

    final double hPadding = 16.0;
    final double vPadding = 12.0;
    final double spacing = 8.0;

    final double contentWidth = iconTp.width + spacing + textTp.width;
    final double width = contentWidth + (hPadding * 2);
    // Determine overall height from tallest element (usually text)
    final double maxContentHeight = iconTp.height > textTp.height
        ? iconTp.height
        : textTp.height;
    final double height = maxContentHeight + (vPadding * 2);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(position.dx, position.dy, width, height),
      const Radius.circular(8),
    );

    canvas.drawRRect(rrect, Paint()..color = CoverColors.white);

    // Center icon and text vertically within the chip
    final double contentY = position.dy + (height - maxContentHeight) / 2;
    iconTp.paint(
      canvas,
      Offset(
        position.dx + hPadding,
        contentY + (maxContentHeight - iconTp.height) / 2,
      ),
    );
    textTp.paint(
      canvas,
      Offset(
        position.dx + hPadding + iconTp.width + spacing,
        contentY + (maxContentHeight - textTp.height) / 2,
      ),
    );

    return width;
  }

  /// Helper function to create and layout a TextPainter for text
  TextPainter _layoutText(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: style.copyWith(
          fontFamily: GtFonts().display,
          package: 'gt_mobile_ui',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp;
  }

  /// Helper function to create and layout a TextPainter for a Material Icon
  TextPainter _layoutIcon(IconData icon, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Static UI, doesn't need repainting unless updated state is passed
  }
}

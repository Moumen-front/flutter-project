
// Helper function to build help instructions bottom sheet
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'icons/neurovive_icons.dart';

Widget buildHelpInstructionsSheetForVoiceRecord(BuildContext context) {
  return DraggableScrollableSheet(
    initialChildSize: 0.75,
    minChildSize: 0.5,
    maxChildSize: 0.9,
    builder: (context, scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with X and title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Neurovive.close,
                      color: Color(0xFFB22222),
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '     Voice Test Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB22222),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildSectionTitle('1. Prepare Your Environment'),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    'Find a Quiet Space:',
                    'Choose a room with no background noise or distractions.',
                  ),
                  _buildBulletPoint(
                    'Position Your Phone:',
                    'Hold the device approximately 20 cm (8 inches) from your mouth.',
                  ),
                  const SizedBox(height: 16),
                  _buildDashedDivider(),
                  const SizedBox(height: 16),

                  _buildSectionTitle('2. Perform the Test'),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    'Step 1:',
                    'Sustained "AAA" Take a deep breath and make a steady "AAA" sound (as in "apple") for 3 seconds.',
                  ),
                  _buildBulletPoint(
                    'Step 2:',
                    'Sustained "OOO" The app will transition automatically. Make a steady "OOO" sound (as in "boot") for another 3 seconds.',
                  ),
                  const SizedBox(height: 16),
                  _buildDashedDivider(),
                  const SizedBox(height: 16),

                  _buildSectionTitle('3. Important Tips for Accuracy'),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    'Be Natural:',
                    'Use your normal speaking volume and pitch. Do not try to "fix" your voice; the AI needs to hear your natural tone to provide an objective truth.',
                  ),
                  _buildBulletPoint(
                    'Don\'t Worry About Tremors:',
                    'If your voice shakes or breaks, do not restart. These subtle changes are exactly what the AI uses to quantify your symptoms accurately.',
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}

Widget _buildBulletPoint(String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' $description'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDashedDivider() {
  return CustomPaint(
    size: const Size(double.infinity, 1),
    painter: _DashedLinePainter(),
  );
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
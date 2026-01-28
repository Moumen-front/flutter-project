import 'package:first_project/screens/land_screen.dart';
import 'package:first_project/screens/send_voice_screen.dart';
import 'package:first_project/themes/MainThemes.dart';
import 'package:first_project/widgets/analysis_loading.dart';
import 'package:first_project/widgets/uploading_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import './screens/handwriting_screen.dart';
import './screens/record_screen2.dart';

//router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/voice',
    redirect: (context, state) {
      return null;
    },

    routes: [
      ShellRoute(
        builder: (context, state, child) {
          String routeName = state.topRoute?.path ?? '';

          ThemeData theme = switch (routeName) {
            '/voice' => Mainthemes.greenBackgroundTheme,
            _ => Mainthemes.whiteBackgroundTheme,
          };

          return Theme(
            data: theme,
            child: Builder(
              builder: (context) {
                final String pageName = state.topRoute?.name ?? "Error, no name for this route";
                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,

                  appBar: AppBar(
                    elevation: 0,
                    leading: !(state.uri.path == '/' || state.uri.path == '/sendvoice' || state.uri.path == '/voice')
                        ? IconButton(
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/');
                              }
                            },
                            icon: Icon(Icons.arrow_back_ios_new),
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                        : const SizedBox.shrink(),

                    title: Text(
                      pageName == '#'?"":pageName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      !(state.uri.path == '/' || state.uri.path == '/sendvoice')
                          ?
                      IconButton(
                        icon: Icon(
                          Icons.help_outline,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 30,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => _buildHelpInstructionsSheet(context),
                          );
                        },
                      ):const SizedBox.shrink(),
                    ],
                  ),

                  body: child,
                );
              },
            ),
          );
        },

        routes: [
          GoRoute(
            path: '/',
            name: 'NeuroVive',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const LandScreen(),
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: Tween<double>(
                        begin: 1,
                        end: 0,
                      ).animate(secondaryAnimation),
                      child: child,
                    );
                  },
            ),
          ),
          GoRoute(
            path: '/voice',
            name: 'Voice Record',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const RecordScreen2(),
                transitionDuration: const Duration(milliseconds: 300),
                // Hero duration
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              );
            },
          ),
          GoRoute(
            path: '/handwriting',
            name: 'Hand Writing',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const HandwritingScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                // Hero duration
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              );
            },
          ),
          GoRoute(
            path: '/sendvoice',
            name: '#',
            builder: (context, state) {
              final path = state.extra as String; // pass wav path via extra
              return SendVoiceScreen(wavPath: path);
            },
          ),
        ],
      ),


    ],
    errorBuilder: (context, state) => const Placeholder(),
  );
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

// Helper function to build help instructions bottom sheet
Widget _buildHelpInstructionsSheet(BuildContext context) {
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
                      Icons.close,
                      color: Color(0xFFB22222),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Voice Test Instructions',
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
                    'Hold the device approximately 8 inches (20 cm) from your mouth.',
                  ),
                  const SizedBox(height: 16),
                  _buildDashedDivider(),
                  const SizedBox(height: 16),

                  _buildSectionTitle('2. Perform the Test'),
                  const SizedBox(height: 8),
                  _buildBulletPoint(
                    'Step 1:',
                    'Sustained "AAA" Take a deep breath and make a steady "AAA" sound (as in "apple") for 5 seconds.',
                  ),
                  _buildBulletPoint(
                    'Step 2:',
                    'Sustained "OOO" The app will transition automatically. Make a steady "OOO" sound (as in "boot") for another 5 seconds.',
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


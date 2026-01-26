import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/animated_text_button.dart';

class LandScreen extends ConsumerWidget {
  const LandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: const EdgeInsets.all(12.0),
            child:  Placeholder()
          ),
      
      
      
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                  AnimatedTextButton(
                    onPressed: () {
                      context.push('/voice');
                    },
                    text: "Voice",
                  ),
                 AnimatedTextButton(
                    onPressed: () {
                      context.push('/handwriting');
                    },
                    text: "hand writing",
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
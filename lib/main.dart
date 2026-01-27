import 'package:first_project/screens/land_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import './screens/handwriting_screen.dart';
import './screens/record_screen2.dart';

//router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      return null;
    },


    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255,34, 75, 68),

            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255,34, 75, 68),
              elevation: 0,
              leading: state.uri.path != '/'
                  ? IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                      color: Colors.white,
                    )
                  : const SizedBox.shrink(),

              title: Text(
                state.topRoute?.name ?? "Error, no name for this route",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            body: child,
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

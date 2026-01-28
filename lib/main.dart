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
                        onPressed: () {},
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

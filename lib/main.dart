import 'package:first_project/icons/neurovive_icons.dart';
import 'package:first_project/notifiers/voice_upload_notifier.dart';
import 'package:first_project/screens/land_screen.dart';
import 'package:first_project/screens/result_screen.dart';
import 'package:first_project/screens/send_voice_screen.dart';
import 'package:first_project/themes/MainThemes.dart';
import 'package:first_project/widgets/analysis_loading.dart';
import 'package:first_project/widgets/uploading_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import './utils.dart';
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
                final String pageName = state.topRoute?.name ??
                    "Error, no name for this route";
                final String currentPath = state.uri.path;
                return Scaffold(
                  backgroundColor: Theme
                      .of(context)
                      .scaffoldBackgroundColor,

                  appBar: AppBar(
                    elevation: 0,
                    leading: !(currentPath == '/' ||
                        currentPath == '/sendvoice' || currentPath == '/voice')

                    ///todo: remove /voice from here when you add the landing screen
                        ? IconButton(
                      onPressed: () {
                       handleBack(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary,
                    )
                        : const SizedBox.shrink(),

                    title: Text(
                      pageName == '#' ? "" : pageName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onPrimary,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      (currentPath == '/voice')

                      /// later u will add the pages that has instructions for them here
                          ?
                      IconButton(
                        icon: Icon(
                          Neurovive.info,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onPrimary,
                          size: 30,
                        ),
                        onPressed: () {
                          switch (currentPath) {
                          ///later we will add the instructions for the other pages here, but the function itself will be in utils.dart
                            case '/voice':
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    buildHelpInstructionsSheetForVoiceRecord(
                                        context),
                              );
                              break;
                          }
                        },
                      ) : const SizedBox.shrink(),
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
            pageBuilder: (context, state) =>
                CustomTransitionPage(
                  key: state.pageKey,
                  child: const LandScreen(),
                  transitionDuration: const Duration(milliseconds: 10),
                  reverseTransitionDuration: const Duration(milliseconds: 10),
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
                transitionDuration: const Duration(milliseconds: 10),
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
                transitionDuration: const Duration(milliseconds: 10),
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
          GoRoute(
              path: '/results',
              name: 'Analysis Result',
              builder: (context, state) {
                final results = state.extra as VoiceResponse;
                return  ResultScreen(result: results);

              })
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



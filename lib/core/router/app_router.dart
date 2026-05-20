import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/discover/presentation/discover_screen.dart';
import '../../features/create/presentation/create_screen.dart';
import '../../features/create/presentation/video_editor_screen.dart';
import '../../features/inbox/presentation/inbox_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../widgets/app_bottom_nav.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      if (isAuthenticated && isLoggingIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginScreen()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _ShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: FeedScreen()),
          ),
          GoRoute(
            path: '/discover',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DiscoverScreen()),
          ),
          GoRoute(
            path: '/inbox',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: InboxScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
          GoRoute(
            path: '/profile/:userId',
            pageBuilder: (context, state) => NoTransitionPage(
              child: ProfileScreen(userId: state.pathParameters['userId']!),
            ),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/create',
        pageBuilder: (context, state) => CustomTransitionPage(
          fullscreenDialog: true,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            );
          },
          child: const CreateScreen(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/editor',
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            );
          },
          child: VideoEditorScreen(videoPath: state.extra as String),
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/edit_profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0), // Slide from right
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            );
          },
          child: const EditProfileScreen(),
        ),
      ),
    ],
  );
});

class _ShellScaffold extends StatefulWidget {
  final Widget child;

  const _ShellScaffold({required this.child});

  @override
  State<_ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<_ShellScaffold> {
  int _currentIndex = 0;

  static const _routes = ['/', '/discover', '/create', '/inbox', '/profile'];

  void _onTabTap(int index) {
    if (index == 2) {
      // Create button — push as modal
      context.push('/create');
      return;
    }
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    // Sync index with current location
    final location = GoRouterState.of(context).uri.path;
    int resolvedIndex = _currentIndex;
    if (location == '/') {
      resolvedIndex = 0;
    } else if (location == '/discover') {
      resolvedIndex = 1;
    } else if (location == '/inbox') {
      resolvedIndex = 3;
    } else if (location.startsWith('/profile')) {
      resolvedIndex = 4;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: resolvedIndex,
        onTap: _onTabTap,
      ),
    );
  }
}

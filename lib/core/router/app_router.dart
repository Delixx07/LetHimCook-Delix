import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/catalog/catalog_screen.dart';
import '../../features/detail/detail_screen.dart';
import '../../features/cooking_mode/cooking_mode_screen.dart';
import '../../features/main/main_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/pantry/pantry_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorExploreKey = GlobalKey<NavigatorState>(debugLabel: 'explore');
final _shellNavigatorPantryKey = GlobalKey<NavigatorState>(debugLabel: 'pantry');
final _shellNavigatorFavoriteKey = GlobalKey<NavigatorState>(debugLabel: 'favorite');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorExploreKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const CatalogScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorPantryKey,
          routes: [
            GoRoute(
              path: '/pantry',
              builder: (context, state) => const PantryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorFavoriteKey,
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/recipe/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DetailScreen(recipeId: id);
      },
    ),
    GoRoute(
      path: '/cooking/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CookingModeScreen(recipeId: id);
      },
    ),
  ],
);

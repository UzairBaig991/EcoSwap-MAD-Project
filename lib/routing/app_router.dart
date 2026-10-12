import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/carbon_dashboard_screen.dart';
import '../features/listing/screens/create_listing_screen.dart';
import '../features/listing/screens/edit_listing_screen.dart';
import '../features/listing/screens/listing_detail_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/home/screens/main_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class PlaceHolderScreen extends StatelessWidget {
  final String title;
  const PlaceHolderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text('Screen: $title')),
      );
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isAuthenticated = authState.value != null;
      final location = state.matchedLocation;

      // While loading initial auth state, remain on splash
      if (isLoading) {
        return location == '/splash' ? null : '/splash';
      }

      // 1. If onboarding not completed -> redirect to /onboarding
      if (!onboardingCompleted) {
        return location == '/onboarding' ? null : '/onboarding';
      }

      // 2. Unauthenticated user trying to access protected routes
      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          location == '/onboarding' ||
          location == '/splash';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // 3. Authenticated user trying to access auth/onboarding routes
      if (isAuthenticated && (isAuthRoute || location == '/splash')) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const PlaceHolderScreen(title: 'Favorites'),
      ),
      GoRoute(
        path: '/create-listing',
        builder: (context, state) => const CreateListingScreen(),
      ),
      GoRoute(
        path: '/listing/edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return EditListingScreen(listingId: id);
        },
      ),
      GoRoute(
        path: '/challenges',
        builder: (context, state) => const PlaceHolderScreen(title: 'Challenges'),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/carbon-impact',
        builder: (context, state) => const CarbonDashboardScreen(),
      ),
      GoRoute(
        path: '/listing/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ListingDetailScreen(listingId: id);
        },
      ),
      GoRoute(
        path: '/chats',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final title = state.uri.queryParameters['title'];
          final ownerId = state.uri.queryParameters['ownerId'];
          final ownerName = state.uri.queryParameters['ownerName'];

          return ChatScreen(
            chatId: id,
            initialListingTitle: title,
            initialOwnerId: ownerId,
            initialOwnerName: ownerName,
          );
        },
      ),
    ],
  );
});

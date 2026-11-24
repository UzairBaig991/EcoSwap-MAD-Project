import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/onboarding/providers/onboarding_provider.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/carbon_dashboard_screen.dart';
import '../features/profile/screens/carbon_offset_pledge_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/listing/screens/create_listing_screen.dart';
import '../features/listing/screens/edit_listing_screen.dart';
import '../features/listing/screens/listing_detail_screen.dart';
import '../features/favorites/screens/favorites_screen.dart';
import '../features/challenges/screens/challenges_screen.dart';
import '../features/chat/screens/chat_list_screen.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/home/screens/main_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/events/screens/community_events_screen.dart';
import '../features/swap_planner/screens/smart_exchange_planner_screen.dart';
import '../features/profile/screens/personal_swap_insights_screen.dart';
import '../features/profile/screens/referral_rewards_screen.dart';
import '../features/profile/screens/charity_hubs_screen.dart';
import '../features/profile/screens/green_living_tips_screen.dart';
import '../features/profile/screens/neighborhood_groups_screen.dart';
import '../features/profile/screens/help_center_screen.dart';
import '../features/profile/screens/recycling_locator_screen.dart';
import '../features/profile/screens/carbon_certificate_screen.dart';
import '../features/profile/screens/green_guarantee_screen.dart';
import '../features/profile/screens/zero_emission_shipping_screen.dart';
import '../features/profile/screens/eco_packaging_calculator_screen.dart';
import '../features/profile/screens/eco_carbon_credit_screen.dart';
import '../features/profile/screens/carbon_neutral_pass_screen.dart';
import '../features/favorites/screens/eco_wishlist_screen.dart';
import '../features/challenges/screens/hall_of_fame_screen.dart';
import '../features/profile/screens/reforestation_pledge_screen.dart';
import '../features/swap_planner/screens/eco_handoff_checklist_screen.dart';
import '../features/listing/screens/eco_item_inspector_screen.dart';
import '../features/listing/screens/smart_value_estimator_screen.dart';
import '../features/listing/screens/smart_description_summarizer_screen.dart';
import '../features/challenges/screens/carbon_leaderboard_screen.dart';
import '../features/profile/screens/dispute_mediation_screen.dart';
import '../features/profile/screens/eco_badges_gallery_screen.dart';
import '../features/profile/screens/impact_passport_pdf_screen.dart';
import '../features/profile/screens/green_warranty_screen.dart';
import '../features/profile/screens/packaging_pledge_ledger_screen.dart';
import '../features/profile/screens/solar_micro_grid_screen.dart';
import '../features/profile/screens/carbon_badge_cert_screen.dart';
import '../features/profile/screens/public_impact_ledger_screen.dart';
import '../features/profile/screens/green_energy_credits_screen.dart';
import '../features/profile/screens/carbon_analytics_graph_screen.dart';
import '../features/profile/screens/carbon_heatmap_screen.dart';
import '../features/profile/screens/eco_trophy_cabinet_screen.dart';
import '../features/profile/screens/circular_orbit_galaxy_screen.dart';
import '../features/profile/screens/solar_impact_badge_screen.dart';
import '../features/profile/screens/volunteer_rewards_pass_screen.dart';
import '../features/home/screens/voice_search_guidance_screen.dart';
import '../features/listing/screens/ai_lighting_meter_screen.dart';
import '../features/listing/screens/ai_condition_verifier_screen.dart';
import '../features/listing/screens/ai_image_quality_inspector_screen.dart';
import '../features/chat/screens/chat_safety_filter_screen.dart';
import '../features/settings/screens/device_sessions_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        final onboardingCompleted = ref.read(onboardingCompletedProvider);
        final isAuthenticated = ref.read(authStateProvider).value != null;

        if (!onboardingCompleted) {
          context.go('/onboarding');
        } else if (isAuthenticated) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_horizontal_circle_rounded,
                  size: 72,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.appName,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authControllerState = ref.watch(authControllerProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.value != null || authControllerState.user != null;
      final location = state.matchedLocation;

      if (location == '/splash') {
        return null;
      }

      if (!onboardingCompleted) {
        return location == '/onboarding' ? null : '/onboarding';
      }

      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          location == '/onboarding' ||
          location == '/splash';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

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

      // Main App Stateful Shell Route
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Explore / Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 1: Saved Favorites
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),

          // Branch 2: Post Item
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/create-listing',
                builder: (context, state) => const CreateListingScreen(),
              ),
            ],
          ),

          // Branch 3: Chat Inbox
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chats',
                builder: (context, state) => const ChatListScreen(),
              ),
            ],
          ),

          // Branch 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Other Routes
      GoRoute(
        path: '/listing/edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return EditListingScreen(listingId: id);
        },
      ),
      GoRoute(
        path: '/challenges',
        builder: (context, state) => const ChallengesScreen(),
      ),
      GoRoute(
        path: '/community-events',
        builder: (context, state) => const CommunityEventsScreen(),
      ),
      GoRoute(
        path: '/smart-planner',
        builder: (context, state) => const SmartExchangePlannerScreen(),
      ),
      GoRoute(
        path: '/swap-insights',
        builder: (context, state) => const PersonalSwapInsightsScreen(),
      ),
      GoRoute(
        path: '/referral-rewards',
        builder: (context, state) => const ReferralRewardsScreen(),
      ),
      GoRoute(
        path: '/charity-hubs',
        builder: (context, state) => const CharityHubsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
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
        path: '/carbon-offset',
        builder: (context, state) => const CarbonOffsetPledgeScreen(),
      ),
      GoRoute(
        path: '/green-tips',
        builder: (context, state) => const GreenLivingTipsScreen(),
      ),
      GoRoute(
        path: '/neighborhood-groups',
        builder: (context, state) => const NeighborhoodGroupsScreen(),
      ),
      GoRoute(
        path: '/help-center',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/recycling-locator',
        builder: (context, state) => const RecyclingLocatorScreen(),
      ),
      GoRoute(
        path: '/eco-inspector',
        builder: (context, state) => const EcoItemInspectorScreen(),
      ),
      GoRoute(
        path: '/carbon-certificate',
        builder: (context, state) => const CarbonCertificateScreen(),
      ),
      GoRoute(
        path: '/green-guarantee',
        builder: (context, state) => const GreenGuaranteeScreen(),
      ),
      GoRoute(
        path: '/zero-emission-shipping',
        builder: (context, state) => const ZeroEmissionShippingScreen(),
      ),
      GoRoute(
        path: '/value-estimator',
        builder: (context, state) => const SmartValueEstimatorScreen(),
      ),
      GoRoute(
        path: '/eco-packaging',
        builder: (context, state) => const EcoPackagingCalculatorScreen(),
      ),
      GoRoute(
        path: '/eco-wishlist',
        builder: (context, state) => const EcoWishlistScreen(),
      ),
      GoRoute(
        path: '/carbon-credits',
        builder: (context, state) => const EcoCarbonCreditScreen(),
      ),
      GoRoute(
        path: '/hall-of-fame',
        builder: (context, state) => const HallOfFameScreen(),
      ),
      GoRoute(
        path: '/carbon-pass',
        builder: (context, state) => const CarbonNeutralPassScreen(),
      ),
      GoRoute(
        path: '/carbon-leaderboard',
        builder: (context, state) => const CarbonLeaderboardScreen(),
      ),
      GoRoute(
        path: '/ai-summarizer',
        builder: (context, state) => const SmartDescriptionSummarizerScreen(),
      ),
      GoRoute(
        path: '/dispute-mediation',
        builder: (context, state) => const DisputeMediationScreen(),
      ),
      GoRoute(
        path: '/eco-badges',
        builder: (context, state) => const EcoBadgesGalleryScreen(),
      ),
      GoRoute(
        path: '/handoff-checklist',
        builder: (context, state) => const EcoHandoffChecklistScreen(),
      ),
      GoRoute(
        path: '/reforestation-parks',
        builder: (context, state) => const ReforestationPledgeScreen(),
      ),
      GoRoute(
        path: '/impact-passport',
        builder: (context, state) => const ImpactPassportPdfScreen(),
      ),
      GoRoute(
        path: '/chat-safety',
        builder: (context, state) => const ChatSafetyFilterScreen(),
      ),
      GoRoute(
        path: '/green-warranty',
        builder: (context, state) => const GreenWarrantyScreen(),
      ),
      GoRoute(
        path: '/packaging-ledger',
        builder: (context, state) => const PackagingPledgeLedgerScreen(),
      ),
      GoRoute(
        path: '/solar-grid',
        builder: (context, state) => const SolarMicroGridScreen(),
      ),
      GoRoute(
        path: '/badge-cert',
        builder: (context, state) => const CarbonBadgeCertScreen(),
      ),
      GoRoute(
        path: '/public-ledger',
        builder: (context, state) => const PublicImpactLedgerScreen(),
      ),
      GoRoute(
        path: '/ai-condition-verifier',
        builder: (context, state) => const AiConditionVerifierScreen(),
      ),
      GoRoute(
        path: '/device-sessions',
        builder: (context, state) => const DeviceSessionsScreen(),
      ),
      GoRoute(
        path: '/green-energy-credits',
        builder: (context, state) => const GreenEnergyCreditsScreen(),
      ),
      GoRoute(
        path: '/ai-photo-quality',
        builder: (context, state) => const AiImageQualityInspectorScreen(),
      ),
      GoRoute(
        path: '/impact-analytics',
        builder: (context, state) => const CarbonAnalyticsGraphScreen(),
      ),
      GoRoute(
        path: '/volunteer-pass',
        builder: (context, state) => const VolunteerRewardsPassScreen(),
      ),
      GoRoute(
        path: '/carbon-heatmap',
        builder: (context, state) => const CarbonHeatmapScreen(),
      ),
      GoRoute(
        path: '/trophy-cabinet',
        builder: (context, state) => const EcoTrophyCabinetScreen(),
      ),
      GoRoute(
        path: '/orbit-galaxy',
        builder: (context, state) => const CircularOrbitGalaxyScreen(),
      ),
      GoRoute(
        path: '/ai-lighting-meter',
        builder: (context, state) => const AiLightingMeterScreen(),
      ),
      GoRoute(
        path: '/voice-search',
        builder: (context, state) => const VoiceSearchGuidanceScreen(),
      ),
      GoRoute(
        path: '/solar-badge',
        builder: (context, state) => const SolarImpactBadgeScreen(),
      ),
      GoRoute(
        path: '/listing/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ListingDetailScreen(listingId: id);
        },
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

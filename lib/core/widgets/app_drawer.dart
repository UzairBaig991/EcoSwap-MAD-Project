import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../utils/app_image_helper.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../main.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Drawer(
      child: Column(
        children: [
          // Drawer Header with User Avatar & Eco Score
          userAsync.when(
            data: (user) {
              final imageProvider = AppImageHelper.getImageProvider(user?.photoUrl);

              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: AppColors.ecoGradient,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          (user?.displayName.isNotEmpty == true)
                              ? user!.displayName[0].toUpperCase()
                              : 'E',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                accountName: Text(
                  user?.displayName ?? 'Eco Swapper',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                accountEmail: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '🌿 ${user?.ecoScore ?? 0} Eco Points',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => Container(
              height: 180,
              color: AppColors.primary,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
            error: (_, __) => Container(
              height: 180,
              color: AppColors.primary,
              child: const Center(child: Text('EcoSwap', style: TextStyle(color: Colors.white, fontSize: 20))),
            ),
          ),

          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.explore_rounded, color: AppColors.primary),
                  title: const Text('Explore Marketplace'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
                  title: const Text('Messages & Swap Chats'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/chats');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle_rounded, color: AppColors.primary),
                  title: const Text('Post New Item'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/create-listing');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: AppColors.error),
                  title: const Text('Saved Favorites'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/favorites');
                  },
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(Icons.co2_rounded, color: AppColors.secondary),
                  title: const Text('Carbon Footprint Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-impact');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events_rounded, color: AppColors.tertiary),
                  title: const Text('Eco Challenges & Leaderboard'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/challenges');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event_rounded, color: AppColors.info),
                  title: const Text('Community Swap Events 🎪'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/community-events');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month_rounded, color: AppColors.secondary),
                  title: const Text('Smart Exchange Planner 🗓️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/smart-planner');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart_rounded, color: AppColors.tertiary),
                  title: const Text('Personal Swap Insights 📊'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/swap-insights');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.card_giftcard_rounded, color: AppColors.tertiary),
                  title: const Text('Green Ambassador Rewards 🎁'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/referral-rewards');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.volunteer_activism_rounded, color: AppColors.secondary),
                  title: const Text('Charity & Donation Hubs 🤝'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/charity-hubs');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.forest_rounded, color: AppColors.primary),
                  title: const Text('Carbon Offset & Tree Pledge 🌳'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-offset');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.tertiary),
                  title: const Text('Green Living Tips & Feed 🌿'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/green-tips');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.group_work_rounded, color: AppColors.secondary),
                  title: const Text('Neighborhood Eco-Pods 🏘️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/neighborhood-groups');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded, color: AppColors.info),
                  title: const Text('Help Center & FAQs ❓'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/help-center');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.recycling_rounded, color: AppColors.primary),
                  title: const Text('Recycling & E-Waste Locator ♻️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/recycling-locator');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.view_in_ar_rounded, color: AppColors.secondary),
                  title: const Text('Eco AR Item Inspector 📐'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/eco-inspector');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.tertiary),
                  title: const Text('Official Carbon Certificate 📜'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-certificate');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shield_rounded, color: AppColors.primary),
                  title: const Text('EcoSwap Green Guarantee 🛡️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/green-guarantee');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pedal_bike_rounded, color: AppColors.secondary),
                  title: const Text('Zero-Emission Eco Courier 🚲'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/zero-emission-shipping');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.auto_graph_rounded, color: AppColors.tertiary),
                  title: const Text('AI Smart Value Estimator 💎'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/value-estimator');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.takeout_dining_rounded, color: AppColors.primary),
                  title: const Text('Zero-Waste Packaging Hub 📦'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/eco-packaging');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.radar_rounded, color: AppColors.secondary),
                  title: const Text('Smart Eco-Wishlist Radar 📡'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/eco-wishlist');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary),
                  title: const Text('Carbon Credit Ledger 💳'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-credits');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.military_tech_rounded, color: AppColors.tertiary),
                  title: const Text('City Carbon Leaderboard 🏆'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-leaderboard');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.auto_fix_high_rounded, color: AppColors.primary),
                  title: const Text('AI Description Summarizer 🪄'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/ai-summarizer');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.badge_rounded, color: AppColors.primary),
                  title: const Text('Digital Eco Passport 🛂'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/impact-passport');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security_rounded, color: AppColors.secondary),
                  title: const Text('Chat Safety & Shield 🛡️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/chat-safety');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary),
                  title: const Text('Green Usability Warranty 🛡️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/green-warranty');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory_2_rounded, color: AppColors.secondary),
                  title: const Text('Plastic-Free Packaging Ledger 📦'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/packaging-ledger');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.solar_power_rounded, color: AppColors.tertiary),
                  title: const Text('Solar Micro-Grid Hub ☀️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/solar-grid');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary),
                  title: const Text('Carbon Reduction Certificate 🏅'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/badge-cert');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phonelink_lock_rounded, color: AppColors.primary),
                  title: const Text('Device Sessions & Security 🔒'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/device-sessions');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bolt_rounded, color: AppColors.primary),
                  title: const Text('Green Energy Credits ⚡'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/green-energy-credits');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_enhance_rounded, color: AppColors.secondary),
                  title: const Text('AI Photo Quality Inspector 📸'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/ai-photo-quality');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.query_stats_rounded, color: AppColors.tertiary),
                  title: const Text('Impact Analytics Graph 📊'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/impact-analytics');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.volunteer_activism_rounded, color: AppColors.primary),
                  title: const Text('Volunteer Rewards Pass 🎗️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/volunteer-pass');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_fire_department_rounded, color: AppColors.tertiary),
                  title: const Text('CO₂ Offset Heatmap 📉'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-heatmap');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary),
                  title: const Text('Shaded Trophy Cabinet 🏆'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/trophy-cabinet');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  title: const Text('Transparent Impact Ledger 📜'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/public-ledger');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.find_in_page_rounded, color: AppColors.tertiary),
                  title: const Text('AI Condition Verifier 🔍'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/ai-condition-verifier');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.gavel_rounded, color: AppColors.secondary),
                  title: const Text('Dispute & Mediation Hub 🛡️'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/dispute-mediation');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.tertiary),
                  title: const Text('Collectible Eco Badges 🏅'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/eco-badges');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fact_check_rounded, color: AppColors.primary),
                  title: const Text('Zero-Waste Handoff Checklist 📋'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/handoff-checklist');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.forest_rounded, color: AppColors.secondary),
                  title: const Text('Urban Tree Planting Parks 🌳'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/reforestation-parks');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events_rounded, color: AppColors.tertiary),
                  title: const Text('Community Hall of Fame 🏆'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/hall-of-fame');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary),
                  title: const Text('Carbon Neutrality Pass 🎫'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/carbon-pass');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_rounded, color: AppColors.primary),
                  title: const Text('My Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_rounded, color: AppColors.primary),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                const Divider(),

                // Dark Mode Switch
                SwitchListTile(
                  secondary: Icon(
                    themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Dark Theme'),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (isDark) {
                    ref.read(themeModeProvider.notifier).state =
                        isDark ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ],
            ),
          ),

          // Logout Footer
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, String>> faqs = [
      {
        'q': 'How does item swapping work on EcoSwap?',
        'a': 'List an item you no longer need as "Free" or "Swap". Browse nearby listings, propose a swap with one of your items, and chat with the owner to arrange a safe public pickup.'
      },
      {
        'q': 'How are CO₂ savings calculated?',
        'a': 'Our carbon estimation model calculates average manufacturing and transportation emissions for each product category (furniture, clothing, electronics) to measure total greenhouse gases prevented.'
      },
      {
        'q': 'What are Eco Points and how do I earn them?',
        'a': 'You earn 50 Eco Points for every completed swap, giveaway, or community event participation. Points unlock profile themes, badges, and rank you up on the City Leaderboard.'
      },
      {
        'q': 'How do I ensure a safe exchange?',
        'a': 'Always meet in public, well-lit locations (like libraries or community centers), inspect items thoroughly, and use our Smart Exchange Planner with QR verification.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center & FAQs ❓'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.impactGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help you today?',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Explore our frequently asked questions or reach out to community support.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          ...faqs.map((faq) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                ),
                child: ExpansionTile(
                  title: Text(faq['q']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq['a']!,
                        style: TextStyle(fontSize: 13.5, color: theme.colorScheme.onSurfaceVariant, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.support_agent_rounded),
            label: const Text('Contact Community Support'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Support ticket submitted! Our green team will email you within 24 hours. 🌿'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

class ToyGameLibraryScreen extends ConsumerWidget {
  const ToyGameLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Circular Toy & Game Library 🧩')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.ecoGradient, borderRadius: BorderRadius.circular(24)),
            child: const Column(
              children: [
                Icon(Icons.toys_rounded, size: 56, color: Colors.amber),
                SizedBox(height: 12),
                Text('Pre-Loved Toys & Board Games', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Borrow, swap, or donate gently used wooden toys, puzzles, and kids gear to prevent plastic waste.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

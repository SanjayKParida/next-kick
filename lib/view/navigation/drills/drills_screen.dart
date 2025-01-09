// lib/screens/drills_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/drills_provider.dart';
import '../../widgets/drill_card.dart';
import 'drill_detail_screen.dart';

class DrillsScreen extends ConsumerWidget {
  const DrillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drillsAsyncValue = ref.watch(drillsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Explore',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4527A0),
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey[200],
              height: 1,
            ),
          ),
        ),
        body: drillsAsyncValue.when(
          data: (drills) => drills.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        size: 64,
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No drills available yet! ⚽\nCheck back soon!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.deepPurple.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final drill = drills[index];
                            return DrillCard(
                              drill: drill,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DrillDetailScreen(drill: drill),
                                ),
                              ),
                            );
                          },
                          childCount: drills.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple.withOpacity(0.2),
                                    Colors.deepPurple.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.rocket_launch_rounded,
                                    color: Colors.deepPurple.shade400,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Many more to come",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.deepPurple.shade700,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "✨",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading drills... ⚽',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.deepPurple.withOpacity(0.5),
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading drills',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.refresh(drillsProvider),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.poppins(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

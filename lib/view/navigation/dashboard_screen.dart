// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_drill_model.dart';
import '../../provider/user_drills_provider.dart';
import '../widgets/drill_progress_card.dart';
import '../widgets/total_progress_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDrillsAsync = ref.watch(userDrillsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Progress',
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
      body: RefreshIndicator(
        color: const Color(0xFF4527A0),
        onRefresh: () => ref.refresh(userDrillsProvider.future),
        child: userDrillsAsync.when(
          data: (userDrills) => userDrills.isEmpty
              ? _buildEmptyState(context)
              : _buildDashboard(context, userDrills),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4527A0),
            ),
          ),
          error: (error, stackTrace) => _buildErrorState(context, ref),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, List<UserDrill> userDrills) {
    // Sort the drills by timestamp in descending order (most recent first)
    final sortedDrills = List<UserDrill>.from(userDrills)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final totalCount = sortedDrills.fold<int>(
      0,
      (sum, drill) => sum + drill.completedCount,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        TotalProgressCard(totalCount: totalCount),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            'Recent Activities',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (sortedDrills.length < 3)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Complete more drills to fill up your activity feed! 🎯',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ...sortedDrills.map((userDrill) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DrillProgressCard(userDrill: userDrill),
            )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_soccer,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No Drills Completed Yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Complete your first drill to see your progress',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFE53935),
            size: 72,
          ),
          const SizedBox(height: 24),
          Text(
            'Failed to Load Progress',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => ref.refresh(userDrillsProvider),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              backgroundColor: const Color(0xFF4527A0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

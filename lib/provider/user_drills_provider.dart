import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_drill_model.dart';
import '../services/drill_service.dart';
import 'user_provider.dart';

final userDrillsProvider = FutureProvider<List<UserDrill>>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) throw Exception('User not logged in');

  final drillService = DrillService();
  return drillService.getUserDrills(user.id);
});

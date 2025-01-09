import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_kick/models/drill_model.dart';

import '../services/drill_service.dart';

final drillsProvider = FutureProvider<List<DrillModel>>((ref) async {
  final drillService = DrillService();
  return drillService.getAllDrills();
});

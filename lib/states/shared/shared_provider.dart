import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_shared.dart';

final sharedProvider = StateNotifierProvider<SharedNotifier, SharedState>((ref) => SharedNotifier());
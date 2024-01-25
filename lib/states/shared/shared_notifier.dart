import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/_data.dart';
import '_shared.dart';

class SharedNotifier extends StateNotifier<SharedState> {
  SharedNotifier(): super(SharedState.initial());
// Здесь будут методы преобразования state
  Future<void> onCategoryTap(StickerCategory category) async {
   final categories = state.categories.map((e) {
      if (e.type == category.type) {
        return e.copyWith(isSelected: true);
      } else {
        return e.copyWith(isSelected: false);
      }
    }).toList();

    if (category.type == StickerType.all) {
     final stickersByCategory = state.stickers;
     state = state.copyWith(categories: categories, stickersByCategory: stickersByCategory);
    } else {
      final stickersByCategory = state.stickers.where((e) => e.type == category.type).toList();
      state = state.copyWith(categories: categories, stickersByCategory: stickersByCategory);
    }
  }

}
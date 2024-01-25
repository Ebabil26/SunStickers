import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/_data.dart';
import '_shared.dart';

class SharedNotifier extends StateNotifier<SharedState> {
  SharedNotifier() : super(SharedState.initial());
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
      state = state.copyWith(
          categories: categories, stickersByCategory: stickersByCategory);
    } else {
      final stickersByCategory =
          state.stickers.where((e) => e.type == category.type).toList();
      state = state.copyWith(
          categories: categories, stickersByCategory: stickersByCategory);
    }
  }

  void toggleTheme() => state = state.copyWith(light: !state.light);

  void onIncreaseQuantityTap(int stickerId) {
    state = state.copyWith(
        stickers: state.stickers
            .map((e) =>
                e.id == stickerId ? e.copyWith(quantity: e.quantity + 1) : e)
            .toList());
  }

  void onDecreaseQuantityTap(int stickerId) {
    state = state.copyWith(
        stickers: state.stickers.map((e) {
      if (e.id == stickerId) {
        return e.quantity == 1 ? e : e.copyWith(quantity: e.quantity - 1);
      }

      return e;
    }).toList());
  }

  void onAddToCartTap(int stickerId) {
    state = state.copyWith(
      stickers: state.stickers.map((e) {
        if (e.id == stickerId) {
          return e.copyWith(cart: true);
        } else {
          return e;
        }
      }).toList(),
    );

    state = state.copyWith(cart: state.stickers.where((e) => e.cart).toList());
  }

  Future<void> onRemoveFromCartTap(int stickerId) async {
    state = state.copyWith(
      stickers: state.stickers.map((e) {
        if (e.id == stickerId) {
          return e.copyWith(cart: false, quantity: 1);
        } else {
          return e;
        }
      }).toList(),
    );

    state = state.copyWith(cart: state.stickers.where((e) => e.cart).toList());
  }

  Future<void> onAddRemoveFavoriteTap(int stickerId) async {
    state = state.copyWith(
      stickers: state.stickers.map((e) {
        if (e.id == stickerId) {
          return e.copyWith(favorite: !e.favorite);
        } else {
          return e;
        }
      }).toList(),
    );

    state = state.copyWith(
        favorite: state.stickers.where((e) => e.favorite).toList());
  }

  void onCheckOutTap() {
    Set<int> cartIds = <int>{};
    for (var item in state.cart) {
      cartIds.add(item.id);
    }

    state = state.copyWith(
        stickers: state.stickers.map((e) {
      if (cartIds.contains(e.id)) {
        return e.copyWith(cart: false, quantity: 1);
      } else {
        return e;
      }
    }).toList());
    state = state.copyWith(cart: state.stickers.where((e) => e.cart).toList());
  }
}

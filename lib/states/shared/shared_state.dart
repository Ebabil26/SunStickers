import 'package:equatable/equatable.dart';

import '../../data/_data.dart';

class SharedState extends Equatable {
  final List<StickerCategory> categories;
  final List<Sticker> stickers;
  final List<Sticker> stickersByCategory;
  final List<Sticker> cart;
  final List<Sticker> favorite;

  final bool light;

  const SharedState({
    required this.categories,
    required this.stickers,
    required this.stickersByCategory,
    required this.light,
    required this.cart,
    required this.favorite,
  });

  SharedState.initial()
      : this(
          categories: AppData.categories,
          stickers: AppData.stickers,
          stickersByCategory: AppData.stickers,
          cart: AppData.cartItems,
          favorite: AppData.favoriteItems,
          light: false,
        );

  @override
  List<Object?> get props => [
        categories,
        stickers,
        stickersByCategory,
        light,
        cart,
        favorite,
      ];

  SharedState copyWith({
    List<StickerCategory>? categories,
    List<Sticker>? stickers,
    List<Sticker>? stickersByCategory,
    bool? light,
    List<Sticker>? cart,
    List<Sticker>? favorite,
  }) {
    return SharedState(
      categories: categories ?? this.categories,
      stickers: stickers ?? this.stickers,
      stickersByCategory: stickersByCategory ?? this.stickersByCategory,
      light: light ?? this.light,
      cart: cart ?? this.cart,
      favorite: favorite ?? this.favorite,
    );
  }
}

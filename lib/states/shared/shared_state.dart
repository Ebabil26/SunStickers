import 'package:equatable/equatable.dart';

import '../../data/_data.dart';

class SharedState extends Equatable {
  final List<StickerCategory> categories;
  final List<Sticker> stickers;
  final List<Sticker> stickersByCategory;
  final bool light;
  const SharedState({
    required this.categories,
    required this.stickers,
    required this.stickersByCategory,
    required this.light
  });

  SharedState.initial(): this(
    categories: AppData.categories,
    stickers: AppData.stickers,
    stickersByCategory: AppData.stickers,
    light: true,
  );

  @override
  List<Object?> get props => [categories, stickers, stickersByCategory, light];

  SharedState copyWith({
    List<StickerCategory>? categories,
    List<Sticker>? stickers,
    List<Sticker>? stickersByCategory,
    bool? light
  }) {
    return SharedState(
        categories: categories ?? this.categories,
        stickers: stickers ?? this.stickers,
        stickersByCategory: stickersByCategory ?? this.stickersByCategory,
        light: light ?? this.light
    );
  }

}

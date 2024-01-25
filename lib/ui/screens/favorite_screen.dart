import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_stickers/states/shared/_shared.dart';

import '../../data/_data.dart';
import '../../ui_kit/_ui_kit.dart';
import '../_ui.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItems = ref.watch(sharedProvider).favorite;

    return Scaffold(
      appBar: _appBar(context),
      body: EmptyWrapper(
        title: "Empty favorite",
        isEmpty: favoriteItems.isEmpty,
        child: _favoriteListView(context, ref),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Favorite screen",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }

  Widget _favoriteListView(BuildContext context, WidgetRef ref) {
    final favoriteItems = ref.watch(sharedProvider).favorite;

    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: favoriteItems.length,
      itemBuilder: (_, index) {
        Sticker sticker = favoriteItems[index];
        return Card(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : AppColor.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(
              sticker.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            leading: Image.asset(sticker.image),
            subtitle: Text(
              sticker.description,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: const Icon(AppIcon.heart, color: Colors.redAccent),
            onTap: () => ref
                .read(sharedProvider.notifier)
                .onAddRemoveFavoriteTap(sticker.id),
          ),
        );
      },
      separatorBuilder: (_, __) => Container(
        height: 20,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_stickers/states/shared/shared_provider.dart';

import '../../data/_data.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class StickerDetail extends ConsumerWidget {
  const StickerDetail({required this.sticker, super.key});

  final Sticker sticker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _appBar(context),
      body: Center(child: Image.asset(sticker.image, scale: 2)),
      floatingActionButton: _floatingActionButton(ref),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _bottomAppBar(context, ref),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        'Sticker Detail Screen',
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
      ],
    );
  }

  Widget _floatingActionButton(WidgetRef ref) {
    return FloatingActionButton(
      elevation: 0.0,
      backgroundColor: AppColor.accent,
      onPressed: () =>
          ref.read(sharedProvider.notifier).onAddRemoveFavoriteTap(sticker.id),
      child: ref
              .watch(sharedProvider)
              .stickers
              .firstWhere((e) => e.id == sticker.id)
              .favorite
          ? const Icon(AppIcon.heart)
          : const Icon(AppIcon.outlinedHeart),
    );
  }

  Widget _bottomAppBar(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
        child: SizedBox(
          height: 300,
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.dark
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        RatingBar.builder(
                          itemPadding: EdgeInsets.zero,
                          itemSize: 20,
                          initialRating: sticker.score,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          glow: false,
                          ignoreGestures: true,
                          itemBuilder: (_, __) => const FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: AppColor.yellow,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        const SizedBox(width: 15),
                        Text(
                          sticker.score.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "(${sticker.voter})",
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${sticker.price}",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: AppColor.accent),
                        ),
                        CounterButton(
                          onIncrementTap: () => ref
                              .read(sharedProvider.notifier)
                              .onIncreaseQuantityTap(sticker.id),
                          onDecrementTap: () => ref
                              .read(sharedProvider.notifier)
                              .onDecreaseQuantityTap(sticker.id),
                          label: Text(
                            ref
                                .watch(sharedProvider)
                                .stickers
                                .firstWhere((e) => e.id == sticker.id)
                                .quantity
                                .toString(),
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      sticker.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await _showDialog(context);
                            if (!result) return;

                            ref
                                .read(sharedProvider.notifier)
                                .onAddToCartTap(sticker.id);

                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          },
                          child: const Text("Add to cart"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDialog(BuildContext context) async {
    final isNeededToOpen = await showDialog<bool>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sticker added to cart'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('Do you want open cart?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'No',
                    style: TextStyle(color: AppColor.accent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: AppColor.accent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;

    return isNeededToOpen;
  }
}

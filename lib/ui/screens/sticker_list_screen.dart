import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_stickers/states/shared/shared_provider.dart';
import 'package:sun_stickers/ui/_ui.dart';

import '../../ui_kit/_ui_kit.dart';

class StickerList extends ConsumerWidget {
  const StickerList({super.key});
  //var categories = AppData.categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: ref.watch(sharedProvider).light
              ? const FaIcon(FontAwesomeIcons.moon)
              : const FaIcon(FontAwesomeIcons.sun),
          onPressed: ref.read(sharedProvider.notifier).toggleTheme,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, color: AppColor.accent),
            Text(
              "Location",
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Badge(
              badgeStyle: const BadgeStyle(badgeColor: AppColor.accent),
              badgeContent: const Text(
                "2",
                style: TextStyle(color: Colors.white),
              ),
              position: BadgePosition.topStart(start: -3),
              child: const Icon(Icons.notifications_none, size: 30),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Morning, Sunny",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "What sticker do you want\nto buy today",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              _searchBar(),
              Text(
                "Available for you",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              _categories(context),
              StickerListView(
                  stickers: ref.watch(sharedProvider).stickersByCategory),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Best stickers of the week",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "See all",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColor.accent),
                      ),
                    ),
                  ],
                ),
              ),
              StickerListView(
                stickers: ref.read(sharedProvider).stickers,
                isReversed: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search sticker',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _categories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 40,
        child: Consumer(builder: (context, WidgetRef ref, __) {
          final categories =
              ref.watch(sharedProvider.select((state) => state.categories));
          //ref.watch(sharedProvider).categories;
          debugPrint("дергается категория");
          return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () =>
                      ref.read(sharedProvider.notifier).onCategoryTap(category),
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: category.isSelected
                          ? AppColor.accent
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      category.type.name.firstCapital,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => Container(
                    width: 15,
                  ),
              itemCount: categories.length);
        }),
      ),
    );
  }
}

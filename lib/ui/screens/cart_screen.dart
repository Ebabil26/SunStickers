import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sun_stickers/states/shared/_shared.dart';

import '../../data/_data.dart';
import '../../ui_kit/_ui_kit.dart';
import '../_ui.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static const _taxes = 5.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(sharedProvider).cart;

    return Scaffold(
      appBar: _appBar(context),
      body: EmptyWrapper(
        title: "Empty cart",
        isEmpty: cartItems.isEmpty,
        child: _cartListView(context, ref),
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? const SizedBox.shrink()
          : _bottomAppBar(context, ref),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Cart screen",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }

  Widget _cartListView(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(sharedProvider).cart;

    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: cartItems.length,
      itemBuilder: (_, index) {
        final sticker = cartItems[index];

        final stickerPrice = sticker.quantity * sticker.price;

        return Dismissible(
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            if (direction != DismissDirection.endToStart) return;

            ref.read(sharedProvider.notifier).onRemoveFromCartTap(sticker.id);
          },
          key: UniqueKey(),
          background: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const FaIcon(FontAwesomeIcons.trash),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.dark
                  : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 20),
                Image.asset(sticker.image, scale: 10),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sticker.name,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "\$${sticker.price}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    CounterButton(
                      onIncrementTap: () {
                        final provider = ref.read(sharedProvider.notifier);

                        provider.onIncreaseQuantityTap(sticker.id);
                        provider.onAddToCartTap(sticker.id);
                      },
                      onDecrementTap: () {
                        final provider = ref.read(sharedProvider.notifier);

                        provider.onDecreaseQuantityTap(sticker.id);
                        provider.onAddToCartTap(sticker.id);
                      },
                      size: const Size(24, 24),
                      padding: 0,
                      label: Text(
                        ref
                            .watch(sharedProvider)
                            .stickers
                            .firstWhere((e) => e.id == sticker.id)
                            .quantity
                            .toString(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Text(
                      "\$$stickerPrice",
                      style:
                          AppTextStyle.h2Style.copyWith(color: AppColor.accent),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => Container(
        height: 20,
      ),
    );
  }

  Widget _bottomAppBar(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(sharedProvider).cart;

    final priceWithoutTaxes = cartItems.map((sticker) {
      return sticker.quantity * sticker.price;
    }).reduce((value, element) => value + element);

    final totalPrice = priceWithoutTaxes + _taxes;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
          child: SizedBox(
              height: 250,
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.dark
                    : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                "\$$priceWithoutTaxes",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Taxes",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                "\$$_taxes",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(thickness: 4.0, height: 30.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                "\$$totalPrice",
                                style: AppTextStyle.h2Style.copyWith(
                                  color: AppColor.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: ElevatedButton(
                              onPressed: ref
                                  .read(sharedProvider.notifier)
                                  .onCheckOutTap,
                              child: const Text("Checkout"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }

  double stickerPrice(Sticker sticker) {
    return (sticker.quantity * sticker.price);
  }
}

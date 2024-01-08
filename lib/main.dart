import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/util/ProductViewState.dart';
import 'package:riverpod_app/util/product_notifier.dart';
import "./secondpage.dart";

final counterProvider = StateProvider((ref) => 0);
final productProvider =
    NotifierProvider<ProductNotifier, List<ProductViewState>>(
        ProductNotifier.new);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final allProducts = ref.watch(productProvider);
    int? currentPosition;

    TextEditingController titleController = TextEditingController();
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $counter'),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment'),
            ),
            
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: allProducts.length,
                itemBuilder: (BuildContext context, int position) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: Text(allProducts[position].name!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          currentPosition = position;
                          titleController.text = allProducts[position].name!;
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Delete logic here
                          ref
                              .read(productProvider.notifier)
                              .removeProduct(position);
                        },
                      )
                    ],
                  );
                }),
            SizedBox(
              width: 120,
              height: 50,
              child: TextField(
                controller: titleController,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 4.0,
              ),
              onPressed: () {
                if (currentPosition != null) {
                  ref.read(productProvider.notifier).updateProduct(
                      currentPosition!,
                      ProductViewState(
                        name: titleController.text,
                        price: 200,
                        quantity: 20,
                      ));
                  currentPosition = null;
                } else {
                  ref.read(productProvider.notifier).addProduct(
                        ProductViewState(
                          name: titleController.text,
                          price: 200,
                          quantity: 20,
                        ),
                      );
                }
              },
              child: const Text('Add objects'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage()),
              ),
              child: const Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}

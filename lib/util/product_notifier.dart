import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/util/ProductViewState.dart';

class ProductNotifier extends Notifier<List<ProductViewState>> {
  @override
  List<ProductViewState> build() => [];
  void addProduct(ProductViewState obj) {
    state.add(obj);
    state = [...state];
  }

  void removeProduct(int position) {
    state.removeAt(position);
    state = [...state];
  }

  void updateProduct(int position, ProductViewState obj) {
    state[position] = obj;
    state = [...state];
  }
}

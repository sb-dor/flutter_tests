import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/favorites.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  // static String routeName = 'favorites_page';

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<Favorites>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: value.items.length,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => FavoriteItemTile(value.items[index]),
      ),
    );
  }
}

class FavoriteItemTile extends StatelessWidget {
  const FavoriteItemTile(this.itemNo, {super.key});

  final int itemNo;

  void _removeFunction(BuildContext context) {
    Provider.of<Favorites>(context, listen: false).remove(itemNo);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites.'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: ValueKey('dismissible_$itemNo'),
        onDismissed: (value) {
          _removeFunction(context);
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.primaries[itemNo % Colors.primaries.length],
          ),
          title: Text(
            'Item $itemNo',
            key: Key('favorites_text_$itemNo'),
          ),
          trailing: IconButton(
            key: ValueKey<String>('remove_icon_$itemNo'),
            icon: const Icon(Icons.close),
            onPressed: () {
              _removeFunction(context);
            },
          ),
        ),
      ),
    );
  }
}

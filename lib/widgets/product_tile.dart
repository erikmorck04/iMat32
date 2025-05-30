import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/product_detail.dart';
import 'package:api_test/model/imat/shopping_item.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/widgets/buy_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);

    return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: iMat.getImage(product),
          ),
          SizedBox(height: 8),
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            '${product.price} ${product.unit}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            _brand(product, context),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _favoriteButton(product, context),
              SizedBox(width: 8),
              BuyButton(
                onPressed: () {
                  iMat.shoppingCartAdd(ShoppingItem(product));
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }

  String _brand(Product product, context) {
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);

    ProductDetail? detail = iMat.getDetail(product);

    if (detail != null) {
      return detail.brand;
    }
    return '';
  }

  Widget _favoriteButton(Product p, context) {
    var iMat = Provider.of<ImatDataHandler>(context, listen: false);
    var isFavorite = iMat.isFavorite(product);

    var icon = isFavorite
        ? Icon(Icons.star, color: Colors.orange)
        : Icon(Icons.star_border, color: Colors.orange);

    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isFavorite ? 'Avfavorisera' : 'Favorit'), // Change text here
          SizedBox(width: 8),
          icon,
        ],
      ),
      onPressed: () {
        iMat.toggleFavorite(product);
        // To update the UI, you may need to call setState if this is in a StatefulWidget
        // In a StatelessWidget, consider using Consumer or Selector for ImatDataHandler
      },
    );
  }
}

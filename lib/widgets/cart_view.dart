import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/widgets/delete_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Använder watch eftersom denna vyn behöver uppdateras
    // om ett item tas bort ur kundvagnen
    var iMat = context.watch<ImatDataHandler>();
    var items = iMat.getShoppingCart().items;

    return Scrollbar(thumbVisibility: true,
    child:
    ListView(
      children: [
        for (final item in items)
          Card(
            child: ListTile(
              leading: SizedBox(
                width: 40,
                height: 40,
                child: iMat.getImage(item.product),
              ),
              title: Text(item.product.name, overflow: TextOverflow.ellipsis,maxLines: 1,),
              subtitle: Text('${item.product.price} ${item.product.unit}'),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 8,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(0),
                  ),
                    onPressed: () {
                    if (item.amount > 1) {
                      iMat.shoppingCartUpdate(item, delta: - 1.0);
                    } else {
                      iMat.shoppingCartRemove(item);
                    }
                  },
                  child: Icon(Icons.remove),
                  ),
                  
                  Text(
                    '${item.amount} st',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(0),
                    backgroundColor: AppTheme.customPanelColor,
                    iconColor: Colors.white
                  ),
                  onPressed: () {
                    iMat.shoppingCartUpdate(item, delta: 1.0);
                  },
                  child: Icon(Icons.add,),
                ),
                ],
                
              ),
            ),
          ),
      ],
    ),);
  }
}

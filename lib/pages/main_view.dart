import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/util/functions.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
import 'package:api_test/pages/history_view.dart';
import 'package:api_test/widgets/cart_view.dart';
import 'package:api_test/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();}

  class _MainViewState extends State<MainView> {
  bool _isHovered = false; // State to track hover

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    return Scaffold(
      body: Column(
        children: [
          Container(color: AppTheme.customPanelColor,
          
            child: 
            Column(
              children: [SizedBox(height: AppTheme.paddingSmall),
                        _header(context),
                        SizedBox(height: AppTheme.paddingSmall),
                        ColoredBox(color: Colors.black, child: SizedBox(height: 2, width: MediaQuery.of(context).size.width,),)],),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _leftPanel(iMat),
                Expanded(
                  child: _centerStage(context, products),
                ),
                Container(
                  width: 300,
                  //color: Colors.blueGrey,
                  child: _shoppingCart(iMat),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shoppingCart(ImatDataHandler iMat) {
    return Container(
      width: 300,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - AppTheme.paddingMedium * 2,
      ),
      decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(-2, 0), // changes position of shadow
        ),
      ],

      ),
      padding: EdgeInsets.all(AppTheme.paddingMedium),
      child: Column(
        children: [
        Text('Kundvagn'),
        Expanded(child: CartView()),
        ElevatedButton(
          onPressed: () {
            iMat.placeOrder();
          },
          child: Text('Köp!'),
        ),],)
        
      ,
    );
  }

  Container _leftPanel(ImatDataHandler iMat) {
    return Container(
      width: 250,
      color: AppTheme.customPanelColor,
      child: Column(
        children: [
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                iMat.selectAllProducts();
              },
              child: Text('Visa allt'),
            ),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                //print('Favoriter');
                iMat.selectFavorites();
              },
              child: Text('Favoriter'),
            ),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                var products = iMat.products;
                iMat.selectSelection([
                  products[4],
                  products[45],
                  products[68],
                  products[102],
                  products[110],
                ]);
              },
              child: Text('Urval'),
            ),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: 132,
            child: ElevatedButton(
              onPressed: () {
                //print('Frukt');
                iMat.selectSelection(
                  iMat.findProductsByCategory(ProductCategory.CABBAGE),
                );
              },
              child: Text('Grönsaker'),
            ),
          ),
          SizedBox(height: AppTheme.paddingSmall),
          
        ],
      ),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      color: AppTheme.customPanelColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false), 
              child:
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainView()));
                },
                
                  child: Image.asset('assets/images/logoiMat-removebg-preview (1).png',height: 70,)
                ,
              ),
            )
            ),
          Container(width: 700,
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Sök produkter...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                fillColor: Colors.white,
                filled: true,
                ),
                onChanged: (value) {
                  var iMat = Provider.of<ImatDataHandler>(context, listen: false);
                  if (value.isEmpty) {
                    iMat.selectAllProducts();
                  } else {
                    iMat.selectSelection(iMat.findProducts(value));
                  }
                },
            )),),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  dbugPrint('Historik-knapp');
                  _showHistory(context);
                },
                child: Text('Köphistorik'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAccount(context);
                },
                child: Text('Användare'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _centerStage(BuildContext context, List<Product> products) {
    // ListView.builder has the advantage that tiles
    // are built as needed.
    return GridView.builder(
      padding: EdgeInsets.all(AppTheme.paddingMedium),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: AppTheme.paddingMedium,
        mainAxisSpacing: AppTheme.paddingMedium,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return ProductTile(products[index]);
      },
    );
  }

  void _showAccount(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountView()),
    );
  }

  void _showHistory(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryView()),
    );
  }
}

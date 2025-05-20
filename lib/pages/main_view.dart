import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat/util/functions.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:api_test/pages/account_view.dart';
import 'package:api_test/pages/checkout_view.dart';
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


final Map<String, IconData> mainCategoryIcons = {
  'Frukt & Grönt': Icons.eco,
  'Skafferi': Icons.kitchen,
  'Drycker': Icons.local_drink,
  'Kött, Fisk & Mejeri': Icons.set_meal,
  'Övrigt': Icons.category,
};

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
                  width: 370,
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
      width: 370,
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
        children: [Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Varukorg', style: TextStyle(fontSize: 30),),
            SizedBox(width: 15,),
            Icon(Icons.shopping_cart, size: 35,),],),

        Expanded(child: CartView()),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.customPanelColor,
            borderRadius: BorderRadius.circular(15)
          ),
          height: 100,
          //padding: EdgeInsets.all(20),
          child: Row(
          
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(
                  '${iMat.getShoppingCart().items.length} produkter',
                          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
                          ),
                ),
                Text(
                          '${iMat.getShoppingCart().items.fold(0.0, (sum, item) => sum + (item.product.price * item.amount)).toStringAsFixed(2)} kr',
                          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
                          ),
                        ),],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(
                onPressed: () {
                  iMat.shoppingCartClear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text('Töm varukorg'),
              ),
              SizedBox(height: AppTheme.paddingSmall),
              ElevatedButton(
            onPressed: () {
              if (iMat.getShoppingCart().items.isNotEmpty) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckoutView()));
              }
              
            },
            
            child: Text('Köp!'),
          ),],),
              
            ],
          ),
        ),
        ],)
        
      ,
    );
  }

  Container _leftPanel(ImatDataHandler iMat) {
    return Container(
      width: 300,
      color: AppTheme.customPanelColor3,
      child: Column(
        children: [
          SizedBox(height: AppTheme.paddingHuge),
          // Fixed buttons at the top
          SizedBox(
            width: 200,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton(
                onPressed: () {
                  iMat.selectAllProducts();
                },
                child: Text('Visa allt', style: TextStyle(fontSize: 25)),
              ),
            ),
          ),
          SizedBox(height: AppTheme.paddingMedium),
          SizedBox(
            width: 200,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton(
                onPressed: () {
                  iMat.selectFavorites();
                },
                child: Text('Favoriter', style: TextStyle(fontSize: 25)),
              ),
            ),
          ),
          SizedBox(height: AppTheme.paddingMedium),
          SizedBox(
            width: 200,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
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
                child: Text('Urval', style: TextStyle(fontSize: 25)),
              ),
            ),
          ),
          SizedBox(height: AppTheme.paddingMedium),
          // Expanded ListView for categories
          Expanded(
            child: ListView(
              children: [
                _categoryGroup(
                  'Frukt & Grönt',
                  {
                    'Grönsaker': ProductCategory.CABBAGE,
                    'Frukt': ProductCategory.FRUIT,
                    'Citrusfrukter': ProductCategory.CITRUS_FRUIT,
                    'Exotiska frukter': ProductCategory.EXOTIC_FRUIT,
                    'Bär': ProductCategory.BERRY,
                    'Meloner': ProductCategory.MELONS,
                    'Rotfrukter': ProductCategory.ROOT_VEGETABLE,
                  },
                  iMat,
                ),
                _categoryGroup(
                  'Skafferi',
                  {
                    'Pasta': ProductCategory.PASTA,
                    'Potatis & Ris': ProductCategory.POTATO_RICE,
                    'Mjöl, Socker & Salt': ProductCategory.FLOUR_SUGAR_SALT,
                    'Nötter & Frön': ProductCategory.NUTS_AND_SEEDS,
                    'Kryddor': ProductCategory.HERB,
                  },
                  iMat,
                ),
                _categoryGroup(
                  'Drycker',
                  {
                    'Varma drycker': ProductCategory.HOT_DRINKS,
                    'Kalla drycker': ProductCategory.COLD_DRINKS,
                  },
                  iMat,
                ),
                _categoryGroup(
                  'Kött, Fisk & Mejeri',
                  {
                    'Kött': ProductCategory.MEAT,
                    'Fisk': ProductCategory.FISH,
                    'Mejeri': ProductCategory.DAIRIES,
                  },
                  iMat,
                ),
                _categoryGroup(
                  'Övrigt',
                  {
                    'Bröd': ProductCategory.BREAD,
                    'Mejeri': ProductCategory.DAIRIES,
                    'Godis': ProductCategory.SWEET,
                  },
                  iMat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      color: AppTheme.customPanelColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainView()));
                },
                child: Image.asset('assets/images/logoiMat-removebg-preview (1).png', height: 70),
              ),
            ),
          ),
          // Search bar
          SizedBox(width: 180),
          Container(
            width: 700,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
              ),
            ),
          ),
          // Buttons
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: AppTheme.colorScheme.primary, width: 1),
                      ),
                    ),
                    icon: Icon(Icons.home, size: 32, color: AppTheme.colorScheme.primary),
                    label: Text(
                      'Hem',
                      style: TextStyle(
                        fontSize: 22,
                        color: AppTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainView()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: AppTheme.colorScheme.primary, width: 1),
                      ),
                    ),
                    icon: Icon(Icons.history, size: 32, color: AppTheme.colorScheme.primary),
                    label: Text(
                      'Köphistorik',
                      style: TextStyle(
                        fontSize: 22,
                        color: AppTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      dbugPrint('Historik-knapp');
                      _showHistory(context);
                    },
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: AppTheme.colorScheme.primary, width: 1),
                      ),
                    ),
                    icon: Icon(Icons.person, size: 32, color: AppTheme.colorScheme.primary),
                    label: Text(
                      'Användare',
                      style: TextStyle(
                        fontSize: 22,
                        color: AppTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _showAccount(context);
                    },
                  ),
                ),
                SizedBox(width: 32),
              ],
            ),
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

  Widget _categoryGroup(String title, Map<String, ProductCategory> categories, ImatDataHandler iMat) {
  return ExpansionTile(
    leading: Icon(mainCategoryIcons[title] ?? Icons.category),
    title: Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    children: categories.entries.map((entry) {
      return ListTile(
        
        contentPadding: EdgeInsets.symmetric(horizontal: 32),
        title: Text(entry.key),
        onTap: () {
          iMat.selectSelection(
            iMat.findProductsByCategory(entry.value),
          );
        },
      );
    }).toList(),
  );
}

  Widget _categoryButton(String text, VoidCallback onPressed) {
  return SizedBox(
    width: 200,
    height: 50,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 25)),
      ),
    ),
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

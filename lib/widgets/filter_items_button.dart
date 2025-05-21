import 'package:api_test/app_theme.dart';
import 'package:api_test/model/imat/product.dart';
import 'package:api_test/model/imat_data_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductSortDropdown extends StatefulWidget {
  final ImatDataHandler imat;
  const ProductSortDropdown({super.key, required this.imat});

  @override
  State<ProductSortDropdown> createState() => _ProductSortDropdownState();
}

class _ProductSortDropdownState extends State<ProductSortDropdown> {
  String selectedSort = 'Namn A-Ö';
  final List<String> sortOptions = [
    'Namn A-Ö',
    'Namn Ö-A',
    'Pris Lågt-Högt',
    'Pris Högt-Lågt',
  ];

  void _sortProducts(String sort) {
    List<Product> sorted = List.from(widget.imat.selectProducts);
    switch (sort) {
      case 'Namn A-Ö':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Namn Ö-A':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Pris Lågt-Högt':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case'Pris Högt-Lågt':
        sorted.sort((a,b) => b.price.compareTo(a.price));
        break;
    }
    widget.imat.selectSelection(sorted);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //color: const Color.fromARGB(255, 224, 228, 230),
        border: Border.all(color: AppTheme.colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(25)
      ),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
          padding: EdgeInsets.symmetric(horizontal: 25),
          value: selectedSort,
          items: sortOptions.map((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 25),),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue == null) return;
            setState(() {
              selectedSort = newValue;
              _sortProducts(newValue);
            });
          },
        ),
      ),
    );
  }
}
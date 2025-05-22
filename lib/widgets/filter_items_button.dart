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
    'Ekologiskt',
  ];

  bool _isHovered = false;

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
      case 'Pris Högt-Lågt':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Ekologiskt':
        sorted = sorted.where((p) => p.isEcological == true).toList();
        break;
    }
    widget.imat.selectSelection(sorted);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 50),
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.grey.withOpacity(0.04)
              : Colors.white,
          border: Border.all(
            color: AppTheme.colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: _isHovered ? 6 : 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        alignment: Alignment.center,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedSort,
            icon: Icon(Icons.arrow_drop_down, color: AppTheme.colorScheme.primary),
            style: TextStyle(fontSize: 25, color: AppTheme.colorScheme.primary, fontWeight: FontWeight.normal),
            isExpanded: true,
            dropdownColor: Colors.white,
            items: sortOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 25, color: AppTheme.colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                ),
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
      ),
    );
  }
}
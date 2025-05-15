import 'package:api_test/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_test/model/imat/product.dart';

class FilterItemsButton extends StatefulWidget{
  const FilterItemsButton({super.key})

  // @override
  // _FilterItemsState createState() => _FilterItemsState();
}

class _FilterItemsState extends State<FilterItemsButton> {
  String _selectedFilter = "placegolder";

  @override
  Widget build(BuildContext context) {

  
    return ExpansionTile(
      title: Text("filter"),

    );

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     const Text("Filter"),
    //     SizedBox(width: AppTheme.paddingSmall),
    //     Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 8),
    //       decoration: BoxDecoration(
    //         border: Border.all(color: Colors.grey),
    //         borderRadius: BorderRadius.circular(4),
    //       ),
    //       child: DropdownButton<String>(
    //         value: _selectedFilter,
    //         underline: const SizedBox(),
    //         isDense: true,
    //         items: [
    //           for (int i = 0; i < 4; i++)
    //             DropdownMenuItem<String>(
    //               value: "filter3",
    //               child: Row(
    //                 children: [

    //                 ],
    //                 ),
    //                 ),
    //         ],
    //         onChanged: (value) {
    //           setState(() {
    //             _selectedFilter = value!;
    //           });
    //         },
              
    //               ),
    //       )
    //   ]
    // );
  }
}
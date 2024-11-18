import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/dimens.dart';

class LanguageDynamicDropDownWidget<T> extends ConsumerStatefulWidget {
  const LanguageDynamicDropDownWidget({
    super.key,
    required this.items,
    required this.onSelect,
    this.defaultBgColor = true,
    this.hintText,
    this.initValue,
    required this.selectedList
  });

  final List<dynamic> items;
  final void Function(dynamic) onSelect;
  final bool defaultBgColor;
  final dynamic initValue;
  final String? hintText;
  final List<dynamic> selectedList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DropDownWidgetState();
}

class _DropDownWidgetState extends ConsumerState<LanguageDynamicDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint("ItemLength:::${widget.selectedList.length}");
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: DropdownButtonFormField2<dynamic>(
        value: widget.selectedList.isEmpty ? null : widget.initValue,  // Reset to null if items are empty
        hint: Text(
          widget.hintText ?? 'Select Language',
          style: TextStyle(color: Colors.grey),
        ),
        isExpanded: true,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: kMarginLarge),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        selectedItemBuilder: (BuildContext context) {
          return widget.items.map<Widget>((dynamic item) {
            return Text(
              item['name'],
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            );
          }).toList();
        },
        items: widget.items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item['name'],
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ))
            .toList(),
        onChanged: (value) {
          widget.onSelect(value);  // Handle the selection
        },
        validator: (value) {
          if (value == null) {
            return 'Please select';
          }
          return null;
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/utils/colors.dart';

import '../../utils/dimens.dart';

/// * Area for stateProvider

class DropDownWidget extends ConsumerStatefulWidget {
  const DropDownWidget(
      {super.key,
      required this.items,
      required this.onSelect,
      this.defaultBgColor = true,
      required this.initValue});

  final List<String> items;
  final Function(String?) onSelect;
  final bool defaultBgColor;
  final String? initValue;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends ConsumerState<DropDownWidget> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: whitePaleColor,
      ),
      child: DropdownButtonFormField2<String>(
        value: widget.initValue,
        isExpanded: true,
        selectedItemBuilder: (BuildContext context) {
          return widget.items.map<Widget>((String value) {
            return FittedBox(
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                  fontSize:
                      kTextRegular2x, // Set the text color for the selected item
                ),
              ),
            );
          }).toList();
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey, width: 0.5)),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 20, horizontal: kMarginLarge),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        items: widget.items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: FittedBox(
                    child: Text(
                      item,
                      style: TextStyle(
                          color: Colors.grey, fontSize: kTextRegular2x),
                    ),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select';
          }
          return null;
        },
        onChanged: widget.onSelect,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 0),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
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
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }
}

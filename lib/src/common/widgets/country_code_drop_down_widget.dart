import 'package:flutter/material.dart';

import '../../data/dummy_data/country_flag_code.dart';

///Country Code Dropdown
class CountryCodeDropDownButton extends StatefulWidget {
  final String? initialCountryCode;
  Function(String countryCode) countryCode;
  CountryCodeDropDownButton(
      {super.key, required this.initialCountryCode, required this.countryCode});

  @override
  State<CountryCodeDropDownButton> createState() =>
      _CountryCodeDropDownButtonState();
}

class _CountryCodeDropDownButtonState extends State<CountryCodeDropDownButton> {
  List countryCodeItems =
      countryFlagCode.map((code) => code["dial_code"]).toList();
  var selectedItem = "";

  dynamic initialData;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialCountryCode ?? countryCodeItems[215]!;

    if (widget.initialCountryCode == null) {
      initialData = countryFlagCode
          .firstWhere((element) => element["dial_code"] == "+95");
    } else {
      debugPrint("InitialCountryCode::${widget.initialCountryCode}");
      initialData = countryFlagCode.firstWhere((element) =>
          element["dial_code"] == widget.initialCountryCode.toString());
    }

    debugPrint("InitialData::$initialData");
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      value: initialData,
      isExpanded: true,
      underline: const SizedBox(),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      selectedItemBuilder: (BuildContext context) {
        return countryFlagCode.map<Widget>((dynamic item) {
          return Center(
            child: Text(
              "${item["dial_code"].toString()}(${item["code"].toString()})",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16, // Set the text color for the selected item
              ),
            ),
          );
        }).toList();
      },
      items: countryFlagCode
          .map((item) => DropdownMenuItem<dynamic>(
              value: item,
              child: Center(
                child: Text(
                  "${item["dial_code"].toString()}(${item["code"].toString()})",
                  style: TextStyle(
                    color:
                        item == initialData ? Colors.pinkAccent : Colors.black,
                  ),
                ),
              )))
          .toList(),
      onChanged: (value) {
        setState(() {
          initialData = countryFlagCode.firstWhere(
              (element) => element["dial_code"] == value["dial_code"]);
          widget.countryCode(value!["dial_code"].toString());
        });
      },
    );
  }
}

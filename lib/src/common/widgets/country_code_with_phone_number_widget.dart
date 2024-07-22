import 'package:flutter/material.dart';

import 'country_code_drop_down_widget.dart';

class CountryCodeWithPhoneNumberWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintLabel;
  Function(String value) onSelectCountryCode;
  CountryCodeWithPhoneNumberWidget(
      {super.key,
      required this.textEditingController,
      required this.hintLabel,
      required this.onSelectCountryCode});

  @override
  State<CountryCodeWithPhoneNumberWidget> createState() =>
      _CountryCodeWithPhoneNumberWidgetState();
}

class _CountryCodeWithPhoneNumberWidgetState
    extends State<CountryCodeWithPhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
          borderRadius: BorderRadius.circular(4.0)),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: CountryCodeDropDownButton(
              countryCode: (value) {
                setState(() {
                  widget.onSelectCountryCode(value.toString());
                });
              },
              initialCountryCode: "+95",
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Center(
                child: TextFormField(
                  controller: widget.textEditingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0.5,
                        )),
                    border: InputBorder.none,
                    hintText: widget.hintLabel,
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

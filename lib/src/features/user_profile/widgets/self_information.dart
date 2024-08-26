import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class SelfInformation extends StatefulWidget {
  const SelfInformation({
    super.key,
    required this.title,
    required this.description,
    this.onChangeDescription,
    this.focusNode,
    this.descriptionController
  });

  final String title;
  final String description;
  final FocusNode? focusNode;
  final TextEditingController? descriptionController;
  final Function(String value)? onChangeDescription;

  @override
  State<SelfInformation> createState() => _SelfInformationState();
}

class _SelfInformationState extends State<SelfInformation> {

  @override
  void initState() {
    super.initState();
    widget.descriptionController?.text = widget.description;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            widget.title,
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: mediumFontSize,
              color: blackColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        8.vGap,
        Divider(
          height: 1,
          color: greyColor,
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          //height: 40,
          padding: EdgeInsets.only(left: 20, top: 12, bottom: 12),
          color: whiteColor,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              controller: widget.descriptionController,
              textAlign: TextAlign.left,
              focusNode: widget.focusNode,
              onChanged: (value){
                widget.onChangeDescription!(value);
              },
              decoration: InputDecoration(border: InputBorder.none),
              style: GoogleFonts.roboto(
                fontSize: smallFontSize,
                color: blackColor,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

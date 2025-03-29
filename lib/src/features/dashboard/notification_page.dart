import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitePaleColor,
      appBar: AppBar(
      backgroundColor: blackColor,
      leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 20,)),
      title: Text(
        'Notifications',
        style: TextStyle(fontFamily: kFontGibsonBold,color: Colors.white),
      ),
      centerTitle: true,
    ),body: Center(child: Text(('There is no notification.')),),);
  }
}

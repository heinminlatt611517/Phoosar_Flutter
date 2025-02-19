import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class CustomAppBarView extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 40,
      backgroundColor: Colors.transparent,
      toolbarHeight: 200,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: SvgPicture.asset(
              'assets/svgs/back_img.svg',
              height: 25,
              width: 25,
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/phoosar_img.png',
            height: 70,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          const Text(''),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

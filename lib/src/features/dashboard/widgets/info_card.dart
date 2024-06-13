import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/dating1.jpeg',
            width: MediaQuery.of(context).size.width - 32,
            height: MediaQuery.of(context).size.height * 0.6,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 12,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Online',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    'Robert',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '30',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    '6 km away',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.work,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Software Engineer',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Live in Yangon',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Text(
                      'University of Computer Studies (Yangon)',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

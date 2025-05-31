import 'package:flutter/material.dart';

import '../utils/image_file.dart';
import '../utils/responsive.dart';

class BackGround extends StatelessWidget {
  final Widget child;

  const BackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, res) {
        return SizedBox(
          height: res.size.height,
          width: res.size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  ImageFile.authVectorTop1,
                  // color: Colors.blue,
                  width: res.size.width,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  ImageFile.authVectorTop2,
                  // color: Colors.blueAccent,
                  width: res.size.width,
                ),
              ),
              Positioned(
                top: res.height(50),
                right: res.width(30),
                child: Image.asset(ImageFile.authVectorMainImage, width: res.width(140)),
              ),
              Positioned(bottom: 0, left: 0, child: Image.asset(ImageFile.authVectorBottom1, width: res.size.width)),
              Positioned(bottom: 0, left: 0, child: Image.asset(ImageFile.authVectorBottom2, width: res.size.width)),
              child,
            ],
          ),
        );
      },
    );
  }
}

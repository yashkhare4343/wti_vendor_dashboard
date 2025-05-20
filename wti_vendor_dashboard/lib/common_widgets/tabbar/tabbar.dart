import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/main.dart';

import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBgPrimary1,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "All Drivers",
            style: CommonFonts.appBarText,
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Padding(padding: EdgeInsets.all(16.0),
            child: DefaultTabController(
                length: 3,
                child: TabBar(
                  indicator: CustomTabIndicator(),
                  labelColor: AppColors.blueAccent,
                  unselectedLabelColor: Colors.black.withOpacity(0.6),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'Verified'),
                    Tab(text: 'Rejected'),
                  ],
                )

            ),
          ),
        ));
  }
}


class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = AppColors.blueAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double tabWidth = configuration.size!.width;
    final double xCenter = offset.dx + tabWidth / 2;
    final double yBottom = offset.dy + configuration.size!.height;

    final double lineWidth = 115.0;
    final double halfLineWidth = lineWidth / 2;

    canvas.drawLine(
      Offset(xCenter - halfLineWidth, yBottom),
      Offset(xCenter + halfLineWidth, yBottom),
      paint,
    );
  }
}



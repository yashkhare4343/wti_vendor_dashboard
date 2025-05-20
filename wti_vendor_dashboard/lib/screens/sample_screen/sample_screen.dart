import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/main.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/search_form/search_input_field.dart';

import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  String? _selectedValue;

  final List<String> _options = [
    'Selected by','Driver Name',
  ];

  final TextEditingController driverController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgPrimary1,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "All Drivers",
            style: CommonFonts.appBarText,
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// Card with Dropdown


                /// TabBar (with custom underline)
                TabBar(
                  indicator: CustomTabIndicator(),
                  labelColor: AppColors.blueAccent,
                  unselectedLabelColor: Colors.black.withOpacity(0.8),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Pending'),
                    Tab(text: 'Verified'),
                    Tab(text: 'Rejected'),
                  ],
                ),

                const SizedBox(height: 12),

                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: DropdownButtonFormField<String>(
                            autofocus: false,
                            focusColor: AppColors.borderColor1,
                            decoration: InputDecoration(
                              labelText: 'Selected For',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderColor1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey, // 👈 Gray border on tap/focus
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            dropdownColor: Colors.white, // 👈 White background for dropdown menu
                            value: _selectedValue,
                            items: _options.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedValue = newValue;
                              });
                              print('Selected: $newValue');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(child: SearchInputField(controller: driverController, hintText: 'Search...',))

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// TabBarView must be wrapped in Expanded
                Expanded(
                  child: TabBarView(
                    children: [
                      pending(),
                      pending(),
                      Center(child: Text('Verified Drivers')),
                      Center(child: Text('Rejected Drivers')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  _CustomPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

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


class Pending extends StatefulWidget {
  const Pending({super.key});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Name, verification, phone, and license
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and verification badge
                      Row(
                        children: [
                          Text(
                            'Yash Khare',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: pending(),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Phone number
                      Text(
                        '+91-9876543210',
                        style: CommonFonts.bodyText3,
                      ),
                      SizedBox(height: 4),
                      // License number (partially masked)

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgGrey1, // 👈 Background color
                          borderRadius: BorderRadius.circular(4), // 👈 Rounded corners
                        ),
                        child:  Text(
                          'License no. - DLXXXXXXXXNC',
                          style: CommonFonts.bodyText3,
                        ),
                      )

                    ],
                  ),
                  // Right side: More options icon
                  Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}


Widget pending(){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      'Verified',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}
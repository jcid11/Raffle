import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular(
      {Key? key, this.width = double.infinity, required this.height})
      :this.shapeBorder = const RoundedRectangleBorder();

  ShimmerWidget.circular(
      {required this.width, required this.height, this.shapeBorder = const CircleBorder()});


  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      period: Duration(seconds: 5),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
            color: Colors.grey[400]!, shape: shapeBorder
        ),
      ),
    );
  }
}


Widget shimmerList() =>
    ListTile(leading:ShimmerWidget.circular(width: 64, height: 64), title: Align(alignment: Alignment.center,child: ShimmerWidget.rectangular(height: 16,)),
      subtitle: ShimmerWidget.rectangular(height: 14),);

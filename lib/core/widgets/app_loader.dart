import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  final double size;

  const AppLoader({
    super.key,
    this.color = AppColors.primary,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(color: color),
      ),
    );
  }
}

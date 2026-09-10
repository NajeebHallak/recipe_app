import 'package:flutter/material.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.rW),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 80.rSp),
            AppGap.h20,
            Text(
              'عذراً، حدث خطأ!',
              style: TextStyle(
                fontSize: 22.rSp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            AppGap.h10,
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.rSp, color: Colors.grey),
            ),
            AppGap.h32,
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: 30.rW,
                  vertical: 12.rH,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.kRadiusMedium12,
                ),
              ),
              icon: Icon(Icons.refresh, color: Colors.white, size: 20.rSp),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.rSp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

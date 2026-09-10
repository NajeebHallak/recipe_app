import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 🚀 كلاس الأبعاد والاستجابة المطور والـ High-Performance
class AppResponsive {
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;

  // أبعاد تصميم الفيجما الافتراضية
  static late double _designWidth;
  static late double _designHeight;

  // نقاط التحول للشاشات (Breakpoints)
  static const double mobileBreakPoint = 600;
  static const double tabletBreakPoint = 1100;

  /// ⚡ التهيئة الأسرع من الـ Flutter Engine مباشرة (بدون الحاجة لـ Context)
  static void init({double baseWidth = 375.0, double baseHeight = 812.0}) {
    _designWidth = baseWidth;
    _designHeight = baseHeight;

    final view = ui.PlatformDispatcher.instance.implicitView;
    if (view != null) {
      screenWidth = view.physicalSize.width / view.devicePixelRatio;
      screenHeight = view.physicalSize.height / view.devicePixelRatio;
    } else {
      screenWidth = baseWidth;
      screenHeight = baseHeight;
    }
    orientation = screenWidth > screenHeight
        ? Orientation.landscape
        : Orientation.portrait;
  }

  // فحص نوع الجهاز
  static bool get isMobile => screenWidth < mobileBreakPoint;
  static bool get isTablet =>
      screenWidth >= mobileBreakPoint && screenWidth < tabletBreakPoint;
  static bool get isDesktop => screenWidth >= tabletBreakPoint;

  // حساب الأبعاد النسبية
  static double get _effectiveWidth {
    double width = orientation == Orientation.landscape
        ? screenHeight
        : screenWidth;
    return width > mobileBreakPoint ? mobileBreakPoint : width;
  }

  static double get _effectiveHeight {
    double height = orientation == Orientation.landscape
        ? screenWidth
        : screenHeight;
    return height > 1200 ? 1200 : height;
  }

  static double setWidth(double size) =>
      (size / _designWidth) * _effectiveWidth;
  static double setHeight(double size) =>
      (size / _designHeight) * _effectiveHeight;

  static double setSp(double size) {
    double scaleFactor = _effectiveWidth / _designWidth;
    if (scaleFactor > 1.15)
      scaleFactor = 1.15; // كبح تكبير الخطوط للحفاظ على تناسق التصميم
    return size * scaleFactor;
  }
}

/// ⚡ مسافات ثابته جاهزة (const) تمنع إعادة التخصيص في الذاكرة وتسسرّع الـ Render Engine
class AppGap {
  // مسافات عمودية
  static const Widget h2 = SizedBox(height: 2);
  static const Widget h4 = SizedBox(height: 4);
  static const Widget h6 = SizedBox(height: 6);
  static const Widget h8 = SizedBox(height: 8);
  static const Widget h10 = SizedBox(height: 10);
  static const Widget h12 = SizedBox(height: 12);
  static const Widget h16 = SizedBox(height: 16);
  static const Widget h20 = SizedBox(height: 20);
  static const Widget h24 = SizedBox(height: 24);
  static const Widget h32 = SizedBox(height: 32);
  static const Widget h40 = SizedBox(height: 40);
  static const Widget h50 = SizedBox(height: 50);

  // مسافات أفقيّة
  static const Widget w2 = SizedBox(width: 2);
  static const Widget w4 = SizedBox(width: 4);
  static const Widget w6 = SizedBox(width: 6);
  static const Widget w8 = SizedBox(width: 8);
  static const Widget w10 = SizedBox(width: 10);
  static const Widget w12 = SizedBox(width: 12);
  static const Widget w16 = SizedBox(width: 16);
  static const Widget w20 = SizedBox(width: 20);
  static const Widget w24 = SizedBox(width: 24);
  static const Widget w32 = SizedBox(width: 32);
}

/// حواف (Border Radius) ثابتة
class AppRadius {
  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;

  static final BorderRadius kRadiusSmall8 = BorderRadius.circular(r8);
  static final BorderRadius kRadiusMedium12 = BorderRadius.circular(r12);
  static final BorderRadius kRadiusLarge16 = BorderRadius.circular(r16);
  static final BorderRadius kRadiusCircular100 = BorderRadius.circular(100);
}

/// امتدادات متطورة وسريعة جداً للرقم (Extensions)
extension ResponsiveNumExtension on num {
  /// عرض نسبي متجاوب
  double get rW => AppResponsive.setWidth(toDouble());

  /// ارتفاع نسبي متجاوب
  double get rH => AppResponsive.setHeight(toDouble());

  /// حجم خط متجاوب
  double get rSp => AppResponsive.setSp(toDouble());

  /// مسافة عمودية ديناميكية جاهزة (مثال: 18.hGap)
  Widget get hGap => SizedBox(height: AppResponsive.setHeight(toDouble()));

  /// مسافة أفقية ديناميكية جاهزة (مثال: 12.wGap)
  Widget get wGap => SizedBox(width: AppResponsive.setWidth(toDouble()));
}

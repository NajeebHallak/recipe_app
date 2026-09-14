import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/core/theme/app_colors.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';

class RecipePdfPreviewScreen extends StatelessWidget {
  final RecipeModel recipe;

  const RecipePdfPreviewScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.print_recipe,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.rSp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: PdfPreview(
          build: (format) => _generatePdf(context, format, recipe),
          canChangeOrientation: false,
          allowPrinting: true,
          canChangePageFormat: true,
          allowSharing: true,
          canDebug: false, // 🛑 تعطيل زر الـ Debug للمستخدمين

          pdfFileName: '${recipe.titleEn.replaceAll(" ", "_")}_Recipe.pdf',
          loadingWidget: Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          ),
          previewPageMargin: EdgeInsets.all(10.rW),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    BuildContext context,
    PdfPageFormat format,
    RecipeModel recipe,
  ) async {
    pw.Document pdf = pw.Document();

    bool isAr = Localizations.localeOf(context).languageCode == 'ar';

    // 1. Load fonts from local assets
    final ByteData boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ByteData regularData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');

    pw.Font fontTitle = pw.Font.ttf(boldData);
    pw.Font fontBody = pw.Font.ttf(regularData);

    // 2. Load Image
    pw.ImageProvider? pdfImage;
    if (recipe.imageUrl.isNotEmpty && recipe.imageUrl.first.isNotEmpty) {
      final imgString = recipe.imageUrl.first;
      try {
        if (imgString.startsWith('http')) {
          pdfImage = await networkImage(
            imgString,
          ).timeout(const Duration(seconds: 5));
        } else {
          final file = File(imgString);
          if (file.existsSync()) {
            pdfImage = pw.MemoryImage(file.readAsBytesSync());
          }
        }
      } catch (e) {
        // Fallback to no image if failed to load
      }
    }

    final String title = (isAr ? recipe.titleAr : recipe.titleEn).replaceAll(
      '\r',
      '',
    );
    final String details = (isAr ? recipe.detailsAr : recipe.detailsEn)
        .replaceAll('\r', '');

    // 3. Build PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(
          40,
        ), // هوامش آمنة جداً لمنع قص الورقة أثناء الطباعة الفعلية
        textDirection: isAr ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        theme: pw.ThemeData.withFont(base: fontBody, bold: fontTitle),
        build: (pw.Context pdfContext) {
          return [
            if (pdfImage != null)
              pw.Container(
                height: 250,
                width: double.infinity,
                child: pw.ClipRRect(
                  horizontalRadius: 10,
                  verticalRadius: 10,
                  child: pw.Image(pdfImage, fit: pw.BoxFit.cover),
                ),
              ),
            pw.SizedBox(height: 20),

            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 32,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              recipe.category,
              style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700),
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Column(
                    children: [
                      pw.Text(
                        context.l10n.prep_time,
                        style: const pw.TextStyle(color: PdfColors.grey600),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${recipe.prepTime} ${context.l10n.mins}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text(
                        context.l10n.servings_count,
                        style: const pw.TextStyle(color: PdfColors.grey600),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${recipe.servings} ${context.l10n.persons}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 30),

            pw.Text(
              context.l10n.instructions,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
            pw.SizedBox(height: 15),

            pw.Text(
              details,
              style: const pw.TextStyle(fontSize: 16, lineSpacing: 5),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}

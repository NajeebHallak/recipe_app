import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/theme/app_colors.dart';
import 'package:recipe/core/widgets/recipe_image_widget.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/features/home/data/models/recipe_model.dart';
import 'package:recipe/features/home/data/models/recipe_request.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_state.dart';

class RecipeFormWidget extends StatefulWidget {
  final RecipeModel? recipe;
  const RecipeFormWidget({super.key, this.recipe});

  @override
  State<RecipeFormWidget> createState() => _RecipeFormWidgetState();
}

class _RecipeFormWidgetState extends State<RecipeFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleArController;
  late TextEditingController _titleEnController;
  late TextEditingController _detailsArController;
  late TextEditingController _detailsEnController;
  String? _selectedCategory;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.deleteRed,
            content: Text('${context.l10n.image_pick_error}: $e'),
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16.rW),
        padding: EdgeInsets.all(24.rW),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24.rW),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.rW,
              height: 4.rH,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.rW),
              ),
            ),
            AppGap.h24,
            Text(
              context.l10n.choose_image_source,
              style: TextStyle(fontSize: 20.rSp, fontWeight: FontWeight.w800),
            ),
            AppGap.h24,
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceButton(
                    context,
                    icon: Icons.photo_library_rounded,
                    label: context.l10n.gallery,
                    color: AppColors.primary,
                    onTap: () {
                      context.pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
                AppGap.w16,
                Expanded(
                  child: _buildImageSourceButton(
                    context,
                    icon: Icons.camera_alt_rounded,
                    label: context.l10n.camera,
                    color: AppColors.primaryGreen,
                    onTap: () {
                      context.pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
              ],
            ),
            AppGap.h16,
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.rW),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.rH),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.rW),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40.rSp, color: color),
            AppGap.h12,
            Text(
              label,
              style: TextStyle(
                fontSize: 16.rSp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isEdit => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    _titleArController = TextEditingController(
      text: widget.recipe?.titleAr ?? '',
    );
    _titleEnController = TextEditingController(
      text: widget.recipe?.titleEn ?? '',
    );
    _detailsArController = TextEditingController(
      text: widget.recipe?.detailsAr ?? '',
    );
    _detailsEnController = TextEditingController(
      text: widget.recipe?.detailsEn ?? '',
    );

    if (widget.recipe != null && widget.recipe!.imageUrl.isNotEmpty) {
      _imagePath = widget.recipe!.imageUrl.first;
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _detailsArController.dispose();
    _detailsEnController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      bool isNetworkImage =
          _imagePath != null && _imagePath!.startsWith('http');
      final request = RecipeRequest(
        id: isEdit ? widget.recipe!.id : null,
        titleAr: _titleArController.text.trim(),
        titleEn: _titleEnController.text.trim(),
        detailsAr: _detailsArController.text.trim(),
        detailsEn: _detailsEnController.text.trim(),
        category: _selectedCategory ?? 'الكل',
        imagePath: isNetworkImage ? null : _imagePath,
      );

      if (isEdit) {
        context.read<HomeCubit>().updateRecipe(request);
      } else {
        context.read<HomeCubit>().addRecipe(request);
      }
    }
  }

  String _getLocalizedCategory(BuildContext context, String dbCategory) {
    if (dbCategory == 'وجبات رئيسية' || dbCategory == 'Main Meals')
      return context.l10n.main_meals;
    if (dbCategory == 'حلويات' || dbCategory == 'Sweets')
      return context.l10n.sweets;
    if (dbCategory == 'مقبلات' || dbCategory == 'Appetizers')
      return context.l10n.appetizers;
    if (dbCategory == 'مشروبات' || dbCategory == 'Drinks')
      return context.l10n.drinks;
    return context.l10n.main_meals;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> availableCategories = [
      context.l10n.main_meals,
      context.l10n.sweets,
      context.l10n.appetizers,
      context.l10n.drinks,
    ];

    if (_selectedCategory == null) {
      if (widget.recipe != null) {
        _selectedCategory = _getLocalizedCategory(
          context,
          widget.recipe!.category,
        );
      } else {
        _selectedCategory = availableCategories.first;
      }
    } else {
      // Ensure current selection is valid for current locale (in case language changed)
      if (!availableCategories.contains(_selectedCategory)) {
        _selectedCategory = _getLocalizedCategory(context, _selectedCategory!);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit ? context.l10n.edit_recipe : context.l10n.add_recipe,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20.rW),
            children: [
              // العنوان
              Row(
                children: [
                  Expanded(
                    child: RecipeTextFieldWidget(
                      label: context.l10n.title_ar_label,
                      controller: _titleArController,
                    ),
                  ),
                  AppGap.w16,
                  Expanded(
                    child: RecipeTextFieldWidget(
                      label: context.l10n.title_en_label,
                      controller: _titleEnController,
                    ),
                  ),
                ],
              ),
              AppGap.h20,

              // التصنيف
              RecipeDropdownWidget(
                selectedCategory: _selectedCategory!,
                categories: availableCategories,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              AppGap.h20,

              // المكونات وطريقة التحضير (عربي)
              RecipeTextFieldWidget(
                label: context.l10n.details_ar_label,
                controller: _detailsArController,
                maxLines: 5,
              ),
              AppGap.h20,

              // المكونات وطريقة التحضير (إنجليزي)
              RecipeTextFieldWidget(
                label: context.l10n.details_en_label,
                controller: _detailsEnController,
                maxLines: 5,
              ),
              AppGap.h20,

              // رفع صورة
              RecipeImagePickerWidget(
                imagePath: _imagePath,
                onTap: _showImageSourceDialog,
                onRemove: _removeImage,
              ),
              AppGap.h40,

              // الأزرار
              RecipeActionButtonsWidget(onSubmit: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// الويدجتات المستخرجة (مجمعة في هذا الملف لسهولة الوصول وتقليل التشتت)
// ---------------------------------------------------------

class RecipeTextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const RecipeTextFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.rW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (val) =>
            val == null || val.isEmpty ? context.l10n.field_required : null,
        style: TextStyle(fontSize: 16.rSp, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14.rSp),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.all(20.rW),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.rW),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.rW),
            borderSide: const BorderSide(
              color: AppColors.primaryGreen,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.rW),
            borderSide: const BorderSide(
              color: AppColors.deleteRed,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.rW),
            borderSide: const BorderSide(color: AppColors.deleteRed, width: 2),
          ),
        ),
      ),
    );
  }
}

class RecipeDropdownWidget extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  const RecipeDropdownWidget({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.rW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.primaryGreen,
        ),
        decoration: InputDecoration(
          labelText: context.l10n.select_category,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14.rSp),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.rW,
            vertical: 16.rH,
          ),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.rW),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.rW),
            borderSide: const BorderSide(
              color: AppColors.primaryGreen,
              width: 2,
            ),
          ),
        ),
        items: categories.map((cat) {
          return DropdownMenuItem(
            value: cat,
            child: Text(
              cat,
              style: TextStyle(fontSize: 16.rSp, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class RecipeImagePickerWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const RecipeImagePickerWidget({
    super.key,
    this.imagePath,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return InkWell(
      onTap: hasImage ? null : onTap,
      borderRadius: BorderRadius.circular(20.rW),
      child: Container(
        height: 200.rH,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.rW),
          color: hasImage
              ? Colors.transparent
              : AppColors.primaryGreen.withOpacity(0.05),
          border: hasImage
              ? null
              : Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
          boxShadow: hasImage
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.rW),
                    child: RecipeImageWidget(
                      imagePath: imagePath!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12.rH,
                    right: 12.rW,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: EdgeInsets.all(8.rW),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.deleteRed,
                          size: 24.rSp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.rH,
                    right: 12.rW,
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.rW,
                          vertical: 8.rH,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20.rW),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 18.rSp,
                            ),
                            AppGap.w8,
                            Text(
                              context.l10n.change_image,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.rSp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.rW),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_rounded,
                      size: 48.rSp,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  AppGap.h16,
                  Text(
                    context.l10n.add_image,
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 18.rSp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class RecipeActionButtonsWidget extends StatelessWidget {
  final VoidCallback onSubmit;

  const RecipeActionButtonsWidget({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading =
            state is HomeAddRecipeLoading || state is HomeUpdateRecipeLoading;

        return Container(
          width: double.infinity,
          height: 60.rH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.rW),
            gradient: const LinearGradient(
              colors: [
                AppColors.primaryGreen,
                Color(0xFF2E7D32),
              ], // Premium Green Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.rW),
              ),
            ),
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? SizedBox(
                    height: 24.rSp,
                    width: 24.rSp,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 24.rSp,
                      ),
                      AppGap.w8,
                      Text(
                        context.l10n.save,
                        style: TextStyle(
                          fontSize: 18.rSp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'My Recipes';

  @override
  String get add_recipe => 'Add Recipe';

  @override
  String get edit_recipe => 'Edit Recipe';

  @override
  String get delete_recipe => 'Delete recipe';

  @override
  String get search_hint => 'Search recipe by name or ingredients...';

  @override
  String get all => 'All';

  @override
  String get main_meals => 'Main Meals';

  @override
  String get sweets => 'Sweets';

  @override
  String get appetizers => 'Appetizers';

  @override
  String get drinks => 'Drinks';

  @override
  String get favorites => 'Favorites';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get instructions => 'Instructions';

  @override
  String get mins => 'mins';

  @override
  String get persons => 'persons';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete_confirm => 'Are you sure you want to delete this recipe?';

  @override
  String get success => 'Success';

  @override
  String get error_occurred => 'Sorry, an error occurred';

  @override
  String get delete_confirm_title => 'Confirm Delete';

  @override
  String get prep_time => 'Prep Time';

  @override
  String get servings_count => 'Servings';

  @override
  String get add_recipe_btn => 'Add Recipe';

  @override
  String get title_ar_label => 'Recipe Title (Arabic)';

  @override
  String get title_en_label => 'Recipe Title (English)';

  @override
  String get details_ar_label => 'Recipe Details (Arabic)';

  @override
  String get details_en_label => 'Recipe Details (English)';

  @override
  String get prep_time_label => 'Prep Time (minutes)';

  @override
  String get servings_label => 'Number of Servings';

  @override
  String get select_category => 'Select Category';

  @override
  String get add_image => 'Add Image';

  @override
  String get change_image => 'Change Image';

  @override
  String get field_required => 'This field is required';

  @override
  String get invalid_number => 'Must be a valid number';

  @override
  String get number_must_be_greater_than_zero =>
      'Number must be greater than zero';

  @override
  String get empty_recipes => 'No recipes found here!';

  @override
  String get no_image_available => 'No image available';

  @override
  String get image_required => 'Please select an image for the recipe';

  @override
  String get recipe_added_success => 'Recipe added successfully!';

  @override
  String get recipe_updated_success => 'Recipe updated successfully!';

  @override
  String get choose_image_source => 'Choose Image Source';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get image_pick_error => 'An error occurred while picking the image';

  @override
  String get smart_sync_center => 'Smart Sync Center';

  @override
  String pending_sync_operations(int count) {
    return 'There are $count operations waiting for internet connection';
  }

  @override
  String get uploading_data => 'Uploading data...';

  @override
  String get start_sync_now => 'Start Syncing Now';

  @override
  String get all_synced_up => 'Everything is synced and up to date!';

  @override
  String get waiting_to_upload => 'Waiting to upload to server';

  @override
  String get preparing_to_update => 'Preparing to update';

  @override
  String get recipe_deleted_locally => 'Recipe deleted locally and temporarily';

  @override
  String get id_label => 'ID';
}

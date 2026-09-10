import 'package:flutter/material.dart';
import 'package:recipe/core/localization/l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  /// للوصول المباشر للكلمات المترجمة مثل: context.l10n.app_title
  AppLocalizations get l10n => AppLocalizations.of(this);
}

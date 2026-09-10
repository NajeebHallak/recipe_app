import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/core/constants/app_responsive_constants.dart';
import 'package:recipe/core/localization/extensions/l10n_extension.dart';
import 'package:recipe/features/home/presentation/cubits/home/home_cubit.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.rW),
      child: TextField(
        onChanged: (query) {
          context.read<HomeCubit>().search(query);
        },
        decoration: InputDecoration(
          hintText: context.l10n.search_hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.rW),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20.rW),
        ),
      ),
    );
  }
}

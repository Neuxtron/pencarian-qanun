import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _PageHeader(),
              _KomisiBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}

class _KomisiBuilder extends StatelessWidget {
  const _KomisiBuilder();

  @override
  Widget build(BuildContext context) {
    // TODO: list komisi
    return const SizedBox();
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 50),
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.collections_bookmark_outlined,
                size: 35,
                color: AppColors.primary,
              ),
            ),
            const Text(
              "Ingin pelajari Qanun\napa hari ini?",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/routes.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_radius.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';
import 'package:pencarian_qanun_mobile/shared/widgets/snapshot_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.komisiFuture,
    required this.changeIndex,
  });

  final Future<List<Komisi>> komisiFuture;
  final Function(int index) changeIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ListLembaga(),
        const _PageHeader(),
        _QuickActions(
          changeIndex: changeIndex,
        ),
        _KomisiGridView(komisiFuture: komisiFuture),
      ],
    );
  }
}

class _ListLembaga extends StatelessWidget {
  const _ListLembaga();

  @override
  Widget build(BuildContext context) {
    const double imageSize = 40;
    final listGambar = [
      "assets/images/lembaga/dinas_syariat_islam.png",
      "assets/images/lembaga/dpr_aceh.png",
      "assets/images/lembaga/kementrian_dalam_negeri.png",
      "assets/images/lembaga/mahkamah_syariah.png",
      "assets/images/lembaga/wilayatul_hisbah.png",
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
      child: Row(
        children: listGambar.map((gambar) {
          return Expanded(
            child: Image.asset(
              gambar,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.changeIndex});
  final Function(int index) changeIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuickActionsItem(
            icon: Icons.history,
            text: "Riwayat",
            onPressed: () {
              Navigator.pushNamed(context, Routes.riwayat);
            },
          ),
          _QuickActionsItem(
            icon: Icons.search,
            text: "Pencarian",
            onPressed: () => changeIndex(1),
          ),
          _QuickActionsItem(
            icon: Icons.star_border,
            text: "Qanun Dibintang",
            onPressed: () {
              Navigator.pushNamed(context, Routes.dibintang);
            },
          ),
          _QuickActionsItem(
            icon: Icons.face,
            text: "Bertanya dengan AI",
            onPressed: () {
              Navigator.pushNamed(context, Routes.chatbot);
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionsItem extends StatelessWidget {
  const _QuickActionsItem({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.medium,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 35,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KomisiGridView extends StatelessWidget {
  const _KomisiGridView({required this.komisiFuture});
  final Future<List<Komisi>> komisiFuture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                indent: 12,
                endIndent: 24,
                color: AppColors.divider,
              ),
            ),
            Text(
              "Daftar Komisi",
              style: AppTextStyles.bodySmall,
            ),
            Expanded(
              child: Divider(
                indent: 24,
                endIndent: 12,
                color: AppColors.divider,
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: komisiFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SnapshotHandler(
                snapshot: snapshot,
                loadingView: const _KomisiBuilder(
                  listKomisi: [],
                  isLoading: true,
                ),
              );
            }

            final listKomisi = snapshot.data!;
            return _KomisiBuilder(
              listKomisi: listKomisi,
              isLoading: false,
            );
          },
        ),
      ],
    );
  }
}

class _KomisiBuilder extends StatelessWidget {
  const _KomisiBuilder({
    required this.listKomisi,
    required this.isLoading,
  });

  final List<Komisi> listKomisi;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        mainAxisSpacing: 24,
        crossAxisSpacing: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      shrinkWrap: true,
      itemCount: isLoading ? 3 : listKomisi.length,
      itemBuilder: (context, index) {
        if (isLoading) return const _LoadingKomisiItem();
        final komisi = listKomisi[index];
        return _KomisiItem(komisi: komisi);
      },
    );
  }
}

class _KomisiItem extends StatelessWidget {
  const _KomisiItem({required this.komisi});
  final Komisi komisi;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.small,
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(3, 3),
            color: Colors.black26,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.detailKomisi,
              arguments: komisi,
            );
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: AppColors.primary,
                child: Text(
                  "Komisi ${komisi.nomorRomawi}",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleLarge.apply(
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        komisi.nama,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Selengkapnya",
                      style: AppTextStyles.bodySmall.apply(
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.accent,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingKomisiItem extends StatelessWidget {
  const _LoadingKomisiItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.loading,
        borderRadius: AppRadius.small,
      ),
      clipBehavior: Clip.hardEdge,
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary,
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

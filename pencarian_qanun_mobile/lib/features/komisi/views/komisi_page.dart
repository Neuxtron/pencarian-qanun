import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/repositories/komisi_repository.dart';
import 'package:pencarian_qanun_mobile/features/komisi/models/detail_komisi.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_radius.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';
import 'package:pencarian_qanun_mobile/shared/widgets/qanun_item.dart';
import 'package:pencarian_qanun_mobile/shared/widgets/snapshot_handler.dart';

class KomisiPage extends StatelessWidget {
  const KomisiPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.accent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final komisi = ModalRoute.of(context)!.settings.arguments as Komisi;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _PageHeader(komisi: komisi),
            _DetailKomisiListView(idKomisi: komisi.id),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.komisi});
  final Komisi komisi;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.small,
            ),
            child: Center(
              child: Text(
                komisi.nomorRomawi,
                style: AppTextStyles.headlineLarge.apply(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              komisi.nama,
              style: AppTextStyles.headlineSmall.apply(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailKomisiListView extends StatefulWidget {
  const _DetailKomisiListView({required this.idKomisi});
  final String idKomisi;

  @override
  State<_DetailKomisiListView> createState() => _DetailKomisiListViewState();
}

class _DetailKomisiListViewState extends State<_DetailKomisiListView> {
  late Future<List<DetailKomisi>> _future;

  @override
  void initState() {
    super.initState();
    _future = KomisiRepository(context).getDetailKomisi(widget.idKomisi);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SnapshotHandler(
            snapshot: snapshot,
            loadingView: const _DetailKomisiBuilder(
              listDetailKomisi: [],
              isLoading: true,
            ),
          );
        }

        final listDetailKomisi = snapshot.data!;
        return _DetailKomisiBuilder(
          listDetailKomisi: listDetailKomisi,
          isLoading: false,
        );
      },
    );
  }
}

class _DetailKomisiBuilder extends StatelessWidget {
  const _DetailKomisiBuilder({
    required this.listDetailKomisi,
    required this.isLoading,
  });

  final List<DetailKomisi> listDetailKomisi;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: isLoading ? 1 : listDetailKomisi.length,
      itemBuilder: (context, index) {
        final detailKomisi = isLoading ? null : listDetailKomisi[index];
        return _DetailKomisiItem(detailKomisi: detailKomisi);
      },
    );
  }
}

class _DetailKomisiItem extends StatelessWidget {
  const _DetailKomisiItem({required this.detailKomisi});

  final DetailKomisi? detailKomisi;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                indent: 12,
                endIndent: 24,
                color: AppColors.divider,
              ),
            ),
            Text(
              detailKomisi?.tahun.toString() ?? "####",
              style: AppTextStyles.bodySmall.apply(
                color: AppColors.divider,
              ),
            ),
            const Expanded(
              child: Divider(
                indent: 24,
                endIndent: 12,
                color: AppColors.divider,
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: detailKomisi?.listQanun.length ?? 3,
          itemBuilder: (context, index) {
            if (detailKomisi == null) return const _LoadingQanunItem();

            final qanun = detailKomisi!.listQanun[index];
            return QanunItem(
              qanun: qanun,
              isDetailKomisi: true,
            );
          },
        ),
      ],
    );
  }
}

class _LoadingQanunItem extends StatelessWidget {
  const _LoadingQanunItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.loading,
        borderRadius: AppRadius.small,
      ),
    );
  }
}

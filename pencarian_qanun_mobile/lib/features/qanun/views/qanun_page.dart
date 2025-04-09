import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/viewmodels/qanun_viewmodel.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_radius.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QanunPage extends StatefulWidget {
  const QanunPage({super.key});

  @override
  State<QanunPage> createState() => _QanunPageState();
}

class _QanunPageState extends State<QanunPage> {
  late Future<Qanun> _future;

  AppBar _buildAppBar(bool isReady) {
    return AppBar(
      foregroundColor: AppColors.accent,
      backgroundColor: AppColors.background,
      actions: _buildAppBarActions(isReady),
    );
  }

  List<Widget> _buildAppBarActions(bool isReady) {
    if (!isReady) return [];

    final viewModel = context.read<QanunViewmodel>();
    final isDownloaded = context.select<QanunViewmodel, bool>((viewModel) {
      return viewModel.isDownloaded!;
    });

    return [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.star_outline),
      ),
      IconButton(
        onPressed: isDownloaded ? null : viewModel.downloadQanun,
        icon: Icon(
          isDownloaded
              ? Icons.download_for_offline
              : Icons.file_download_outlined,
          color: isDownloaded ? Colors.green.shade400 : null,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _future = context.read<QanunViewmodel>().getDetailQanun();
  }

  @override
  Widget build(BuildContext context) {
    final qanun = context.watch<QanunViewmodel>().selectedQanun!;

    return Scaffold(
      appBar: _buildAppBar(qanun.details != null),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12),
            child: Text(
              qanun.nama,
              style: AppTextStyles.headlineMedium,
            ),
          ),
          SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: qanun.details?.tags.length ?? 3,
              itemBuilder: (context, index) {
                if (qanun.details == null) return const _LoadingTagItem();
                final tag = qanun.details!.tags[index];
                return _TagItem(tag: tag);
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError || snapshot.data?.details == null) {
                  return const Center(
                    child: Text("Terjadi kesalahan"),
                  );
                }

                return SfPdfViewer.network(qanun.downloadUrl!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TagItem extends StatelessWidget {
  const _TagItem({required this.tag});
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: AppRadius.full,
      ),
      child: Center(
        child: Text(
          tag,
          style: const TextStyle(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _LoadingTagItem extends StatelessWidget {
  const _LoadingTagItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: AppColors.loading,
        borderRadius: AppRadius.full,
      ),
    );
  }
}

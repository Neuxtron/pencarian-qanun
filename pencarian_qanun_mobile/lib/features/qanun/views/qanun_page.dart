import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/repositories/qanun_repository.dart';
import 'package:pencarian_qanun_mobile/core/utils/app_constants.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_radius.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QanunPage extends StatefulWidget {
  const QanunPage({super.key});

  @override
  State<QanunPage> createState() => _QanunPageState();
}

class _QanunPageState extends State<QanunPage> {
  late Qanun _qanun;
  final _repository = QanunRepository();

  bool _isLoading = true;

  _getDetails() async {
    final qanun = await _repository.getDetailQanun(_qanun.id);
    if (qanun != null) _qanun = qanun;
    setState(() => _isLoading = false);
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: AppColors.accent,
      backgroundColor: AppColors.background,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.star_outline),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      _qanun = ModalRoute.of(context)!.settings.arguments as Qanun;
      _repository.readQanun(_qanun);
      _getDetails();
    }

    final fullUrl =
        "${AppConstants.baseUrl}/qanun/${_qanun.id} - ${_qanun.details?.namaFile}";
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12),
            child: Text(
              _qanun.nama,
              style: AppTextStyles.headlineMedium,
            ),
          ),
          SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: _qanun.details?.tags.length ?? 3,
              itemBuilder: (context, index) {
                if (_qanun.details == null) return const _LoadingTagItem();
                final tag = _qanun.details!.tags[index];
                return _TagItem(tag: tag);
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _DetailsHandler(
              isLoading: _isLoading,
              details: _qanun.details,
              child: SfPdfViewer.network(fullUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsHandler extends StatelessWidget {
  const _DetailsHandler({
    required this.details,
    required this.child,
    required this.isLoading,
  });

  final bool isLoading;
  final DetailQanun? details;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (details == null) {
      return const Center(
        child: Text("Terjadi kesalahan"),
      );
    }

    return child;
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

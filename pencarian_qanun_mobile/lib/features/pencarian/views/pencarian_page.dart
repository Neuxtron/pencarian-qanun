import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/services/database_service.dart';
import 'package:pencarian_qanun_mobile/features/pencarian/views/hasil_pencarian_page.dart';
import 'package:pencarian_qanun_mobile/features/pencarian/widgets/search_input.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';

class PencarianPage extends StatefulWidget {
  const PencarianPage({super.key});

  @override
  State<PencarianPage> createState() => _PencarianPageState();
}

class _PencarianPageState extends State<PencarianPage> {
  late DatabaseService _databaseService;
  String? _searchText;

  _handleSearch(String? text) {
    if (text != null) _databaseService.addRiwayatPencarian(text);
    setState(() => _searchText = text);
  }

  _handleHapusRiwayatPencarian() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            "Apakah Anda ingin menghapus riwayat pencarian?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Batal",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.caption,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Hapus",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (!confirm) return;
    await _databaseService.hapusRiwayatPencarian();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
  }

  @override
  Widget build(BuildContext context) {
    if (_searchText != null) {
      return HasilPencarianPage(
        searchText: _searchText!,
        onSearch: _handleSearch,
      );
    }

    return Column(
      children: [
        SearchInput(
          onSearch: _handleSearch,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pencarian terakhir",
                style: TextStyle(
                  color: AppColors.caption,
                ),
              ),
              InkWell(
                onTap: _handleHapusRiwayatPencarian,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        "Hapus",
                        style: AppTextStyles.bodyMedium.apply(
                          color: AppColors.caption,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.close,
                        color: AppColors.caption,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: _databaseService.getRiwayatPencarian(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            final listRiwayatPencarian = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listRiwayatPencarian.length,
              itemBuilder: (context, index) {
                final text = listRiwayatPencarian[index];
                return InkWell(
                  onTap: () => setState(() => _searchText = text),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.history),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              text,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_outward),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/features/pencarian/repositories/pencarian_repository.dart';
import 'package:pencarian_qanun_mobile/features/pencarian/widgets/search_input.dart';
import 'package:pencarian_qanun_mobile/shared/widgets/qanun_item.dart';
import 'package:pencarian_qanun_mobile/shared/widgets/snapshot_handler.dart';

class HasilPencarianPage extends StatelessWidget {
  const HasilPencarianPage({
    super.key,
    required this.searchText,
    required this.onSearch,
  });

  final String searchText;
  final Function(String? text) onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchInput(
          defaultText: searchText,
          onSearch: onSearch,
        ),
        FutureBuilder(
          future: PencarianRepository().searchQanun(searchText),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SnapshotHandler(snapshot: snapshot);
            }
    
            final listQanun = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: listQanun.length,
              itemBuilder: (context, index) {
                final qanun = listQanun[index];
                return QanunItem(
                  qanun: qanun,
                  isDetailKomisi: false,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

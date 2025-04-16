import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/viewmodels/qanun_viewmodel.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/widgets/qanun_item.dart';
import 'package:pencarian_qanun_mobile/shared/widgets/snapshot_handler.dart';
import 'package:provider/provider.dart';

class DibintangPage extends StatelessWidget {
  const DibintangPage({super.key});

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
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: AppColors.primary.withOpacity(.3),
                    size: 64,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Dibintang",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary.withOpacity(.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              FutureBuilder(
                future: context.read<QanunViewmodel>().getQanunDibintang(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SnapshotHandler(snapshot: snapshot);
                  }

                  final listQanun = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
          ),
        ),
      ),
    );
  }
}

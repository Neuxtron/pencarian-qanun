import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/viewmodels/qanun_viewmodel.dart';
import 'package:pencarian_qanun_mobile/routes.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_radius.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';
import 'package:provider/provider.dart';

class QanunItem extends StatelessWidget {
  const QanunItem({
    super.key,
    required this.qanun,
    required this.isDetailKomisi,
  });

  final Qanun qanun;
  final bool isDetailKomisi;

  @override
  Widget build(BuildContext context) {
    final nomorString = qanun.nomor.toString().padLeft(2, "0");
    final subtitleLeading =
        isDetailKomisi ? "" : "Komisi ${qanun.komisi!.nomorRomawi} ";

    return Container(
      height: 64,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.small,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<QanunViewmodel>().selectQanun(qanun);
            Navigator.pushNamed(context, Routes.qanun);
          },
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ColoredBox(
                  color: AppColors.primary,
                  child: Center(
                    child: Text(
                      isDetailKomisi ? nomorString : qanun.komisi!.nomorRomawi,
                      style: AppTextStyles.headlineLarge.apply(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(qanun.nama),
                            Text(
                              "$subtitleLeading${qanun.tahun} No. ${qanun.nomor}",
                              style: const TextStyle(color: AppColors.caption),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/repositories/qanun_repository.dart';
import 'package:pencarian_qanun_mobile/shared/utils/app_utils.dart';

class QanunViewmodel extends ChangeNotifier {
  final _repository = QanunRepository();

  Qanun? _selectedQanun;
  bool? _isDownloaded;

  Qanun? get selectedQanun => _selectedQanun;
  bool? get isDownloaded => _isDownloaded;

  Future selectQanun(Qanun? qanun) async {
    _selectedQanun = qanun!;
    _repository.readQanun(qanun);
  }

  Future<Qanun> getDetailQanun() async {
    _selectedQanun!.details =
        await _repository.getDetailQanun(_selectedQanun!.id);
    _isDownloaded = await _repository.checkIsDownloaded(_selectedQanun!.id);
    notifyListeners();
    return _selectedQanun!;
  }

  Future downloadQanun() async {
    if (_selectedQanun?.details == null) return;

    AppUtils.showToast("Mengunduh qanun...");
    final success = await _repository.downloadQanun(_selectedQanun!);
    if (success) {
      AppUtils.showToast("Berhasil mengunduh qanun");
      _isDownloaded = true;
      notifyListeners();
    } else {
      AppUtils.showToast("Gagal mengunduh qanun");
    }
  }
}

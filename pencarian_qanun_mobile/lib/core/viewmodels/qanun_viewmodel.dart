import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/qanun.dart';
import 'package:pencarian_qanun_mobile/core/providers/connection_mode_provider.dart';
import 'package:pencarian_qanun_mobile/core/repositories/qanun_repository.dart';
import 'package:pencarian_qanun_mobile/core/services/database_service.dart';
import 'package:pencarian_qanun_mobile/shared/utils/app_utils.dart';
import 'package:provider/provider.dart';

class QanunViewmodel extends ChangeNotifier {
  late BuildContext context;

  final _repository = QanunRepository();

  Qanun? _selectedQanun;
  bool? _isDownloaded;

  Qanun? get selectedQanun => _selectedQanun;
  bool? get isDownloaded => _isDownloaded;
  ConnectionModeProvider get _modeProvider =>
      context.read<ConnectionModeProvider>();

  Future selectQanun(Qanun? qanun) async {
    _selectedQanun = qanun!;
    _repository.readQanun(qanun);
  }

  Future<Qanun> getDetailQanun() async {
    if (_modeProvider.isOnline) {
      _selectedQanun!.details =
          await _repository.getDetailQanun(_selectedQanun!.id);
    } else {
      _selectedQanun!.details = await _getOfflineDetailQanun();
    }
    _isDownloaded = await _repository.checkIsDownloaded(_selectedQanun!.id);
    notifyListeners();
    return _selectedQanun!;
  }

  void downloadQanun(BuildContext context) {
    AppUtils.showSnackbar(context, "Mengunduh qanun...");
    _repository.downloadQanun(_selectedQanun!).then((success) {
      if (success) {
        AppUtils.showSnackbar(context, "Berhasil mengunduh qanun");
        _isDownloaded = true;
        notifyListeners();
      } else {
        AppUtils.showSnackbar(context, "Gagal mengunduh qanun");
      }
    });
  }

  Future<List<Qanun>> getRiwayatQanun() async {
    return _repository.getRiwayatQanun();
  }

  Future<DetailQanun> _getOfflineDetailQanun() async {
    _modeProvider.isOnline = false;
    final qanunJson =
        await DatabaseService().getDetailQanun(_selectedQanun!.id);
    return Qanun.fromDatabase(qanunJson).details!;
  }
}

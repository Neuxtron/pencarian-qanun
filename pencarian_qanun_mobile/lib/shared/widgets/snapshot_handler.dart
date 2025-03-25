import 'dart:developer';

import 'package:flutter/material.dart';

class SnapshotHandler extends StatelessWidget {
  const SnapshotHandler({
    super.key,
    required this.snapshot,
    this.errorView,
    this.loadingView,
  });

  final AsyncSnapshot snapshot;
  final Widget? errorView;
  final Widget? loadingView;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loadingView ?? const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      log(snapshot.error.toString());
      return errorView ?? const Text("Terjadi kesalahan");
    }
    return const SizedBox();
  }
}

import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_radius.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    required this.onSearch,
    this.defaultText,
  });

  final Function(String? text) onSearch;
  final String? defaultText;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.defaultText ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      padding: const EdgeInsets.only(left: 18),
      decoration: BoxDecoration(
        color: AppColors.input,
        border: Border.all(color: AppColors.primary),
        borderRadius: AppRadius.full,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Cari Qanun...",
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          widget.defaultText != null ? IconButton(
            onPressed: () => widget.onSearch(null),
            icon: const Icon(Icons.close),
          ) : const SizedBox(),
          SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              onPressed: () {
                widget.onSearch(_controller.text.trim());
              },
              color: Colors.white,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.primary),
              ),
              icon: const Icon(Icons.search, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

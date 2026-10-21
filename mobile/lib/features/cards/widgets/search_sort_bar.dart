import 'package:flutter/material.dart';

class SearchSortBar<T> extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearchChanged;
  final List<T> sortOptions;
  final T selectedSort;
  final String Function(T option) sortLabel;
  final ValueChanged<T> onSortChanged;

  const SearchSortBar({
    super.key,
    required this.hintText,
    required this.onSearchChanged,
    required this.sortOptions,
    required this.selectedSort,
    required this.sortLabel,
    required this.onSortChanged,
  });

  @override
  State<SearchSortBar<T>> createState() => _SearchSortBarState<T>();
}

class _SearchSortBarState<T> extends State<SearchSortBar<T>> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clear() {
    _searchController.clear();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ListenableBuilder(
                  listenable: _searchController,
                  builder: (context, _) => _searchController.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close),
                    onPressed: _clear,
                  ),
                ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<T>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            initialValue: widget.selectedSort,
            onSelected: widget.onSortChanged,
            itemBuilder: (context) => [
              for (final option in widget.sortOptions)
                CheckedPopupMenuItem<T>(
                  value: option,
                  checked: option == widget.selectedSort,
                  child: Text(widget.sortLabel(option)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
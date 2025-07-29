import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SearchWidget extends ConsumerStatefulWidget {
  final String value;
  final Function(String value) onValueSearched;

  const SearchWidget({
    super.key,
    required this.onValueSearched,
    required this.value,
  });

  @override
  SearchWidgetState createState() => SearchWidgetState();
}
class SearchWidgetState extends ConsumerState<SearchWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Buscar per nom',
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search_outlined),
                  ),
                ),
                onChanged: widget.onValueSearched,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

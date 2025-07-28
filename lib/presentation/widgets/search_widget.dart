import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchWidget extends ConsumerStatefulWidget {
  final Function(String value) onValueSearched;

  const SearchWidget({super.key, required this.onValueSearched});

  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends ConsumerState<SearchWidget> {
  late String valueToSearch;

  @override
  void initState() {
    super.initState();
    valueToSearch = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name',
                          suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.search_outlined)),
                        ),
                        onChanged: (value) {
                          widget.onValueSearched(value);
                        },
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

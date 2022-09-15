import 'package:flutter/material.dart';
import 'package:rx_dart_practice_api/bloc/search_result.dart';
import 'package:rx_dart_practice_api/models/animal.dart';
import 'package:rx_dart_practice_api/models/person.dart';

class SearchResultView extends StatelessWidget {
  final Stream<SearchResult?> searchResult;
  const SearchResultView({Key? key, required this.searchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: searchResult,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          print("This is result $result");

          if (result is SearchResultHasError) {
            return const Text("Got error");
          } else if (result is SearchResultLoading) {
            return const CircularProgressIndicator();
          } else if (result is SearchResultNoResults) {
            return const Text("No result found, try another term!");
          } else if (result is SearchResultWithResults) {
            final results = result.results;

            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final String title;
                  if (item is Animal) {
                    title = "ANIMAL";
                  } else if (item is Person) {
                    title = "PERSON";
                  } else {
                    title = "UNKNOWN";
                  }
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(item.toString()),
                  );
                },
              ),
            );
          } else {
            return const Text("Unknown state");
          }
        } else {
          return const Text("waiting....");
        }
      },
    );
  }
}

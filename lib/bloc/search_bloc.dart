import 'package:flutter/foundation.dart';
import 'package:rx_dart_practice_api/bloc/api.dart';
import 'package:rx_dart_practice_api/bloc/search_result.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> result;

  void dispose() {
    search.close();
  }

  factory SearchBloc({required Api api}) {
    final textChanges = BehaviorSubject<String>();
    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((String searchTerm) {
      if (searchTerm.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(seconds: 1))
            .map(
              (results) => results.isEmpty
                  ? SearchResultNoResults()
                  : SearchResultWithResults(results),
            )
            .startWith(
              const SearchResultLoading(),
            )
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
        // print("search result error ${error.toString()}");

      }
    });

    return SearchBloc._(search: textChanges.sink, result: results);
  }
  const SearchBloc._({
    required this.search,
    required this.result,
  });
}

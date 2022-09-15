import 'package:flutter/foundation.dart';
import 'package:rx_dart_practice_api/models/thing.dart';

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {
  const SearchResultLoading();
}

class SearchResultNoLoading implements SearchResult {
  const SearchResultNoLoading();
}

class SearchResultHasError implements SearchResult {
  final Object error;
  const SearchResultHasError(this.error);
}

class SearchResultWithResults implements SearchResult {
  final List<Thing> results;

  SearchResultWithResults(this.results);
}

class SearchResultNoResults implements SearchResult {
  // final List<Thing> results;

  SearchResultNoResults();
}

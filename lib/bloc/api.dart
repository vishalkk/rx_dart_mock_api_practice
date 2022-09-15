import 'dart:convert';
import 'dart:io';

import 'package:rx_dart_practice_api/models/animal.dart';
import 'package:rx_dart_practice_api/models/person.dart';
import 'package:rx_dart_practice_api/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();
    //search in cache
    final cacheResult = _extractThingsUsingSearchTearm(term);

    if (cacheResult != null) {
      return cacheResult;
    }

    //we dont have value cached
    //lets call the api Person
    final persons = await _getJson('http://127.0.0.1:5500/api/persons.json')
        .then((json) => json.map((value) => Person.fromJson(value)));

    _persons = persons.toList();

    //lets call the api Person
    final animal = await _getJson("http://127.0.0.1:5500/api/animals.json")
        .then((json) => json.map((value) => Animal.fromJson(value)));

    _animals = animal.toList();

    return _extractThingsUsingSearchTearm(term) ?? [];
  }

  List<Thing>? _extractThingsUsingSearchTearm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;

    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];
      //search in animal
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) ||
            animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }
      //search in persom
      for (final person in cachedPersons) {
        if (person.name.trimmedContains(term) ||
            person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }

      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsensitiveContained on String {
  bool trimmedContains(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}

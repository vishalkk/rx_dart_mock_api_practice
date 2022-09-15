import 'package:flutter/material.dart';
import 'package:rx_dart_practice_api/bloc/api.dart';
import 'package:rx_dart_practice_api/bloc/search_bloc.dart';
import 'package:rx_dart_practice_api/view/search_result_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SearchBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(api: Api());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration:
                    const InputDecoration(hintText: "Enter your search term"),
                onChanged: _bloc.search.add,
              ),
              const SizedBox(
                height: 10,
              ),
              SearchResultView(searchResult: _bloc.result)
            ],
          ),
        ));
  }
}

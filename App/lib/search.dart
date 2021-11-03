import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;

extension StringCasingExtension on String {
  String toCapitalized() =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String toTitleCase() => this
      .replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(" ");
}

class SearchPage extends StatefulWidget {
  final Function callback;
  SearchPage(this.callback);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const historyLength = 5;

  List<String> _searchHistory = [
    'Brown Tailed Mynah',
    'Blue Jay',
    'Black Hawk',
    'Chinese Yellow Sparrow',
  ];

  late List<String> filteredSearchHistory;

  String? selectedTerm;

  List<String> filterSearchTerms({
    @required String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: controller,
      body: FloatingSearchBarScrollNotifier(
        child: SearchResultsListView(
          searchTerm: selectedTerm,
        ),
      ),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      hint: 'Search for a specific bird',
      actions: [
        FloatingSearchBarAction.searchToClear(),
      ],
      onQueryChanged: (query) {
        setState(() {
          filteredSearchHistory = filterSearchTerms(filter: query);
        });
      },
      onSubmitted: (query) async {
        setState(() {
          addSearchTerm(query);
          selectedTerm = query;
        });
        // @Bryan
        QuerySnapshot snap =
            await FirebaseFirestore.instance.collection('AllBirdInfo').get();

        query = query.toLowerCase().toTitleCase();

        snap.docs.forEach((doc) {
          // globals.slide_spec_bird = doc;
          if (doc["name"] == query) {
            globals.slide_spec_bird = doc;
            widget.callback();
          }
        });

        // var document = await FirebaseFirestore.instance
        //     .collection('AllBirdInfo')
        //     .doc(query)
        //     .get();

        // final url = document.get("wikiurl");
        // if (await canLaunch(url))
        //   await launch(url);
        // else
        //   // can't launch url, there is some error
        //   throw "Could not launch $url";

        controller.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: Builder(
              builder: (context) {
                if (filteredSearchHistory.isEmpty && controller.query.isEmpty) {
                  return Container(
                    height: 56,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Start searching',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                } else if (filteredSearchHistory.isEmpty) {
                  return ListTile(
                    title: Text(controller.query),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      setState(() {
                        addSearchTerm(controller.query);
                        selectedTerm = controller.query;
                      });
                      controller.close();
                    },
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filteredSearchHistory
                        .map(
                          (term) => ListTile(
                            title: Text(
                              term,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: const Icon(Icons.history),
                            trailing: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  deleteSearchTerm(term);
                                });
                              },
                            ),
                            onTap: () {
                              setState(() async {
                                putSearchTermFirst(term);

                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection('AllBirdInfo')
                                    .get();

                                selectedTerm = term.toLowerCase().toTitleCase();
                                snap.docs.forEach((doc) {
                                  // globals.slide_spec_bird = doc;
                                  if (doc["name"] == selectedTerm) {
                                    globals.slide_spec_bird = doc;
                                    widget.callback();
                                  }
                                });
                              });
                              controller.close();
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String? searchTerm;

  const SearchResultsListView({
    Key? key,
    required this.searchTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchTerm == null) {
      return Container();
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context)!.style;

    // IMPLEMENT BACKEND LOGIC, CALL TO SHOW SPECIFIC BIRD
    // if (searchTerm == birdName) {
    //    LOGIC i.e. CALL SHOW SPECIFIC BIRD FUNCTION
    // }
    return Container();
    ListView(
      padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
      children: List.generate(
        50,
        (index) => ListTile(
          title: Text('$searchTerm search result'),
          subtitle: Text(index.toString()),
          onTap: () {},
        ),
      ),
    );
  }
}



/*
Widget buildFloatingSearchBar() {
  return FloatingSearchBar(
    hint: 'Search...',
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: 0.0,
    openAxisAlignment: 0.0,
    width: 600,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Colors.accents.map((color) {
              return Container(height: 112, color: color);
            }).toList(),
          ),
        ),
      );
    },
  );
}
*/
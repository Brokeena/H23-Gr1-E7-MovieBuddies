import 'package:cinechooser/utils/top_buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:flutter/foundation.dart';
import 'package:cinechooser/utils/movie_carte.dart';
import 'package:cinechooser/utils/bottom_buttons_row.dart';
import '../utils/app_styles.dart';
import '../utils/carte_overlay.dart';
import 'package:cinechooser/api/movie.dart';
import 'package:cinechooser/api/api.dart';
import 'package:cinechooser/main.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({Key? key}) : super(key: key);

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {

  final controller = SwipableStackController();

  late final SwipableStackController _controller;

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();

    _controller = SwipableStackController()..addListener(_listenController);
    _asyncMethod();
  }

  _asyncMethod() async {
    displayedMovies = await getTrendingMovies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("here");
    double width = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            const TopButtonsRow(),
            SwipableStack(
              detectableSwipeDirections: const {
                SwipeDirection.right,
                SwipeDirection.left,
              },
              controller: _controller,
              stackClipBehaviour: Clip.none,
              onSwipeCompleted: (index, direction) {
                if (kDebugMode) {
                  print('$index, $direction'); //debug
                }
              },
              builder: (context, properties) {
                final indexMovie = properties.index % (displayedMovies.length+1);

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Center(
                        child: SizedBox(
                          height: heigth * 0.65,
                          width: width * 0.9,
                          child: Cartes(
                            name: displayedMovies.elementAt(indexMovie).nom,
                            genres: displayedMovies
                                .elementAt(indexMovie)
                                .genres
                                .toString(),
                            poster:
                                displayedMovies.elementAt(indexMovie).poster,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            BottomButtonsRow(
              onSwipe: (direction) {
                _controller.next(swipeDirection: direction);
              },
              onRewindTap: _controller.rewind,
              canRewind: _controller.canRewind,
            ),
          ],
        ),
      ),
    );
  }
}

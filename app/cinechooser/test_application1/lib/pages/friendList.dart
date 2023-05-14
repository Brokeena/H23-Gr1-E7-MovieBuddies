import 'package:cinechooser/pages/reglages.dart';
import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../widget/friend.dart';
import 'login_page.dart';

List<String> pseudos = [];

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Scaffold build(BuildContext context) {
    getFriendsPseudo() async {
      for (var friendId in friendList) {
        var data = await db.doc(friendId).get();
        var pseudo1 = await data['pseudo'];
        pseudos.add(pseudo1);
      }
      return pseudos;
    }

    double width = MediaQuery.of(context).size.width;
    print('friendsList :$friendList');
    return Scaffold(
        backgroundColor: Styles.bgColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Friends', style: Styles.entete),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Reglages()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: FutureBuilder(
                future: getFriendsPseudo(),
                builder: (context, snaphot) {
                  if (snaphot.hasData) {
                    return Wrap(
                        spacing: width / 16,
                        runSpacing: width / 16,
                        direction: Axis.vertical,
                        children: List.generate(friendList.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Friend(index: index),
                          );
                        }));
                  } else {
                    return const CircularProgressIndicator();
                  }
                })));
  }
}

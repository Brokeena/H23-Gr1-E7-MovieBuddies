
import 'package:cinechooser/pages/Connexions/auth_page.dart';
import 'package:cinechooser/utils/loading_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinechooser/utils/app_styles.dart';
import 'package:cinechooser/main.dart';
import '../../widget/MovieCase.dart';
import 'package:cinechooser/pages/Connexions/login_page.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

double tailleBordure = 0;

List<String> imageGenre = [
  'android/assets/images/genre1.png',
  'android/assets/images/genre2.png',
  'android/assets/images/genre3.png',
  'android/assets/images/genre4.png',
  'android/assets/images/genre5.png',
  'android/assets/images/genre6.png',
  'android/assets/images/genre7.png',
  'android/assets/images/genre8.png',
  'android/assets/images/genre9.png',
  'android/assets/images/genre10.png',
  'android/assets/images/genre11.png',
  'android/assets/images/genre12.png',
  'android/assets/images/genre13.png',
  'android/assets/images/genre14.png',
  'android/assets/images/genre15.png',
  'android/assets/images/genre16.png',
  'android/assets/images/genre17.png',
  'android/assets/images/genre18.png',
];

class Choix extends StatefulWidget {
  const Choix({Key? key}) : super(key: key);

  @override
  State<Choix> createState() => _ChoixState();
}

Future getDocId() async {
  List<String> docIDs = [];
  await FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((snapshot) => snapshot.docs.forEach((document) {
            docIDs.add(document.reference.id);
          }));
  return docIDs;
}

Future deleteUser() async {
//delete the just created user
}

class _ChoixState extends State<Choix> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthPage()),
            );
            deleteUser();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (listGenre.length >= 3) {
                  firstTime = true;
                  db.doc(docID).update({'genres': listGenre});
                  db.doc(docID).update({'firstTime': true});
                  initiateALl();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoadingPageRegister()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(width / 6, height / 50),
                  elevation: 0,
                  backgroundColor: Styles.red1,
                  shape: const StadiumBorder()),
              child: const Text('Next', style: Styles.bouton3),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: width / 16, left: width / 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome to Cinechooser',
                    style: Styles.nom_de_pages),
                const Divider(height: 10),
                const Text('Pick 3 genres or more ',
                    style: Styles.informations),
                const Divider(height: 25),
                Wrap(
                    spacing: width / 16,
                    runSpacing: width / 16,
                    direction: Axis.horizontal,
                    children: List.generate(idGenre.length, (index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectionne[index]) {
                                listGenre.add(idGenre[index]);
                                colors[index] = Colors.white;
                                selectionne[index] = false;
                              } else {
                                listGenre.remove(idGenre[index]);
                                colors[index] = Colors.transparent;
                                selectionne[index] = true;
                              }
                            });
                          },
                          child: MovieCase(
                              nom: nomGenre[index],
                              image: imageGenre[index],
                              color: colors[index]));
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

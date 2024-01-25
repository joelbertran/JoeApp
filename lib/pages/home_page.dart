import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginapp/pages/chat_page.dart';
import 'package:loginapp/services/auth_service.dart';
import 'package:provider/provider.dart';

//les couleurs que nous allons utiliser dans notre code
const degreen = Color(0xFF00BFA5);
const dewhite = Colors.white;
const deblack = Colors.black;
const deblue = Color(0xFF01579B);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign user out
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deblack,
        //icons a gauche
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: dewhite,
            size: 32,
          ),
        ),

        actions: [
          // sign out button
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            color: dewhite,
          ),
        ],
      ),
      body: Column(
        children: [
          //Pour creer les differents section
          MenuSection(),
          FavoriteSection(),

          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
      // button float
      floatingActionButton: FloatingActionButton(
        backgroundColor: deblue, //coleur du creon(floattannt)
        onPressed: () {},
        child: const Icon(
          Icons.edit,
          size: 32,
        ),
      ),
    );
  }

  // build a list of users execpt for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all user except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          // afficher l'uid de tous les utilisateurs cliques sur la page de discution
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }
}

class MenuSection extends StatelessWidget {
  final List menuItems = ['Message', 'Onligne', 'Groupe', 'Colls'];
  MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: deblack,
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(15),
          //ajoutter les points
          child: Row(
            //appele la fonction final MenuSection
            children: menuItems.map((items) {
              return Container(
                margin: const EdgeInsets.only(right: 55),
                child: Text(
                  items,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 23,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class FavoriteSection extends StatelessWidget {
  FavoriteSection({super.key});

  final List favoriteContacts = [
    {'name': 'email', 'profil': ''},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: deblack,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 20), // separation du contenu a l'interieur
        decoration: const BoxDecoration(
          color: deblue,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Favoritewhile contacts',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            // Pour afficher et scroller le menu 2
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: favoriteContacts.map((favorite) {
                  return Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            color: dewhite,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(favorite['profil'])),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          favorite[
                              'name'], // appel des nom sur 1 menu des favorite
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

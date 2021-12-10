import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/fav/favorite_page.dart';
import 'package:cars/pages/login/login_page.dart';
import 'package:cars/pages/login/user.dart';
import 'package:cars/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<FirebaseUser> future = FirebaseAuth.instance.currentUser();
    return Drawer(
      child: ListView(
        children: [
          // FlutterLogo(size: 50,),
          FutureBuilder<FirebaseUser>(
              future: future,
              builder: (context, snapshot){
                FirebaseUser user = snapshot.data;
                return user != null ? _header(user) : Container();
              }),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Favoritos"),
            subtitle: Text("Adicione aos favoritos"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              push(context, FavoritePage());
            }
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Ajuda"),
            subtitle: Text("Selecione para obter ajuda"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sair"),
            subtitle: Text("Selecione para fazer Logout"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => _onClickLogout(context),
          ),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader _header(FirebaseUser user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.displayName ?? ""),
      accountEmail: Text(user.email),
      currentAccountPicture: user.photoUrl != null ? CircleAvatar(
        backgroundImage: NetworkImage(user.photoUrl),
      ) : FlutterLogo(),
    );
  }

  _onClickLogout(BuildContext context) {
    Users.clear();
    FirebaseService().logout();
    Navigator.pop(context);
    push(context, LoginPage(), replace: true);
  }
}

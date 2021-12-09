import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/fav/favorite_page.dart';
import 'package:cars/pages/login/login_page.dart';
import 'package:cars/pages/login/user.dart';
import 'package:cars/utils/nav.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> future = User.get();
    return Drawer(
      child: ListView(
        children: [
          // FlutterLogo(size: 50,),
          FutureBuilder<User>(
              future: future,
              builder: (context, snapshot){
                User user = snapshot.data;
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

  UserAccountsDrawerHeader _header(User user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.nome),
      accountEmail: Text(user.email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(user.urlFoto),
      ),
    );
  }

  _onClickLogout(BuildContext context) {
    User.clear();
    FirebaseService().logout();
    Navigator.pop(context);
    push(context, LoginPage(), replace: true);
  }
}

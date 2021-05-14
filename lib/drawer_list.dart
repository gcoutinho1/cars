import 'package:cars/pages/login_page.dart';
import 'package:cars/utils/nav.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // FlutterLogo(size: 50,),
          UserAccountsDrawerHeader(
              accountName: Text("Guilherme Coutinho"),
              accountEmail: Text("guilherme@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://cdn.imgbin.com/3/12/17/imgbin-computer-icons-avatar-user-login-avatar-man-wearing-blue-shirt-illustration-mJrXLG07YnZUc2bH5pGfFKUhX.jpg"),
              ),

          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Favoritos"),
            subtitle: Text("Adicione aos favoritos"),
            trailing: Icon(Icons.arrow_forward),
            onTap: (){
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Ajuda"),
            subtitle: Text("Selecione para obter ajuda"),
            trailing: Icon(Icons.arrow_forward),
            onTap: (){
            },
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

  _onClickLogout(BuildContext context) {
    Navigator.pop(context);
    push(context, LoginPage(), replace: true);
  }
}

import 'dart:html';

import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/login/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

String firebaseUserUid;

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse> login(String email, String senha) async {
    // final User user = _auth.currentUser;
    try {
      // Login no Firebase
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      final User fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");
      saveUser(fUser);

      // Cria um usuario do app
      final user = Users(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoURL,
      );
      user.save();

      // Salva no Firestore
      saveUser(fUser);

      // Resposta genérica
      return ApiResponse.working();
    } catch (error) {
      print("Firebase error ");
      return ApiResponse.error(message: "Não foi possível fazer o login");
    }
  }

  Future<ApiResponse> loginGoogle() async {
    try {
      // Login com o Google
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Google User: ${googleUser.email}");

      // Credenciais para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login no Firebase
      UserCredential result = await _auth.signInWithCredential(credential);
      final User fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");
      // user.save();

      // // Cria um usuario do app
      final user = Users(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoURL,
      );
      //salva o user na api
      user.save();

      // Salva no Firestore
      saveUser(fUser);

      // Resposta genérica
      return ApiResponse.working();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(message: "Não foi possível fazer o login");
    }
  }

  // salva o usuario na collection de usuarios logados no firebase
  // metodo atualizado depois da atualização do flutter + plugins
  // estava utilizando refUser.set no lugar de refUser.update! com o .set nao adicionava os carros nos favoritos de forma separada por usuário.
  static void saveUser(User fUser) async {
    User fUser =  FirebaseAuth.instance.currentUser;
    if (fUser != null) {
      firebaseUserUid = fUser.uid;
      DocumentReference refUser =
          FirebaseFirestore.instance.collection('users').doc(firebaseUserUid);
      refUser.update({
        'nome': fUser.displayName,
        'email': fUser.email,
        'urlPhoto': fUser.photoURL,
      });
    }
  }

  Future<ApiResponse> cadastrar(String nome, String email, String senha) async {
    try {
      // Usuario do Firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      final User fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");

      // Dados para atualizar o usuário
      // final userUpdateInfo = FirebaseAuth.instance.currentUser.updateProfile;
      fUser.updateDisplayName(nome);
      fUser.updatePhotoURL(
              "https://s3-sa-east-1.amazonaws.com/livetouch-temp/livrows/foto.png");

      // Resposta genérica
      return ApiResponse.working(message: "Usuário criado com sucesso");
    } catch (error) {
      print(error);

      if (error is PlatformException) {
        print("Error Code ${error.code}");

        return ApiResponse.error(
            message: "Erro ao criar um usuário.\n\n${error.message}");
      }

      return ApiResponse.error(message: "Não foi possível criar um usuário.");
    }
  }
  // deprecated method
  // static Future<String> uploadFirebaseStorage(File file) async{
  //   print("Upload para o StorageFirebase $file");
  //   String fileName = path.basename(file.path);
  //   final storageRef = FirebaseStorage.instance.ref().child(fileName);
  //
  //   final StorageTaskSnapshot task = await storageRef.putFile(file).whenComplete();
  //   final String urlFoto = await task.ref.getDownloadURL();
  //   return urlFoto;
  // }

  Future<void> logout() async {
    // await FavoriteService().deleteCarros();

    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

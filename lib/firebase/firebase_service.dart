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
      // Login Firebase
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      final User fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");
      saveUser(fUser);

      // Create a user in app
      final user = Users(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoURL,
      );
      user.save();

      // Save in Firestore
      saveUser(fUser);

      // Generic answer
      return ApiResponse.working();
    } catch (error) {
      print("Firebase error ");
      return ApiResponse.error(message: "Não foi possível fazer o login");
    }
  }

  Future<ApiResponse> loginGoogle() async {
    try {
      // Login with Gmail
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Google User: ${googleUser.email}");

      // Credentials for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login Firebase
      UserCredential result = await _auth.signInWithCredential(credential);
      final User fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");
      // user.save();

      // Create an app user
      final user = Users(
        nome: fUser.displayName,
        login: fUser.email,
        email: fUser.email,
        urlFoto: fUser.photoURL,
      );
      // save the user in the api
      user.save();

      // save user in firestore
      saveUser(fUser);

      // Generic answer
      return ApiResponse.working();
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error(message: "Não foi possível fazer o login");
    }
  }

  // salva o usuario na collection de usuarios logados no firebase
  // metodo atualizado depois da atualização do flutter + plugins
  // estava utilizando refUser.set no lugar de refUser.update // com o refUser.set nao adicionava os carros nos favoritos de forma separada por usuário.
  static void saveUser(User fUser) async {
    User fUser = FirebaseAuth.instance.currentUser;
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
      // User of Firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      final User fUser = result.user;
      print("Firebase Nome: ${fUser.displayName}");
      print("Firebase Email: ${fUser.email}");
      print("Firebase Foto: ${fUser.photoURL}");

      // Data to update the user
      // final userUpdateInfo = FirebaseAuth.instance.currentUser.updateProfile;
      fUser.updateDisplayName(nome);
      fUser.updatePhotoURL(
          "https://image.shutterstock.com/image-vector/man-icon-vector-260nw-1040084344.jpg");

      // Generic answer
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

  //TODO: implement uploadFireBaseStorage
  /// https://pub.dev/packages/firebase_storage
  // deprecated method for upload in Firebase Storage bellow
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

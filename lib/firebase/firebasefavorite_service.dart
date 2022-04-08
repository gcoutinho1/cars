import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseFavoriteService {
  // getCars() => _cars.snapshots();
  // code bellow is to save only collection 'carros'
  // get _cars => FirebaseFirestore.instance.collection('carros');
  // to save a colletion inside users in firebase
  get _users => FirebaseFirestore.instance.collection('users');
  //If you logged directly into the login API, save directly to the cars collection
  /**comentei pra fazer um teste, descomentar depois**/
  // get _cars => firebaseUserUid != null ? _users.document(firebaseUserUid).colletion('carros') : FirebaseFirestore.instance.collection('carros');
  get stream => _cars.snapshots();

  CollectionReference get _cars {
    String uid = firebaseUserUid;
    DocumentReference refUser = FirebaseFirestore.instance.collection('users').doc(uid);
    return refUser.collection('carros');
  }

  /**testar sem esse codigo**/
  List<Cars> toList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((document) => Cars.fromMap(document.data()))
        .toList();
  }

  Future<bool> addFavorite(Cars cars) async {
    DocumentReference docRef = _cars.doc("${cars.id}");
    DocumentSnapshot doc = await docRef.get();
    final exists = doc.exists;

    if (exists) {
      // Remove dos favoritos
      docRef.delete();
      print("${cars.nome}, removido dos favoritos");

      return false;
    } else {
      // Adiciona nos favoritos
      docRef.set(cars.toMap());
      print("${cars.nome}, add nos favoritos");

      return true;
    }
  }

  Future<bool> deleteCarsFirebase() async {
    print("Deletado carros do usuário: $firebaseUserUid");

    // delete cars in firebase
    final query = await _cars.get();
    for (DocumentSnapshot doc in query.docs) {
      await doc.reference.delete();
    }
    // delete user reference
    _users.document(firebaseUserUid).delete();
    return true;
  }

  Future<bool> exists(Cars cars) async {
    // busca carro no banco de dados do Firebase
    DocumentReference docRef = _cars.doc("${cars.id}");
    DocumentSnapshot doc = await docRef.get();
    // verifica se o carro já esta adicionado nos favoritos
    final exists = doc.exists;
    return exists;
  }
}

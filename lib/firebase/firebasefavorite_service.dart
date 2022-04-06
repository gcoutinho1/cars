import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseFavoriteService {
  getCars() => _cars.snapshots();
  // get _cars => Firestore.instance.collection('carros');

  CollectionReference get _cars {
    String uid = firebaseUserUid;
    DocumentReference refUser = Firestore.instance.collection("users").document(uid);
    return refUser.collection("carros");
  }

  List<Cars> toList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((document) => Cars.fromMap(document.data))
        .toList();
  }

  Future<bool> addFavorite(Cars cars) async {
    var document = _cars.document("${cars.id}");
    var documentSnapshot = await document.get();
    if (!documentSnapshot.exists){
      print("${cars.nome}, adicionado nos favoritos");
      document.setData(cars.toMap());

      return true;
    } else {
      print("${cars.nome}, removido dos favoritos");
      document.delete();

      return false;
    }
  }

  Future<bool> exists(Cars cars) async {
    // busca carro no banco de dados do Firebase
    var document = _cars.document("${cars.id}");
    var documentSnapshot = await document.get();
    // verifica se o carro já esta adicionado nos favoritos
    return await documentSnapshot.exists;
  }
}

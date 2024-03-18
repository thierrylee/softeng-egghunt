import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softeng_egghunt/data/egg.dart';

abstract class EggsRepository {
  Future<Iterable<Egg>> getEggs();
}

class EggsRepositoryImpl extends EggsRepository {
  EggsRepositoryImpl();

  Iterable<Egg>? _eggList;

  @override
  Future<Iterable<Egg>> getEggs() async {
    if (_eggList != null) {
      return _eggList!;
    }

    FirebaseFirestore.instance.collection("eggs").snapshots().listen((snapshot) {
      _eggList = _toEggList(snapshot.docs);
    });
    _eggList = _toEggList((await FirebaseFirestore.instance.collection("eggs").get()).docs);

    return _eggList!;
  }

  Iterable<Egg> _toEggList(List<DocumentSnapshot<Map<String, dynamic>>> documents) {
    return documents.map((document) {
      if (document.data() == null) return null;
      final eggName = document.data()!["eggName"] as String?;
      final eggValue = document.data()!["eggValue"] as int?;
      final eggDescription = document.data()!["eggDescription"] as String?;
      if (eggName != null && eggValue != null) {
        return Egg(
          eggName: eggName,
          eggValue: eggValue,
          eggDescription: eggDescription ?? "Pas de description pour cet oeuf",
        );
      } else {
        return null;
      }
    }).whereType<Egg>();
  }
}

class EggsRepositoryMock extends EggsRepository {
  EggsRepositoryMock();

  Iterable<Egg>? _eggList;

  @override
  Future<Iterable<Egg>> getEggs() async {
    _eggList ??= {
      const Egg(eggName: "testEgg", eggValue: 1, eggDescription: "Un oeuf de test"),
      const Egg(eggName: "mainStage", eggValue: 1, eggDescription: "Sur la scène"),
      const Egg(eggName: "babyfootFoot", eggValue: 1, eggDescription: "Sur le babyfoot"),
      const Egg(eggName: "speakerThisDay", eggValue: 3, eggDescription: "Récompense pour avoir donné un talk"),
    };
    return _eggList!;
  }
}

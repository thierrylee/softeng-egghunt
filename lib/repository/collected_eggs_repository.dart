import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softeng_egghunt/data/collected_egg.dart';
import 'package:softeng_egghunt/score_list/infrastructure/score_list_bloc.dart';

abstract class CollectedEggsRepository {
  void listenOnCollectedEggs(ScoreListBloc listener);

  Future<Iterable<CollectedEgg>> getCollectedEggs();

  Future<void> addCollectedEgg(CollectedEgg collectedEgg);
}

class CollectedEggsRepositoryImpl extends CollectedEggsRepository {
  CollectedEggsRepositoryImpl();

  Iterable<CollectedEgg>? _collectedEggList;

  @override
  void listenOnCollectedEggs(ScoreListBloc listener) async {
    FirebaseFirestore.instance.collection("collectedEggs").snapshots().listen((snapshot) {
      _collectedEggList = _toCollectedEggList(snapshot.docs);
      listener.add(ScoreListUpdateEvent(collectedEggs: _collectedEggList!));
    });
  }

  @override
  Future<Iterable<CollectedEgg>> getCollectedEggs() async {
    return _collectedEggList ?? {};
  }

  @override
  Future<void> addCollectedEgg(CollectedEgg collectedEgg) async {
    await FirebaseFirestore.instance.collection("collectedEggs").add({
      "userName": collectedEgg.userName,
      "eggName": collectedEgg.eggName,
    });
  }


  Iterable<CollectedEgg> _toCollectedEggList(List<DocumentSnapshot<Map<String, dynamic>>> documents) {
    return documents.map((document) {
      if (document.data() == null) return null;
      final eggName = document.data()!["eggName"] as String?;
      final userName = document.data()!["userName"] as String?;
      if (eggName != null && userName != null) {
        return CollectedEgg(eggName: eggName, userName: userName);
      } else {
        return null;
      }
    }).whereType<CollectedEgg>();
  }
}

class CollectedEggsRepositoryMock extends CollectedEggsRepository {
  Iterable<CollectedEgg>? _collectedEggList;
  ScoreListBloc? _listener;

  CollectedEggsRepositoryMock();

  @override
  void listenOnCollectedEggs(ScoreListBloc listener) async {
    listener.add(ScoreListUpdateEvent(collectedEggs: await getCollectedEggs()));
    _listener = listener;
  }

  @override
  Future<Iterable<CollectedEgg>> getCollectedEggs() async {
    _collectedEggList ??= {
      const CollectedEgg(eggName: "testEgg", userName: "LEE"),
      const CollectedEgg(eggName: "mainStage", userName: "LEE"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "LEE"),
      const CollectedEgg(eggName: "mainStage", userName: "SOFT"),
      const CollectedEgg(eggName: "speakerThisDay", userName: "SOFT"),
      const CollectedEgg(eggName: "mainStage", userName: "LOL"),
      const CollectedEgg(eggName: "mainStage", userName: "YOLO"),
      const CollectedEgg(eggName: "unknownEgg", userName: "ZERO"),
      const CollectedEgg(eggName: "mainStage", userName: "UNO"),
      const CollectedEgg(eggName: "mainStage", userName: "XOXO"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "WESH"),
      const CollectedEgg(eggName: "mainStage", userName: "OCTO"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "OCTO"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "RER"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "HELL"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "SONY"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "XBOX"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "PKMN"),
      const CollectedEgg(eggName: "babyfootFoot", userName: "007"),
    };
    return _collectedEggList!;
  }

  @override
  Future<void> addCollectedEgg(CollectedEgg collectedEgg) async {
    if (_collectedEggList != null) {
      final newList = _collectedEggList!.toList(growable: true);
      newList.add(collectedEgg);
      _collectedEggList = newList;
      if (_listener != null) {
        listenOnCollectedEggs(_listener!);
      }
    }
  }
}

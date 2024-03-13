import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softeng_egghunt/repository/collected_eggs_repository.dart';
import 'package:softeng_egghunt/repository/eggs_repository.dart';
import 'package:softeng_egghunt/repository/username_repository.dart';

abstract class EggHuntRepositoryProvider {
  static const _useMock = false;

  static UsernameRepository getUsernameRepository() {
    if (GetIt.instance.isRegistered<UsernameRepository>()) {
      return GetIt.instance.get<UsernameRepository>();
    }

    final repository = UsernameRepository(preferences: SharedPreferences.getInstance());
    GetIt.instance.registerSingleton<UsernameRepository>(repository);
    return repository;
  }

  static EggsRepository getEggsRepository() {
    if (GetIt.instance.isRegistered<EggsRepository>()) {
      return GetIt.instance.get<EggsRepository>();
    }

    final repository = switch (_useMock) {
      true => EggsRepositoryMock(),
      false => EggsRepositoryImpl(),
    };
    GetIt.instance.registerSingleton<EggsRepository>(repository);
    return repository;
  }

  static CollectedEggsRepository getCollectedEggsRepository() {
    if (GetIt.instance.isRegistered<CollectedEggsRepository>()) {
      return GetIt.instance.get<CollectedEggsRepository>();
    }

    final repository = switch (_useMock) {
      true => CollectedEggsRepositoryMock(),
      false => CollectedEggsRepositoryImpl(),
    };
    GetIt.instance.registerSingleton<CollectedEggsRepository>(repository);
    return repository;
  }
}

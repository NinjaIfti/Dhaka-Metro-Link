import 'package:get_it/get_it.dart';
import '../database/database_helper.dart';
import '../utils/data_seeder.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/station_repository.dart';
import '../../domain/repositories/journey_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/card_repository_impl.dart';
import '../../data/repositories/station_repository_impl.dart';
import '../../data/repositories/journey_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Database
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<CardRepository>(
    () => CardRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<StationRepository>(
    () => StationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<JourneyRepository>(
    () => JourneyRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );

  // Utilities
  sl.registerLazySingleton<DataSeeder>(
    () => DataSeeder(
      userRepository: sl(),
      cardRepository: sl(),
      journeyRepository: sl(),
      transactionRepository: sl(),
    ),
  );

  // Seed initial data
  await sl<DataSeeder>().seedInitialData();
}

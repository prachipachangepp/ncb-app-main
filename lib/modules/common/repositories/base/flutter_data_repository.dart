// // we can do this as this function will never be called
// import 'package:flutter_data/flutter_data.dart';
// import 'package:get_it/get_it.dart';
// import 'package:ncb/main.data.dart';
// import 'package:ncb/modules/common/models/testament.dart';
//
// // T _<T>(ProviderBase<T> provider) => null as T;
//
// class FlutterDataGetItInitializer {
//   final FutureFn<String>? baseDirFn;
//   final List<int>? encryptionKey;
//   final bool clear = false;
//   final bool? remote;
//   final bool? verbose;
//
//   FlutterDataGetItInitializer({
//     this.baseDirFn,
//     this.encryptionKey,
//     this.remote,
//     this.verbose,
//   });
//
//   Future<void> register() async {
//     if (!GetIt.I.isRegistered<ProviderContainer>()) {
//       _registerProviderContainer();
//     }
//
//     if (GetIt.I.isRegistered<RepositoryInitializer>()) {
//       return;
//     }
//
//     await _registerRepositoryInitializer();
//     _registerRepositories();
//   }
//
//   void _registerProviderContainer() {
//     final container = ProviderContainer(
//       overrides: [
//         configureRepositoryLocalStorage(
//           baseDirFn: baseDirFn,
//           encryptionKey: encryptionKey,
//           clear: clear,
//         ),
//       ],
//     );
//
//     GetIt.I.registerSingleton<ProviderContainer>(container);
//   }
//
//   Future<void> _registerRepositoryInitializer() async {
//     var repositoryInitializer = repositoryInitializerProvider(
//       remote: remote,
//       verbose: remote,
//     ).future;
//
//     final init = await container.read(repositoryInitializer);
//
//     internalLocatorFn = repositoryProvider;
//
//     GetIt.I.registerSingleton<RepositoryInitializer>(init);
//   }
//
//   Repository<T> repositoryProvider<T extends DataModel<T>>(
//     Provider<Repository<T>> provider,
//     _,
//   ) {
//     return container.read(provider);
//   }
//
//   void _registerRepositories() {
//     GetIt.I.registerSingleton<Repository<Testament>>(
//       container.read(testamentsRepositoryProvider),
//     );
//   }
//
//   ProviderContainer get container => GetIt.I.get<ProviderContainer>();
// }

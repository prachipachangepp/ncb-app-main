// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
// import 'package:dev_toolkit/dev_toolkit.dart';
// import 'package:flrx/application.dart';
// import 'package:flrx/components/modules/module.dart';
// import 'package:flrx/components/registrar/service_locator.dart';
// import 'package:flrx/config/application_config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get_it/get_it.dart';
// import 'package:ncb/app.dart';
// import 'package:ncb/config/app_config.dart';
// import 'package:ncb/modules/common/models/loading_state.dart';
// import 'package:ncb/modules/common/models/testament.dart';
// import 'package:ncb/modules/common/service/testament_service.dart';
// import 'package:ncb/store/actions/actions.dart';
// import 'package:ncb/store/states/app_state.dart';
// import 'package:ncb/store/store_retriever.dart';
// import 'package:redux/redux.dart';
// import 'package:redux_future_middleware/redux_future_middleware.dart';
//
// import 'mocks/mock_auth_service.dart';
//
// void whileAllowingReassignment(ValueSetter<ServiceLocator> callback) {
//   var originalReassignment = GetIt.I.allowReassignment;
//   GetIt.I.allowReassignment = true;
//   callback(Application.serviceLocator);
//   GetIt.I.allowReassignment = originalReassignment;
// }
//
// Future setupFromConfig(ApplicationConfig config) async {
//   // Wait for all modules to initialize
//   await Future.forEach<Module>(
//     config.modules,
//     (module) => module.initialize(),
//   );
//
//   // Wait for all modules to boot
//   await Future.forEach<Module>(
//     config.modules,
//     (module) => module.boot(),
//   );
// }
//
// void expectActionDispatched<T>({int times = 1}) {
//   var actions = DevToolKitMiddleware.logs
//       .where((element) => element.action.type == T.toString())
//       .toList();
//   expect(actions.length, times);
// }
//
// void main() {
//   testWidgets('App loads all testaments', (WidgetTester tester) async {
//     await setupFromConfig(AppConfig());
//
//     whileAllowingReassignment((locator) {
//       locator.registerSingleton<TestamentService>(
//         MockTestamentService(),
//       );
//     });
//
//     Store<AppState> store = await AppStoreRetriever().retrieveStore();
//
//     /// Check Initial State is valid
//     expect(DevToolKitMiddleware.logs.length, 0);
//     expect(store.state.testamentState.loadingState, LoadingState.initial());
//
//     /// Build our app and trigger a frame.
//     await tester.pumpWidget(StoreProvider(store: store, child: App()));
//
//     /// Pump once more to call [onInitialBuild]
//     await tester.pump();
//
//     /// Check action dispatched and new state is valid
//     expect(DevToolKitMiddleware.logs.length, 1);
//     expectActionDispatched<FuturePendingAction<FetchTestamentsAction>>();
//     expect(store.state.testamentState.loadingState, LoadingState.loading());
//
//     /// Check UI is as expected
//     expect(
//       find.byWidgetPredicate((widget) => widget is CircularProgressIndicator),
//       findsOneWidget,
//     );
//
//     /// Pump with duration longer than Mock Service's Future time,
//     /// otherwise future is completed before we can check loading state
//     await tester.pump(Duration(microseconds: 1));
//
//     /// Test success action and state
//     expect(DevToolKitMiddleware.logs.length, 2);
//     expectActionDispatched<
//         FutureSucceededAction<FetchTestamentsAction, List<Testament>>>();
//     expect(store.state.testamentState.loadingState, LoadingState.success());
//
//     /// Test UI for success state
//     expect(
//       find.byWidgetPredicate((widget) => widget is CircularProgressIndicator),
//       findsNothing,
//     );
//     store.state.testamentState.testaments!.forEach((element) {
//       expect(find.text(element.name), findsOneWidget);
//     });
//   });
// }

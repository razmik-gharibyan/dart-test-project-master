import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:mockito/mockito.dart';

class MockRouter extends Mock implements Router {}
class MockPlatformLocation extends Mock implements PlatformLocation {}

const routerProvidersForTesting = [
  ClassProvider(LocationStrategy, useClass: HashLocationStrategy),
  ClassProvider(PlatformLocation, useClass: MockPlatformLocation),
  ClassProvider(Location),
  ClassProvider(Router, useClass: MockRouter)
];

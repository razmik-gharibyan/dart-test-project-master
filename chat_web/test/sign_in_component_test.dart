@TestOn('browser')
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_web/routes.dart';
import 'package:chat_web/services.dart';
import 'package:chat_web/src/components/sign_in_component/sign_in_component.dart';
import 'package:mockito/mockito.dart';
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'sign_in_component_po.dart';
import 'sign_in_component_test.template.dart' as self;
import 'utils.dart';

class MockSession extends Mock implements Session {}

class MockWebApiClient extends Mock implements WebApiClient {}

class MockUsersClient extends Mock implements UsersClient {}

@GenerateInjector([
  ClassProvider(Session, useClass: MockSession),
  ClassProvider(MockUsersClient),
  routerProvidersForTesting
])
// ignore: undefined_getter
InjectorFactory rootInjector = self.rootInjector$Injector;

@Directive(
    selector: '[override]',
    providers: [ExistingProvider(UsersClient, MockUsersClient)])
class OverrideDirective {}

@Component(
    selector: 'sign-in-test',
    template: '<sign-in override></sign-in>',
    directives: const [OverrideDirective, SignInComponent])
class SignInTestComponent {
  @ViewChild(SignInComponent)
  SignInComponent signInComponent;
}

main() {
  final testBed = NgTestBed.forComponent(self.SignInTestComponentNgFactory,
      rootInjector: rootInjector);
  NgTestFixture<SignInTestComponent> fixture;
  SignInComponentPO po;
  Injector injector;

  setUp(() async {
    fixture = await testBed.create(beforeComponentCreated: (injr) {
      injector = injr;
    });
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = SignInComponentPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  test('basic', () {
    expect(fixture.text,
        stringContainsInOrder(['username', 'password', 'Sign In', 'Sign Up']));
  });

  test('username input', () {
    expect(po.usernameMaterialInput.exists, true);
    expect(po.usernameMaterialInput.attributes['label'], 'username');
  });

  test('password input', () {
    expect(po.passwordMaterialInput.exists, true);
    expect(po.passwordMaterialInput.attributes['label'], 'password');
  });

  test('sign in button', () {
    expect(po.signInButton.exists, true);
    expect(po.signInButton.innerText, 'Sign In');
  });

  test('input username and password', () async {
    await po.usernameInput.type('username');
    await po.psswordInput.type('password');
    await fixture.update((c) {
      expect(c.signInComponent.username, 'username');
      expect(c.signInComponent.password, 'password');
    });
  });

  test('sign in button click calls signIn method', () async {
    final webUsersClient = injector.get(MockUsersClient);
    await fixture.update((c) {
      c.signInComponent.username = 'username';
      c.signInComponent.password = 'password';
    });
    await po.signInButton.click();
    verify(webUsersClient.login('username', 'password')).called(1);
  });

  test('navigate after successful login', () async {
    final router = injector.get(Router);
    final webUsersClient = injector.get(MockUsersClient);
    when(webUsersClient.login('username', 'password')).thenAnswer(
        (_) => Future.value(User(id: UserId('id'), name: 'username')));
    fixture.update((c) async {
      c.signInComponent.username = 'username';
      c.signInComponent.password = 'password';
      await c.signInComponent.signIn();
      final result = verify(router.navigate(captureAny));
      expect(result.captured.single, RoutePaths.chats.toUrl());
    });
  });
}

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:chat_web/routes.dart';
import 'package:chat_web/services.dart';
import 'package:rest_api_client/rest_api_client.dart';

@Component(
    selector: 'my-app',
    styleUrls: [
      'package:angular_components/app_layout/layout.scss.css',
      'app_component.css'
    ],
    templateUrl: 'app_component.html',
    directives: [
      coreDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,
      routerDirectives
    ],
    providers: [
      ClassProvider(ApiClient, useClass: WebApiClient),
      ClassProvider(Session)
    ],
    exports: [RoutePaths, Routes])
class AppComponent {
  Session session;
  AppComponent(this.session);

  signOut() {
    session.clear();
  }
}

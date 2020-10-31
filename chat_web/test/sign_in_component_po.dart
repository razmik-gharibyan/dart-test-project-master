import 'package:pageloader/pageloader.dart';

part 'sign_in_component_po.g.dart';

@PageObject()
abstract class SignInComponentPO {
  SignInComponentPO();
  // ignore: redirect_to_non_class
  factory SignInComponentPO.create(PageLoaderElement context) = $SignInComponentPO.create;

  @First(ByCss('input[type=text]'))
  PageLoaderElement get usernameInput;

  @First(ByCss('input[type=password]'))
  PageLoaderElement get psswordInput;

  @First(ByCss('material-input[type=text]'))
  PageLoaderElement get usernameMaterialInput;

  @First(ByCss('material-input[type=password]'))
  PageLoaderElement get passwordMaterialInput;

  @First(ByCss('material-button'))
  PageLoaderElement get signInButton;
  
}
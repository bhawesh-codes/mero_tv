import 'package:injectable/injectable.dart';
import 'package:stacked/stacked_annotations.dart';
import 'get_it_service.config.dart';


@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: false, 
)
Future<void> configureDependencies() async => init(StackedLocator.instance.locator);

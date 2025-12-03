import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:service_order_management/core/image_picker/core/domain/contract/image_picker_contract.dart';
import 'package:service_order_management/core/image_picker/data/service/image_picker_service.dart';

import 'injectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  ImagePickerService get imagePickerService => ImagePickerServiceImpl();
}
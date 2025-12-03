// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:service_order_management/module/image_picker/core/domain/contract/image_picker_contract.dart'
    as _i918;
import 'package:service_order_management/module/image_picker/core/usecase/image_picker_usecase.dart'
    as _i517;
import 'package:service_order_management/module/image_picker/data/service/image_picker_service.dart'
    as _i1018;
import 'package:service_order_management/module/service_order/controller/service_order_controller.dart'
    as _i56;
import 'package:service_order_management/module/service_order/core/domain/contract/service_order_contract.dart'
    as _i366;
import 'package:service_order_management/module/service_order/core/domain/usecase/service_order_usecase.dart'
    as _i304;
import 'package:service_order_management/module/service_order/data/repository/service_order_repository.dart'
    as _i534;
import 'package:service_order_management/module/service_order/infra/local_db.dart'
    as _i1027;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i517.ImagePickerUsecase>(
      () => _i517.ImagePickerUsecase(
        imagePickerService: gh<_i1018.ImagePickerServiceImpl>(),
      ),
    );
    gh.factory<_i918.ImagePickerService>(() => _i1018.ImagePickerServiceImpl());
    gh.factory<_i366.ServiceOrderRepository>(
      () => _i534.ServiceOrderRepostoryImpl(localDb: gh<_i1027.Localdb>()),
    );
    gh.factory<_i304.ServiceOrderUsecase>(
      () => _i304.ServiceOrderUsecase(
        serviceOrderRepository: gh<_i366.ServiceOrderRepository>(),
      ),
    );
    gh.factory<_i56.ServiceOrderController>(
      () => _i56.ServiceOrderController(
        serviceOrderUsecase: gh<_i304.ServiceOrderUsecase>(),
        imagePickerUseCase: gh<_i517.ImagePickerUsecase>(),
      ),
    );
    return this;
  }
}

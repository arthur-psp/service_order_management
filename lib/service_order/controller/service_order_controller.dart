import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:service_order_management/service_order/core/domain/model/service_order.dart';
import 'package:service_order_management/service_order/core/domain/usecase/service_order_usecase.dart';
import 'package:service_order_management/service_order/state/servic_order_state.dart';

@injectable
class ServiceOrderController extends Cubit<ServiceOrderState>{
  final ServiceOrderUsecase serviceOrderUsecase;

  List<ServiceOrder> _services = [];

  ServiceOrderController({
    required this.serviceOrderUsecase,
  }) : super(ServiceOrderInitial()) {
    getServiceOrder();
  }

  Future<void> getServiceOrder() async {
    emit(ServiceOrderLoading());
    final services = await serviceOrderUsecase.getAll();
    _services = services;
    emit(ServiceOrderLoaded(services));
  }

  Future<void> createServiceOrder(ServiceOrder serviceOrder) async {
    try {
      emit(ServiceOrderLoading());
      await serviceOrderUsecase.create(serviceOrder);
      await getServiceOrder();
    } catch (e) {
      ServiceOrderError('Erro ao criar nova ordem de serviço: $e');
    }
  }
}
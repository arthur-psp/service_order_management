import 'package:injectable/injectable.dart';
import 'package:service_order_management/service_order/core/domain/contract/service_order_contract.dart';
import 'package:service_order_management/service_order/core/domain/model/service_order.dart';

@injectable
class ServiceOrderUsecase {
  final ServiceOrderRepository serviceOrderRepository;

  ServiceOrderUsecase({ required this.serviceOrderRepository });

  Future<ServiceOrder> create(ServiceOrder serviceOrder) async {
    return await serviceOrderRepository.create(serviceOrder);
  }

  Future<List<ServiceOrder>> getAll() async {
    return await serviceOrderRepository.getAll();
  }

  Future<ServiceOrder> getById(int id) async {
    return await serviceOrderRepository.getById(id);
  }

  Future<ServiceOrder> update(int id, ServiceOrder so) async {
    return await serviceOrderRepository.update(id, so);
  }

  Future<void> delete(int id) async {
    return await serviceOrderRepository.delete(id);
  }
}
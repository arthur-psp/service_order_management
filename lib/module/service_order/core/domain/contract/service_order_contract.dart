import 'package:service_order_management/module/service_order/core/domain/model/service_order.dart';

abstract class ServiceOrderRepository {
    Future<ServiceOrder> create(ServiceOrder serviceOrder);
    Future<List<ServiceOrder>> getAll();
    Future<ServiceOrder> getById(int id);
    Future<ServiceOrder> update(int id, ServiceOrder serviceOrder);
    Future<void> delete(int id);
}
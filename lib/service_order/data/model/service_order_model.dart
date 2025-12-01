import 'package:service_order_management/service_order/core/domain/model/service_order.dart';

class ServiceOrderModel extends ServiceOrder{
  ServiceOrderModel({
    super.id,
    required super.name,
    required super.createdDate,
    required super.startedDate,
    required super.finalizedDate,
    required super.description,
    required super.imageUrl,
    required super.active,
    super.status,
    super.adress
  });
}
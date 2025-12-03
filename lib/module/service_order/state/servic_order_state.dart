import 'package:service_order_management/module/service_order/core/domain/model/service_order.dart';

abstract class ServiceOrderState {}

class ServiceOrderInitial extends ServiceOrderState{}

class ServiceOrderLoading extends ServiceOrderState{}

class ServiceOrderLoaded extends ServiceOrderState{
  final List<ServiceOrder> services;

  ServiceOrderLoaded(this.services);
}

class ServiceOrderError extends ServiceOrderState {
  final String message;
  
  ServiceOrderError(this.message);
}
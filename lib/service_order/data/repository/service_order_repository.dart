import 'package:injectable/injectable.dart';
import 'package:service_order_management/service_order/core/domain/contract/service_order_contract.dart';
import 'package:service_order_management/service_order/core/domain/model/service_order.dart';
import 'package:service_order_management/service_order/infra/local_db.dart';

@Injectable(as: ServiceOrderRepository)

class ServiceOrderRepostoryImpl extends ServiceOrderRepository {
  final Localdb localDb;

  ServiceOrderRepostoryImpl({ required this.localDb });

  @override
  Future<ServiceOrder> create(ServiceOrder serviceOrder) async {
    final db = await localDb.database;

    final serviceOrderMap = serviceOrder.toMap();

    serviceOrderMap.remove('id');

    final serviceOrderId = await db.insert('service_order', serviceOrderMap);
    return serviceOrder.copyWith(id: serviceOrderId);
  }

  @override
  Future<List<ServiceOrder>> getAll() async {
    final db = await localDb.database;

    final List<Map<String, dynamic>> maps = await db.query('service_order');

    return maps.map((map) => ServiceOrder.fromMap(map)).toList();
  }
}
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

    //remove para ser autoincrement
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

  @override
  Future<ServiceOrder> getById(int id) async {
    final db = await localDb.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM service_order WHERE id = ?", [id]);

    if (maps.isEmpty) {
      throw Exception("Service Order not found");
    }

    return ServiceOrder.fromMap(maps.first);
  }

  @override
  Future<ServiceOrder> update(int id, ServiceOrder serviceOrder) async {
    final db = await localDb.database;

    final rowsAffected = await db.rawUpdate(
      '''
        UPDATE service_order SET 
          name = ?, 
          started_date = ?, 
          finalized_date = ?, 
          description = ?, 
          images = ?, 
          active = ?, 
          status = ?, 
          address = ?
        WHERE id = ?
      ''', 
      [ 
        serviceOrder.name, 
        serviceOrder.startedDate, 
        serviceOrder.finalizedDate, 
        serviceOrder.description, 
        serviceOrder.images, 
        serviceOrder.active,
        serviceOrder.status, 
        serviceOrder.adress,
        id,
      ]
    );

    if (rowsAffected == 0) {
      throw Exception("Service Order not found");
    }

    return getById(id);
  }

  @override
  Future<void> delete(int id) async {
    final db = await localDb.database;

    final rowsAffected = await db.rawDelete("DELETE FROM service_order WHERE id = ?", [id]);

    if (rowsAffected == 0) {
      throw Exception("Service Order not found");
    }

    return;
  }
}
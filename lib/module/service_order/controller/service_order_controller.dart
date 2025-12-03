import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:service_order_management/module/image_picker/core/usecase/image_picker_usecase.dart';
import 'package:service_order_management/module/service_order/core/domain/model/service_order.dart';
import 'package:service_order_management/module/service_order/core/domain/usecase/service_order_usecase.dart';
import 'package:service_order_management/module/service_order/state/servic_order_state.dart';

@injectable
class ServiceOrderController extends Cubit<ServiceOrderState>{
  final ServiceOrderUsecase serviceOrderUsecase;
  final ImagePickerUsecase imagePickerUseCase;

  List<ServiceOrder> _services = [];

  ServiceOrderController({
    required this.serviceOrderUsecase,
    required this.imagePickerUseCase,
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
      emit(ServiceOrderError('Erro ao criar nova ordem de serviço: $e'));
    }
  }

  Future<void> getById(int id) async {
    try {
      print('🔧 TESTE DIRETO DO USECASE');
      emit(ServiceOrderLoading());
      await serviceOrderUsecase.getById(id);
      await getServiceOrder();
    }catch (e) {
      ServiceOrderError('Erro ao listar ordem de serviço por id: $e');
    }
  }

  Future<void> update(int id, ServiceOrder so) async {
    try {
      emit(ServiceOrderLoading());
      await serviceOrderUsecase.update(id, so);
      await getServiceOrder();
    }catch (e) {
      ServiceOrderError('Erro ao atualizar ordem de serviço: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      emit(ServiceOrderLoading());
      await serviceOrderUsecase.delete(id);
      await getServiceOrder();
    }catch (e) {
      ServiceOrderError('Erro ao excluir ordem de serviço: $e');
    }
  }

  Future<void> addImageToServiceOrder(int id, String imageBase64) async {
    try {
      print('🔧 TESTE DIRETO DO USECASE');
      final serviceOrder = await serviceOrderUsecase.getById(id);

      final List<String> updatedImages = [...(serviceOrder.images ?? []), imageBase64];
      final updatedOrder = serviceOrder.copyWith(images: updatedImages);
      await serviceOrderUsecase.update(id, updatedOrder);
      await getServiceOrder();
    } catch (e) {
      print("Error updating with image");
      emit(ServiceOrderError("Erro ao atualizar serviço com imagem"));
    }
  }

  Future<void> takePhotoForServiceOrder(int serviceOrderId) async {
    print('🔧 TESTE DIRETO DO USECASE');
    final image = await imagePickerUseCase.takePhoto();
    if (image != null) {
      await addImageToServiceOrder(serviceOrderId, image);
    }
  }

  Future<void> pickPhotoForServiceOrder(int serviceOrderId) async {
    print('🔧 TESTE DIRETO DO USECASE');
    final image = await imagePickerUseCase.pickFromGallery();
    if (image != null) {
      await addImageToServiceOrder(serviceOrderId, image);
    }
  }
}
import 'package:injectable/injectable.dart';
import 'package:service_order_management/core/image_picker/data/service/image_picker_service.dart';

@injectable
class ImagePickerUsecase {
  final ImagePickerServiceImpl imagePickerService;

  ImagePickerUsecase({ required this.imagePickerService });

  Future<String?> takePhoto() async {
    return await imagePickerService.takePhoto();
  }

  Future<String?> pickFromGallery() async {
    return await imagePickerService.pickFromGallery();
  }

  Future<List<String>> pickMultipleFromGallery() async {
    return await imagePickerService.pickMultipleFromGallery();
  }
}
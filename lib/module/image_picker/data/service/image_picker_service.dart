import 'package:image_picker/image_picker.dart';
import 'package:service_order_management/module/image_picker/core/domain/contract/image_picker_contract.dart';
import 'dart:io';
import 'dart:convert';
import 'package:injectable/injectable.dart';

@Injectable(as: ImagePickerService)
class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();

 ImagePickerServiceImpl() {
    print('🎉 ImagePickerServiceImpl INSTANCIADO!');
  }

  @override
  Future<String?> takePhoto() async {
    try {
       print('📸 1. takePhoto() chamado');
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 800,
        maxHeight: 1024,
      );
      print('📸 3. Resultado da câmera: ${photo?.path ?? "null"}');
      if (photo != null) {
        // Converte a imagem para base64 para salvar no banco
        final bytes = await File(photo.path).readAsBytes();
        return base64Encode(bytes);
      }
      return null;
    } catch (e) {
      print('Erro ao tirar foto: $e');
      return null;
    }
  }

  @override
  Future<String?> pickFromGallery() async {
    try {
      print('🖼️ 1. pickFromGallery() chamado');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
       print('🖼️ 3. Resultado da galeria: ${image?.path ?? "null"}');
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        return base64Encode(bytes);
      }
      return null;
    } catch (e) {
      print('Erro ao escolher imagem: $e');
      return null;
    }
  }

  @override
  Future<List<String>> pickMultipleFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
        limit: 5,
      );
      
      final List<String> base64Images = [];
      for (var image in images) {
        final bytes = await File(image.path).readAsBytes();
        base64Images.add(base64Encode(bytes));
      }
      return base64Images;
    } catch (e) {
      print('Erro ao escolher múltiplas imagens: $e');
      return [];
    }
  }
}
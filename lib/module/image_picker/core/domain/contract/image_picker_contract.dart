abstract class ImagePickerService {
  Future<String?> takePhoto();
  Future<String?> pickFromGallery();
  Future<List<String>> pickMultipleFromGallery();
}
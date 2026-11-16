part of '../state.dart';

class ScreenShotViewModel extends Notifier<ScreenShotState> {
  ScreenShotViewModel();

  /// Álbum donde se guardan las capturas en la galería (Android / iOS).
  static const String _album = 'PoGo Check List';

  Future<void> captureAndSaveInGallery(
    ScreenshotController screenshotController,
    String fileName,
    BuildContext context,
  ) async {
    Uint8List? imageBytes = await screenshotController.capture();
    if (imageBytes == null) {
      if (context.mounted) {
        showErrorSnackBar(context, '[Error guardando la imagen]');
      }
      return;
    }
    try {
      if (kIsWeb) {
        // En web se descarga como archivo desde el navegador.
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: imageBytes,
          fileExtension: 'png',
          mimeType: MimeType.png,
        );
      } else {
        // Android: MediaStore (Pictures/<album>, sin permisos en Android 10+).
        // iOS: Fotos (requiere NSPhotoLibraryAddUsageDescription).
        await FileSaver.instance.saveToGallery(
          name: fileName,
          bytes: imageBytes,
          fileExtension: 'png',
          mimeType: MimeType.png,
          album: _album,
        );
      }
    } on PlatformException catch (error) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          error.code == 'PermissionDenied'
              ? '[Sin permiso para guardar en la galería]'
              : '[Error guardando la imagen]',
        );
      }
      return;
    } on UnsupportedError {
      if (context.mounted) {
        showErrorSnackBar(context, '[Plataforma no soportada]');
      }
      return;
    }
    if (context.mounted) {
      showSuccessSnackBar(context, '[Imagen guardada]');
    }
  }

  @override
  ScreenShotState build() => ScreenShotState();
}

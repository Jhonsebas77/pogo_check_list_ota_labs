part of com.pogo_check_list_ota_labs.app.state;

class ScreenShotViewModel extends Notifier<ScreenShotState> {
  ScreenShotViewModel();

  Future<void> captureAndSaveInGallery(
    ScreenshotController screenshotController,
    String fileName,
    BuildContext context,
  ) async {
    Uint8List? imageBytes = await screenshotController.capture();
    if (imageBytes == null && context.mounted) {
      showErrorSnackBar(context, '[Error guardando la imagen]');
      return;
    }
    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: imageBytes,
        mimeType: MimeType.png,
      );
      if (context.mounted) {
        showSuccessSnackBar(context, '[Imagen guardada]');
      }
    } else {
      Directory? storageDir = await getExternalStorageDirectory();
      StringBuffer newPath = StringBuffer();
      if (storageDir != null) {
        List<String> paths = storageDir.path.split('/');
        for (int i = 1; i < paths.length; i++) {
          String pathSection = paths[i];
          if (pathSection == 'Android') {
            break;
          }
          newPath.write('/$pathSection');
        }
      }
      newPath.write('/Download');
      File tempFile = await File('$newPath/screenshot.png').create();
      await tempFile.writeAsBytes(imageBytes! as List<int>);
      await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 60,
        name: fileName,
      );
      await tempFile.delete();
      if (context.mounted) {
        showSuccessSnackBar(context, '[Imagen guardada]\nDestino: $newPath');
      }
    }
  }

  @override
  ScreenShotState build() => ScreenShotState();
}

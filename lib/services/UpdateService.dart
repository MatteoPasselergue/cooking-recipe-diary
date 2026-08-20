import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class UpdateService {

  static Future<void> startUpdate(String url, { required Function(double progress) onProgress,}) async {
    final dir = await getTemporaryDirectory();
    final filePath = "${dir.path}/update.apk";

    Dio dio = Dio();

    try {
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      await OpenFilex.open(filePath);
    } catch (e) {
      print(e);
    }
  }

}
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ProductImageStorage {
  static final _picker = ImagePicker();
  static const _uuid = Uuid();

  static Future<String?> pickAndSaveProductImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file == null) return null;

    if (kIsWeb) {
      return file.path;
    }

    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'product_images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final dest = p.join(imagesDir.path, '${_uuid.v4()}.jpg');
    await File(file.path).copy(dest);
    return dest;
  }
}

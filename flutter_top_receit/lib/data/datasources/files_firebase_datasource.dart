import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseStorageDataSource {
  Future<List<Map<String, String>>> fetchImages();
  Future<String> uploadImage(dynamic file, String fileName);
  Future<void> deleteImage(String imageUrl);
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage storage;

  FirebaseStorageDataSourceImpl({required this.storage});

  @override
  Future<List<Map<String, String>>> fetchImages() async {
    try {
      final ListResult result = await storage.ref().child('images').listAll();
      final images = await Future.wait(result.items.map((ref) async {
        final url = await ref.getDownloadURL();
        return {'id': ref.name, 'url': url};
      }));

      return images;
    } catch (e) {
      throw Exception('Error al cargar las imágenes: $e');
    }
  }

  @override
  Future<String> uploadImage(dynamic file, String fileName) async {
    try {
      final Reference storageRef = storage.ref().child('images/$fileName');

      if (kIsWeb) {
        // En el entorno web
        if (file is Uint8List) {
          await storageRef.putData(file);
          print('Subiendo archivo: $file');
          print('Tipo de archivo: ${file.runtimeType}');
        } else {
          throw Exception(
              'En entornos web, el fichero debe ser de tipo Uint8List');
        }
      } else {
        // En móviles/escritorio
        print('Subiendo archivo: $file');
        print('Tipo de archivo: ${file.runtimeType}');
        if (file is File) {
          final fileBytes = await file.readAsBytes();

          await storageRef.putData(fileBytes);
        } else if (file is String) {
          final fileBytes = File(file).readAsBytesSync();

          await storageRef.putData(fileBytes);
        } else {
          throw Exception(
              'En dispositivos móviles, el archivo debe ser de tipo File o String');
        }
      }

      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error al cargar la imagen: $e');
    }
  }

  String getFilePathFromUrl(String imageUrl) {
    final Uri uri = Uri.parse(imageUrl);
    // Obtener la ruta relevante dentro de Firebase Storage, omitiendo los segmentos no necesarios
    final String filePath = uri.pathSegments.skip(4).join('/').split('?')[0];
    print('Extracted file path from URL: $filePath');
    return Uri.decodeComponent(filePath);
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final String filePath = getFilePathFromUrl(imageUrl);
      final Reference storageRef = storage.ref().child(filePath);
      print('Attempting to delete file at path: $filePath');
      await storageRef.delete();
      print('Image deleted successfully from Firebase Storage.');
    } catch (e) {
      print('Failed to delete image: $e');
      throw Exception('Failed to delete image: $e');
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class UploadFileServices {
  Future<String> uploadImage(File? image) async {
    final supabase = Supabase.instance.client;
    if (image == null) {
      return '';
    } else {
      final file = File(image.path);
      final fileName = '${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg';
      final fullPath = '${file.path}/$fileName';
      try {
        await supabase.storage.from('profiles').upload(
          fullPath,
          image,
          fileOptions:
          const FileOptions(cacheControl: '3600', upsert: false),
        ); // Get public URL
        final publicUrl =
        supabase.storage.from('profiles').getPublicUrl(fullPath);
        return publicUrl;
      } catch (error) {
        print('Error uploading image: $error');
        rethrow;
      }
    }
  }
}
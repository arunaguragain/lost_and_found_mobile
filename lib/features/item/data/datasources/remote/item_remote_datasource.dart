import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_and_found_mobile/core/api/api_client.dart';
import 'package:lost_and_found_mobile/core/api/api_endpoints.dart';
import 'package:lost_and_found_mobile/core/services/storage/token_service.dart';
import 'package:lost_and_found_mobile/features/item/data/datasources/item_datasource.dart';

final itemRemoteDatasourceProvider = Provider<ItemRemoteDatasource>((ref) {
  return ItemRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ItemRemoteDatasource implements IItemRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ItemRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<String> uploadImage(File image) async {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      'itemPhoto': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    //get token from token service
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    // return response.data['success'];
    return response.data['data'];
  }

  @override
  Future<String> uploadVideo(File video) async {
    final fileName = video.path.split('/').last;
    final formData = FormData.fromMap({
      'itemVideo': MultipartFile.fromFile(video.path, filename: fileName),
    });
    //get token from token service
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['success'];
    
  }
}

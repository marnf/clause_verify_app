import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/response_data.dart';
import '../utils/logging/logger.dart';
import 'auth_service.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class NetworkCaller {
  final int timeoutDuration = 30;

  // Future<ResponseData> getRequest(String endpoint, {String? token}) async {
  //   AppLoggerHelper.info('GET Request: $endpoint');
  //   try {
  //     final Response response = await get(
  //       Uri.parse(endpoint),
  //       headers: {
  //         // 'Authorization': token ?? AuthService.token.toString(),
  //         'Authorization': 'Bearer ${token ?? AuthService.token}',
  //         'Content-type': 'application/json',
  //       },
  //     ).timeout(Duration(seconds: timeoutDuration));
  //     return _handleResponse(response);
  //   } catch (e) {
  //     return _handleError(e);
  //   }
  // }


Future<ResponseData> getRequest(String endpoint, {String? token}) async {
  AppLoggerHelper.info('GET Request: $endpoint');
  
  // 🔍 Debug: Token check করুন
  final authToken = token ?? AuthService.token;
  AppLoggerHelper.info('🔑 Token available: ${authToken != null && authToken.isNotEmpty}');
  AppLoggerHelper.info('🔑 Token value: ${authToken?.substring(0, 20)}...'); // First 20 chars only
  
  try {
    final headers = <String, String>{
      'Content-type': 'application/json',
    };
    
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
      AppLoggerHelper.info('✅ Authorization header added');
    } else {
      AppLoggerHelper.warning('⚠️ No token available for this request');
    }
    
    AppLoggerHelper.info('📤 Sending request with headers: $headers');
    
    final Response response = await get(
      Uri.parse(endpoint),
      headers: headers,
    ).timeout(Duration(seconds: timeoutDuration));
    
    AppLoggerHelper.info('📥 Response received: ${response.statusCode}');
    return _handleResponse(response);
  } catch (e) {
    AppLoggerHelper.error('❌ Request failed: $e');
    AppLoggerHelper.error('❌ Error type: ${e.runtimeType}');
    return _handleError(e);
  }
}


// Future<ResponseData> getRequest(String endpoint, {String? token}) async {
//   AppLoggerHelper.info('GET Request: $endpoint');

//   final authHeader = 'Bearer ${token ?? AuthService.token}';

//   // 👇 এখানেই নিশ্চিত হওয়া যাবে
//   AppLoggerHelper.info('Authorization Header: $authHeader');

//   try {
//     final Response response = await get(
//       Uri.parse(endpoint),
//       headers: {
//         'Authorization': authHeader,
//         'Content-Type': 'application/json',
//       },
//     ).timeout(Duration(seconds: timeoutDuration));

//     return _handleResponse(response);
//   } catch (e) {
//     return _handleError(e);
//   }
// }




  Future<ResponseData> postRequest(
  String endpoint, {
  Map<String, dynamic>? body,
  String? token,
  bool requiresAuth = true, // নতুন parameter
}) async {
  AppLoggerHelper.info('POST Request: $endpoint');
  AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

  try {
    // Headers conditionally তৈরি করুন
    final headers = <String, String>{
      'Content-type': 'application/json',
    };

    // শুধুমাত্র যদি auth দরকার হয় তাহলে Authorization header যোগ করুন
    if (requiresAuth) {
      final authToken = token ?? AuthService.token;
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }
    }

    final Response response = await post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(Duration(seconds: timeoutDuration));
    
    return _handleResponse(response);
  } catch (e) {
    return _handleError(e);
  }
}

  Future<ResponseData> putRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PUT Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

    try {
      final Response response = await put(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? AuthService.token.toString(),
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PATCH Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await patch(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? AuthService.token.toString(),
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(String endpoint, String? token) async {
    AppLoggerHelper.info('DELETE Request: $endpoint');
    try {
      final Response response = await delete(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? AuthService.token.toString(),
          'Content-type': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }


  Future<ResponseData> multipartRequest(
    String endpoint, {
    Map<String, String>? files,      // File paths: {'front_image': '/path/to/image.jpg'}
    Map<String, String>? fields,     // Text fields: {'original_box': 'true', 'invoice': 'false'}
    String? token,
  }) async {
    AppLoggerHelper.info('MULTIPART Request: $endpoint');
    
    try {
      // Step 1: Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Step 2: Add Authorization header
      request.headers['Authorization'] = 'Bearer ${token ?? AuthService.token}';
      AppLoggerHelper.info('Authorization: Bearer ${token ?? AuthService.token}');

      // Step 3: Add files
      if (files != null) {
        for (var entry in files.entries) {
          String fieldName = entry.key;    // 'front_image'
          String filePath = entry.value;   // '/path/to/image.jpg'
          
          File file = File(filePath);
          
          // Check if file exists
          if (!await file.exists()) {
            AppLoggerHelper.error('File not found: $filePath');
            continue;
          }
          
          // Determine content type from file extension
          String extension = filePath.split('.').last.toLowerCase();
          MediaType contentType;
          
          if (extension == 'jpg' || extension == 'jpeg') {
            contentType = MediaType('image', 'jpeg');
          } else if (extension == 'png') {
            contentType = MediaType('image', 'png');
          } else {
            contentType = MediaType('image', 'jpeg'); // default
          }

          // Add file to request
          request.files.add(
            await http.MultipartFile.fromPath(
              fieldName,
              file.path,
              contentType: contentType,
            ),
          );
          
          AppLoggerHelper.info('✅ Added file: $fieldName -> $filePath (${contentType.mimeType})');
        }
      }

      // Step 4: Add additional text fields (accessories data)
      if (fields != null) {
        request.fields.addAll(fields);
        AppLoggerHelper.info('📦 Added fields: $fields');
      }

      AppLoggerHelper.info('📤 Sending multipart request...');

      // Step 5: Send request with extended timeout for file uploads
      var streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutDuration * 3), // 30 seconds for file uploads
      );
      
      // Step 6: Convert streamed response to regular response
      var response = await http.Response.fromStream(streamedResponse);
      
      AppLoggerHelper.info('📥 Response received: ${response.statusCode}');
      
      // Step 7: Use existing response handler
      return _handleResponse(response);
      
    } catch (e) {
      AppLoggerHelper.error('Multipart request error: $e');
      return _handleError(e);
    }
  }


  // Handle the response from the server
  // Handle the response from the server
  Future<ResponseData> _handleResponse(http.Response response) async {
    AppLoggerHelper.info('Response Status: ${response.statusCode}');
    AppLoggerHelper.info('Response Body: ${response.body}');

    try {
      final decodedResponse = jsonDecode(response.body);

      // সব case-এ responseData থাকবে (শুধু 204 ব্যতীত)
      switch (response.statusCode) {
        case 200:
        case 201:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage: '',
          );
        case 204:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: '',
          );
        case 400:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData:
                decodedResponse, // এখানে null না দিয়ে decodedResponse দিন
            errorMessage:
                decodedResponse['message'] ??
                decodedResponse['error'] ??
                'There was an issue with your request. Please try again.',
          );
        case 401:
          // await AuthService.logoutUser();
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: decodedResponse, // responseData থাকবে
            errorMessage:
                decodedResponse['message'] ??
                decodedResponse['detail'] ??
                'You are not authorized. Please log in to continue.',
          );
        case 403:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage:
                decodedResponse['message'] ??
                'You do not have permission to access this resource.',
          );
        case 404:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage:
                decodedResponse['message'] ??
                'The resource you are looking for was not found.',
          );
        case 500:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage:
                decodedResponse['message'] ??
                'Internal server error. Please try again later.',
          );
        default:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: decodedResponse,
            errorMessage:
                decodedResponse['message'] ??
                decodedResponse['error'] ??
                'Something went wrong. Please try again.',
          );
      }
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: null,
        errorMessage: 'Failed to process the response. Please try again later.',
      );
    }
  }

  // Handle errors during the request process
  ResponseData _handleError(dynamic error) {
    log('Request Error: $error');

    if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        errorMessage:
            'Request timed out. Please check your internet connection and try again.',
        responseData: null,
      );
    } else if (error is http.ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage:
            'Network error occurred. Please check your connection and try again.',
        responseData: null,
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Unexpected error occurred. Please try again later.',
        responseData: null,
      );
    }
  }
}

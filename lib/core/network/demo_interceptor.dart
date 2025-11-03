import 'package:dio/dio.dart';
import 'package:ilike/core/network/hive_service.dart';

/// Mock response interceptor for demo mode
/// This intercepts network requests and returns mock data for demo purposes
class DemoInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if this is demo mode (user has demo token)
    final token = HiveService.getAuthToken();
    final isDemoMode = token == 'demo-token-123';

    if (isDemoMode) {
      print('[DemoInterceptor] Intercepting request for demo mode: ${options.method} ${options.path}');

      // Return mock response based on the endpoint
      final mockResponse = _getMockResponse(options);
      if (mockResponse != null) {
        handler.resolve(mockResponse);
        return;
      }
    }

    // Continue with actual request if not demo mode or no mock available
    super.onRequest(options, handler);
  }

  Response? _getMockResponse(RequestOptions options) {
    final path = options.path;
    final method = options.method.toLowerCase();

    // Mock profile endpoint
    if (path.contains('/profile/me') && method == 'get') {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'success': true,
          'data': {
            'id': 'demo-user-123',
            'name': 'Demo User',
            'email': 'demo@ilike.com',
            'age': 25,
            'gender': 'other',
            'location': 'Demo City, Demo Country',
            'bio': 'Demo user for testing the iLike app! 🚀',
            'interests': ['Technology', 'Flutter', 'Dating Apps', 'Coffee'],
            'intentions': ['Long-term relationship', 'Friendship'],
            'height': "5'10\"",
            'photoUrls': [
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
            ],
            'isProfileComplete': true,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        },
      );
    }

    // Mock potential matches endpoint
    if (path.contains('/matches/potential') && method == 'get') {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'success': true,
          'data': [
            {
              'id': 'demo-match-1',
              'name': 'Sarah Chen',
              'age': 24,
              'gender': 'female',
              'location': '2.5 km away',
              'bio': 'Love hiking, coffee, and good conversations. Looking for someone who shares my passion for adventure!',
              'interests': ['Hiking', 'Coffee', 'Photography', 'Travel'],
              'intentions': ['Long-term relationship'],
              'height': "5'6\"",
              'photoUrls': [
                'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=600&fit=crop&crop=face',
              ],
              'distance': 2.5,
            },
            {
              'id': 'demo-match-2',
              'name': 'Mike Johnson',
              'age': 28,
              'gender': 'male',
              'location': '4.1 km away',
              'bio': 'Fitness enthusiast and dog lover. Always up for trying new restaurants and outdoor activities.',
              'interests': ['Fitness', 'Dogs', 'Cooking', 'Music'],
              'intentions': ['Dating', 'Long-term relationship'],
              'height': "6'0\"",
              'photoUrls': [
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop&crop=face',
              ],
              'distance': 4.1,
            },
          ],
        },
      );
    }

    // Mock login endpoint
    if (path.contains('/users/login') && method == 'post') {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'success': true,
          'data': {
            'user': {
              'id': 'demo-user-123',
              'name': 'Demo User',
              'email': 'demo@ilike.com',
              'hasCompletedProfile': true,
            },
            'token': 'demo-token-123',
          }
        },
      );
    }

    // Mock like/dislike endpoints
    if ((path.contains('/matches/like/') || path.contains('/matches/dislike/')) && method == 'post') {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'success': true,
          'data': {
            'matched': false,
            'message': 'Action recorded successfully',
          }
        },
      );
    }

    // Default: Return a generic success response
    return Response(
      requestOptions: options,
      statusCode: 200,
      data: {
        'success': true,
        'message': 'Demo mode: Request handled successfully',
      },
    );
  }
}
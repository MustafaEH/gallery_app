import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/features/photo_gallery/presentation/cubit/photo_cubit.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;

  const ErrorDisplayWidget({super.key, required this.message});

  String _getUserFriendlyMessage(String errorMessage) {
    if (errorMessage.contains('Failed to fetch curated photos')) {
      return 'Unable to load photos from the server';
    } else if (errorMessage.contains('SocketException') ||
        errorMessage.contains('NetworkException') ||
        errorMessage.contains('timeout')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (errorMessage.contains('401') || errorMessage.contains('403')) {
      return 'Access denied. Please try again later.';
    } else if (errorMessage.contains('500') ||
        errorMessage.contains('502') ||
        errorMessage.contains('503')) {
      return 'Server is temporarily unavailable. Please try again in a few minutes.';
    } else if (errorMessage.contains('404')) {
      return 'Photos not found. Please try again.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  String _getErrorSuggestion(String errorMessage) {
    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('NetworkException') ||
        errorMessage.contains('timeout')) {
      return '• Check your internet connection\n• Try switching between WiFi and mobile data\n• Restart the app';
    } else if (errorMessage.contains('500') ||
        errorMessage.contains('502') ||
        errorMessage.contains('503')) {
      return '• Wait a few minutes and try again\n• Check if the service is down\n• Try refreshing the app';
    } else {
      return '• Check your internet connection\n• Try refreshing the app\n• Contact support if the problem persists';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userFriendlyMessage = _getUserFriendlyMessage(message);
    final suggestion = _getErrorSuggestion(message);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),

            // Error Title
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error Message
            Text(
              userFriendlyMessage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Suggestions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Try these solutions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Retry Button
            ElevatedButton.icon(
              onPressed: () {
                context.read<PhotoCubit>().loadPhotos();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

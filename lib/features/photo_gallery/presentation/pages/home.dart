import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/features/photo_gallery/presentation/cubit/photo_cubit.dart';
import 'package:gallery/features/photo_gallery/presentation/cubit/photo_state.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/app_header.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/photo_content.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/loading_indicator.dart';
import 'package:gallery/features/photo_gallery/presentation/widgets/error_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhotoCubit>().loadPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(),
              BlocBuilder<PhotoCubit, PhotoState>(
                builder: (context, state) {
                  if (state is PhotoInitial) {
                    return const Center(
                      child: Text('Starting to load photos...'),
                    );
                  } else if (state is PhotoLoading) {
                    return const LoadingIndicator();
                  } else if (state is PhotoLoaded) {
                    return PhotoContent(
                      photos: state.photos,
                      isLoadingMore: state.isLoadingMore,
                      isOfflineData: state.isOfflineData,
                    );
                  } else if (state is PhotoError) {
                    return ErrorDisplayWidget(message: state.message);
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery/features/photo_gallery/presentation/cubit/photo_cubit.dart';
import 'package:gallery/features/photo_gallery/presentation/pages/home.dart';
import 'package:gallery/core/theme/app_theme.dart';
import 'package:gallery/core/theme/theme_provider.dart';
import 'package:gallery/injection.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const Gallery());
}

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<ThemeProvider>(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Photo Gallery',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: BlocProvider(
              create: (context) => getIt<PhotoCubit>(),
              child: const Home(),
            ),
          );
        },
      ),
    );
  }
}

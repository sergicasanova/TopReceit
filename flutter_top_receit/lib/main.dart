import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/firebase_options.dart';
import 'package:flutter_top_receit/injection.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_event.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguaje_state.dart';
import 'package:flutter_top_receit/presentation/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<RecipeBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<IngredientBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<RecipeIngredientBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<StepBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<LanguageBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<FavoriteBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<LikeBloc>(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          context.read<LanguageBloc>().add(GetLocaleEvent());
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'TopRecipe',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
            ],
            locale: state.locale,
          );
        },
      ),
    );
  }
}

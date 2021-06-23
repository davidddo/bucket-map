import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/app/home.dart';
import 'package:bucket_map/core/auth/login.dart';
import 'package:bucket_map/core/app/bloc/bloc.dart';
import 'package:bucket_map/core/auth/repositories/repositories.dart';
import 'package:bucket_map/core/settings/bloc/bloc.dart';
import 'package:bucket_map/core/settings/models/models.dart';
import 'package:bucket_map/core/themes.dart';
import 'package:bucket_map/utils/utils.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    @required AuthenticationRepository authenticationRepository,
    @required ProfileRepository profileRepository,
    @required PinRepository pinRepository,
    @required SharedPreferencesService sharedPreferencesService,
    Settings initialSettings,
  })  : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        _pinRepository = pinRepository,
        _sharedPreferencesService = sharedPreferencesService,
        _initialSettings = initialSettings;

  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  final PinRepository _pinRepository;

  final SharedPreferencesService _sharedPreferencesService;
  final Settings _initialSettings;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(
              sharedPreferencesService: _sharedPreferencesService,
              initialSettings: _initialSettings,
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              authenticationRepository: _authenticationRepository,
              profileRepository: _profileRepository,
            ),
          ),
          BlocProvider<CountriesBloc>(
            create: (context) => CountriesBloc()..add(LoadCountriesEvent()),
          ),
          BlocProvider<PinsBloc>(
            create: (context) => PinsBloc(
              authRepository: _authenticationRepository,
              pinRepository: _pinRepository,
            ),
          ),
          BlocProvider<FilteredCountriesBloc>(
            create: (context) => FilteredCountriesBloc(
              countriesBloc: BlocProvider.of<CountriesBloc>(context),
            ),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Bucket Map',
          themeMode: state.settings.themeMode,
          theme: Themes.buildLightTheme(),
          darkTheme: Themes.buildDarkTheme(),
          home: FlowBuilder<AppStatus>(
            state: context.select((AppBloc bloc) => bloc.state.status),
            onGeneratePages: (
              AppStatus status,
              List<Page<dynamic>> pages,
            ) {
              switch (status) {
                case AppStatus.authenticated:
                  return [HomePage.page()];
                case AppStatus.unauthenticated:
                default:
                  return [LoginPage.page()];
              }
            },
          ),
        );
      },
    );
  }
}

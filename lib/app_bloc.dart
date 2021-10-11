import 'package:orderly/Blocs/address/address_bloc.dart';
import 'package:orderly/Blocs/fleetOrders/bloc.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/login/login_bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Blocs/theme/theme_bloc.dart';
import 'package:orderly/Blocs/user_reg/userReg_bloc.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Blocs/authentication/authentication_bloc.dart';
import 'Blocs/myOrders/myOrders_bloc.dart';

class AppBloc {
  static final userRepository = UserRepository();
  static final themeBloc = ThemeBloc();


  static final authBloc = AuthBloc(userRepository: userRepository);
  static final loginBloc = LoginBloc(userRepository: userRepository);
  //customer
  static final userRegBloc = UserRegBloc(userRepository: userRepository);
  static final homeBloc = HomeBloc(homeRepository: userRepository);
  static final cartBloc = CartBloc(cartRepository: userRepository);
  static final addressBloc=AddressBloc(addressRepo:userRepository);
  static final myOrdersBloc=MyOrdersBloc(ordersRepo:userRepository)
  ;
  //fleet manager
  static final fleetOrdersBloc=FleetOrdersBloc(fleetOrdersRepo:userRepository);


  static final List<BlocProvider> providers = [
    // BlocProvider<ApplicationBloc>(
    //   create: (context) => applicationBloc,
    // ),
    // BlocProvider<LanguageBloc>(
    //   create: (context) => languageBloc,
    // ),
    BlocProvider<ThemeBloc>(
      create: (context) => themeBloc,
    ),
    BlocProvider<AuthBloc>(
      create: (context) => authBloc,
    ),
    BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
    ),

    //customer
    BlocProvider<UserRegBloc>(
      create: (context) => userRegBloc,
    ),
    BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
    ),
    BlocProvider<CartBloc>(
      create: (context) => cartBloc,
    ),
    BlocProvider<AddressBloc>(
      create: (context) => addressBloc,
    ),
    BlocProvider<MyOrdersBloc>(
      create: (context) => myOrdersBloc,
    ),

    //fleet manager
    BlocProvider<FleetOrdersBloc>(
      create: (context) => fleetOrdersBloc,
    ),

  ];

  static void dispose() {
    // applicationBloc.close();
    // languageBloc.close();
    // themeBloc.close();
    authBloc.close();
    loginBloc.close();
    userRegBloc.close();
    homeBloc.close();
    cartBloc.close();
    addressBloc.close();
    myOrdersBloc.close();
    fleetOrdersBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}

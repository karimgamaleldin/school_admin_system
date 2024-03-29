import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_admin_system/modules/adminsystemscreen.dart';
import 'package:school_admin_system/modules/login/cubit/cubit.dart';
import 'package:school_admin_system/modules/login/cubit/states.dart';
import 'package:school_admin_system/modules/login/login_screen.dart';
import 'package:school_admin_system/shared/constants.dart';
import 'package:school_admin_system/shared/my_bloc_observer.dart';
import 'package:school_admin_system/shared/useless%20cubit/useless_cubit.dart';
import 'package:school_admin_system/shared/useless%20cubit/useless_states.dart';
import 'Network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  Widget startWidget;
  adminId = CacheHelper.getData(key: 'adminId');
  if (adminId!=""&&adminId!=null) {
    startWidget = Directionality(
      textDirection: TextDirection.rtl,
        child: AdminSystemScreen()
    );
  } else {
    startWidget = LoginScreen();
  }
  runApp(
      MyApp(
          startWidget
      )
  );
}


class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp(this.startWidget);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()..getAdminData()
        ),
        BlocProvider(
            create: (context) => LoginCubit()
        ),
        BlocProvider(
            create: (context) => UselessCubit()
        )
      ],
      child: BlocConsumer<UselessCubit, UselessStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: startWidget
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saatmenumobileapp/helper/preferences.dart';
import 'package:saatmenumobileapp/models/auth.dart';
import 'package:saatmenumobileapp/presentation/page/auth/login.dart';
import 'package:saatmenumobileapp/presentation/page/cashier/cashier_home.dart';
import 'package:saatmenumobileapp/presentation/page/cashier/cashier_pending_payment.dart';
import 'package:saatmenumobileapp/presentation/page/home.dart';
import 'package:saatmenumobileapp/presentation/page/kitchen/kitchen_accepted_order.dart';
import 'package:saatmenumobileapp/presentation/page/kitchen/kitchen_completed_order.dart';
import 'package:saatmenumobileapp/presentation/page/kitchen/kitchen_incoming_order.dart';
import 'package:saatmenumobileapp/presentation/page/kitchen/kitchen_home.dart';
import 'package:saatmenumobileapp/presentation/page/order_detail.dart';
import 'package:saatmenumobileapp/presentation/page/served.dart';
import 'package:saatmenumobileapp/presentation/page/table/table_checkout.dart';
import 'package:saatmenumobileapp/presentation/page/table/table_detail.dart';
import 'package:saatmenumobileapp/presentation/page/waiter/waiter_home.dart';
import 'package:saatmenumobileapp/presentation/page/waiter/waiter_incoming.dart';
import 'package:saatmenumobileapp/presentation/page/waiter/waiter_new_order.dart';
import 'package:saatmenumobileapp/presentation/page/waiter/waiter_served.dart';
import 'package:saatmenumobileapp/presentation/widget/bottom_nav_bar.dart';
import 'package:saatmenumobileapp/providers/chef_order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChefOrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash_screen',
        routes: {
          'splash_screen': (context) => const SplashScreen(),
          'home': (context) => const HomePage(),
          'login': (context) => const LoginPage(),
          'bottom_nav_bar': (context) => const BottomNavBarWidget(),
          'served': (context) => const ServedPage(),
          'order_detail': (context) => const OrderDetailPage(),
          'table_detail': (context) => const TableDetailPage(),
          'table_checkout': (context) => const TableCheckOutPage(),
          'kitchen_home': (context) => const KitchenHomePage(),
          'kitchen_incoming_order': (context) =>
              const KitchenIncomingOrderPage(),
          'kitchen_accepted_order': (context) =>
              const KitchenAcceptedOrderPage(),
          'kitchen_completed_order': (context) =>
              const KitchenCompletedOrderPage(),
          'waiter_home': (context) => const WaiterHomePage(),
          'waiter_incoming_order': (context) => const WaiterIncomingOrderPage(),
          'waiter_new_order': (context) => const WaiterNewOrderPage(),
          'waiter_served_order': (context) => const WaiterServedOrderPage(),
          'cashier_home': (context) => const CashierHomePage(),
          'cashier_pending_payment': (context) =>
              const CashierPendingPaymentPage(),
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      Auth? userData = await AppPreferences.getUserData();
      if(userData.staff == null){
        Navigator.pushReplacementNamed(context, 'login');
      }
      else{
      // var currentTime = DateTime.now().toUtc().toIso8601String();
      if( DateTime.now().toUtc().toIso8601String().compareTo(userData.staff!.expiredAt) > 0){
        Navigator.pushNamed(context, 'login');
        return;
      }
        switch (userData.staff!.position) {
          case 1:
            Navigator.pushReplacementNamed(context, 'waiter_home');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, 'kitchen_home');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, 'cashier_home');
            break;
          default:
            Navigator.pushReplacementNamed(context, 'login');
            break;
        }
      } 
    });
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

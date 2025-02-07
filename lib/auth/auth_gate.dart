import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:washa_mobile/views/pages/login_page.dart';
import 'package:washa_mobile/views/widget_tree.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // final session = snapshot.hasData ? snapshot.data : null;
        final session = snapshot.data!.session;
        if (session != null) {
          return WidgetTree();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

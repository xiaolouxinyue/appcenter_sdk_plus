import 'package:appcenter_sdk_plus/appcenter_sdk_plus.dart';
import 'package:appcenter_sdk_plus/service/appcenter_analytics.dart';
import 'package:appcenter_sdk_plus/service/appcenter_crashes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoadingPage.route,
      routes: {
        LoadingPage.route: (context) => const LoadingPage(),
        HomePage.route: (context) =>
            const HomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  static const String route = "/home";

  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  await AppCenterAnalytics.trackEvent("app_started",
                      properties: {"theme": "system"});
                },
                child: const Text("Submit event log"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    throw Exception("something");
                  } catch (e, s) {
                    await AppCenterCrashes.trackError(e, s);
                  }
                },
                child: const Text("Submit crash log"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  static const String route = "/";

  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<void>(
                future: AppCenter.start("00000000-0000-0000-0000-000000000001"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox.fromSize(
                          size: const Size(16, 16),
                          child: const CircularProgressIndicator(),
                        ),
                      ],
                    );
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, HomePage.route);
                  });
                  return Container();
                }),
          ],
        ),
      ),
    );
  }
}

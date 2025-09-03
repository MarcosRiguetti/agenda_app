import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Awesome Notifications
  await AwesomeNotifications().initialize(
    null, // ícone padrão do app
    [
      NotificationChannel(
        channelKey: 'agenda_channel',
        channelName: 'Agenda Notificações',
        channelDescription: 'Lembretes dos eventos da agenda',
        defaultColor: Colors.green,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );

  // Solicitar permissão (Android 13+)
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const AgendaApp());
}

class AgendaApp extends StatelessWidget {
  const AgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

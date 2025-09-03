import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  /// Agendar notificação
  static Future<void> agendarNotificacao({
    required int id,
    required String titulo,
    required String descricao,
    required DateTime dataHora,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id, // id único da notificação
        channelKey: 'agenda_channel',
        title: titulo,
        body: descricao,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(
        date: dataHora,
        preciseAlarm: true,
      ),
    );
  }

  /// Cancelar notificação
  static Future<void> cancelarNotificacao(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  /// Atualizar notificação
  static Future<void> atualizarNotificacao({
    required int id,
    required String titulo,
    required String descricao,
    required DateTime dataHora,
  }) async {
    await cancelarNotificacao(id);
    
    await agendarNotificacao(
      id: id,
      titulo: titulo,
      descricao: descricao,
      dataHora: dataHora,
    );
  }
}

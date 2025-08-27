import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/models/evento.dart';
import '../../data/database/database_helper.dart';
import 'add_evento_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool isDarkMode = false;

  List<Evento> eventos = [];
  List<Evento> eventosDoDia = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // Seleciona o dia atual
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    final lista = await DatabaseHelper().getEventos();
    setState(() {
      eventos = lista;
      _filtrarEventosDoDia(_selectedDay!);
    });
  }

  void _filtrarEventosDoDia(DateTime dia) {
    eventosDoDia =
        eventos
            .where(
              (evento) =>
                  evento.dataHora.year == dia.year &&
                  evento.dataHora.month == dia.month &&
                  evento.dataHora.day == dia.day,
            )
            .toList();
  }

  Color _getCardColor(Evento evento) {
    if (evento.cor != null) return Color(evento.cor!);
    return isDarkMode ? Colors.grey.shade700 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final bottomColor =
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Agenda Flutter"),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _filtrarEventosDoDia(selectedDay);
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: textColor, fontSize: 18),
              leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
              rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: textColor),
              weekendStyle: TextStyle(
                color: isDarkMode ? Colors.redAccent.shade200 : Colors.red,
              ),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(color: textColor),
              weekendTextStyle: TextStyle(
                color: isDarkMode ? Colors.redAccent.shade200 : Colors.red,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: isDarkMode ? Colors.tealAccent.shade700 : Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            height: 2,
            color: isDarkMode ? Colors.white24 : Colors.black26,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child:
                  eventosDoDia.isEmpty
                      ? Center(
                        child: Text(
                          _selectedDay == null
                              ? "Selecione um dia para ver os eventos"
                              : "Nenhum evento para este dia",
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      )
                      : ListView.builder(
                        itemCount: eventosDoDia.length,
                        itemBuilder: (context, index) {
                          final evento = eventosDoDia[index];
                          final cardColor = _getCardColor(evento);
                          final eventoTextColor =
                              cardColor.computeLuminance() < 0.5
                                  ? Colors.white
                                  : Colors.black87;
                          final iconColor =
                              cardColor.computeLuminance() < 0.5
                                  ? Colors.white
                                  : Colors.black87;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      evento.titulo,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: eventoTextColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    evento.descricao,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: eventoTextColor.withOpacity(0.85),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                isDarkMode
                                                    ? Colors.tealAccent.shade100
                                                    : Colors.green.shade700,
                                            child: Icon(
                                              Icons.access_time,
                                              size: 12,
                                              color: iconColor,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${evento.dataHora.hour.toString().padLeft(2, '0')}:${evento.dataHora.minute.toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: eventoTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: iconColor,
                                              size: 20,
                                            ),
                                            onPressed: () async {
                                              final atualizado =
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => AddEventoPage(
                                                            selectedDay:
                                                                evento.dataHora,
                                                            eventoExistente:
                                                                evento,
                                                          ),
                                                    ),
                                                  );
                                              if (atualizado != null) {
                                                await _carregarEventos();
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: iconColor,
                                              size: 20,
                                            ),
                                            onPressed: () async {
                                              await DatabaseHelper()
                                                  .deleteEvento(evento.id!);
                                              await _carregarEventos();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode ? Colors.tealAccent.shade700 : Colors.green,
        onPressed: () async {
          final novoEvento = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventoPage(selectedDay: _selectedDay),
            ),
          );
          if (novoEvento != null) {
            await _carregarEventos();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

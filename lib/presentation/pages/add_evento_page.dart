import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../data/database/database_helper.dart';
import '../../data/models/evento.dart';

class AddEventoPage extends StatefulWidget {
  final DateTime? selectedDay;
  final Evento? eventoExistente; // Evento a ser editado

  const AddEventoPage({super.key, this.selectedDay, this.eventoExistente});

  @override
  State<AddEventoPage> createState() => _AddEventoPageState();
}

class _AddEventoPageState extends State<AddEventoPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  Color _corSelecionada = Colors.green; // cor default

  @override
  void initState() {
    super.initState();
    if (widget.eventoExistente != null) {
      _tituloController.text = widget.eventoExistente!.titulo;
      _descricaoController.text = widget.eventoExistente!.descricao;
      _dataSelecionada = widget.eventoExistente!.dataHora;
      _horaSelecionada = TimeOfDay(
        hour: widget.eventoExistente!.dataHora.hour,
        minute: widget.eventoExistente!.dataHora.minute,
      );
      if (widget.eventoExistente!.cor != null) {
        _corSelecionada = Color(widget.eventoExistente!.cor!);
      }
    } else {
      _dataSelecionada = widget.selectedDay ?? DateTime.now();
      _horaSelecionada = TimeOfDay.now();
    }
  }

  void _salvarEvento() async {
    if (_formKey.currentState!.validate()) {
      final dataHora = DateTime(
        _dataSelecionada!.year,
        _dataSelecionada!.month,
        _dataSelecionada!.day,
        _horaSelecionada!.hour,
        _horaSelecionada!.minute,
      );

      if (widget.eventoExistente != null) {
        // Atualiza evento existente
        final atualizado = Evento(
          id: widget.eventoExistente!.id,
          titulo: _tituloController.text,
          descricao: _descricaoController.text,
          dataHora: dataHora,
          cor: _corSelecionada.value,
        );
        await DatabaseHelper().updateEvento(atualizado);
        Navigator.pop(context, atualizado);
      } else {
        // Cria novo evento
        final evento = Evento(
          titulo: _tituloController.text,
          descricao: _descricaoController.text,
          dataHora: dataHora,
          cor: _corSelecionada.value,
        );
        await DatabaseHelper().insertEvento(evento);
        Navigator.pop(context, evento);
      }
    }
  }

  Future<void> _selecionarData() async {
    final novaData = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale("pt", "BR"),
    );

    if (novaData != null) setState(() => _dataSelecionada = novaData);
  }

  Future<void> _selecionarHora() async {
    final novaHora = await showTimePicker(
      context: context,
      initialTime: _horaSelecionada!,
    );

    if (novaHora != null) setState(() => _horaSelecionada = novaHora);
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.eventoExistente != null ? "Editar Evento" : "Novo Evento",
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: "Título do Evento",
                    child: TextFormField(
                      controller: _tituloController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Informe um título"
                                  : null,
                    ),
                  ),
                  _buildSection(
                    title: "Descrição",
                    child: TextFormField(
                      controller: _descricaoController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  _buildSection(
                    title: "Data",
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _selecionarData,
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Escolher",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSection(
                    title: "Hora",
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _horaSelecionada!.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _selecionarHora,
                          icon: const Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Escolher",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSection(
                    title: "Cor do Evento",
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final corSelecionada = await showDialog<Color>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text("Escolha a cor"),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                        pickerColor: _corSelecionada,
                                        onColorChanged:
                                            (cor) =>
                                                Navigator.pop(context, cor),
                                      ),
                                    ),
                                  ),
                            );
                            if (corSelecionada != null) {
                              setState(() => _corSelecionada = corSelecionada);
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _corSelecionada,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text("Clique para alterar a cor"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _salvarEvento,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        widget.eventoExistente != null
                            ? "Atualizar Evento"
                            : "Salvar Evento",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Evento {
  int? id;
  String titulo;
  String descricao;
  DateTime dataHora;
  int? cor;

  Evento({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataHora,
    this.cor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataHora': dataHora.toIso8601String(),
      'cor': cor,
    };
  }

  factory Evento.fromMap(Map<String, dynamic> map) => Evento(
    id: map['id'],
    titulo: map['titulo'],
    descricao: map['descricao'],
    dataHora: DateTime.parse(map['dataHora']),
    cor: map['cor'],
  );
}

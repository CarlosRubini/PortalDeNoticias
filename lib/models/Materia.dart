import 'package:json_annotation/json_annotation.dart';

part 'Materia.g.dart';

@JsonSerializable(explicitToJson: true)
class Materia {
  final String titulo;
  final String tipo;
  final String descricao;
  final String dataMateria;
  final String imagem;

  Materia(
      this.titulo, this.descricao, this.tipo, this.dataMateria, this.imagem);

  factory Materia.fromJson(Map<String, dynamic> json) =>
      _$MateriaFromJson(json);

  Map<String, dynamic> toJson() => _$MateriaToJson(this);
}

enum TipoMateria {
  Todos,
  Cotidiano,
  Viver,
  Pessoas,
  MundoPop,
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Materia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Materia _$MateriaFromJson(Map<String, dynamic> json) {
  return Materia(
    json['titulo'] as String,
    json['descricao'] as String,
    json['tipo'] as String,
    json['dataMateria'] as String,
    json['imagem'] as String,
  );
}

Map<String, dynamic> _$MateriaToJson(Materia instance) => <String, dynamic>{
      'titulo': instance.titulo,
      'tipo': instance.tipo,
      'descricao': instance.descricao,
      'dataMateria': instance.dataMateria,
      'imagem': instance.imagem,
    };

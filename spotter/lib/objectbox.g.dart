// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';

import 'models/task_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2432166687953516652),
      name: 'Task',
      lastPropertyId: const IdUid(4, 4371495459484611180),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2298319077664181108),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3211315776754532028),
            name: 'taskDescription',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 6907622731959549502),
            name: 'taskGroup',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4371495459484611180),
            name: 'completed',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 8108166947537495174),
      name: 'TaskCollectionList',
      lastPropertyId: const IdUid(2, 3744637546667393341),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8985378110078263766),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3744637546667393341),
            name: 'taskCollectionNames',
            type: 30,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Store openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) =>
    Store(getObjectBoxModel(),
        directory: directory,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 8108166947537495174),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Task: EntityDefinition<Task>(
        model: _entities[0],
        toOneRelations: (Task object) => [],
        toManyRelations: (Task object) => {},
        getId: (Task object) => object.id,
        setId: (Task object, int id) {
          object.id = id;
        },
        objectToFB: (Task object, fb.Builder fbb) {
          final taskDescriptionOffset = fbb.writeString(object.taskDescription);
          final taskGroupOffset = fbb.writeString(object.taskGroup);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, taskDescriptionOffset);
          fbb.addOffset(2, taskGroupOffset);
          fbb.addBool(3, object.completed);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Task(
              taskDescription: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              taskGroup: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              completed: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 10, false))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    TaskCollectionList: EntityDefinition<TaskCollectionList>(
        model: _entities[1],
        toOneRelations: (TaskCollectionList object) => [],
        toManyRelations: (TaskCollectionList object) => {},
        getId: (TaskCollectionList object) => object.id,
        setId: (TaskCollectionList object, int id) {
          object.id = id;
        },
        objectToFB: (TaskCollectionList object, fb.Builder fbb) {
          final taskCollectionNamesOffset = fbb.writeList(object
              .taskCollectionNames
              .map(fbb.writeString)
              .toList(growable: false));
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, taskCollectionNamesOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TaskCollectionList(
              taskCollectionNames: const fb.ListReader<String>(
                      fb.StringReader(asciiOptimization: true),
                      lazy: false)
                  .vTableGet(buffer, rootOffset, 6, []))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Task] entity fields to define ObjectBox queries.
class Task_ {
  /// see [Task.id]
  static final id = QueryIntegerProperty<Task>(_entities[0].properties[0]);

  /// see [Task.taskDescription]
  static final taskDescription =
      QueryStringProperty<Task>(_entities[0].properties[1]);

  /// see [Task.taskGroup]
  static final taskGroup =
      QueryStringProperty<Task>(_entities[0].properties[2]);

  /// see [Task.completed]
  static final completed =
      QueryBooleanProperty<Task>(_entities[0].properties[3]);
}

/// [TaskCollectionList] entity fields to define ObjectBox queries.
class TaskCollectionList_ {
  /// see [TaskCollectionList.id]
  static final id =
      QueryIntegerProperty<TaskCollectionList>(_entities[1].properties[0]);

  /// see [TaskCollectionList.taskCollectionNames]
  static final taskCollectionNames =
      QueryStringVectorProperty<TaskCollectionList>(_entities[1].properties[1]);
}

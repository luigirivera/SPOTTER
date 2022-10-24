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
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'models/session_model.dart';
import 'models/sync_model.dart';
import 'models/task_model.dart';
import 'models/user_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 2432166687953516652),
      name: 'Task',
      lastPropertyId: const IdUid(8, 3116807868853089639),
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
            id: const IdUid(4, 4371495459484611180),
            name: 'completed',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3031576394869465085),
            name: 'taskGroupId',
            type: 11,
            flags: 520,
            indexId: const IdUid(1, 4157824682857840899),
            relationTarget: 'TaskGroup'),
        ModelProperty(
            id: const IdUid(8, 3116807868853089639),
            name: 'taskDateId',
            type: 11,
            flags: 520,
            indexId: const IdUid(3, 6369646154956444029),
            relationTarget: 'TaskDate')
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 2244299741876127042),
      name: 'TaskGroup',
      lastPropertyId: const IdUid(2, 3245963186454929968),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5149661405858191867),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3245963186454929968),
            name: 'taskGroup',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'tasks', srcEntity: 'Task', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(4, 6894683450146198376),
      name: 'TaskDate',
      lastPropertyId: const IdUid(10, 2904426658388335482),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1209234501180254007),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(7, 8729241759794953062),
            name: 'year',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 3999079546073260376),
            name: 'month',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3456104568692523990),
            name: 'day',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2904426658388335482),
            name: 'weekday',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(1, 5473346048667747771),
            name: 'taskGroups',
            targetId: const IdUid(3, 2244299741876127042))
      ],
      backlinks: <ModelBacklink>[
        ModelBacklink(name: 'tasks', srcEntity: 'Task', srcField: '')
      ]),
  ModelEntity(
      id: const IdUid(6, 5945979529088856067),
      name: 'StudyTheme',
      lastPropertyId: const IdUid(5, 431531247899342397),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6328427022553728420),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 5166880150451166563),
            name: 'index',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 540112357152437798),
            name: 'folder',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 431531247899342397),
            name: 'name',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(8, 8907197670501213787),
      name: 'DataToUpload',
      lastPropertyId: const IdUid(12, 1975284651273606259),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4416940880320670025),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(6, 2999212745484615391),
            name: 'addOrDeleteOrNeither',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7037980094063814279),
            name: 'operandType',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 1359277506266641171),
            name: 'deleteUser',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2118089188054687950),
            name: 'taskID',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 2618741343415969800),
            name: 'groupID',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 1975284651273606259),
            name: 'dateID',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(9, 7562821681699500801),
      name: 'SpotterUser',
      lastPropertyId: const IdUid(4, 7284375468628451175),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 767245565985993433),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 4452255613075982974),
            name: 'uid',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7599168946913273407),
            name: 'isAnon',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7284375468628451175),
            name: 'deleteUser',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(10, 8442671955771970492),
      name: 'StudyCount',
      lastPropertyId: const IdUid(3, 3243957007760897762),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6176349437650548911),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 9163955846415475904),
            name: 'count',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3243957007760897762),
            name: 'date',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(10, 8442671955771970492),
      lastIndexId: const IdUid(3, 6369646154956444029),
      lastRelationId: const IdUid(1, 5473346048667747771),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [
        8108166947537495174,
        8960039917790828058,
        1122309656234107963
      ],
      retiredIndexUids: const [7485740281930158389],
      retiredPropertyUids: const [
        8985378110078263766,
        3744637546667393341,
        6907622731959549502,
        3464322506574893699,
        6005979652544907125,
        1276408424731658357,
        157017507726260566,
        8688360419597907777,
        670442149101728455,
        7755749066108277002,
        8363835032810571706,
        4997147112644763886,
        2332013002352367957,
        7167278758745115140,
        2071013046512458381,
        6501321710646494062,
        4936541493375219022,
        4021613382800126923,
        2928674987731761317,
        7033964361855051741,
        1291466172437674877,
        3401413730924788528,
        4768763936726069584
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Task: EntityDefinition<Task>(
        model: _entities[0],
        toOneRelations: (Task object) => [object.taskGroup, object.taskDate],
        toManyRelations: (Task object) => {},
        getId: (Task object) => object.id,
        setId: (Task object, int id) {
          object.id = id;
        },
        objectToFB: (Task object, fb.Builder fbb) {
          final taskDescriptionOffset = fbb.writeString(object.taskDescription);
          fbb.startTable(9);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, taskDescriptionOffset);
          fbb.addBool(3, object.completed);
          fbb.addInt64(5, object.taskGroup.targetId);
          fbb.addInt64(7, object.taskDate.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Task(
              taskDescription: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              completed: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 10, false))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          object.taskGroup.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0);
          object.taskGroup.attach(store);
          object.taskDate.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0);
          object.taskDate.attach(store);
          return object;
        }),
    TaskGroup: EntityDefinition<TaskGroup>(
        model: _entities[1],
        toOneRelations: (TaskGroup object) => [],
        toManyRelations: (TaskGroup object) => {
              RelInfo<Task>.toOneBacklink(
                      6, object.id, (Task srcObject) => srcObject.taskGroup):
                  object.tasks
            },
        getId: (TaskGroup object) => object.id,
        setId: (TaskGroup object, int id) {
          object.id = id;
        },
        objectToFB: (TaskGroup object, fb.Builder fbb) {
          final taskGroupOffset = fbb.writeString(object.taskGroup);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, taskGroupOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TaskGroup(
              taskGroup: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          InternalToManyAccess.setRelInfo(
              object.tasks,
              store,
              RelInfo<Task>.toOneBacklink(
                  6, object.id, (Task srcObject) => srcObject.taskGroup),
              store.box<TaskGroup>());
          return object;
        }),
    TaskDate: EntityDefinition<TaskDate>(
        model: _entities[2],
        toOneRelations: (TaskDate object) => [],
        toManyRelations: (TaskDate object) => {
              RelInfo<TaskDate>.toMany(1, object.id): object.taskGroups,
              RelInfo<Task>.toOneBacklink(
                      8, object.id, (Task srcObject) => srcObject.taskDate):
                  object.tasks
            },
        getId: (TaskDate object) => object.id,
        setId: (TaskDate object, int id) {
          object.id = id;
        },
        objectToFB: (TaskDate object, fb.Builder fbb) {
          fbb.startTable(11);
          fbb.addInt64(0, object.id);
          fbb.addInt64(6, object.year);
          fbb.addInt64(7, object.month);
          fbb.addInt64(8, object.day);
          fbb.addInt64(9, object.weekday);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = TaskDate(
              year: const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0),
              month:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0),
              day: const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0),
              weekday:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          InternalToManyAccess.setRelInfo(object.taskGroups, store,
              RelInfo<TaskDate>.toMany(1, object.id), store.box<TaskDate>());
          InternalToManyAccess.setRelInfo(
              object.tasks,
              store,
              RelInfo<Task>.toOneBacklink(
                  8, object.id, (Task srcObject) => srcObject.taskDate),
              store.box<TaskDate>());
          return object;
        }),
    StudyTheme: EntityDefinition<StudyTheme>(
        model: _entities[3],
        toOneRelations: (StudyTheme object) => [],
        toManyRelations: (StudyTheme object) => {},
        getId: (StudyTheme object) => object.id,
        setId: (StudyTheme object, int id) {
          object.id = id;
        },
        objectToFB: (StudyTheme object, fb.Builder fbb) {
          final folderOffset = fbb.writeString(object.folder);
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.index);
          fbb.addOffset(2, folderOffset);
          fbb.addOffset(4, nameOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = StudyTheme(
              index: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              folder: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              name: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 12, ''))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    DataToUpload: EntityDefinition<DataToUpload>(
        model: _entities[4],
        toOneRelations: (DataToUpload object) => [],
        toManyRelations: (DataToUpload object) => {},
        getId: (DataToUpload object) => object.id,
        setId: (DataToUpload object, int id) {
          object.id = id;
        },
        objectToFB: (DataToUpload object, fb.Builder fbb) {
          fbb.startTable(13);
          fbb.addInt64(0, object.id);
          fbb.addInt64(5, object.addOrDeleteOrNeither);
          fbb.addInt64(6, object.operandType);
          fbb.addBool(8, object.deleteUser);
          fbb.addInt64(9, object.taskID);
          fbb.addInt64(10, object.groupID);
          fbb.addInt64(11, object.dateID);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = DataToUpload(
              addOrDeleteOrNeither:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0),
              operandType: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              taskID: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 22),
              groupID: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              dateID: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              deleteUser: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 20, false))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    SpotterUser: EntityDefinition<SpotterUser>(
        model: _entities[5],
        toOneRelations: (SpotterUser object) => [],
        toManyRelations: (SpotterUser object) => {},
        getId: (SpotterUser object) => object.id,
        setId: (SpotterUser object, int id) {
          object.id = id;
        },
        objectToFB: (SpotterUser object, fb.Builder fbb) {
          final uidOffset =
              object.uid == null ? null : fbb.writeString(object.uid!);
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, uidOffset);
          fbb.addBool(2, object.isAnon);
          fbb.addBool(3, object.deleteUser);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SpotterUser(
              uid: const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6),
              isAnon: const fb.BoolReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              deleteUser: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 10, false))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    StudyCount: EntityDefinition<StudyCount>(
        model: _entities[6],
        toOneRelations: (StudyCount object) => [],
        toManyRelations: (StudyCount object) => {},
        getId: (StudyCount object) => object.id,
        setId: (StudyCount object, int id) {
          object.id = id;
        },
        objectToFB: (StudyCount object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.count);
          fbb.addInt64(2, object.date);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = StudyCount(
              count: const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              date: const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0))
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

  /// see [Task.completed]
  static final completed =
      QueryBooleanProperty<Task>(_entities[0].properties[2]);

  /// see [Task.taskGroup]
  static final taskGroup =
      QueryRelationToOne<Task, TaskGroup>(_entities[0].properties[3]);

  /// see [Task.taskDate]
  static final taskDate =
      QueryRelationToOne<Task, TaskDate>(_entities[0].properties[4]);
}

/// [TaskGroup] entity fields to define ObjectBox queries.
class TaskGroup_ {
  /// see [TaskGroup.id]
  static final id = QueryIntegerProperty<TaskGroup>(_entities[1].properties[0]);

  /// see [TaskGroup.taskGroup]
  static final taskGroup =
      QueryStringProperty<TaskGroup>(_entities[1].properties[1]);
}

/// [TaskDate] entity fields to define ObjectBox queries.
class TaskDate_ {
  /// see [TaskDate.id]
  static final id = QueryIntegerProperty<TaskDate>(_entities[2].properties[0]);

  /// see [TaskDate.year]
  static final year =
      QueryIntegerProperty<TaskDate>(_entities[2].properties[1]);

  /// see [TaskDate.month]
  static final month =
      QueryIntegerProperty<TaskDate>(_entities[2].properties[2]);

  /// see [TaskDate.day]
  static final day = QueryIntegerProperty<TaskDate>(_entities[2].properties[3]);

  /// see [TaskDate.weekday]
  static final weekday =
      QueryIntegerProperty<TaskDate>(_entities[2].properties[4]);

  /// see [TaskDate.taskGroups]
  static final taskGroups =
      QueryRelationToMany<TaskDate, TaskGroup>(_entities[2].relations[0]);
}

/// [StudyTheme] entity fields to define ObjectBox queries.
class StudyTheme_ {
  /// see [StudyTheme.id]
  static final id =
      QueryIntegerProperty<StudyTheme>(_entities[3].properties[0]);

  /// see [StudyTheme.index]
  static final index =
      QueryIntegerProperty<StudyTheme>(_entities[3].properties[1]);

  /// see [StudyTheme.folder]
  static final folder =
      QueryStringProperty<StudyTheme>(_entities[3].properties[2]);

  /// see [StudyTheme.name]
  static final name =
      QueryStringProperty<StudyTheme>(_entities[3].properties[3]);
}

/// [DataToUpload] entity fields to define ObjectBox queries.
class DataToUpload_ {
  /// see [DataToUpload.id]
  static final id =
      QueryIntegerProperty<DataToUpload>(_entities[4].properties[0]);

  /// see [DataToUpload.addOrDeleteOrNeither]
  static final addOrDeleteOrNeither =
      QueryIntegerProperty<DataToUpload>(_entities[4].properties[1]);

  /// see [DataToUpload.operandType]
  static final operandType =
      QueryIntegerProperty<DataToUpload>(_entities[4].properties[2]);

  /// see [DataToUpload.deleteUser]
  static final deleteUser =
      QueryBooleanProperty<DataToUpload>(_entities[4].properties[3]);

  /// see [DataToUpload.taskID]
  static final taskID =
      QueryIntegerProperty<DataToUpload>(_entities[4].properties[4]);

  /// see [DataToUpload.groupID]
  static final groupID =
      QueryIntegerProperty<DataToUpload>(_entities[4].properties[5]);

  /// see [DataToUpload.dateID]
  static final dateID =
      QueryIntegerProperty<DataToUpload>(_entities[4].properties[6]);
}

/// [SpotterUser] entity fields to define ObjectBox queries.
class SpotterUser_ {
  /// see [SpotterUser.id]
  static final id =
      QueryIntegerProperty<SpotterUser>(_entities[5].properties[0]);

  /// see [SpotterUser.uid]
  static final uid =
      QueryStringProperty<SpotterUser>(_entities[5].properties[1]);

  /// see [SpotterUser.isAnon]
  static final isAnon =
      QueryBooleanProperty<SpotterUser>(_entities[5].properties[2]);

  /// see [SpotterUser.deleteUser]
  static final deleteUser =
      QueryBooleanProperty<SpotterUser>(_entities[5].properties[3]);
}

/// [StudyCount] entity fields to define ObjectBox queries.
class StudyCount_ {
  /// see [StudyCount.id]
  static final id =
      QueryIntegerProperty<StudyCount>(_entities[6].properties[0]);

  /// see [StudyCount.count]
  static final count =
      QueryIntegerProperty<StudyCount>(_entities[6].properties[1]);

  /// see [StudyCount.date]
  static final date =
      QueryIntegerProperty<StudyCount>(_entities[6].properties[2]);
}

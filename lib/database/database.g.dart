// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AlumneDao? _alumneDaoInstance;

  ProfessorDao? _professorDaoInstance;

  CursDao? _cursDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 12,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `alumnes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nia` TEXT NOT NULL, `grup` TEXT, `cursId` INTEGER, `nom` TEXT NOT NULL, `c1` TEXT NOT NULL, `c2` TEXT, `fotoPath` TEXT, `fotoPathHash` TEXT, FOREIGN KEY (`cursId`) REFERENCES `cursos` (`id`) ON UPDATE NO ACTION ON DELETE SET NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `professors` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `dni` TEXT NOT NULL, `nom` TEXT NOT NULL, `c1` TEXT NOT NULL, `c2` TEXT, `fotoPath` TEXT, `fotoPathHash` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cursos` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nom` TEXT NOT NULL)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_cursos_nom` ON `cursos` (`nom`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AlumneDao get alumneDao {
    return _alumneDaoInstance ??= _$AlumneDao(database, changeListener);
  }

  @override
  ProfessorDao get professorDao {
    return _professorDaoInstance ??= _$ProfessorDao(database, changeListener);
  }

  @override
  CursDao get cursDao {
    return _cursDaoInstance ??= _$CursDao(database, changeListener);
  }
}

class _$AlumneDao extends AlumneDao {
  _$AlumneDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _alumneInsertionAdapter = InsertionAdapter(
            database,
            'alumnes',
            (Alumne item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'grup': item.grup,
                  'cursId': item.cursId,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath,
                  'fotoPathHash': item.fotoPathHash
                }),
        _alumneUpdateAdapter = UpdateAdapter(
            database,
            'alumnes',
            ['id'],
            (Alumne item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'grup': item.grup,
                  'cursId': item.cursId,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath,
                  'fotoPathHash': item.fotoPathHash
                }),
        _alumneDeletionAdapter = DeletionAdapter(
            database,
            'alumnes',
            ['id'],
            (Alumne item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'grup': item.grup,
                  'cursId': item.cursId,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath,
                  'fotoPathHash': item.fotoPathHash
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Alumne> _alumneInsertionAdapter;

  final UpdateAdapter<Alumne> _alumneUpdateAdapter;

  final DeletionAdapter<Alumne> _alumneDeletionAdapter;

  @override
  Future<int?> countAlumnes() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM alumnes',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Alumne>> findAllAlumnes() async {
    return _queryAdapter.queryList('SELECT * FROM alumnes',
        mapper: (Map<String, Object?> row) => Alumne(
            id: row['id'] as int?,
            nia: row['nia'] as String,
            nom: row['nom'] as String,
            c1: row['c1'] as String,
            c2: row['c2'] as String?,
            grup: row['grup'] as String?,
            fotoPath: row['fotoPath'] as String?,
            cursId: row['cursId'] as int?));
  }

  @override
  Stream<List<String>> findAllAlumnesNom() {
    return _queryAdapter.queryListStream('SELECT nom FROM alumnes',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'alumnes',
        isView: false);
  }

  @override
  Future<List<Alumne>> obtenirAlumnesDelCurs(int cursId) async {
    return _queryAdapter.queryList('SELECT * FROM alumnes WHERE cursId = ?1',
        mapper: (Map<String, Object?> row) => Alumne(
            id: row['id'] as int?,
            nia: row['nia'] as String,
            nom: row['nom'] as String,
            c1: row['c1'] as String,
            c2: row['c2'] as String?,
            grup: row['grup'] as String?,
            fotoPath: row['fotoPath'] as String?,
            cursId: row['cursId'] as int?),
        arguments: [cursId]);
  }

  @override
  Future<void> insertAlumne(Alumne alumne) async {
    await _alumneInsertionAdapter.insert(alumne, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAlumnes(List<Alumne> alumnes) async {
    await _alumneInsertionAdapter.insertList(alumnes, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAlumne(Alumne alumne) async {
    await _alumneUpdateAdapter.update(alumne, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAlumnes(List<Alumne> alumnes) async {
    await _alumneUpdateAdapter.updateList(alumnes, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAlumne(Alumne alumne) async {
    await _alumneDeletionAdapter.delete(alumne);
  }

  @override
  Future<void> deleteAlumnes(List<Alumne> alumnes) async {
    await _alumneDeletionAdapter.deleteList(alumnes);
  }
}

class _$ProfessorDao extends ProfessorDao {
  _$ProfessorDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _professorInsertionAdapter = InsertionAdapter(
            database,
            'professors',
            (Professor item) => <String, Object?>{
                  'id': item.id,
                  'dni': item.dni,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath,
                  'fotoPathHash': item.fotoPathHash
                }),
        _professorUpdateAdapter = UpdateAdapter(
            database,
            'professors',
            ['id'],
            (Professor item) => <String, Object?>{
                  'id': item.id,
                  'dni': item.dni,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath,
                  'fotoPathHash': item.fotoPathHash
                }),
        _professorDeletionAdapter = DeletionAdapter(
            database,
            'professors',
            ['id'],
            (Professor item) => <String, Object?>{
                  'id': item.id,
                  'dni': item.dni,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath,
                  'fotoPathHash': item.fotoPathHash
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Professor> _professorInsertionAdapter;

  final UpdateAdapter<Professor> _professorUpdateAdapter;

  final DeletionAdapter<Professor> _professorDeletionAdapter;

  @override
  Future<int?> countProfessors() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM professors',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Professor>> findAllProfessors() async {
    return _queryAdapter.queryList('SELECT * FROM professors',
        mapper: (Map<String, Object?> row) => Professor(
            id: row['id'] as int?,
            dni: row['dni'] as String,
            nom: row['nom'] as String,
            c1: row['c1'] as String,
            c2: row['c2'] as String?,
            fotoPath: row['fotoPath'] as String?));
  }

  @override
  Stream<List<String>> findAllProfessorsNom() {
    return _queryAdapter.queryListStream('SELECT nom FROM professors',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'professors',
        isView: false);
  }

  @override
  Future<void> insertProfessor(Professor professor) async {
    await _professorInsertionAdapter.insert(
        professor, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertProfessors(List<Professor> professors) async {
    await _professorInsertionAdapter.insertList(
        professors, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProfessor(Professor professor) async {
    await _professorUpdateAdapter.update(professor, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProfessor(Professor professor) async {
    await _professorDeletionAdapter.delete(professor);
  }

  @override
  Future<void> deleteProfessors(List<Professor> professors) async {
    await _professorDeletionAdapter.deleteList(professors);
  }
}

class _$CursDao extends CursDao {
  _$CursDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _cursInsertionAdapter = InsertionAdapter(database, 'cursos',
            (Curs item) => <String, Object?>{'id': item.id, 'nom': item.nom}),
        _cursUpdateAdapter = UpdateAdapter(database, 'cursos', ['id'],
            (Curs item) => <String, Object?>{'id': item.id, 'nom': item.nom}),
        _cursDeletionAdapter = DeletionAdapter(database, 'cursos', ['id'],
            (Curs item) => <String, Object?>{'id': item.id, 'nom': item.nom});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Curs> _cursInsertionAdapter;

  final UpdateAdapter<Curs> _cursUpdateAdapter;

  final DeletionAdapter<Curs> _cursDeletionAdapter;

  @override
  Future<List<Curs>> findAllCursos() async {
    return _queryAdapter.queryList('SELECT * FROM cursos',
        mapper: (Map<String, Object?> row) =>
            Curs(id: row['id'] as int?, nom: row['nom'] as String));
  }

  @override
  Stream<List<String>> findAllCursosNom() {
    return _queryAdapter.queryListStream('SELECT nom FROM cursos',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'cursos',
        isView: false);
  }

  @override
  Future<void> buidarCursos() async {
    await _queryAdapter.queryNoReturn('DELETE FROM cursos');
  }

  @override
  Future<int> insertCurs(Curs curs) {
    return _cursInsertionAdapter.insertAndReturnId(
        curs, OnConflictStrategy.ignore);
  }

  @override
  Future<void> insertCursos(List<Curs> cursos) async {
    await _cursInsertionAdapter.insertList(cursos, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCurs(Curs curs) async {
    await _cursUpdateAdapter.update(curs, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCurs(Curs curs) async {
    await _cursDeletionAdapter.delete(curs);
  }

  @override
  Future<void> deleteCursos(List<Curs> cursos) async {
    await _cursDeletionAdapter.deleteList(cursos);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
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

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 6,
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
            'CREATE TABLE IF NOT EXISTS `alumnes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nia` TEXT NOT NULL, `grup` TEXT, `nom` TEXT NOT NULL, `c1` TEXT NOT NULL, `c2` TEXT, `fotoPath` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `professors` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `dni` TEXT NOT NULL, `nom` TEXT NOT NULL, `c1` TEXT NOT NULL, `c2` TEXT, `fotoPath` TEXT)');

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
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath
                }),
        _alumneUpdateAdapter = UpdateAdapter(
            database,
            'alumnes',
            ['id'],
            (Alumne item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'grup': item.grup,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath
                }),
        _alumneDeletionAdapter = DeletionAdapter(
            database,
            'alumnes',
            ['id'],
            (Alumne item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'grup': item.grup,
                  'nom': item.nom,
                  'c1': item.c1,
                  'c2': item.c2,
                  'fotoPath': item.fotoPath
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
            fotoPath: row['fotoPath'] as String?));
  }

  @override
  Stream<List<String>> findAllAlumnesNom() {
    return _queryAdapter.queryListStream('SELECT nom FROM alumnes',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'alumnes',
        isView: false);
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
  Future<void> deleteAlumne(Alumne alumne) async {
    await _alumneDeletionAdapter.delete(alumne);
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
                  'fotoPath': item.fotoPath
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
                  'fotoPath': item.fotoPath
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
                  'fotoPath': item.fotoPath
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
}

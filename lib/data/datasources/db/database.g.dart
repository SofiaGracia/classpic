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

  StudentDao? _studentDaoInstance;

  TeacherDao? _teacherDaoInstance;

  CursDao? _cursDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 23,
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
            'CREATE TABLE IF NOT EXISTS `student` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `nia` TEXT NOT NULL, `group` TEXT, `courseId` INTEGER, `hasFoto` INTEGER NOT NULL, `name` TEXT NOT NULL, `photoPathHash` TEXT, `s1` TEXT NOT NULL, `s2` TEXT, FOREIGN KEY (`courseId`) REFERENCES `course` (`id`) ON UPDATE NO ACTION ON DELETE SET NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `teacher` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `dni` TEXT NOT NULL, `hasFoto` INTEGER NOT NULL, `name` TEXT NOT NULL, `photoPathHash` TEXT, `s1` TEXT NOT NULL, `s2` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `course` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_course_name` ON `course` (`name`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StudentDao get studentDao {
    return _studentDaoInstance ??= _$StudentDao(database, changeListener);
  }

  @override
  TeacherDao get teacherDao {
    return _teacherDaoInstance ??= _$TeacherDao(database, changeListener);
  }

  @override
  CursDao get cursDao {
    return _cursDaoInstance ??= _$CursDao(database, changeListener);
  }
}

class _$StudentDao extends StudentDao {
  _$StudentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _studentInsertionAdapter = InsertionAdapter(
            database,
            'student',
            (Student item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'group': item.group,
                  'courseId': item.courseId,
                  'hasFoto': item.hasFoto ? 1 : 0,
                  'name': item.name,
                  'photoPathHash': item.photoPathHash,
                  's1': item.s1,
                  's2': item.s2
                }),
        _studentUpdateAdapter = UpdateAdapter(
            database,
            'student',
            ['id'],
            (Student item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'group': item.group,
                  'courseId': item.courseId,
                  'hasFoto': item.hasFoto ? 1 : 0,
                  'name': item.name,
                  'photoPathHash': item.photoPathHash,
                  's1': item.s1,
                  's2': item.s2
                }),
        _studentDeletionAdapter = DeletionAdapter(
            database,
            'student',
            ['id'],
            (Student item) => <String, Object?>{
                  'id': item.id,
                  'nia': item.nia,
                  'group': item.group,
                  'courseId': item.courseId,
                  'hasFoto': item.hasFoto ? 1 : 0,
                  'name': item.name,
                  'photoPathHash': item.photoPathHash,
                  's1': item.s1,
                  's2': item.s2
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Student> _studentInsertionAdapter;

  final UpdateAdapter<Student> _studentUpdateAdapter;

  final DeletionAdapter<Student> _studentDeletionAdapter;

  @override
  Future<int?> countStudents() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM student',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Student>> findAllStudents() async {
    return _queryAdapter.queryList('SELECT * FROM student',
        mapper: (Map<String, Object?> row) => Student(
            id: row['id'] as int?,
            nia: row['nia'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?,
            courseId: row['courseId'] as int?,
            group: row['group'] as String?));
  }

  @override
  Stream<List<String>> findAllStudentsName() {
    return _queryAdapter.queryListStream('SELECT name FROM student',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'student',
        isView: false);
  }

  @override
  Stream<List<int?>> observeTeacherIdsByCourse(int courseId) {
    return _queryAdapter.queryListStream(
        'SELECT id FROM teacher WHERE id IS NOT NULL AND courseId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [courseId],
        queryableName: 'teacher',
        isView: false);
  }

  @override
  Future<Student?> findStudentById(int id) async {
    return _queryAdapter.query('SELECT * FROM student WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Student(
            id: row['id'] as int?,
            nia: row['nia'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?,
            courseId: row['courseId'] as int?,
            group: row['group'] as String?),
        arguments: [id]);
  }

  @override
  Future<Student?> findStudentByNia(String nia) async {
    return _queryAdapter.query('SELECT * FROM student WHERE nia = ?1',
        mapper: (Map<String, Object?> row) => Student(
            id: row['id'] as int?,
            nia: row['nia'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?,
            courseId: row['courseId'] as int?,
            group: row['group'] as String?),
        arguments: [nia]);
  }

  @override
  Future<List<Student>> getStudentsByCurs(int courseId) async {
    return _queryAdapter.queryList('SELECT * FROM student WHERE courseId = ?1',
        mapper: (Map<String, Object?> row) => Student(
            id: row['id'] as int?,
            nia: row['nia'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?,
            courseId: row['courseId'] as int?,
            group: row['group'] as String?),
        arguments: [courseId]);
  }

  @override
  Future<int> insertStudent(Student student) {
    return _studentInsertionAdapter.insertAndReturnId(
        student, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertStudents(List<Student> students) async {
    await _studentInsertionAdapter.insertList(
        students, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudent(Student student) async {
    await _studentUpdateAdapter.update(student, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStudents(List<Student> students) async {
    await _studentUpdateAdapter.updateList(students, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStudent(Student student) async {
    await _studentDeletionAdapter.delete(student);
  }

  @override
  Future<void> deleteStudents(List<Student> students) async {
    await _studentDeletionAdapter.deleteList(students);
  }
}

class _$TeacherDao extends TeacherDao {
  _$TeacherDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _teacherInsertionAdapter = InsertionAdapter(
            database,
            'teacher',
            (Teacher item) => <String, Object?>{
                  'id': item.id,
                  'dni': item.dni,
                  'hasFoto': item.hasFoto ? 1 : 0,
                  'name': item.name,
                  'photoPathHash': item.photoPathHash,
                  's1': item.s1,
                  's2': item.s2
                },
            changeListener),
        _teacherUpdateAdapter = UpdateAdapter(
            database,
            'teacher',
            ['id'],
            (Teacher item) => <String, Object?>{
                  'id': item.id,
                  'dni': item.dni,
                  'hasFoto': item.hasFoto ? 1 : 0,
                  'name': item.name,
                  'photoPathHash': item.photoPathHash,
                  's1': item.s1,
                  's2': item.s2
                },
            changeListener),
        _teacherDeletionAdapter = DeletionAdapter(
            database,
            'teacher',
            ['id'],
            (Teacher item) => <String, Object?>{
                  'id': item.id,
                  'dni': item.dni,
                  'hasFoto': item.hasFoto ? 1 : 0,
                  'name': item.name,
                  'photoPathHash': item.photoPathHash,
                  's1': item.s1,
                  's2': item.s2
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Teacher> _teacherInsertionAdapter;

  final UpdateAdapter<Teacher> _teacherUpdateAdapter;

  final DeletionAdapter<Teacher> _teacherDeletionAdapter;

  @override
  Future<int?> countTeachers() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM teacher',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Teacher>> findAllTeachers() async {
    return _queryAdapter.queryList('SELECT * FROM teacher',
        mapper: (Map<String, Object?> row) => Teacher(
            id: row['id'] as int?,
            dni: row['dni'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?));
  }

  @override
  Stream<List<String>> findAllTeachersName() {
    return _queryAdapter.queryListStream('SELECT name FROM teacher',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'teacher',
        isView: false);
  }

  @override
  Future<Teacher?> findTeacherById(int id) async {
    return _queryAdapter.query('SELECT * FROM teacher WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Teacher(
            id: row['id'] as int?,
            dni: row['dni'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?),
        arguments: [id]);
  }

  @override
  Stream<List<int?>> observeIdsTeacher() {
    return _queryAdapter.queryListStream(
        'SELECT id FROM teacher WHERE id IS NOT NULL',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        queryableName: 'teacher',
        isView: false);
  }

  @override
  Stream<List<Teacher>> streamAllTeachers() {
    return _queryAdapter.queryListStream('SELECT * FROM teacher',
        mapper: (Map<String, Object?> row) => Teacher(
            id: row['id'] as int?,
            dni: row['dni'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?),
        queryableName: 'teacher',
        isView: false);
  }

  @override
  Future<Teacher?> findTeacherByDni(String dni) async {
    return _queryAdapter.query('SELECT * FROM teacher WHERE dni = ?1',
        mapper: (Map<String, Object?> row) => Teacher(
            id: row['id'] as int?,
            dni: row['dni'] as String,
            name: row['name'] as String,
            s1: row['s1'] as String,
            hasFoto: (row['hasFoto'] as int) != 0,
            s2: row['s2'] as String?,
            photoPathHash: row['photoPathHash'] as String?),
        arguments: [dni]);
  }

  @override
  Future<void> insertTeacher(Teacher professor) async {
    await _teacherInsertionAdapter.insert(professor, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTeachers(List<Teacher> professors) async {
    await _teacherInsertionAdapter.insertList(
        professors, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTeacher(Teacher professor) async {
    await _teacherUpdateAdapter.update(professor, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTeachers(List<Teacher> professor) async {
    await _teacherUpdateAdapter.updateList(professor, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTeacher(Teacher professor) async {
    await _teacherDeletionAdapter.delete(professor);
  }

  @override
  Future<void> deleteTeachers(List<Teacher> professors) async {
    await _teacherDeletionAdapter.deleteList(professors);
  }
}

class _$CursDao extends CursDao {
  _$CursDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _courseInsertionAdapter = InsertionAdapter(
            database,
            'course',
            (Course item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _courseUpdateAdapter = UpdateAdapter(
            database,
            'course',
            ['id'],
            (Course item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _courseDeletionAdapter = DeletionAdapter(
            database,
            'course',
            ['id'],
            (Course item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Course> _courseInsertionAdapter;

  final UpdateAdapter<Course> _courseUpdateAdapter;

  final DeletionAdapter<Course> _courseDeletionAdapter;

  @override
  Future<List<Course>> findAllCursos() async {
    return _queryAdapter.queryList('SELECT * FROM cursos',
        mapper: (Map<String, Object?> row) =>
            Course(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Stream<List<String>> findAllCursosNom() {
    return _queryAdapter.queryListStream('SELECT nom FROM cursos',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'cursos',
        isView: false);
  }

  @override
  Future<Course?> findCursById(int id) async {
    return _queryAdapter.query('SELECT * FROM cursos WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Course(id: row['id'] as int?, name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<Course?> findCursByNom(String nom) async {
    return _queryAdapter.query('SELECT * FROM cursos WHERE nom = ?1',
        mapper: (Map<String, Object?> row) =>
            Course(id: row['id'] as int?, name: row['name'] as String),
        arguments: [nom]);
  }

  @override
  Future<void> buidarCursos() async {
    await _queryAdapter.queryNoReturn('DELETE FROM cursos');
  }

  @override
  Future<int> insertCurs(Course curs) {
    return _courseInsertionAdapter.insertAndReturnId(
        curs, OnConflictStrategy.ignore);
  }

  @override
  Future<void> insertCursos(List<Course> cursos) async {
    await _courseInsertionAdapter.insertList(cursos, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCurs(Course curs) async {
    await _courseUpdateAdapter.update(curs, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCurs(Course curs) async {
    await _courseDeletionAdapter.delete(curs);
  }

  @override
  Future<void> deleteCursos(List<Course> cursos) async {
    await _courseDeletionAdapter.deleteList(cursos);
  }
}

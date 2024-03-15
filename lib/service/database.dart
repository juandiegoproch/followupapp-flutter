import "package:flutter/material.dart";
import 'package:flutter/foundation.dart' show kIsWeb;
import "dart:io";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Database? db;

void onDatabaseOpen(Database db)
{
  debugOnOpen(db);
}

void onDatabaseCreate(Database database, version) {
      database.transaction((txn) {
        txn.execute("""
      CREATE TABLE Tasks (
        taskId INTEGER PRIMARY KEY AUTOINCREMENT,
        area TEXT NOT NULL,
        person TEXT NOT NULL,
        program TEXT NOT NULL,
        deliverable TEXT NOT NULL,
        taskState TEXT NOT NULL -- one of uninitiated,ongoing,finalized,continuous
      );
      """);
        txn.execute("""
      CREATE TABLE Milestones(
          taskId INTEGER,
          mId INTEGER PRIMARY KEY AUTOINCREMENT,
          satisfied INTEGER,
          isFinal INTEGER,
          mDate TEXT, -- ISO 8601 datetime (UTC)
        
          FOREIGN KEY (taskId) REFERENCES Tasks
      );
      """);

        txn.execute("""
      CREATE TABLE Logs(
          taskId INTEGER,
          lId INTEGER PRIMARY KEY AUTOINCREMENT,
          lastModified TEXT, -- ISO 8601 datetime (UTC)
          value TEXT,
		
          FOREIGN KEY (taskId) REFERENCES Tasks
      );
    """);
        return Future.value(null);
      });
      debugOnCreate(database);
}

void debugOnOpen(Database database) async
{
  debugPrint("Opening db at ${await getDatabasesPath()}");
  debugPrint("DB open!");
}

void debugOnCreate(Database database)
{
  String debugData = """  
  INSERT INTO Tasks(area,person,program,deliverable,taskstate) VALUES
  ('finanzas','Jose Felipe','Pagos de Plastico','Plasticos pagados','uninitiated'),
  ('contabilidad', 'Manuel Flores', 'Contar pellets','Numero de pellets apuntado','ongoing'),
  ('cobranzas', 'Patricia Merino', 'Cobrar el centavo','Ultimo centavo cobrado','continuous'),
  ('importaciones','Pedro Patterson','Traer material','60 toneladas en almacen','finalized'),
  ('informes','Informito Lapicerovich', 'Informar','Informe detallado completo','uninitiated'); -- this is malformed
  
  
  -- Asumir hoy = 17 feb 24.
  INSERT INTO Milestones(taskid,satisfied,isFinal,mDate) VALUES 
  (1,null,0,'2024-03-21T00:00:00'), -- 21 mar 24 (Pagos Plastico)
  (1,null,1,'2024-03-23T00:00:00'), -- 23 mar 24, END "
  (2,null,0,'2024-02-15T00:00:00'), -- 15 feb 24, (Contar Pellets)
  (2,null,0,'2024-02-20T00:00:00'), -- 20 feb 24, "
  (2,null,1,'2024-03-10T00:00:00'), -- 10 mar 24, END
  (3,null,0,'2024-02-07T00:00:00'), -- 7 feb 24 (Cobrar centavo)
  (3,null,0,'2024-02-17T00:00:00'), -- 17 feb 24
  (3,null,0,'2024-03-10T00:00:00'), -- 10 mar 24
  (4,null,0,'2024-01-10T00:00:00'), -- 10 ene 24 (Traer material)
  (4,null,0,'2024-01-20T00:00:00'), -- 20 ene 24
  (4,null,1,'2024-02-01T00:00:00'); -- 1 feb 24 (END)
  								    -- X XXX XX (Informar)
                      
    INSERT INTO Logs(taskId,lastModified,value) VALUES
  (1,'2024-02-18T00:00:00','Tarea Ingresada'),
  (2,'2024-02-15T00:00:00','Pallet a1, a2 y a3 tienen 1773, 3342 y 7732 pellets cada uno. En total 77549 pellets. Faltan b1, b2 y b3'),
  (3,'2024-02-07T00:00:00','Se han cobrado 17 centavos de Pablo y Betra. Falta cobrarle a Magnolia y a los hermanos Patroclo'),
  (4,'2024-01-10T00:00:00','Se ha solicitado al vendedor que me de PVC');
  """;
  database.execute(debugData);
}

void startBackend() async {
  if (!kIsWeb) {
    if (Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // Add other platform specific setup here if needed
  }

  // Determine the database path based on the platform
  String databasePath;
  if (kIsWeb) {
    // For web platform, use in-memory database
    databasePath = ':memory:';
  } else {
    // For non-web platforms, use file-based database
    databasePath = "followupapp.db";
  }

  // Open the database
  // deleteDatabase('followupapp.db'); // HACK: for testing
  db = await openDatabase(
    databasePath,
    version: 1,
    onCreate: (db, version) => onDatabaseCreate(db, version),
    onOpen: (db) => onDatabaseOpen(db),
  );
}

Future<void> whenDBUp() async {
  const int tries = 10;
  const int milis = 100;
  // HACK: this should coordinate with the dbinit!
  for (int i = 0; i < tries; i++) {
    if (db != null && db!.isOpen) {
      return Future.value();
    } else {
      await Future.delayed(const Duration(milliseconds: milis)); //pause execution without blocking
    }
  }
  // if the database doesnt respond in three attempts, assume it's broken
  return Future.error(StateError("Database is closed or not responding"));
}

Future<void> stopBackend() async {
  await db?.close();
}

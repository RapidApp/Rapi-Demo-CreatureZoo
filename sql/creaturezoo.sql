
DROP TABLE IF EXISTS [diet_type];
CREATE TABLE [diet_type] (
  [id]      INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name]    varchar(32) NOT NULL,
  [cls]     varchar(16) DEFAULT NULL,
  [about]   text DEFAULT NULL
);
INSERT INTO [diet_type] ([name],[cls]) VALUES ('Herbivore','herbivore');
INSERT INTO [diet_type] ([name],[cls]) VALUES ('Carnivore','carnivore');
INSERT INTO [diet_type] ([name],[cls]) VALUES ('Omnivore','omnivore');

DROP TABLE IF EXISTS [species];
CREATE TABLE [species] (
  [id]            INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [diet_type_id]  INTEGER NOT NULL,
  [name]          varchar(32) UNIQUE NOT NULL,
  [ideal_wt_lbs]  decimal(6,2) DEFAULT NULL,
  [min_sq_ft]     decimal(8,2) DEFAULT NULL,
  [about]         text DEFAULT NULL,
  FOREIGN KEY ([diet_type_id]) REFERENCES [diet_type] ([id]) 
   ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS [enclosure_class];
CREATE TABLE [enclosure_class] (
  [id]             INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [classification] varchar(32) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS [enclosure];
CREATE TABLE [enclosure] (
  [id]                  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [name]                varchar(32) UNIQUE NOT NULL,
  [enclosure_class_id]  INTEGER NOT NULL,
  [length_ft]           decimal(8,2) DEFAULT NULL,
  [width_ft]            decimal(8,2) DEFAULT NULL,
  [height_ft]           decimal(8,2) DEFAULT NULL,
  [open_top]            boolean NOT NULL,
  [detail]              text DEFAULT NULL,
  FOREIGN KEY ([enclosure_class_id]) REFERENCES [enclosure_class] ([id]) 
   ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS [creature];
CREATE TABLE [creature] (
  [id]           INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [species_id]   INTEGER NOT NULL,
  [name]         varchar(32) NOT NULL,
  [image]        text DEFAULT NULL,
  [attachment]   text DEFAULT NULL,
  [dob]          date NOT NULL,
  [high_risk]    boolean NOT NULL DEFAULT 0,
  [market_value] decimal(14,2) DEFAULT NULL,
  [detail]       text DEFAULT NULL,
  [enclosure_id] INTEGER,
  FOREIGN KEY ([species_id]) REFERENCES [species] ([id]) 
   ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY ([enclosure_id]) REFERENCES [enclosure] ([id]) 
   ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS [creature_weight_log];
CREATE TABLE [creature_weight_log] (
  [id]            INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [creature_id]   INTEGER NOT NULL,
  [recorded]      datetime NOT NULL,
  [weight_lbs]    decimal(6,2) NOT NULL,
  [comment]       text DEFAULT NULL,
  FOREIGN KEY ([creature_id]) REFERENCES [creature] ([id]) 
   ON DELETE CASCADE ON UPDATE CASCADE
);

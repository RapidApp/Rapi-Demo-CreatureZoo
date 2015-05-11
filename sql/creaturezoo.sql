
------------------------------------------------------------------
-- TODO: tie into some imported 3rd-part scpecies taxonomy db...
--
-- DROP TABLE IF EXISTS [taxonomy];
-- CREATE TABLE [taxonomy] (
--   [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
--    
--       ...
-- );
------------------------------------------------------------------


DROP TABLE IF EXISTS [species];
CREATE TABLE [species] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
--[taxonomy_id] INTEGER NOT NULL,
  [name] varchar(32) NOT NULL,
  [about] varchar(255) DEFAULT NULL,
--FOREIGN KEY ([taxonomy_id]) REFERENCES [taxonomy] ([id]) 
--  ON DELETE CASCADE ON UPDATE CASCADE,
);


DROP TABLE IF EXISTS [creature];
CREATE TABLE [creature] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [species_id] INTEGER NOT NULL,
  [name] varchar(32) NOT NULL,
  [detail] text DEFAULT NULL,
  FOREIGN KEY ([species_id]) REFERENCES [species] ([id]) 
   ON DELETE CASCADE ON UPDATE CASCADE,
);


DROP TABLE IF EXISTS [creature_weight_log];
CREATE TABLE [creature_weight_log] (
  [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  [creature_id] INTEGER NOT NULL,
  [recorded] datetime NOT NULL,
  [weight_lbs] decimal(6,2) NOT NULL,
  [comment] text DEFAULT NULL,
  FOREIGN KEY ([creature_id]) REFERENCES [creature] ([id]) 
   ON DELETE CASCADE ON UPDATE CASCADE
);

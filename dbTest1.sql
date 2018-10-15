

CREATE TABLE "locations" (
"tid" INTEGER REFERENCES "tracks"("tid") ON DELETE CASCADE,
"lat" REAL,
"lon" REAL,
"altitude" REAL,
"horizontalAccuracy" REAL,
"verticalAccuracy" REAL,
"speed" REAL,
"course" REAL,
"timeStamp" TEXT
);
INSERT INTO "locations" VALUES (1, 46.0, -112.0, 1000.0, 5.0, 5.0, 1.0, 10.0, '2018-10-10 17:33:55');
INSERT INTO "locations" VALUES (1, 47.0, -111.0, 2000.0, 10.0, 6.0, 2.0, 20.0, '2018-10-10 17:34:51');
INSERT INTO "locations" VALUES (2, 45.0, -110.0, 3000.0, 15.0, 7.0, 3.0, 30.0, '2018-10-11 17:34:29');
INSERT INTO "locations" VALUES (2, 46.5, -111.5, 4000.0, 20.0, 8.0, 4.0, 40.0, '2018-10-11 17:35:35');
INSERT INTO "locations" VALUES (2, 47.5, -112.5, 5000.0, 25.0, 9.0, 5.0, 50.0, '2018-10-11 17:36:22');


CREATE TABLE "tracks" (
"tid" INTEGER,
"uuid" TEXT,
"name" TEXT,
"dateCreated" TEXT,
"dateModified" TEXT,
"currentTrack" INTEGER DEFAULT 0,
"uploaded" INTEGER DEFAULT 0,
"notes" TEXT,
PRIMARY KEY ("tid")
);
INSERT INTO "tracks" VALUES (1, '8359cd29-d7f9-42dc-83e3-90f978a5aff2', 'Test Track 1', '2018-10-10 17:33:51', '2018-10-10 17:45:02', 0, 1, 'Saw a monster bull');
INSERT INTO "tracks" VALUES (2, 'f098ec92-2d9b-4608-96f3-da97d8d5d920', 'Test Track 2', '2018-10-11 17:34:18', '2018-10-11 18:54:18', 1, 0, 'Skunked');
INSERT INTO "tracks" VALUES (3, '2e189b42-1b0d-4849-9850-b1cc30fb9d8a', 'Test Track 3', '2018-10-14 21:56:50', NULL, 0, 0, NULL);

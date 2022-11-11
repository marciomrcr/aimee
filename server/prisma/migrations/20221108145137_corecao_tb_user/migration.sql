/*
  Warnings:

  - You are about to drop the column `adress` on the `Cliente` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Cliente" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "whatsapp" TEXT,
    "instagram" TEXT,
    "facebook" TEXT,
    "address" TEXT,
    "city" TEXT,
    "state" TEXT,
    "zipcode" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_Cliente" ("city", "createdAt", "facebook", "id", "instagram", "name", "phone", "state", "whatsapp", "zipcode") SELECT "city", "createdAt", "facebook", "id", "instagram", "name", "phone", "state", "whatsapp", "zipcode" FROM "Cliente";
DROP TABLE "Cliente";
ALTER TABLE "new_Cliente" RENAME TO "Cliente";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

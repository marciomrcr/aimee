/*
  Warnings:

  - Added the required column `cnpj` to the `Provider` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Provider" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "cnpj" TEXT NOT NULL,
    "ie" TEXT,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "whatsapp" TEXT,
    "email" TEXT NOT NULL,
    "instagram" TEXT,
    "facebook" TEXT,
    "address" TEXT,
    "city" TEXT,
    "state" TEXT,
    "zipcode" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_Provider" ("address", "city", "createdAt", "email", "facebook", "id", "instagram", "name", "phone", "state", "whatsapp", "zipcode") SELECT "address", "city", "createdAt", "email", "facebook", "id", "instagram", "name", "phone", "state", "whatsapp", "zipcode" FROM "Provider";
DROP TABLE "Provider";
ALTER TABLE "new_Provider" RENAME TO "Provider";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

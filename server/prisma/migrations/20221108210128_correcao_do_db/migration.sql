/*
  Warnings:

  - You are about to drop the column `consumerId` on the `Sale` table. All the data in the column will be lost.
  - The primary key for the `Sale_Product` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - Added the required column `consumerId` to the `Sale_Product` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "Purchase" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "sum_total" INTEGER NOT NULL,
    "count_itens" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Purcahase_Product" (
    "providerId" TEXT NOT NULL,
    "purchaseId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "price" INTEGER NOT NULL,
    "subtotal" INTEGER NOT NULL,

    PRIMARY KEY ("purchaseId", "providerId"),
    CONSTRAINT "Purcahase_Product_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Purcahase_Product_purchaseId_fkey" FOREIGN KEY ("purchaseId") REFERENCES "Purchase" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Purcahase_Product_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Sale" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "sum_total" INTEGER NOT NULL,
    "count_itens" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_Sale" ("count_itens", "createdAt", "id", "sum_total") SELECT "count_itens", "createdAt", "id", "sum_total" FROM "Sale";
DROP TABLE "Sale";
ALTER TABLE "new_Sale" RENAME TO "Sale";
CREATE TABLE "new_Sale_Product" (
    "saleId" TEXT NOT NULL,
    "consumerId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "price" INTEGER NOT NULL,
    "subtotal" INTEGER NOT NULL,

    PRIMARY KEY ("saleId", "consumerId"),
    CONSTRAINT "Sale_Product_consumerId_fkey" FOREIGN KEY ("consumerId") REFERENCES "Consumer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Sale_Product_saleId_fkey" FOREIGN KEY ("saleId") REFERENCES "Sale" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Sale_Product_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Sale_Product" ("amount", "price", "productId", "saleId", "subtotal") SELECT "amount", "price", "productId", "saleId", "subtotal" FROM "Sale_Product";
DROP TABLE "Sale_Product";
ALTER TABLE "new_Sale_Product" RENAME TO "Sale_Product";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

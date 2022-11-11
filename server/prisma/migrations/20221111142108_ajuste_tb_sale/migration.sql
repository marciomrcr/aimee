/*
  Warnings:

  - The primary key for the `Sale_Product` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `amount` on the `Sale_Product` table. All the data in the column will be lost.
  - You are about to drop the column `price` on the `Sale_Product` table. All the data in the column will be lost.
  - Added the required column `consumerId` to the `Sale` table without a default value. This is not possible if the table is not empty.
  - Added the required column `amountProduct` to the `Sale_Product` table without a default value. This is not possible if the table is not empty.
  - The required column `id` was added to the `Sale_Product` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.
  - Added the required column `priceSale` to the `Sale_Product` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Sale" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL,
    "consumerId" TEXT NOT NULL,
    "sum_total" INTEGER NOT NULL,
    "count_itens" INTEGER NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Sale_consumerId_fkey" FOREIGN KEY ("consumerId") REFERENCES "Consumer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Sale" ("code", "count_itens", "createdAt", "id", "sum_total", "updatedAt") SELECT "code", "count_itens", "createdAt", "id", "sum_total", "updatedAt" FROM "Sale";
DROP TABLE "Sale";
ALTER TABLE "new_Sale" RENAME TO "Sale";
CREATE UNIQUE INDEX "Sale_code_key" ON "Sale"("code");
CREATE TABLE "new_Sale_Product" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "saleId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "amountProduct" INTEGER NOT NULL,
    "priceSale" INTEGER NOT NULL,
    "subtotal" INTEGER NOT NULL,
    "consumerId" TEXT,
    CONSTRAINT "Sale_Product_saleId_fkey" FOREIGN KEY ("saleId") REFERENCES "Sale" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Sale_Product_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Sale_Product" ("consumerId", "productId", "saleId", "subtotal") SELECT "consumerId", "productId", "saleId", "subtotal" FROM "Sale_Product";
DROP TABLE "Sale_Product";
ALTER TABLE "new_Sale_Product" RENAME TO "Sale_Product";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

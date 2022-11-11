/*
  Warnings:

  - The primary key for the `Category_Product` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The required column `id` was added to the `Category_Product` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Category_Product" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "productId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    CONSTRAINT "Category_Product_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Category_Product_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Category_Product" ("categoryId", "productId") SELECT "categoryId", "productId" FROM "Category_Product";
DROP TABLE "Category_Product";
ALTER TABLE "new_Category_Product" RENAME TO "Category_Product";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

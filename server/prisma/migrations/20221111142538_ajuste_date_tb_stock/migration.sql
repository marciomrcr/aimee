-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_stock_Movement" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL DEFAULT 1,
    "entry_date" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "output_date" DATETIME,
    CONSTRAINT "stock_Movement_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_stock_Movement" ("amount", "code", "entry_date", "id", "output_date", "productId") SELECT "amount", "code", "entry_date", "id", "output_date", "productId" FROM "stock_Movement";
DROP TABLE "stock_Movement";
ALTER TABLE "new_stock_Movement" RENAME TO "stock_Movement";
CREATE UNIQUE INDEX "stock_Movement_code_key" ON "stock_Movement"("code");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

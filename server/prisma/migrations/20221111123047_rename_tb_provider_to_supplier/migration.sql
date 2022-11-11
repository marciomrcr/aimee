/*
  Warnings:

  - You are about to drop the `Provider` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropIndex
DROP INDEX "Provider_facebook_key";

-- DropIndex
DROP INDEX "Provider_instagram_key";

-- DropIndex
DROP INDEX "Provider_email_key";

-- DropIndex
DROP INDEX "Provider_whatsapp_key";

-- DropIndex
DROP INDEX "Provider_phone_key";

-- DropIndex
DROP INDEX "Provider_ie_key";

-- DropIndex
DROP INDEX "Provider_name_key";

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "Provider";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "Supplier" (
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

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Purcahase_Product" (
    "providerId" TEXT NOT NULL,
    "purchaseId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "price" INTEGER NOT NULL,
    "subtotal" INTEGER NOT NULL,

    PRIMARY KEY ("purchaseId", "providerId"),
    CONSTRAINT "Purcahase_Product_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Supplier" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Purcahase_Product_purchaseId_fkey" FOREIGN KEY ("purchaseId") REFERENCES "Purchase" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Purcahase_Product_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Purcahase_Product" ("amount", "price", "productId", "providerId", "purchaseId", "subtotal") SELECT "amount", "price", "productId", "providerId", "purchaseId", "subtotal" FROM "Purcahase_Product";
DROP TABLE "Purcahase_Product";
ALTER TABLE "new_Purcahase_Product" RENAME TO "Purcahase_Product";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_ie_key" ON "Supplier"("ie");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_name_key" ON "Supplier"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_phone_key" ON "Supplier"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_whatsapp_key" ON "Supplier"("whatsapp");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_email_key" ON "Supplier"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_instagram_key" ON "Supplier"("instagram");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_facebook_key" ON "Supplier"("facebook");

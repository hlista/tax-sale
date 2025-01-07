-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Property" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "parcelNumber" TEXT NOT NULL,
    "taxSale" BOOLEAN,
    "location" TEXT,
    "nameAndAddress" TEXT,
    "grossAccessedValueOfProperty" DECIMAL,
    "homesteadDeduction" DECIMAL,
    "mortgageDeduction" DECIMAL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_Property" ("createdAt", "grossAccessedValueOfProperty", "homesteadDeduction", "id", "location", "mortgageDeduction", "nameAndAddress", "parcelNumber", "taxSale", "updatedAt") SELECT "createdAt", "grossAccessedValueOfProperty", "homesteadDeduction", "id", "location", "mortgageDeduction", "nameAndAddress", "parcelNumber", "taxSale", "updatedAt" FROM "Property";
DROP TABLE "Property";
ALTER TABLE "new_Property" RENAME TO "Property";
CREATE UNIQUE INDEX "Property_parcelNumber_key" ON "Property"("parcelNumber");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

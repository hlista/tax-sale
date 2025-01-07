-- CreateTable
CREATE TABLE "Property" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "parcelNumber" TEXT NOT NULL,
    "taxSale" BOOLEAN NOT NULL,
    "location" TEXT NOT NULL,
    "nameAndAddress" TEXT NOT NULL,
    "grossAccessedValueOfProperty" DECIMAL NOT NULL,
    "homesteadDeduction" DECIMAL NOT NULL,
    "mortgageDeduction" DECIMAL NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateIndex
CREATE UNIQUE INDEX "Property_parcelNumber_key" ON "Property"("parcelNumber");

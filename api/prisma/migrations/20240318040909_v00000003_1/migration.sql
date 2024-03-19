/*
  Warnings:

  - You are about to alter the column `initialTime` on the `Word` table. The data in that column could be lost. The data in that column will be cast from `Int` to `Decimal(65,30)`.
  - You are about to alter the column `finalTime` on the `Word` table. The data in that column could be lost. The data in that column will be cast from `Int` to `Decimal(65,30)`.

*/
-- AlterTable
ALTER TABLE `Word` MODIFY `initialTime` DECIMAL(65, 30) NOT NULL,
    MODIFY `finalTime` DECIMAL(65, 30) NOT NULL;

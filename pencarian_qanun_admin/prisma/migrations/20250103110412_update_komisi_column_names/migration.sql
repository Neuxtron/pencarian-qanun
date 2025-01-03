/*
  Warnings:

  - You are about to drop the column `namaKomisi` on the `komisi` table. All the data in the column will be lost.
  - You are about to drop the column `nomorKomisi` on the `komisi` table. All the data in the column will be lost.
  - Added the required column `nama_komisi` to the `Komisi` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nomor_komisi` to the `Komisi` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `komisi` DROP COLUMN `namaKomisi`,
    DROP COLUMN `nomorKomisi`,
    ADD COLUMN `nama_komisi` VARCHAR(191) NOT NULL,
    ADD COLUMN `nomor_komisi` INTEGER NOT NULL;

-- CreateTable
CREATE TABLE `Qanun` (
    `id` VARCHAR(191) NOT NULL,
    `idKomisi` VARCHAR(191) NOT NULL,
    `tahun` INTEGER NOT NULL,
    `nomor_qanun` INTEGER NOT NULL,
    `nama_qanun` VARCHAR(191) NOT NULL,
    `nama_file` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Tag` (
    `id` VARCHAR(191) NOT NULL,
    `idQanun` VARCHAR(191) NOT NULL,
    `text` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Qanun` ADD CONSTRAINT `Qanun_idKomisi_fkey` FOREIGN KEY (`idKomisi`) REFERENCES `Komisi`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Tag` ADD CONSTRAINT `Tag_idQanun_fkey` FOREIGN KEY (`idQanun`) REFERENCES `Qanun`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

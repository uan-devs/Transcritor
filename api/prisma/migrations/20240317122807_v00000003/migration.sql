-- CreateTable
CREATE TABLE `Transcription` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `userId` INTEGER NOT NULL,
    `multimediaId` INTEGER NOT NULL,
    `text` TEXT NOT NULL,
    `language` VARCHAR(191) NULL DEFAULT 'en',
    `status` VARCHAR(191) NULL DEFAULT 'pending',

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Multimedia` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `userId` INTEGER NOT NULL,
    `fileType` ENUM('Audio', 'Video') NOT NULL,
    `fileUrl` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `status` VARCHAR(191) NULL DEFAULT 'pending',
    `language` VARCHAR(191) NULL DEFAULT 'en',

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Word` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `transcriptionId` INTEGER NOT NULL,
    `initialTime` INTEGER NOT NULL,
    `finalTime` INTEGER NOT NULL,
    `word` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Transcription` ADD CONSTRAINT `Transcription_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Transcription` ADD CONSTRAINT `Transcription_multimediaId_fkey` FOREIGN KEY (`multimediaId`) REFERENCES `Multimedia`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Multimedia` ADD CONSTRAINT `Multimedia_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Word` ADD CONSTRAINT `Word_transcriptionId_fkey` FOREIGN KEY (`transcriptionId`) REFERENCES `Transcription`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

import {
  Injectable,
  NotFoundException,
  ServiceUnavailableException,
} from '@nestjs/common';
import * as speech from '@google-cloud/speech';
import { FirebaseService } from '../firebase/firebase.service';
import { PrismaService } from '../prisma/prisma.service';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime/library';

@Injectable()
export class TranscriptionService {
  constructor(
    private readonly firebase: FirebaseService,
    private readonly prisma: PrismaService,
  ) {}

  async createTranscription(userId: number, file: Express.Multer.File) {
    const client = new speech.SpeechClient();
    const audioBytes = file.buffer.toString('base64');

    const audio = {
      content: audioBytes,
    };

    const [response] = await client.recognize({
      audio: audio,
      config: {
        languageCode: 'pt-PT',
        encoding: 'LINEAR16',
        enableWordTimeOffsets: true,
      },
    });

    if (response !== null) {
      const mediaUrl = await this.firebase.uploadMedia(file);

      try {
        const [media, transcription] = await this.prisma.$transaction(
          async (tx) => {
            const media = await tx.multimedia.create({
              data: {
                userId: userId,
                fileUrl: mediaUrl,
                name: file.originalname,
                fileType: file.mimetype.includes('audio') ? 'Audio' : 'Video',
                language: response.results[0].languageCode ?? 'pt-PT',
              },
            });

            const transcription = await tx.transcription.create({
              data: {
                userId: userId,
                multimediaId: media.id,
                text: response.results[0].alternatives[0].transcript,
                language: response.results[0].languageCode ?? 'pt-PT',
              },
            });

            for (const word of response.results[0].alternatives[0].words) {
              const initialTime = parseFloat(word.startTime.seconds.toString());
              const finalTime = parseFloat(word.endTime.seconds.toString());

              await tx.word.create({
                data: {
                  transcriptionId: transcription.id,
                  word: word.word,
                  initialTime: initialTime,
                  finalTime: finalTime,
                },
              });
            }

            return [media, transcription];
          },
        );

        delete transcription.userId;
        delete transcription.multimediaId;
        delete media.id;
        delete media.userId;
        delete media.updatedAt;

        return {
          ...transcription,
          media: {
            ...media,
          },
        };
      } catch (error) {
        if (error instanceof PrismaClientKnownRequestError) {
          throw new ServiceUnavailableException(
            'Error in the storage service. Please try again later.',
          );
        } else {
          throw new ServiceUnavailableException(
            'Error in the transcription service. Please try again later.',
          );
        }
      }
    } else {
      throw new ServiceUnavailableException(
        'Error in the transcription service. Please try again later.',
      );
    }
  }

  async getAllTranscriptions(userId: number) {
    const transcriptions = await this.prisma.transcription.findMany({
      where: {
        userId: userId,
      },
      include: {
        multimedia: true,
      },
    });

    return transcriptions.map((transcription) => {
      return {
        id: transcription.id,
        createdAt: transcription.createdAt,
        text: transcription.text,
        language: transcription.language,
        multimedia: {
          name: transcription.multimedia.name,
        },
      };
    });
  }

  async getTranscription(userId: number, transcriptionId: number) {
    const transcription = await this.prisma.transcription.findFirst({
      where: {
        id: transcriptionId,
        userId: userId,
      },
      include: {
        multimedia: true,
        words: true,
      },
    });

    if (transcription === null) {
      throw new NotFoundException('Transcription not found');
    }

    return {
      id: transcription.id,
      createdAt: transcription.createdAt,
      text: transcription.text,
      language: transcription.language,
      multimedia: {
        name: transcription.multimedia.name,
        url: transcription.multimedia.fileUrl,
      },
      words: transcription.words.map((word) => {
        return {
          word: word.word,
          initialTime: word.initialTime,
          finalTime: word.finalTime,
        };
      }),
    };
  }
}

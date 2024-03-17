import { Injectable } from '@nestjs/common';

@Injectable()
export class TranscriptionService {
  async createTranscription(userId: number, file: Express.Multer.File) {
    console.log(file);
    // Identify the media type
    // Identify the media language
    // Transcribe the media
    // Save the transcription
    // Build the response
    // Return the response
    return {
      text: 'Hello, World!',
    };
  }
}

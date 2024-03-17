import {
  Controller,
  HttpStatus,
  ParseFilePipeBuilder,
  Post,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { TranscriptionService } from './transcription.service';
import { JwtGuard } from '../auth/guard';
import { GetUser } from '../auth/decorator';
import { FileInterceptor } from '@nestjs/platform-express';

@UseGuards(JwtGuard)
@Controller('transcription')
export class TranscriptionController {
  constructor(private readonly transcriptionService: TranscriptionService) {}

  @Post('create')
  @UseInterceptors(FileInterceptor('media'))
  createTranscription(
    @GetUser('id') userId: number,
    @UploadedFile(
      new ParseFilePipeBuilder()
        .addFileTypeValidator({
          fileType: 'wav',
        })
        .addMaxSizeValidator({
          maxSize: 10 * 1024 * 1024,
          message(maxSize) {
            return `File size should not exceed ${maxSize} Kb`;
          },
        })
        .build({
          errorHttpStatusCode: HttpStatus.BAD_REQUEST,
        }),
    )
    file: Express.Multer.File,
  ) {
    return this.transcriptionService.createTranscription(userId, file);
  }
}

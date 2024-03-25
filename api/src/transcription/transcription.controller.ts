import {
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
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
import { diskStorage } from 'multer';

@UseGuards(JwtGuard)
@Controller('transcription')
export class TranscriptionController {
  constructor(private readonly transcriptionService: TranscriptionService) {}

  @Post('create')
  @UseInterceptors(
    FileInterceptor('media', {
      storage: diskStorage({
        destination: './uploads',
        filename(req, file, cb) {
          console.log(file);
          cb(null, file.originalname);
        },
      }),
    }),
  )
  async createTranscription(
    @GetUser('id') userId: number,
    @UploadedFile(
      new ParseFilePipeBuilder()
        .addFileTypeValidator({
          fileType: new RegExp('audio/(ogg|wav|mp3|mp4|m4a)'),
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
    console.log(file);
    return this.transcriptionService.createTranscription(userId, file);
  }

  @Get('list')
  getAllTranscriptions(@GetUser('id') userId: number) {
    return this.transcriptionService.getAllTranscriptions(userId);
  }

  @Get(':id')
  getTranscription(@GetUser('id') userId: number, @Param('id') id: string) {
    return this.transcriptionService.getTranscription(userId, parseInt(id));
  }

  @HttpCode(HttpStatus.NO_CONTENT)
  @Delete(':id')
  deleteTranscription(@GetUser('id') userId: number, @Param('id') id: string) {
    return this.transcriptionService.deleteTranscription(userId, parseInt(id));
  }
}

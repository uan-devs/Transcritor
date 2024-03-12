import {
  Body,
  Controller,
  Get,
  Patch,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { User } from '@prisma/client';
import { GetUser } from '../auth/decorator';
import { JwtGuard } from '../auth/guard';
import { UserService } from './user.service';
import { ChangePasswordDTO, EditUserDTO } from './dto';
import { FileInterceptor } from '@nestjs/platform-express';

@UseGuards(JwtGuard)
@Controller('users')
export class UserController {
  constructor(private service: UserService) {}

  @Get('me')
  get(@GetUser() user: User) {
    return user;
  }

  @Patch('me')
  editUser(@GetUser('id') userId: number, @Body() dto: EditUserDTO) {
    return this.service.editUser(userId, dto);
  }

  @Patch('change-password')
  changePassword(
    @GetUser('id') userId: number,
    @Body() dto: ChangePasswordDTO,
  ) {
    return this.service.changePassword(userId, dto);
  }

  @Patch('upload-image')
  @UseInterceptors(FileInterceptor('photo'))
  updatePhoto(
    @GetUser('id') userId: number,
    @UploadedFile() file: Express.Multer.File,
  ) {
    return this.service.updatePhoto(userId, file);
  }
}

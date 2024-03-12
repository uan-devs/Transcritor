import * as argon from 'argon2';
import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  ChangePasswordDTO,
  ChangePasswordResponseDTO,
  EditUserDTO,
  EditUserResponseDTO,
} from './dto';
import { FirebaseService } from 'src/firebase/firebase.service';

@Injectable()
export class UserService {
  constructor(
    private prisma: PrismaService,
    private firebase: FirebaseService,
  ) {}

  async editUser(id: number, dto: EditUserDTO): Promise<EditUserResponseDTO> {
    const date = dto.dateOfBirth ? new Date(dto.dateOfBirth) : null;

    delete dto.dateOfBirth;

    const user = await this.prisma.user.update({
      where: {
        id: id,
      },
      data: {
        dateOfBirth: date ? new Date(date.toISOString()) : null,
        ...dto,
      },
    });

    delete user.password;

    return {
      ...user,
    };
  }

  async changePassword(
    id: number,
    dto: ChangePasswordDTO,
  ): Promise<ChangePasswordResponseDTO> {
    const user = await this.prisma.user.findUnique({
      where: {
        id: id,
      },
    });

    const correctPassword = await argon.verify(
      user.password,
      dto.currentPassword,
    );

    if (!correctPassword) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const samePassword = await argon.verify(user.password, dto.newPassword);

    if (samePassword) {
      throw new BadRequestException('Invalid request');
    }

    const hash = await argon.hash(dto.newPassword);

    await this.prisma.user.update({
      where: {
        id: id,
      },
      data: {
        password: hash,
      },
    });

    return {
      message: 'Password changed successfully',
    };
  }

  async updatePhoto(id: number, file: Express.Multer.File) {
    const url = await this.firebase.uploadImage(file);
    const user = await this.prisma.user.update({
      where: {
        id: id,
      },
      data: {
        profileImage: url,
      },
    });

    delete user.password;

    return { ...user };
  }
}

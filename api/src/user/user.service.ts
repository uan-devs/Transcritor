import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  ChangePasswordDTO,
  ChangePasswordResponseDTO,
  EditUserDTO,
  EditUserResponseDTO,
} from './dto';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async editUser(id: number, dto: EditUserDTO): Promise<EditUserResponseDTO> {
    return {
      id,
      ...dto,
    };
  }

  async changePassword(
    id: number,
    dto: ChangePasswordDTO,
  ): Promise<ChangePasswordResponseDTO> {
    return {
      id: id,
      ...dto,
    };
  }
}

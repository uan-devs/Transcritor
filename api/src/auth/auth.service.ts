import { Injectable } from '@nestjs/common';
import {
  LoginRequestDTO,
  LoginResponseDTO,
  RegisterRequestDTO,
  RegisterResponseDTO,
} from './dto';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwt: JwtService,
    private config: ConfigService,
  ) {}

  async login(dto: LoginRequestDTO): Promise<LoginResponseDTO> {
    return {
      access_token: dto.email,
      refresh_token: dto.password,
    };
  }

  async register(dto: RegisterRequestDTO): Promise<RegisterResponseDTO> {
    return {
      access_token: dto.email,
      refresh_token: dto.firstName,
    };
  }
}

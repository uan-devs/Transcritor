import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginRequestDTO, RegisterRequestDTO } from './dto';
import { GetUser } from './decorator';
import { JwtGuard } from './guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @HttpCode(HttpStatus.OK)
  @Post('login')
  login(@Body() dto: LoginRequestDTO) {
    return this.authService.login(dto);
  }

  @Post('register')
  register(@Body() dto: RegisterRequestDTO) {
    return this.authService.register(dto);
  }

  @UseGuards(JwtGuard)
  @Get('refresh-token')
  refreshToken(@GetUser('id') userId: number) {
    return this.authService.refreshToken(userId);
  }
}

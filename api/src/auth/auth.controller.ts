import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginRequestDTO, RegisterRequestDTO } from './dto';

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
}

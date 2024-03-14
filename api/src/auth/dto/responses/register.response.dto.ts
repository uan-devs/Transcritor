import { IsNotEmpty, IsString } from 'class-validator';

export class RegisterResponseDTO {
  @IsString()
  @IsNotEmpty()
  access_token: string;

  @IsString()
  @IsNotEmpty()
  refresh_token: string;
}

import { IsNotEmpty, IsString } from 'class-validator';

export class RefreshTokenResponseDTO {
  @IsString()
  @IsNotEmpty()
  access_token: string;

  @IsString()
  @IsNotEmpty()
  refresh_token: string;
}

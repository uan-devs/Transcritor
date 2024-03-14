import { IsNotEmpty, IsString } from 'class-validator';

export class ChangePasswordResponseDTO {
  @IsString()
  @IsNotEmpty()
  message: string;
}

import { IsNumberString } from 'class-validator';

export class CreateTranscriptionResponseDTO {
  @IsNumberString()
  id: number;
}

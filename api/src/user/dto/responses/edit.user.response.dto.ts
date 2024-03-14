import { PartialType } from '@nestjs/mapped-types';
import { UserResponseDTO } from './user.response.dto';

export class EditUserResponseDTO extends PartialType(UserResponseDTO) {}

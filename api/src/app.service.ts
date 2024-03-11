import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello() {
    return { message: 'Seja bem vindo à API UAN Transcritor (UTA)' };
  }
}

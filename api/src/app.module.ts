import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { FirebaseModule } from './firebase/firebase.module';
import { TranscriptionModule } from './transcription/transcription.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';
import { MulterModule } from '@nestjs/platform-express';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..'),
    }),
    MulterModule.register({
      dest: './uploads',
    }),
    FirebaseModule,
    PrismaModule,
    AuthModule,
    UserModule,
    TranscriptionModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

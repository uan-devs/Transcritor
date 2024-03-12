import { v4 as createId } from 'uuid';
import { FirebaseOptions, initializeApp } from 'firebase/app';
import {
  getStorage,
  ref,
  getDownloadURL,
  uploadBytesResumable,
} from 'firebase/storage';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class FirebaseService {
  private app;
  private storage;

  constructor(private config: ConfigService) {
    const firebaseConfig: FirebaseOptions = {
      apiKey: config.get('API_KEY'),
      authDomain: config.get('AUTH_DOMAIN'),
      projectId: config.get('PROJECT_ID'),
      storageBucket: config.get('STORAGE_BUCKET'),
      messagingSenderId: config.get('MESSAGING_SENDER_ID'),
      appId: config.get('APP_ID'),
    };

    this.app = initializeApp(firebaseConfig);
    this.storage = getStorage(this.app);
  }

  async uploadImage(file: Express.Multer.File) {
    const randomName = createId();
    return await this.uploadFile(
      file,
      `profileImages/${randomName}-${file.originalname.replaceAll(/\s/g, '')}`,
    );
  }

  private async uploadFile(
    file: Express.Multer.File,
    path: string,
  ): Promise<string> {
    const newFile = ref(this.storage, path);
    const upload = await uploadBytesResumable(newFile, file.buffer, {
      contentType: file.mimetype,
    });
    const fileUrl = await getDownloadURL(upload.ref);

    return fileUrl;
  }
}

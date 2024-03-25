import { v4 as createId } from 'uuid';
import { FirebaseOptions, initializeApp } from 'firebase/app';
import {
  getStorage,
  ref,
  getDownloadURL,
  uploadBytesResumable,
  deleteObject,
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

  async deleteFileByUrl(url: string) {
    const storageRef = ref(this.storage, url);

    await deleteObject(storageRef);
  }

  async uploadImage(file: Express.Multer.File) {
    const randomName = createId();
    return await this.uploadFile(
      file.buffer,
      file.mimetype,
      `profileImages/${randomName}-${file.originalname.replaceAll(/\s/g, '')}`,
    );
  }

  async uploadMedia(buffer: Buffer, mimetype: string, name: string) {
    const randomName = createId();
    return await this.uploadFile(
      buffer,
      mimetype,
      `audioFiles/${randomName}-${name.replaceAll(/\s/g, '')}`,
    );
  }

  private async uploadFile(
    buffer: Buffer,
    mimetype: string,
    path: string,
  ): Promise<string> {
    const newFile = ref(this.storage, path);
    const upload = await uploadBytesResumable(newFile, buffer, {
      contentType: mimetype,
    });
    const fileUrl = await getDownloadURL(upload.ref);

    return fileUrl;
  }
}

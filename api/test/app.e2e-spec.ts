import * as pactum from 'pactum';
import { Faker, en, pt_PT } from '@faker-js/faker';
import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { AppModule } from './../src/app.module';
import { PrismaService } from './../src/prisma/prisma.service';
import { RegisterRequestDTO, LoginRequestDTO } from '../src/auth/dto';

describe('App (e2e)', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  const faker = new Faker({ locale: [pt_PT, en] });
  const userPassword = faker.internet.password();

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
    await app.init();
    await app.listen(3000);

    prisma = app.get(PrismaService);

    await prisma.cleanDB();

    pactum.request.setBaseUrl('http://localhost:3000');
  });

  afterAll(() => {
    app.close();
  });

  describe('API root', () => {
    const endpoint = '/';

    it('Should return a welcome message', () => {
      return pactum
        .spec()
        .get(endpoint)
        .expectStatus(200)
        .expectBodyContains('message');
    });
  });

  describe('Auth group', () => {
    const registerRequestDTO: RegisterRequestDTO = {
      email: faker.internet.email(),
      password: userPassword,
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName(),
      province: faker.location.state(),
    };

    describe('Register endpoint', () => {
      const endpoint = '/auth/register';

      // Test the register endpoint error cases
      it('Should return a 400 status code if the request body is invalid', () => {
        return pactum.spec().post(endpoint).withBody({}).expectStatus(400);
      });

      it('Should return a 400 status code if the email is invalid', () => {
        const dtoCopy = { ...registerRequestDTO, email: 'invalid-email' };

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the email is missing', () => {
        const dtoCopy = { ...registerRequestDTO };
        delete dtoCopy.email;

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the password is empty', () => {
        const dtoCopy = { ...registerRequestDTO, password: '' };

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the password is missing', () => {
        const dtoCopy = { ...registerRequestDTO };
        delete dtoCopy.password;

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the first name is empty', () => {
        const dtoCopy = { ...registerRequestDTO, firstName: '' };

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the first name is missing', () => {
        const dtoCopy = { ...registerRequestDTO };
        delete dtoCopy.firstName;

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 201 status code if the request body is valid', () => {
        return pactum
          .spec()
          .post(endpoint)
          .withBody(registerRequestDTO)
          .expectStatus(201)
          .expectBodyContains('access_token')
          .expectBodyContains('refresh_token');
      });
    });

    describe('Login endpoint', () => {
      const endpoint = '/auth/login';
      const loginRequestDTO: LoginRequestDTO = {
        email: registerRequestDTO.email,
        password: registerRequestDTO.password,
      };

      // Test the login endpoint error cases
      it('Should return a 400 status code if the request body is invalid', () => {
        return pactum.spec().post(endpoint).withBody({}).expectStatus(400);
      });

      it('Should return a 400 status code if the email is invalid', () => {
        const dtoCopy = { ...loginRequestDTO, email: 'invalid-email' };

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the email is empty', () => {
        const dtoCopy = { ...loginRequestDTO, email: '' };

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the email is missing', () => {
        const dtoCopy = { ...loginRequestDTO };
        delete dtoCopy.email;

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the password is missing', () => {
        const dtoCopy = { ...loginRequestDTO };
        delete dtoCopy.password;

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 400 status code if the password is empty', () => {
        const dtoCopy = { ...loginRequestDTO, password: '' };

        return pactum.spec().post(endpoint).withBody(dtoCopy).expectStatus(400);
      });

      it('Should return a 200 status code if the request body is valid', () => {
        return pactum
          .spec()
          .post(endpoint)
          .withBody(loginRequestDTO)
          .expectStatus(200)
          .expectBodyContains('access_token')
          .expectBodyContains('refresh_token');
      });
    });
  });
});

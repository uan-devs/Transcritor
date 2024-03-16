#!/bin/sh
npm run build
npx prisma migrate dev
npx prisma migrate deploy
npm run start:prod

exec "$@"

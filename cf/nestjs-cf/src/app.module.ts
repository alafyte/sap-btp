import { Module } from '@nestjs/common';
import { UserModule } from './user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { parseVCAP } from './config';

@Module({
  imports: [
    TypeOrmModule.forRoot(parseVCAP()),
    UserModule
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}

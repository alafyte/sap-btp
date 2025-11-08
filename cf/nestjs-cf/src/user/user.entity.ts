import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

@Entity()
export class User {
  @ApiProperty({ description: 'The unique ID of the user' })
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({ description: 'Name of the user' })
  @Column()
  name: string;
}

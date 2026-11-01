import { DataSourceOptions } from "typeorm";

export const parseVCAP = (): DataSourceOptions => {
  if (process.env.VCAP_SERVICES) {
    const vcapServices = JSON.parse(process.env.VCAP_SERVICES);

    const postgresServices = vcapServices['postgresql-db'];

    if (!postgresServices?.length) {
      throw new Error('PostgreSQL service not bound');
    }

    const postgresService = postgresServices[0].credentials;
    
    return {
      type: 'postgres',
      host: postgresService.hostname,
      port: postgresService.port,
      username: postgresService.username,
      password: postgresService.password,
      database: postgresService.dbname,
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true,
      ssl: {
        rejectUnauthorized: true,
        ca: postgresService.sslrootcert,
        cert: postgresService.sslcert,
      },
    };
  } else {
    // Local fallback
    return {
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: 'postgres',
      database: 'test',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true
    };
  }
};
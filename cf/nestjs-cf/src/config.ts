import { DataSourceOptions } from "typeorm";

export const parseVCAP = (): DataSourceOptions => {
  if (process.env.VCAP_SERVICES) {
    const services = JSON.parse(process.env.VCAP_SERVICES);
    const postgresService = services['postgresql-db'][0].credentials;
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
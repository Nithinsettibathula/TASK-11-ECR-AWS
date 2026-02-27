module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST', 'nithin-task-11-db.cibg8qw2kouc.us-east-1.rds.amazonaws.com'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'strapi'),
      user: env('DATABASE_USERNAME', 'nithinadmin'),
      password: env('DATABASE_PASSWORD', 'SecurePassword123!'),
      ssl: env.bool('DATABASE_SSL', true) && {
        rejectUnauthorized: env.bool('DATABASE_SSL_REJECT_UNAUTHORIZED', false),
      },
    },
    debug: false,
  },
});
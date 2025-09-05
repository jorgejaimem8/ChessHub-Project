const { Pool } = require('pg');
// // Configuración de la conexión a la base de datos
const pool = new Pool({
    user: 'ugfchsan0qbfkvhvyuwl',
    host: 'bm9v4y7glvvz5acg8lj3-postgresql.services.clever-cloud.com',
    database: 'bm9v4y7glvvz5acg8lj3',
    password: 'FL2O9CrTAJ89cBxbHihI',
    port: 50013 // Puerto por defecto de PostgreSQL
});

module.exports = pool;
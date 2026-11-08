const { Pool } = require("pg");

let pool = null;

async function getPool() {
  try {
    if (!pool) {
      pool = new Pool({
        connectionString: process.env.DB_CONNECTION,
        max: 10,
        idleTimeoutMillis: 30000,
      });
    }
    return pool;
  } catch (error) {
    console.error("Error occurred while creating database pool:", error);
    return null;
  }
}

async function closePool() {
  if (pool) {
    console.log("Close Connections from Data Base");
    await pool.end();
    pool = null;
  }
}

module.exports = { getPool, closePool };

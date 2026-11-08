const { getPool } = require("../config/db");

async function getAllUsers() {
  const pool = await getPool();
  const result = await pool.query(
    "SELECT id, name, email, activo, fecha_creacion FROM users ORDER BY fecha_creacion DESC",
  );
  return result.rows;
}

async function getUserByIdOrEmail(key, data) {
  const pool = await getPool();
  const result = await pool.query(
    `SELECT id, name, email, activo, fecha_creacion FROM users WHERE ${key}= $1`,
    [data],
  );
  return result.rows[0] || null;
}

async function createUser({ name, email, password_hash }) {
  const pool = await getPool();
  const result = await pool.query(
    `INSERT INTO users (name, email, password_hash)
     VALUES ($1, $2, $3)
     RETURNING id, name, email, activo, fecha_creacion`,
    [name, email, password_hash],
  );
  return result.rows[0];
}

module.exports = { getAllUsers, getUserByIdOrEmail, createUser };

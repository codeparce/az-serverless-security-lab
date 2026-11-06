//DEPENDNCIAS ================================================
const { app } = require("@azure/functions");
const { CryptographyClient } = require("@azure/keyvault-keys");

const { Pool } = require("pg");
const { testDB, getCryptoClient } = require("../utils/utils");

// CONSTANTES ================================================
const { connectionString, env, vaultUrl } = require("../utils/env");

const pool = new Pool({ connectionString: connectionString });

// FUNCION ========================================================
app.http("getCardsPrime", {
  methods: ["GET"],
  authLevel: "anonymous",
  handler: async (request, context) => {
    const client = await pool.connect();

    try {
      await testDB(client);

      context.log(
        `Http function processed request for url "${request.url}" -  ${env}`,
      );

      const queryKey = request.query.keys().next();

      if (queryKey.value === "id") {
        return getCardUser(request, client);
      }

      return getCardsUsers(request, client);
    } catch (error) {
      context.error("Error en la funcion", error);
    } finally {
      context.log("Cerrando conexion");
      client.release();
    }
  },
});

async function getCardsUsers(request, client) {
  // Obtenemos el parámetro 'limit' de la URL (ej: /api/secureData?limit=5)
  // Si no se envía, por defecto traemos un máximo de 10 registros
  const limitParam = request.query.get("limit") || "10";
  const limit = parseInt(limitParam, 10);

  const queryText = "SELECT * FROM user_cards ORDER BY id DESC LIMIT $1;";
  const result = await client.query(queryText, [limit]);

  return {
    status: 200,
    jsonBody: {
      total: result.rowCount,
      data: result.rows,
    },
  };
}

async function getCardUser(request, client) {
  const id = parseInt(request.query.get("id"));

  const queryText = `
      SELECT id, user_id, card_data, created_at 
      FROM user_cards 
      WHERE id = $1 
      ORDER BY id DESC 
      LIMIT 1;
    `;

  const result = await client.query(queryText, [id]);
  const row = result.rows[0];

  const cryptoClient = await getCryptoClient(vaultUrl);

  const decryptResult = await cryptoClient.decrypt({
    algorithm: "RSA-OAEP-256",
    ciphertext: row.card_data, // Pasamos el Buffer directamente
  });

  const decryptedText = new TextDecoder().decode(decryptResult.result);

  return {
    status: 200,
    jsonBody: {
      id: row.id,
      user_id: row.user_id,
      card_data: decryptedText,
      created_at: row.created_at,
    },
  };
}

const { app } = require("@azure/functions");

//DEPENDNCIAS ================================================
const { CryptographyClient } = require("@azure/keyvault-keys");
const { Pool } = require("pg");
const { testDB, getCryptoClient } = require("../utils/utils");

// CONSTANTES ================================================
const { connectionString, env, vaultUrl } = require("../utils/env");

const pool = new Pool({ connectionString: connectionString });

app.http("addCardPrime", {
  methods: ["POST"],
  authLevel: "anonymous",
  handler: async (request, context) => {
    const client = await pool.connect();
    try {
      await testDB(client);

      context.log(
        `Http function processed request for url "${request.url}" -  ${env}`,
      );

      const bodyData = await request.json();

      return await insertCardPrime(bodyData, client);
    } catch (error) {
      context.error("Error en la funcion", error);
    }
  },
});

async function insertCardPrime(bodyData, client) {
  const cryptoClient = await getCryptoClient(vaultUrl);

  const encryptResult = await cryptoClient.encrypt({
    algorithm: "RSA-OAEP-256",
    plaintext: Buffer.from(bodyData.card_data),
  });

  const queryText = `
      INSERT INTO user_cards (user_id, card_data) 
      VALUES ($1, $2) 
      RETURNING id, created_at;
    `;

  const values = [bodyData.user_id, encryptResult.result];

  const result = await client.query(queryText, values);
  console.log("Tarjeta guardada con ID:", result.rows[0].id);

  return {
    status: 200,
    jsonBody: {
      message: "Tarjeta cifrada y guardada exitosamente",
      id: result.rows[0].id,
    },
  };
}

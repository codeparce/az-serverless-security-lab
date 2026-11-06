import { DefaultAzureCredential } from "@azure/identity";
import { KeyClient, CryptographyClient } from "@azure/keyvault-keys";

// POSTGRESQL
/// Test de conexion a la base de datos
export const testDB = async (client) => {
  try {
    const res = await client.query("SELECT NOW()");
    console.log("Conexión exitosa. Hora actual en la BD:", res.rows[0]);
  } catch (err) {
    console.error("Error al ejecutar la consulta", err.stack);
  }
};

//AZURE KEY VAULT
export async function getCryptoClient(vaultUrl) {
  try {
    const credential = new DefaultAzureCredential();
    const keyClient = new KeyClient(vaultUrl, credential);

    const key = await keyClient.getKey("RSA-KEY");
    return new CryptographyClient(key.id, credential);
  } catch (error) {
    console.error("Error al obtener el cliente de criptografía", error);
  }
}

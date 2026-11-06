-- 1. Creamos la tabla para almacenar las tarjetas cifradas
CREATE TABLE user_cards (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    -- Usamos BYTEA porque el resultado de Key Vault es un array de bytes (binario)
    card_data BYTEA NOT NULL, 
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Creamos un índice en user_id para que las búsquedas de tarjetas por usuario sean rápidas
CREATE INDEX idx_user_cards_user_id ON user_cards(user_id);

-- 3. (Opcional) Comentario para documentar la tabla
COMMENT ON COLUMN user_cards.card_data IS 'Contiene el número de tarjeta cifrado mediante RSA-OAEP-256 de Azure Key Vault';

-- Usuario 101: Simulando un blob de cifrado RSA
INSERT INTO user_cards (user_id, card_data) 
VALUES (101, '\x4a8f2c1d9e3b7a6c5d4e3f2a1b0c9d8e7f6a5b4c3d2e1f0a9b8c7d6e5f4a3b2c');

-- Usuario 102: Simulando otro blob diferente
INSERT INTO user_cards (user_id, card_data) 
VALUES (102, '\xbcde7890f1e2d3c4b5a697887766554433221100aabbccddeeff001122334455');
DROP TABLE
  IF EXISTS users;
CREATE TABLE
  IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    mail TEXT NOT NULL,
    balance INTEGER DEFAULT 0 NOT NULL
  );

DROP TABLE
  IF EXISTS carts;
CREATE TABLE
  IF NOT EXISTS carts (
    id INTEGER PRIMARY KEY,
    uid INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    UNIQUE (item_id, uid)
  );

DROP TABLE
  IF EXISTS collections;
CREATE TABLE
  IF NOT EXISTS collections (
    id INTEGER PRIMARY KEY,
    uid INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    UNIQUE (item_id, uid)
  );

DROP TABLE
  IF EXISTS orders;
CREATE TABLE
  IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY,
    uid INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    item_title text not null,
    item_price INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    created_at INTEGER NOT NULL
  );

CREATE TABLE IF NOT EXISTS products (
  id TEXT PRIMARY KEY,
  sku TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  price_cny REAL NOT NULL CHECK(price_cny > 0),
  currency_prices TEXT NOT NULL DEFAULT '{}',
  image_url TEXT NOT NULL DEFAULT '',
  icon TEXT NOT NULL DEFAULT '🛍️',
  color TEXT NOT NULL DEFAULT '#e8f0e9',
  stock INTEGER NOT NULL DEFAULT 0 CHECK(stock >= 0),
  market_codes TEXT NOT NULL DEFAULT '["AU","US","GB","CA","NZ"]',
  fulfillment TEXT NOT NULL DEFAULT 'auto',
  status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','active','archived')),
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_products_status_updated ON products(status, updated_at DESC);
CREATE TABLE IF NOT EXISTS admin_sessions (
  token_hash TEXT PRIMARY KEY,
  expires_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_admin_sessions_expiry ON admin_sessions(expires_at);

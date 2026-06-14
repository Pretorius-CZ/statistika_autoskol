-- Spusť v Supabase: Project → SQL Editor → New query → paste → Run

CREATE TABLE IF NOT EXISTS zkousky_testy (
  id BIGSERIAL PRIMARY KEY,
  datum TIMESTAMPTZ,
  autoskola TEXT NOT NULL,
  pokus_typ TEXT NOT NULL,
  hodnoceni TEXT NOT NULL,
  mesic SMALLINT NOT NULL,
  rok SMALLINT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS zkousky_jizdy (
  id BIGSERIAL PRIMARY KEY,
  datum TIMESTAMPTZ,
  autoskola TEXT NOT NULL,
  pokus_typ TEXT NOT NULL,
  hodnoceni TEXT NOT NULL,
  mesic SMALLINT NOT NULL,
  rok SMALLINT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_testy_mesic_rok ON zkousky_testy(mesic, rok);
CREATE INDEX IF NOT EXISTS idx_jizdy_mesic_rok ON zkousky_jizdy(mesic, rok);

ALTER TABLE zkousky_testy ENABLE ROW LEVEL SECURITY;
ALTER TABLE zkousky_jizdy ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_testy"   ON zkousky_testy FOR SELECT TO anon USING (true);
CREATE POLICY "insert_testy" ON zkousky_testy FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "delete_testy" ON zkousky_testy FOR DELETE TO anon USING (true);

CREATE POLICY "read_jizdy"   ON zkousky_jizdy FOR SELECT TO anon USING (true);
CREATE POLICY "insert_jizdy" ON zkousky_jizdy FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "delete_jizdy" ON zkousky_jizdy FOR DELETE TO anon USING (true);

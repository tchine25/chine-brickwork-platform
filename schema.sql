-- Chine Brickwork Platform — Database Schema
-- Run this in: Supabase → SQL Editor → New query → Run

CREATE TABLE IF NOT EXISTS jobs (
  id TEXT PRIMARY KEY,
  cb TEXT, con TEXT, proj TEXT, stage TEXT, owner TEXT,
  next_date TEXT, next_act TEXT, status TEXT, contact TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS comms (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  job_id TEXT REFERENCES jobs(id) ON DELETE CASCADE,
  d TEXT, who TEXT, type TEXT, text TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS log_entries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  entry_date TEXT, cb TEXT, contractor TEXT, action TEXT, owner TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS future_opps (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  contractor TEXT, timing TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS future_opp_projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  opp_id UUID REFERENCES future_opps(id) ON DELETE CASCADE,
  name TEXT, detail TEXT, action TEXT, timing TEXT
);

CREATE TABLE IF NOT EXISTS leads (
  id SERIAL PRIMARY KEY,
  title TEXT, src TEXT, val TEXT, loc TEXT, deadline TEXT,
  hot BOOLEAN DEFAULT FALSE, description TEXT, url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS plans (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  ref TEXT, description TEXT, borough TEXT, status TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE comms ENABLE ROW LEVEL SECURITY;
ALTER TABLE log_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE future_opps ENABLE ROW LEVEL SECURITY;
ALTER TABLE future_opp_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users full access to all tables
CREATE POLICY "auth_all" ON jobs FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON comms FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON log_entries FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON future_opps FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON future_opp_projects FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON leads FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON plans FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Enable realtime
ALTER PUBLICATION supabase_realtime ADD TABLE jobs, comms, log_entries;

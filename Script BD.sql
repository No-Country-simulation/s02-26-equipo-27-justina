CREATE TABLE users (
    id UUID PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    password_hash TEXT,
    status TEXT NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    last_login_at TIMESTAMP
);
CREATE TABLE scenarios (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    difficulty INT NOT NULL CHECK (difficulty BETWEEN 1 AND 5),
    expected_time_seconds INT,
    version TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TABLE scenario_parameters (
    id UUID PRIMARY KEY,
    scenario_id UUID NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_json JSONB NOT NULL,
    data_type TEXT NOT NULL
);
CREATE TABLE procedures (
    id UUID PRIMARY KEY,
    scenario_id UUID NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    version TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TABLE procedure_steps (
    id UUID PRIMARY KEY,
    procedure_id UUID NOT NULL REFERENCES procedures(id) ON DELETE CASCADE,
    step_order INT NOT NULL,
    name TEXT NOT NULL,
    allowed_actions JSONB,
    constraints JSONB
);CREATE TABLE runs (
    id UUID PRIMARY KEY,
    scenario_id UUID NOT NULL REFERENCES scenarios(id),
    user_id UUID NOT NULL REFERENCES users(id),
    status TEXT NOT NULL,
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP,
    seed TEXT,
    config JSONB
);
CREATE TABLE run_events (
    id UUID PRIMARY KEY,
    run_id UUID NOT NULL REFERENCES runs(id) ON DELETE CASCADE,
    event_time TIMESTAMP NOT NULL,
    event_type TEXT NOT NULL,
    severity TEXT,
    payload JSONB
);
CREATE TABLE run_metric_summary (
    run_id UUID PRIMARY KEY REFERENCES runs(id) ON DELETE CASCADE,
    total_time_seconds INT,
    active_time_seconds INT,
    idle_time_seconds INT,
    actions_count INT,
    errors_total INT,
    critical_errors INT,
    path_efficiency_score FLOAT,
    smoothness_score FLOAT,
    precision_score FLOAT,
	ai_analysis_json JSONB,
	ai_generated_at TIMESTAMP,
    computed_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS CarWizardDB;

-- Usar la base de datos
USE CarWizardDB;


CREATE TABLE IF NOT EXISTS years (
    year INTEGER,
    PRIMARY KEY (year)
);

CREATE TABLE IF NOT EXISTS makes (
    id INTEGER,
    name VARCHAR(50),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS models (
    name VARCHAR(50),
    PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS engines (
    id INTEGER,
    engine_type VARCHAR(50),
    fuel_type VARCHAR(50),
    cylinders VARCHAR(50),
    size VARCHAR(50),
    horsepower_hp INTEGER,
    horsepower_rpm FLOAT,
    torque_ft_lbs FLOAT,
    torque_rpm FLOAT,
    valves FLOAT,
    valve_timing VARCHAR(50),
    cam_type VARCHAR(50),
    drive_type VARCHAR(50),
    transmission VARCHAR(50),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS bodies (
    id INTEGER,
    type VARCHAR(50),
    doors INTEGER,
    length FLOAT,
    width FLOAT,
    seats INTEGER,
    height FLOAT,
    wheel_base FLOAT,
    front_track VARCHAR(50),
    rear_track VARCHAR(50),
    ground_clearance FLOAT,
    cargo_capacity FLOAT,
    max_cargo_capacity FLOAT,
    curb_weight FLOAT,
    gross_weight FLOAT,
    max_payload FLOAT,
    max_towing_capacity FLOAT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS mileages (
    id INTEGER,
    fuel_tank_capacity FLOAT,
    combined_LitersAt100km FLOAT,
    city_LitersAt100km FLOAT,
    highway_LitersAt100km FLOAT,
    range_city FLOAT,
    range_highway FLOAT,
    battery_capacity_electric FLOAT,
    epa_time_to_charge_hr_240v_electric VARCHAR(50),
    epa_kwh_100_mi_electric VARCHAR(50),
    range_electric VARCHAR(50),
    epa_highway_mpg_electric FLOAT,
    epa_city_mpg_electric FLOAT,
    epa_combined_mpg_electric FLOAT,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS make_models (
    id INTEGER,
    make_id INTEGER,
    name VARCHAR(50),
    PRIMARY KEY (id),
    FOREIGN KEY (make_id) REFERENCES makes(id),
    FOREIGN KEY (model_id) REFERENCES models(name)
);

CREATE TABLE IF NOT EXISTS trims (
    id INTEGER,
    make_model_id INTEGER,
    year INTEGER,
    name VARCHAR(50),
    description VARCHAR(50),
    msrp INTEGER,
    engine_id INTEGER,
    body_id INTEGER,
    mileage_id INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (year_id) REFERENCES years(year),
    FOREIGN KEY (engine_id) REFERENCES engines(id),
    FOREIGN KEY (body_id) REFERENCES bodies(id),
    FOREIGN KEY (make_model_id) REFERENCES make_models(id),
    FOREIGN KEY (mileage_id) REFERENCES mileages(id)
);

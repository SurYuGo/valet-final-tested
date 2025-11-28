CREATE DATABASE IF NOT EXISTS valetdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE valetdb;

CREATE TABLE IF NOT EXISTS parking (
  id VARCHAR(100) PRIMARY KEY,
  plate VARCHAR(50),
  entry_time TIMESTAMP NULL,
  exit_time TIMESTAMP NULL,
  fee INT,
  paid BOOLEAN DEFAULT FALSE,
  payment_id VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS payment (
  id VARCHAR(100) PRIMARY KEY,
  parking_id VARCHAR(100),
  amount INT,
  status VARCHAR(50),
  raw_response TEXT,
  qr_url VARCHAR(2000),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

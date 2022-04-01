DROP DATABASE IF EXISTS dbproject;
CREATE DATABASE dbproject;
USE dbproject;

CREATE TABLE users(
	username VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30)
);
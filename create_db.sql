DROP DATABASE IF EXISTS dbproject;
CREATE DATABASE dbproject;
USE dbproject;

CREATE TABLE users(
	username VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30)
);

CREATE TABLE listings(
	l_id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    itemname VARCHAR(30),
    subcategory VARCHAR(30),
    subattribute VARCHAR(30),
    price DECIMAL(10,2),
    minsale DECIMAL(10,2),
    dt datetime
	
);

#connects sellers to their listings
CREATE TABLE posts(
	l_id int PRIMARY KEY,
	username VARCHAR(30),
    FOREIGN KEY(username) REFERENCES users(username),
    FOREIGN KEY(l_id) REFERENCES listings(l_id)
);

CREATE TABLE bids(
	b_id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
	price DECIMAL(10,2),
    dtime datetime
);

#connects bid ids to listings
CREATE TABLE bidson(
	b_id int PRIMARY KEY,
	l_id int,
    FOREIGN KEY(l_id) REFERENCES listings(l_id),
    FOREIGN KEY(b_id) REFERENCES bids(b_id)
);

#connects buyers to bid ids
CREATE TABLE places(
	b_id int PRIMARY KEY,
	username VARCHAR(30),
    FOREIGN KEY(b_id) REFERENCES bids(b_id),
    FOREIGN KEY(username) REFERENCES users(username)
);

CREATE TABLE questions(
    q_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    question VARCHAR(300)
);

CREATE TABLE asks(
    asker VARCHAR(30),
    q_id INT PRIMARY KEY,
    FOREIGN KEY(asker) REFERENCES users(username),
    FOREIGN KEY(q_id) REFERENCES questions(q_id)
);

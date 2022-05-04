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

#USER POSTS LISTING
CREATE TABLE posts(
	l_id int PRIMARY KEY,
	username VARCHAR(30),
    FOREIGN KEY(username) 
		REFERENCES users(username) 
			ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY(l_id) REFERENCES listings(l_id) ON DELETE CASCADE
);

CREATE TABLE bids(
	b_id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
	price DECIMAL(10,2),
    dtime datetime
);

#Bids on listings
CREATE TABLE bidson(
	b_id int PRIMARY KEY,
	l_id int,
    FOREIGN KEY(l_id) REFERENCES listings(l_id) ON DELETE CASCADE,
    FOREIGN KEY(b_id) REFERENCES bids(b_id) ON DELETE CASCADE
);

#connects buyers to bid ids
CREATE TABLE places(
	b_id int PRIMARY KEY,
	username VARCHAR(30),
    FOREIGN KEY(b_id) 
		REFERENCES bids(b_id)
			ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY(username) 
		REFERENCES users(username)
			ON DELETE CASCADE
            ON UPDATE CASCADE
);
 
CREATE TABLE admin(
	id INT PRIMARY KEY,
	password VARCHAR(30)
);
INSERT INTO admin VALUES(0, "adminpass");

CREATE TABLE customer_rep(
	id INT PRIMARY KEY,
	password VARCHAR(30)
);

CREATE TABLE admin_creates(
	aid INT,
    cr_id INT,
    FOREIGN KEY(aid) REFERENCES admin(id),
    FOREIGN KEY(cr_id) REFERENCES customer_rep(id)
);

CREATE TABLE question(
	q_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    q_text VARCHAR(300)
);

CREATE TABLE asks(
	asker VARCHAR(30),
    q_id INT PRIMARY KEY,
    FOREIGN KEY(asker)
		REFERENCES users(username)
			ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY(q_id) REFERENCES question(q_id)
);

CREATE TABLE resolves(
	q_id INT PRIMARY KEY,
    resolver INT,
    resolve_text VARCHAR(300),
    FOREIGN KEY(q_id) REFERENCES question(q_id),
    FOREIGN KEY(resolver) REFERENCES customer_rep(id)
);
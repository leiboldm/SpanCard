DROP TABLE users CASCADE;
CREATE TABLE users(
	username TEXT PRIMARY KEY,
	email TEXT,
	passwordhash TEXT,
	salt TEXT
);

DROP TABLE user_words CASCADE;
CREATE TABLE user_words (
	username TEXT references users(username),
	word TEXT,
	successes INT DEFAULT 0,
	failures INT DEFAULT 0,
	PRIMARY KEY (username, word)
);

DROP TABLE spanish_translations CASCADE;
CREATE TABLE spanish_translations (
	username TEXT references users(username),
	word TEXT NOT NULL,
	translation TEXT NOT NULL,
	type TEXT,
	example TEXT,
	PRIMARY KEY (username, word, translation)
);
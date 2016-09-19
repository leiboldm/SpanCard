DROP TABLE users CASCADE;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	username TEXT NOT NULL,
	email TEXT,
	passwordhash TEXT,
	salt TEXT
);

DROP TABLE user_words;
CREATE TABLE user_words (
	user_id INT references users(id),
	word TEXT NOT NULL,
	successes INT DEFAULT 0,
	failures INT DEFAULT 0,
	PRIMARY KEY (user_id, word)
);

DROP TABLE spanish_translations;
CREATE TABLE spanish_translations (
	word TEXT PRIMARY KEY,
	translation TEXT NOT NULL,
	type TEXT,
	example TEXT
);
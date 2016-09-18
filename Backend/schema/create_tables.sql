CREATE TABLE User (
	id INT PRIMARY KEY,
	name STRING NOT NULL
);

CREATE TABLE UserWord (
	user INT references User(id),
	word STRING NOT NULL,
	successes INT DEFAULT 0,
	failures INT DEFAULT 0,
	PRIMARY_KEY(user, word)
);

CREATE TABLE SpanishTranslation(
	word STRING PRIMARY KEY,
	translation STRING NOT NULL,
	type STRING,
	example STRING
);
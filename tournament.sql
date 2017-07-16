

-- Eric St-Laurent IPND July 15 2017

-- Deletes database if db already exists to avoid errors

DROP database tournament;

DROP table if exists players CASCADE;
DROP table  if exists matches CASCADE;
DROP VIEW  if exists standings CASCADE;
DROP View  if exists count CASCADE;
DROP VIEW  if exists wins CASCADE;

create database tournament;
\c tournament;


-- Creates players table
create table players (
  ID serial primary key,
  Name text
  );

-- Creates matches table
create table matches (
    match_id serial PRIMARY KEY,
    winner INT,
    loser INT,
    FOREIGN KEY(winner) REFERENCES players(ID),
    FOREIGN KEY(loser) REFERENCES players(ID),
    results INT
    );

-- Create wins view: number of wins per player
  create view WINS as
  SELECT Players.id, COUNT(Matches.winner) AS wins
	FROM players, matches
	WHERE players.id = matches.winner
  GROUP BY players.id
  ORDER BY wins DESC;

-- Create count views: number of matches per player
  CREATE VIEW count AS
  	SELECT Players.id, Count(players.id) AS matches
  	FROM players, matches
    WHERE players.id = matches.loser OR players.id = matches.winner
    GROUP BY players.id
    ORDER BY matches DESC;

-- Create view Standings - number of wins and matches for each player

  CREATE VIEW standings AS
    SELECT players.id as id, players.name as name,
    (SELECT count(*) FROM matches WHERE matches.winner = players.id) as wins,
    (SELECT count(*) FROM matches WHERE players.id in (winner, loser)) as matches
    FROM players
    GROUP BY players.id
    ORDER BY wins DESC;

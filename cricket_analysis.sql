use cricket;

#--basic queries--
#1)Retrieve the player name and team for all batting records:
SELECT Player, Team
FROM Batting;

#2)Retrieve the batting statistics for players from India:
SELECT *
FROM Batting
WHERE Team = 'India';

#3)Retrieve the unique list of player teams from the batting data:
SELECT DISTINCT Team
FROM Batting;

#4)Retrieve the player name and team for all batting records where the player's team is either India or Australia using the
SELECT Player, Team
FROM Batting
WHERE Team IN ('India', 'Australia');

#5)Retrieve the player name and team for all batting records where the player's name contains "Kohli"
SELECT Player, Team
FROM Batting
WHERE Player LIKE '%Kohli%';

#6)Retrieve the player name and team for all batting records where the player's highest score is null:
SELECT Player, Team
FROM Batting
WHERE HS IS NULL;

#7)Retrieve the player name, team, and batting average for all records where the player's highest score is between 50 and 100:
SELECT Player, Team, Avg
FROM Batting
WHERE HS BETWEEN 50 AND 100;

#8)Retrieve the top 5 players with the most number of wickets, along with their team and economy rate:
SELECT Player, Team, Econ, Wkts
FROM Bowling
ORDER BY Wkts DESC
LIMIT 5;

#9)Retrieve the bowling statistics for matches in which a player took at least 5 wickets:
SELECT *
FROM Bowling
WHERE 5W >= 1;

#10)Retrieve the player name and team for the 5th to 10th highest scoring batting records:
SELECT Player, Team, Runs
FROM Batting
ORDER BY Runs DESC
LIMIT 5 OFFSET 4;


#--intermediate queries--

#11)Find the top 10 players with the highest batting averages in all match types:
SELECT Player, AVG(Avg) AS BattingAverage
FROM Batting
GROUP BY Player
ORDER BY BattingAverage DESC
LIMIT 10;

#12)Find the total runs scored by each team in all match types:
SELECT Team, SUM(Runs) AS TotalRuns
FROM Batting
GROUP BY Team;

#13)Find the total runs scored and wickets taken by each player in all match types:
SELECT bat.Player, SUM(bat.Runs) AS TotalRuns, SUM(Wkts) AS TotalWickets
FROM Batting bat JOIN Bowling bowl ON bat.Player =bowl.Player
GROUP BY Player;

#14)Find the players who have scored at least 1000 runs and taken at least 50 wickets in all match types:
SELECT Batting.Player
FROM Batting JOIN Bowling ON Batting.Player = Bowling.Player
GROUP BY Batting.Player
HAVING SUM(Batting.Runs) >= 1000 AND SUM(Bowling.Wkts) >= 50;

#15)Get the list of all players who have either bowled or batted in a match:
SELECT Player FROM Batting
UNION
SELECT Player FROM Bowling;

#16)List the player names and strike rates (where strike rate is greater than 100)and player names and economy rates(where economy rate is less than 5)
SELECT Player, SR FROM Batting
WHERE SR > 100
UNION
SELECT Player, Econ FROM Bowling
WHERE Econ < 5;

#--advanced queries--

#17)Get the player and their previous match's runs and wickets:
SELECT Player, Runs, Wkts, LAG(Runs) OVER (PARTITION BY Player ORDER BY M) as PrevRuns, LAG(Wkts) OVER (PARTITION BY Player ORDER BY M) as PrevWkts
FROM Bowling
ORDER BY Player, M;

#18)Show the bowler with the highest strike rate in a season:
WITH rates_table AS (
  SELECT Player, SR
  FROM Bowling
)
SELECT Player, SR
FROM rates_table
WHERE SR = (
  SELECT MAX(SR)
  FROM rates_table
);

#19)Show the batting details of players who have scored more than 500 runs in a single season:
WITH runs_table AS (
  SELECT Player, M, Runs
  FROM Batting
  WHERE Runs > 500
)
SELECT *
FROM runs_table
ORDER BY Runs DESC;

#20)Create a view that shows the total runs scored by each team in all matches:

CREATE VIEW team_run AS
SELECT Team, SUM(Runs) AS TotalRuns
FROM Batting
GROUP BY Team;




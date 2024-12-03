-- Step 1: Create the database
CREATE DATABASE USElection2024;
USE USElection2024;

-- Step 2: Create tables
-- Table for states
CREATE TABLE States (
    StateID INT AUTO_INCREMENT PRIMARY KEY,
    StateName VARCHAR(50) NOT NULL,
    ElectoralVotes INT NOT NULL
);

-- Table for candidates
CREATE TABLE Candidates (
    CandidateID INT AUTO_INCREMENT PRIMARY KEY,
    CandidateName VARCHAR(100) NOT NULL,
    Party VARCHAR(50) NOT NULL
);

-- Table for votes
CREATE TABLE Votes (
    VoteID INT AUTO_INCREMENT PRIMARY KEY,
    StateID INT NOT NULL,
    CandidateID INT NOT NULL,
    TotalVotes INT NOT NULL,
    FOREIGN KEY (StateID) REFERENCES States(StateID),
    FOREIGN KEY (CandidateID) REFERENCES Candidates(CandidateID)
);

-- Step 3: Insert sample data
-- Insert states
INSERT INTO States (StateName, ElectoralVotes)
VALUES 
    ('California', 54),
    ('Texas', 40),
    ('Florida', 30),
    ('New York', 28),
    ('Pennsylvania', 19);

-- Insert candidates
INSERT INTO Candidates (CandidateName, Party)
VALUES
    ('Donald J. Trump', 'Republican'),
    ('Joe Biden', 'Democratic');

-- Insert votes
INSERT INTO Votes (StateID, CandidateID, TotalVotes)
VALUES
    (1, 1, 6000000), -- Trump in California
    (1, 2, 8000000), -- Biden in California
    (2, 1, 5000000), -- Trump in Texas
    (2, 2, 4500000), -- Biden in Texas
    (3, 1, 4000000), -- Trump in Florida
    (3, 2, 3800000), -- Biden in Florida
    (4, 1, 3000000), -- Trump in New York
    (4, 2, 4500000), -- Biden in New York
    (5, 1, 2500000), -- Trump in Pennsylvania
    (5, 2, 2700000); -- Biden in Pennsylvania

-- Step 4: Analysis
-- 1. Total votes for each candidate
SELECT c.CandidateName, SUM(v.TotalVotes) AS TotalVotes
FROM Votes v
JOIN Candidates c ON v.CandidateID = c.CandidateID
GROUP BY c.CandidateName;

-- 2. State-by-state vote breakdown
SELECT s.StateName, c.CandidateName, v.TotalVotes
FROM Votes v
JOIN States s ON v.StateID = s.StateID
JOIN Candidates c ON v.CandidateID = c.CandidateID
ORDER BY s.StateName, v.TotalVotes DESC;

-- 3. Total electoral votes won by each candidate
SELECT c.CandidateName, SUM(s.ElectoralVotes) AS TotalElectoralVotes
FROM Votes v
JOIN States s ON v.StateID = s.StateID
JOIN Candidates c ON v.CandidateID = c.CandidateID
WHERE v.TotalVotes = (SELECT MAX(v2.TotalVotes)
                      FROM Votes v2
                      WHERE v2.StateID = v.StateID)
GROUP BY c.CandidateName;
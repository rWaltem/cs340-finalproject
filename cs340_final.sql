-- phpMyAdmin SQL Dump
-- version 5.2.1-1.el7.remi
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 25, 2024 at 08:22 PM
-- Server version: 10.6.19-MariaDB-log
-- PHP Version: 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs340_waltemry`
--

-- --------------------------------------------------------

--
-- Table structure for table `Album`
--

CREATE TABLE `Album` (
  `albumID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `artistID` int(11) NOT NULL,
  `releaseDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Album`
--

INSERT INTO `Album` (`albumID`, `name`, `artistID`, `releaseDate`) VALUES
(1, 'RICH SIPS', 1, '2019-12-16'),
(2, 'Pressure', 2, '2019-08-30'),
(3, 'Wtf U Mean (feat. Freddie Dredd)', 3, '2020-02-29'),
(4, 'Nectar', 5, '2020-09-25'),
(5, 'Sempiternal (Deluxe Edition)', 6, '2013-04-02'),
(6, 'BACKBONE', 4, '2018-01-26'),
(7, 'Disgrace', 7, '2019-11-16'),
(8, 'GTG', 8, '2018-08-10'),
(9, 'Timely!!', 9, '1983-12-05'),
(10, 'Madman Across The Water', 10, '1971-11-05');

-- --------------------------------------------------------

--
-- Table structure for table `Artist`
--

CREATE TABLE `Artist` (
  `artistID` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `bio` text DEFAULT NULL,
  `debutDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Artist`
--

INSERT INTO `Artist` (`artistID`, `name`, `bio`, `debutDate`) VALUES
(1, 'Bilmuri', 'Bilmuri seeks to strive in optimal levels of dank riffage.', '2016-10-15'),
(2, 'Wage War', NULL, '2015-11-27'),
(3, 'HAARPER', NULL, '2018-05-31'),
(4, 'DROELOE', 'Optimistic nihilist\nIdentity forever under construction', '2016-03-21'),
(5, 'Joji', NULL, '2017-11-03'),
(6, 'Bring Me The Horizon', NULL, '2006-10-30'),
(7, 'Josh A', 'Josh A is an independent artist known for blending rap and melodic beats.', '2015-01-01'),
(8, 'Freddie Dredd', NULL, '2016-08-02'),
(9, 'Anri', 'Anri is a Japanese singer and songwriter known for her contributions to the city pop genre.', '1978-01-01'),
(10, 'Elton John', 'Elton John is a legendary British musician known for his piano-driven pop and rock music, as well as his flamboyant performances.', '1969-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `ContributesToSong`
--

CREATE TABLE `ContributesToSong` (
  `songID` int(11) NOT NULL,
  `artistID` int(11) NOT NULL,
  `role` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `ContributesToSong`
--

INSERT INTO `ContributesToSong` (`songID`, `artistID`, `role`) VALUES
(1, 1, 'Main Artist'),
(2, 1, 'Main Artist'),
(3, 1, 'Main Artist'),
(4, 1, 'Main Artist'),
(5, 1, 'Main Artist'),
(6, 1, 'Main Artist'),
(7, 1, 'Main Artist'),
(106, 3, 'Producer'),
(106, 8, 'Featured');

-- --------------------------------------------------------

--
-- Table structure for table `Follows`
--

CREATE TABLE `Follows` (
  `userID` int(11) NOT NULL,
  `artistID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Follows`
--

INSERT INTO `Follows` (`userID`, `artistID`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 4),
(7, 5),
(8, 6),
(9, 6),
(10, 6);

-- --------------------------------------------------------

--
-- Table structure for table `Genre`
--

CREATE TABLE `Genre` (
  `genreID` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Genre`
--

INSERT INTO `Genre` (`genreID`, `name`) VALUES
(8, 'blues'),
(12, 'city pop'),
(1, 'classical'),
(7, 'country'),
(6, 'electronic'),
(5, 'hip-hop'),
(4, 'jazz'),
(10, 'metal'),
(3, 'pop'),
(11, 'rap'),
(9, 'reggae'),
(2, 'rock');

-- --------------------------------------------------------

--
-- Table structure for table `Playlist`
--

CREATE TABLE `Playlist` (
  `playlistID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `creationDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Playlist`
--

INSERT INTO `Playlist` (`playlistID`, `userID`, `name`, `creationDate`) VALUES
(1, 1, 'Chill Vibes', '2024-11-25'),
(2, 2, 'Workout Mix', '2024-11-25'),
(3, 3, 'Road Trip', '2024-11-25'),
(4, 4, 'Party Hits', '2024-11-25'),
(5, 5, 'Study Session', '2024-11-25'),
(6, 6, 'Throwback Jams', '2024-11-25'),
(7, 7, 'Sunday Morning', '2024-11-25'),
(8, 8, 'Lock In', '2024-11-25'),
(9, 9, 'Relax & Unwind', '2024-11-25'),
(10, 10, 'Dance Floor', '2024-11-25');

-- --------------------------------------------------------

--
-- Table structure for table `Ratings`
--

CREATE TABLE `Ratings` (
  `userID` int(11) NOT NULL,
  `songID` int(11) NOT NULL,
  `rating` tinyint(4) DEFAULT NULL CHECK (`rating` between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Ratings`
--

INSERT INTO `Ratings` (`userID`, `songID`, `rating`) VALUES
(2, 1, 5),
(2, 2, 5),
(2, 3, 3),
(2, 4, 4),
(2, 7, 5),
(2, 65, 5),
(2, 69, 5),
(2, 86, 5),
(2, 92, 5),
(2, 97, 5),
(3, 7, 4),
(4, 65, 2),
(5, 86, 2),
(6, 97, 3),
(7, 69, 2),
(9, 92, 4);

-- --------------------------------------------------------

--
-- Table structure for table `Song`
--

CREATE TABLE `Song` (
  `songID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `albumID` int(11) NOT NULL,
  `length` time NOT NULL,
  `trackNumber` int(11) NOT NULL,
  `releaseDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Song`
--

INSERT INTO `Song` (`songID`, `name`, `albumID`, `length`, `trackNumber`, `releaseDate`) VALUES
(1, 'THICC THICCLY', 1, '00:02:40', 1, '2019-10-10'),
(2, 'BRUH.mp4', 1, '00:02:11', 2, '2019-10-10'),
(3, 'THEMURIWITHHUMANHAIR', 1, '00:02:40', 3, '2019-10-10'),
(4, 'ASURPRISETOBESUREBUTAWELCOMEONE', 1, '00:02:44', 3, '2019-10-10'),
(5, '80/20SKYBEEF', 1, '00:02:57', 4, '2019-10-10'),
(6, 'COWPEOPLE', 1, '00:02:40', 5, '2019-10-10'),
(7, 'SOURDOUGHSTARTER', 1, '00:03:19', 6, '2019-10-10'),
(62, 'Ew', 4, '00:03:26', 1, '2020-09-25'),
(63, 'MODUS', 4, '00:03:26', 2, '2020-09-25'),
(64, 'Tick Tock', 4, '00:02:13', 3, '2020-09-25'),
(65, 'Daylight', 4, '00:02:47', 4, '2020-09-25'),
(66, 'Upgrade', 4, '00:01:37', 5, '2020-09-25'),
(67, 'Gimme Love', 4, '00:03:34', 6, '2020-09-25'),
(68, 'Run', 4, '00:03:16', 7, '2020-09-25'),
(69, 'Sanctuary', 4, '00:03:00', 8, '2020-09-25'),
(70, 'High Hopes (feat. Omar Apollo)', 4, '00:03:21', 9, '2020-09-25'),
(71, 'NITROUS', 4, '00:03:22', 10, '2020-09-25'),
(72, 'Pretty Boy (feat. Lil Yachty)', 4, '00:02:55', 11, '2020-09-25'),
(73, 'Normal People (feat. rei brown)', 4, '00:03:35', 12, '2020-09-25'),
(74, 'Afterthought (feat. BENEE)', 4, '00:03:15', 13, '2020-09-25'),
(75, 'Mr. Hollywood', 4, '00:03:20', 14, '2020-09-25'),
(76, '777', 4, '00:03:14', 15, '2020-09-25'),
(77, 'Reanimator (feat. Yves Tumor)', 4, '00:03:13', 16, '2020-09-25'),
(78, 'Like You Do', 4, '00:03:21', 17, '2020-09-25'),
(79, 'Your Man', 4, '00:03:14', 18, '2020-09-25'),
(80, 'Who I Am', 2, '00:03:41', 1, '2019-08-30'),
(81, 'Prison', 2, '00:02:48', 2, '2019-08-30'),
(82, 'Grave', 2, '00:03:14', 3, '2019-08-30'),
(83, 'Ghost', 2, '00:03:21', 4, '2019-08-30'),
(84, 'Me Against Myself', 2, '00:03:57', 5, '2019-08-30'),
(85, 'Hurt', 2, '00:03:15', 6, '2019-08-30'),
(86, 'Low', 2, '00:03:47', 7, '2019-08-30'),
(87, 'The Line', 2, '00:03:14', 8, '2019-08-30'),
(88, 'Fury', 2, '00:03:19', 9, '2019-08-30'),
(89, 'Forget My Name', 2, '00:03:22', 10, '2019-08-30'),
(90, 'Take The Fight', 2, '00:03:38', 11, '2019-08-30'),
(91, 'Will We Ever Learn', 2, '00:04:00', 12, '2019-08-30'),
(92, 'Can You Feel My Heart', 5, '00:04:21', 1, '2013-04-01'),
(93, 'The House of Wolves', 5, '00:04:01', 2, '2013-04-01'),
(94, 'Empire (Let Them Sing)', 5, '00:04:04', 3, '2013-04-01'),
(95, 'Sleepwalking', 5, '00:03:43', 4, '2013-04-01'),
(96, 'Go to Hell, for Heaven’s Sake', 5, '00:03:37', 5, '2013-04-01'),
(97, 'Shadow Moses', 5, '00:04:00', 6, '2013-04-01'),
(98, 'And the Snakes Start to Sing', 5, '00:05:02', 7, '2013-04-01'),
(99, 'Seen It All Before', 5, '00:03:23', 8, '2013-04-01'),
(100, 'Antivist', 5, '00:03:18', 9, '2013-04-01'),
(101, 'Crooked Young', 5, '00:04:02', 10, '2013-04-01'),
(102, 'Hospital For Souls', 5, '00:06:44', 11, '2013-04-01'),
(103, 'Join The Club', 5, '00:03:05', 12, '2013-04-01'),
(104, 'Chasing Rainbows', 5, '00:04:00', 13, '2013-04-01'),
(105, 'Deathbed', 5, '00:04:47', 14, '2013-04-01'),
(106, 'Wtf U Mean (feat. Freddie)', 3, '00:01:58', 1, '2020-02-29');

-- --------------------------------------------------------

--
-- Table structure for table `SongGenre`
--

CREATE TABLE `SongGenre` (
  `songID` int(11) NOT NULL,
  `genreID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `SongGenre`
--

INSERT INTO `SongGenre` (`songID`, `genreID`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 9),
(62, 6),
(63, 4),
(64, 4),
(65, 4),
(66, 4),
(67, 4),
(68, 7),
(69, 4),
(70, 11),
(71, 8),
(72, 4),
(73, 4),
(74, 9),
(75, 5),
(76, 4),
(77, 4),
(78, 4),
(79, 4),
(80, 2),
(81, 2),
(82, 2),
(83, 2),
(84, 10),
(85, 11),
(86, 2),
(87, 2),
(88, 2),
(89, 2),
(90, 2),
(91, 2);

-- --------------------------------------------------------

--
-- Table structure for table `SongsInPlaylist`
--

CREATE TABLE `SongsInPlaylist` (
  `playlistID` int(11) NOT NULL,
  `songID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `SongsInPlaylist`
--

INSERT INTO `SongsInPlaylist` (`playlistID`, `songID`) VALUES
(1, 1),
(1, 103),
(2, 2),
(2, 7),
(3, 1),
(3, 3),
(3, 100),
(5, 86),
(5, 87),
(6, 68),
(9, 71),
(10, 77);

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `userID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `joinDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`userID`, `username`, `email`, `password`, `joinDate`) VALUES
(1, 'owen', 'owen@oregonstate.edu', 'owenpassword', '2024-11-25'),
(2, 'ryan', 'ryan@oregonstate.edu', 'ryanpassword', '2024-11-25'),
(3, 'liam', 'corey@oregonstate.edu', 'coreypassword', '2024-11-25'),
(4, 'sophia', 'sophia@oregonstate.edu', 'sophiapassword', '2024-11-25'),
(5, 'noah', 'noah@oregonstate.edu', 'noahpassword', '2024-11-25'),
(6, 'olivia', 'olivia@oregonstate.edu', 'oliviapassword', '2024-11-25'),
(7, 'elijah', 'elijah@oregonstate.edu', 'elijahpassword', '2024-11-25'),
(8, 'ava', 'ava@oregonstate.edu', 'avapassword', '2024-11-25'),
(9, 'william', 'william@oregonstate.edu', 'williampassword', '2024-11-25'),
(10, 'mia', 'mia@oregonstate.edu', 'miapassword', '2024-11-25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Album`
--
ALTER TABLE `Album`
  ADD PRIMARY KEY (`albumID`),
  ADD KEY `artistID` (`artistID`);

--
-- Indexes for table `Artist`
--
ALTER TABLE `Artist`
  ADD PRIMARY KEY (`artistID`);

--
-- Indexes for table `ContributesToSong`
--
ALTER TABLE `ContributesToSong`
  ADD PRIMARY KEY (`songID`,`artistID`,`role`),
  ADD KEY `artistID` (`artistID`);

--
-- Indexes for table `Follows`
--
ALTER TABLE `Follows`
  ADD PRIMARY KEY (`userID`,`artistID`),
  ADD KEY `artistID` (`artistID`);

--
-- Indexes for table `Genre`
--
ALTER TABLE `Genre`
  ADD PRIMARY KEY (`genreID`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `Playlist`
--
ALTER TABLE `Playlist`
  ADD PRIMARY KEY (`playlistID`),
  ADD KEY `userID` (`userID`);

--
-- Indexes for table `Ratings`
--
ALTER TABLE `Ratings`
  ADD PRIMARY KEY (`userID`,`songID`),
  ADD KEY `songID` (`songID`);

--
-- Indexes for table `Song`
--
ALTER TABLE `Song`
  ADD PRIMARY KEY (`songID`),
  ADD KEY `albumID` (`albumID`);

--
-- Indexes for table `SongGenre`
--
ALTER TABLE `SongGenre`
  ADD PRIMARY KEY (`songID`,`genreID`),
  ADD KEY `genreID` (`genreID`);

--
-- Indexes for table `SongsInPlaylist`
--
ALTER TABLE `SongsInPlaylist`
  ADD PRIMARY KEY (`playlistID`,`songID`),
  ADD KEY `songID` (`songID`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Album`
--
ALTER TABLE `Album`
  MODIFY `albumID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Artist`
--
ALTER TABLE `Artist`
  MODIFY `artistID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Genre`
--
ALTER TABLE `Genre`
  MODIFY `genreID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `Playlist`
--
ALTER TABLE `Playlist`
  MODIFY `playlistID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Song`
--
ALTER TABLE `Song`
  MODIFY `songID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Album`
--
ALTER TABLE `Album`
  ADD CONSTRAINT `Album_ibfk_1` FOREIGN KEY (`artistID`) REFERENCES `Artist` (`artistID`) ON DELETE CASCADE;

--
-- Constraints for table `ContributesToSong`
--
ALTER TABLE `ContributesToSong`
  ADD CONSTRAINT `ContributesToSong_ibfk_1` FOREIGN KEY (`songID`) REFERENCES `Song` (`songID`) ON DELETE CASCADE,
  ADD CONSTRAINT `ContributesToSong_ibfk_2` FOREIGN KEY (`artistID`) REFERENCES `Artist` (`artistID`) ON DELETE CASCADE;

--
-- Constraints for table `Follows`
--
ALTER TABLE `Follows`
  ADD CONSTRAINT `Follows_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `User` (`userID`),
  ADD CONSTRAINT `Follows_ibfk_2` FOREIGN KEY (`artistID`) REFERENCES `Artist` (`artistID`);

--
-- Constraints for table `Playlist`
--
ALTER TABLE `Playlist`
  ADD CONSTRAINT `Playlist_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `User` (`userID`);

--
-- Constraints for table `Ratings`
--
ALTER TABLE `Ratings`
  ADD CONSTRAINT `Ratings_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `User` (`userID`),
  ADD CONSTRAINT `Ratings_ibfk_2` FOREIGN KEY (`songID`) REFERENCES `Song` (`songID`);

--
-- Constraints for table `Song`
--
ALTER TABLE `Song`
  ADD CONSTRAINT `Song_ibfk_1` FOREIGN KEY (`albumID`) REFERENCES `Album` (`albumID`) ON DELETE CASCADE;

--
-- Constraints for table `SongGenre`
--
ALTER TABLE `SongGenre`
  ADD CONSTRAINT `SongGenre_ibfk_1` FOREIGN KEY (`songID`) REFERENCES `Song` (`songID`) ON DELETE CASCADE,
  ADD CONSTRAINT `SongGenre_ibfk_2` FOREIGN KEY (`genreID`) REFERENCES `Genre` (`genreID`) ON DELETE CASCADE;

--
-- Constraints for table `SongsInPlaylist`
--
ALTER TABLE `SongsInPlaylist`
  ADD CONSTRAINT `SongsInPlaylist_ibfk_1` FOREIGN KEY (`playlistID`) REFERENCES `Playlist` (`playlistID`) ON DELETE CASCADE,
  ADD CONSTRAINT `SongsInPlaylist_ibfk_2` FOREIGN KEY (`songID`) REFERENCES `Song` (`songID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

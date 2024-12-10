-- phpMyAdmin SQL Dump
-- version 5.2.1-1.el7.remi
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 10, 2024 at 10:56 AM
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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`cs340_waltemry`@`%` PROCEDURE `GetAllAlbums` ()   BEGIN
    SELECT
        Album.albumID,
        Album.name AS album_name,
        Album.releaseDate,
        Artist.artistID,
        GROUP_CONCAT(DISTINCT Artist.name SEPARATOR ', ') AS artist_names,
        COUNT(Song.songID) AS song_count
    FROM Album
    LEFT JOIN Song ON Album.albumID = Song.albumID
    LEFT JOIN Song_Artist ON Song.songID = Song_Artist.songID
    LEFT JOIN Artist ON Song_Artist.artistID = Artist.artistID
    GROUP BY Album.albumID
    ORDER BY Album.releaseDate DESC;
END$$

CREATE DEFINER=`cs340_waltemry`@`%` PROCEDURE `GetAllArtists` ()   BEGIN
    SELECT 
        Artist.artistID,
        Artist.name AS artist_name,
        Artist.debutDate AS debut_date,
        COUNT(DISTINCT Song.songID) AS song_count,
        COUNT(DISTINCT Album.albumID) AS album_count
    FROM Artist
    LEFT JOIN Song_Artist ON Artist.artistID = Song_Artist.artistID
    LEFT JOIN Song ON Song_Artist.songID = Song.songID
    LEFT JOIN Album ON Song.albumID = Album.albumID
    GROUP BY Artist.artistID
    ORDER BY artist_name ASC;
END$$

CREATE DEFINER=`cs340_waltemry`@`%` PROCEDURE `GetPlaylistSongDetails` (IN `playlistID` INT)   BEGIN
    SELECT 
        Song.songID,
        Song.name AS song_name,
        Song.length,
        Song.trackNumber,
        Song.releaseDate,
        Album.albumID,
        Album.name AS album_name,
        Genre.name AS genre_name,
        GROUP_CONCAT(DISTINCT Artist.name SEPARATOR ', ') AS artist_names,
        Artist.artistID
    FROM Playlist_Song
    LEFT JOIN Song ON Playlist_Song.songID = Song.songID
    LEFT JOIN Album ON Song.albumID = Album.albumID
    LEFT JOIN Song_Artist ON Song.songID = Song_Artist.songID
    LEFT JOIN Artist ON Song_Artist.artistID = Artist.artistID
    LEFT JOIN Song_Genre ON Song.songID = Song_Genre.songID
    LEFT JOIN Genre ON Song_Genre.genreID = Genre.genreID
    WHERE Playlist_Song.playlistID = playlistID
    GROUP BY Song.songID;
END$$

CREATE DEFINER=`cs340_waltemry`@`%` PROCEDURE `GetSongDetails` (IN `songID` INT)   BEGIN
    SELECT
        Song.songID,
        Song.name AS song_name,
        Song.albumID,
        Song.length,
        Song.trackNumber,
        Song.releaseDate,
        Album.name AS album_name,
        Album.albumID,
        Artist.artistID,
        GROUP_CONCAT(DISTINCT Artist.name SEPARATOR ', ') AS artist_names,
        GROUP_CONCAT(DISTINCT Genre.name SEPARATOR ', ') AS genre_names
    FROM Song
    LEFT JOIN Song_Artist ON Song.songID = Song_Artist.songID
    LEFT JOIN Artist ON Song_Artist.artistID = Artist.artistID
    LEFT JOIN Album ON Song.albumID = Album.albumID
    LEFT JOIN Song_Genre ON Song.songID = Song_Genre.songID
    LEFT JOIN Genre ON Song_Genre.genreID = Genre.genreID
    WHERE Song.songID = songID
    GROUP BY Song.songID;
END$$

--
-- Functions
--
CREATE DEFINER=`cs340_waltemry`@`%` FUNCTION `CountAlbumsByArtist` (`artistID` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE albumCount INT;

    SELECT COUNT(DISTINCT Album.albumID) 
    INTO albumCount
    FROM Artist
    JOIN Song_Artist ON Artist.artistID = Song_Artist.artistID
    JOIN Song ON Song_Artist.songID = Song.songID
    JOIN Album ON Song.albumID = Album.albumID
    WHERE Artist.artistID = artistID;

    RETURN albumCount;
END$$

CREATE DEFINER=`cs340_waltemry`@`%` FUNCTION `GetSongCount` (`artistID` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE songCount INT;
    
    SELECT COUNT(DISTINCT Song.songID) INTO songCount
    FROM Song
    JOIN Song_Artist ON Song.songID = Song_Artist.songID
    WHERE Song_Artist.artistID = artistID;
    
    RETURN songCount;
END$$

DELIMITER ;

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
(4, 'Nectar', 5, '2020-09-25'),
(5, 'Sempiternal (Deluxe Edition)', 6, '2013-04-02'),
(19, 'Timely!!', 9, '1983-12-05'),
(20, 'Disgrace', 7, '2019-11-16'),
(21, 'GTG', 8, '2018-08-10'),
(22, 'Madman Across The Water', 10, '1971-11-05'),
(23, 'wet milk', 1, '2019-04-19'),
(24, 'All Time Low', 7, '2022-04-22'),
(25, 'BACKBONE', 4, '2018-01-26'),
(26, 'Drop It Like It\'s Hot!', 3, '2020-05-31'),
(27, 'Test', 16, '2024-12-09');

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
(10, 'Elton John', 'Elton John is a legendary British musician known for his piano-driven pop and rock music, as well as his flamboyant performances.', '1969-01-01'),
(16, 'Test', NULL, '0000-00-00');

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
(3, 3, 'Road Trip', '2024-11-25'),
(4, 4, 'Party Hits', '2024-11-25'),
(5, 5, 'Study Session', '2024-11-25'),
(6, 6, 'Throwback Jams', '2024-11-25'),
(7, 7, 'Sunday Morning', '2024-11-25'),
(8, 8, 'Lock In', '2024-11-25'),
(9, 9, 'Relax & Unwind', '2024-11-25'),
(10, 10, 'Dance Floor', '2024-11-25'),
(13, 2, 'bilmuri awesomeness', '0000-00-00'),
(14, 14, 'Fun Rock', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `Playlist_Song`
--

CREATE TABLE `Playlist_Song` (
  `playlistID` int(11) NOT NULL,
  `songID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Playlist_Song`
--

INSERT INTO `Playlist_Song` (`playlistID`, `songID`) VALUES
(1, 1),
(1, 103),
(3, 1),
(3, 3),
(3, 100),
(5, 86),
(5, 87),
(6, 68),
(9, 71),
(10, 77),
(13, 1),
(13, 2),
(13, 7),
(13, 71),
(13, 164),
(13, 168),
(14, 1),
(14, 2),
(14, 63),
(14, 87),
(14, 89);

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
(127, 'CAT\'S EYE - (NEW TAKE)', 19, '00:03:09', 1, '1983-12-05'),
(128, 'WINDY SUMMER', 19, '00:04:06', 2, '1983-12-05'),
(129, 'STAY BY ME', 19, '00:03:37', 3, '1983-12-05'),
(130, 'A HOPE FROM SAD STREET', 19, '00:04:19', 4, '1983-12-05'),
(131, 'YOU ARE NOT ALONE', 19, '00:04:03', 5, '1983-12-05'),
(132, '悲しみがとまらない　I CAN\'T STOP THE LONELINLESS', 19, '00:04:23', 6, '1983-12-05'),
(133, 'SHYNESS BOY', 19, '00:03:16', 7, '1983-12-05'),
(134, 'LOST LOVE IN THE RAIN', 19, '00:04:19', 8, '1983-12-05'),
(135, 'DRIVING MY LOVE', 19, '00:04:51', 9, '1983-12-05'),
(136, 'GOOD-NIGHT FOR YOU', 19, '00:05:20', 10, '1983-12-05'),
(137, 'Remember Summer Days', 19, '00:04:55', 11, '1983-12-05'),
(138, 'Disgrace', 20, '00:02:46', 1, '2019-11-16'),
(139, 'Lone Wolf Squad', 20, '00:02:20', 2, '2019-11-16'),
(140, 'Decay', 20, '00:02:15', 3, '2019-11-16'),
(141, 'So Tired', 20, '00:02:07', 4, '2019-11-16'),
(142, 'Paranoia', 20, '00:02:44', 5, '2019-11-16'),
(143, 'Suicide Benz', 20, '00:02:58', 6, '2019-11-16'),
(144, 'I Miss My Ex', 20, '00:02:21', 7, '2019-11-16'),
(145, 'Sleepless', 20, '00:02:42', 8, '2019-11-16'),
(146, 'January Never Ends', 20, '00:02:20', 9, '2019-11-16'),
(147, 'Outbreak', 20, '00:02:14', 10, '2019-11-16'),
(148, 'Lowlife', 20, '00:01:35', 11, '2019-11-16'),
(149, 'Darkness', 20, '00:01:52', 12, '2019-11-16'),
(150, 'Save Me', 20, '00:03:01', 13, '2019-11-16'),
(151, 'GTG', 21, '00:01:33', 1, '2018-08-10'),
(152, 'Tiny Dancer', 22, '00:06:17', 1, '1971-11-05'),
(153, 'Levon', 22, '00:05:22', 2, '1971-11-05'),
(154, 'Razer Face', 22, '00:04:42', 3, '1971-11-05'),
(155, 'Madman Across The Water', 22, '00:05:57', 4, '1971-11-05'),
(156, 'Indian Sunset', 22, '00:06:46', 5, '1971-11-05'),
(157, 'Holiday Inn', 22, '00:04:16', 6, '1971-11-05'),
(158, 'Rotten Peaches', 22, '00:04:58', 7, '1971-11-05'),
(159, 'All The Nasties', 22, '00:05:09', 8, '1971-11-05'),
(160, 'Goodbye', 22, '00:01:48', 9, '1971-11-05'),
(161, 'lifeisgood', 23, '00:02:48', 1, '2019-04-19'),
(162, 'myfeelingshavefeelings', 23, '00:02:16', 2, '2019-04-19'),
(163, 'holycrud', 23, '00:02:30', 3, '2019-04-19'),
(164, 'ilovebeer', 23, '00:04:06', 4, '2019-04-19'),
(165, 'mytop10mostbrootalbreakdownsof2047', 23, '00:03:01', 5, '2019-04-19'),
(166, 'spacebetweenlettersarecool', 23, '00:02:38', 6, '2019-04-19'),
(167, 'youareamazingandiloveyou', 23, '00:02:47', 7, '2019-04-19'),
(168, 'All Time Low', 24, '00:03:06', 1, '2022-04-22'),
(169, 'BACKBONE', 25, '00:03:14', 1, '2018-01-26'),
(170, 'Drop It Like It\'s Hot!', 26, '00:02:15', 1, '2020-05-31'),
(171, 'test1', 27, '00:30:30', 1, '2024-12-09'),
(172, 'test2', 27, '00:40:40', 2, '2024-12-09');

-- --------------------------------------------------------

--
-- Table structure for table `Song_Artist`
--

CREATE TABLE `Song_Artist` (
  `songID` int(11) NOT NULL,
  `artistID` int(11) NOT NULL,
  `role` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Song_Artist`
--

INSERT INTO `Song_Artist` (`songID`, `artistID`, `role`) VALUES
(1, 1, 'Main Artist'),
(2, 1, 'Main Artist'),
(3, 1, 'Main Artist'),
(4, 1, 'Main Artist'),
(5, 1, 'Main Artist'),
(6, 1, 'Main Artist'),
(7, 1, 'Main Artist'),
(62, 5, 'Main Artist'),
(63, 5, 'Main Artist'),
(64, 5, 'Main Artist'),
(65, 5, 'Main Artist'),
(66, 5, 'Main Artist'),
(67, 5, 'Main Artist'),
(68, 5, 'Main Artist'),
(69, 5, 'Main Artist'),
(70, 5, 'Main Artist'),
(71, 5, 'Main Artist'),
(72, 5, 'Main Artist'),
(73, 5, 'Main Artist'),
(74, 5, 'Main Artist'),
(75, 5, 'Main Artist'),
(76, 5, 'Main Artist'),
(77, 5, 'Main Artist'),
(78, 5, 'Main Artist'),
(79, 5, 'Main Artist'),
(80, 2, 'Main Artist'),
(81, 2, 'Main Artist'),
(82, 2, 'Main Artist'),
(83, 2, 'Main Artist'),
(84, 2, 'Main Artist'),
(85, 2, 'Main Artist'),
(86, 2, 'Main Artist'),
(87, 2, 'Main Artist'),
(88, 2, 'Main Artist'),
(89, 2, 'Main Artist'),
(90, 2, 'Main Artist'),
(91, 2, 'Main Artist'),
(92, 6, 'Main Artist'),
(93, 6, 'Main Artist'),
(94, 6, 'Main Artist'),
(95, 6, 'Main Artist'),
(96, 6, 'Main Artist'),
(97, 6, 'Main Artist'),
(98, 6, 'Main Artist'),
(99, 6, 'Main Artist'),
(100, 6, 'Main Artist'),
(101, 6, 'Main Artist'),
(102, 6, 'Main Artist'),
(103, 6, 'Main Artist'),
(104, 6, 'Main Artist'),
(105, 6, 'Main Artist'),
(127, 9, 'Main'),
(128, 9, 'Main'),
(129, 9, 'Main'),
(130, 9, 'Main'),
(131, 9, 'Main'),
(132, 9, 'Main'),
(133, 9, 'Main'),
(134, 9, 'Main'),
(135, 9, 'Main'),
(136, 9, 'Main'),
(137, 9, 'Main'),
(138, 7, 'Main'),
(139, 7, 'Main'),
(140, 7, 'Main'),
(141, 7, 'Main'),
(142, 7, 'Main'),
(143, 7, 'Main'),
(144, 7, 'Main'),
(145, 7, 'Main'),
(146, 7, 'Main'),
(147, 7, 'Main'),
(148, 7, 'Main'),
(149, 7, 'Main'),
(150, 7, 'Main'),
(151, 8, 'Main'),
(152, 10, 'Main'),
(153, 10, 'Main'),
(154, 10, 'Main'),
(155, 10, 'Main'),
(156, 10, 'Main'),
(157, 10, 'Main'),
(158, 10, 'Main'),
(159, 10, 'Main'),
(160, 10, 'Main'),
(161, 1, 'Main'),
(162, 1, 'Main'),
(163, 1, 'Main'),
(164, 1, 'Main'),
(165, 1, 'Main'),
(166, 1, 'Main'),
(167, 1, 'Main'),
(168, 7, 'Main'),
(169, 4, 'Main'),
(170, 3, 'Main'),
(171, 16, 'Main'),
(172, 16, 'Main');

-- --------------------------------------------------------

--
-- Table structure for table `Song_Genre`
--

CREATE TABLE `Song_Genre` (
  `songID` int(11) NOT NULL,
  `genreID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `Song_Genre`
--

INSERT INTO `Song_Genre` (`songID`, `genreID`) VALUES
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
(91, 2),
(127, 12),
(128, 12),
(129, 12),
(130, 12),
(131, 12),
(132, 12),
(133, 12),
(134, 12),
(135, 12),
(136, 12),
(137, 12),
(138, 11),
(139, 11),
(140, 11),
(141, 11),
(142, 11),
(143, 11),
(144, 11),
(145, 11),
(146, 11),
(147, 11),
(148, 11),
(149, 11),
(150, 11),
(151, 11),
(152, 2),
(153, 2),
(154, 2),
(155, 2),
(156, 2),
(157, 2),
(158, 2),
(159, 2),
(160, 2),
(161, 2),
(162, 2),
(163, 2),
(164, 2),
(165, 2),
(166, 2),
(167, 2),
(168, 11),
(169, 6),
(170, 11),
(171, 12),
(172, 5);

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
(10, 'mia', 'mia@oregonstate.edu', 'miapassword', '2024-11-25'),
(14, 'ryan2', 'ryan2@oregonstate.edu', 'ryan2', '2024-12-08'),
(15, 'coreybai', 'baixia@oregonstate.edu', 'Bxd19980610', '2024-12-09');

-- --------------------------------------------------------

--
-- Table structure for table `User_Follow`
--

CREATE TABLE `User_Follow` (
  `userID` int(11) NOT NULL,
  `artistID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Dumping data for table `User_Follow`
--

INSERT INTO `User_Follow` (`userID`, `artistID`) VALUES
(1, 7),
(1, 10),
(2, 1),
(2, 2),
(2, 5),
(2, 7),
(3, 3),
(4, 4),
(5, 5),
(6, 4),
(7, 5),
(8, 6),
(9, 6),
(10, 6);

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
-- Indexes for table `Playlist_Song`
--
ALTER TABLE `Playlist_Song`
  ADD PRIMARY KEY (`playlistID`,`songID`),
  ADD KEY `songID` (`songID`);

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
-- Indexes for table `Song_Artist`
--
ALTER TABLE `Song_Artist`
  ADD PRIMARY KEY (`songID`,`artistID`,`role`),
  ADD KEY `artistID` (`artistID`);

--
-- Indexes for table `Song_Genre`
--
ALTER TABLE `Song_Genre`
  ADD PRIMARY KEY (`songID`,`genreID`),
  ADD KEY `genreID` (`genreID`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `User_Follow`
--
ALTER TABLE `User_Follow`
  ADD PRIMARY KEY (`userID`,`artistID`),
  ADD KEY `artistID` (`artistID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Album`
--
ALTER TABLE `Album`
  MODIFY `albumID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `Artist`
--
ALTER TABLE `Artist`
  MODIFY `artistID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `Genre`
--
ALTER TABLE `Genre`
  MODIFY `genreID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `Playlist`
--
ALTER TABLE `Playlist`
  MODIFY `playlistID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `Song`
--
ALTER TABLE `Song`
  MODIFY `songID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `User`
--
ALTER TABLE `User`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Album`
--
ALTER TABLE `Album`
  ADD CONSTRAINT `Album_ibfk_1` FOREIGN KEY (`artistID`) REFERENCES `Artist` (`artistID`) ON DELETE CASCADE;

--
-- Constraints for table `Playlist`
--
ALTER TABLE `Playlist`
  ADD CONSTRAINT `Playlist_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `User` (`userID`);

--
-- Constraints for table `Playlist_Song`
--
ALTER TABLE `Playlist_Song`
  ADD CONSTRAINT `Playlist_Song_ibfk_1` FOREIGN KEY (`playlistID`) REFERENCES `Playlist` (`playlistID`) ON DELETE CASCADE,
  ADD CONSTRAINT `Playlist_Song_ibfk_2` FOREIGN KEY (`songID`) REFERENCES `Song` (`songID`) ON DELETE CASCADE;

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
-- Constraints for table `Song_Artist`
--
ALTER TABLE `Song_Artist`
  ADD CONSTRAINT `Song_Artist_ibfk_1` FOREIGN KEY (`songID`) REFERENCES `Song` (`songID`) ON DELETE CASCADE,
  ADD CONSTRAINT `Song_Artist_ibfk_2` FOREIGN KEY (`artistID`) REFERENCES `Artist` (`artistID`) ON DELETE CASCADE;

--
-- Constraints for table `Song_Genre`
--
ALTER TABLE `Song_Genre`
  ADD CONSTRAINT `Song_Genre_ibfk_1` FOREIGN KEY (`songID`) REFERENCES `Song` (`songID`) ON DELETE CASCADE,
  ADD CONSTRAINT `Song_Genre_ibfk_2` FOREIGN KEY (`genreID`) REFERENCES `Genre` (`genreID`) ON DELETE CASCADE;

--
-- Constraints for table `User_Follow`
--
ALTER TABLE `User_Follow`
  ADD CONSTRAINT `User_Follow_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `User` (`userID`),
  ADD CONSTRAINT `User_Follow_ibfk_2` FOREIGN KEY (`artistID`) REFERENCES `Artist` (`artistID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

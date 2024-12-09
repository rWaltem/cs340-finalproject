<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

include('db_connection.php');

// Get Album ID from query parameter
$albumID = isset($_GET['albumID']) ? intval($_GET['albumID']) : 0;

if ($albumID <= 0) {
    die("Invalid album ID.");
}

// Fetch album details
$stmt = $conn->prepare("
    SELECT
        Album.name AS album_name,
        Artist.artistID,
        Album.releaseDate AS album_releaseDate,
        GROUP_CONCAT(DISTINCT Artist.name SEPARATOR ', ') AS artist_names
    FROM Album
    LEFT JOIN Song ON Album.albumID = Song.albumID
    LEFT JOIN Song_Artist ON Song.songID = Song_Artist.songID
    LEFT JOIN Artist ON Song_Artist.artistID = Artist.artistID
    WHERE Album.albumID = ?
    GROUP BY Album.albumID;
");
$stmt->bind_param("i", $albumID);
$stmt->execute();
$albumResult = $stmt->get_result();

if ($albumResult->num_rows === 0) {
    die("Album not found.");
}

$album = $albumResult->fetch_assoc();
$stmt->close();

// Fetch songs in the album
$songsQuery = "
    SELECT
        Song.songID,
        Song.name AS song_name,
        Song.length,
        Song.trackNumber
    FROM Song
    WHERE Song.albumID = ?
    ORDER BY Song.trackNumber;
";
$stmt = $conn->prepare($songsQuery);
$stmt->bind_param("i", $albumID);
$stmt->execute();
$songs = $stmt->get_result();
$stmt->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Album: <?php echo htmlspecialchars($album['album_name']); ?></title>
</head>
<body>
    <a href="dashboard.php">Go to Dashboard</a>
    <a href="followed_artists.php">Go to Followed Artists</a>
    <h1>Album: <?php echo htmlspecialchars($album['album_name']); ?></h1>
    <p>Artist: <a href="artist_page.php?artistID=<?php echo $album['artistID']?>"><?php echo htmlspecialchars($album['artist_names']); ?></a></p>
    <p>Release Date: <?php echo htmlspecialchars($album['album_releaseDate']); ?></p>

    <h2>Songs in this Album</h2>
    <table border="1">
        <tr>
            <th>Track Number</th>
            <th>Song Title</th>
            <th>Length</th>
            <th></th>
        </tr>
        <?php while ($song = $songs->fetch_assoc()) : ?>
        <tr>
            <td><?php echo htmlspecialchars($song['trackNumber']); ?></td>
            <td><a href="song_info.php?songID=<?php echo $song['songID']; ?>"><?php echo htmlspecialchars($song['song_name']); ?></a></td> 
            <td><?php echo htmlspecialchars($song['length']); ?></td>
            <td><a href="choose_playlist.php?songID=<?php echo $song['songID']; ?>">Add to Playlist</a></td>
        </tr>
        <?php endwhile; ?>
    </table>
</body>
</html>

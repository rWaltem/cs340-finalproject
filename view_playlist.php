<?php
// Database connection
include('db_connection.php');

// Get playlist ID from query parameters
$playlistID = isset($_GET['playlistID']) ? intval($_GET['playlistID']) : 0;

// Fetch playlist details
$stmt = $conn->prepare("SELECT name FROM Playlist WHERE playlistID = ?");
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}

$stmt->bind_param("i", $playlistID);
$stmt->execute();
$result = $stmt->get_result();

if ($playlist = $result->fetch_assoc()) {
    $playlistName = $playlist['name'];
} else {
    die("Playlist not found.");
}

$stmt->close();

// Fetch songs in the playlist
$stmt = $conn->prepare("
    SELECT Song.name AS song_name, Artist.name AS artist_name
    FROM Song
    INNER JOIN Playlist_Song ON Song.songID = Playlist_Song.songID
    INNER JOIN Song_Artist ON Song.songID = Song_Artist.songID
    INNER JOIN Artist ON Song_Artist.artistID = Artist.artistID
    WHERE Playlist_Song.playlistID = ?;
");
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}

$stmt->bind_param("i", $playlistID);
$stmt->execute();
$songs = $stmt->get_result();

$stmt->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Playlist: <?php echo htmlspecialchars($playlistName); ?></title>
</head>
<body>
    <a href='dashboard.php'>Go back to Dashboard</a>
    <h1>Playlist: <?php echo htmlspecialchars($playlistName); ?></h1>
    <table border="1">
        <tr>
            <th>Title</th>
            <th>Artist</th>
        </tr>
        <?php while ($song = $songs->fetch_assoc()): ?>
        <tr>
            <td><?php echo htmlspecialchars($song['song_name']); ?></td>
            <td><?php echo htmlspecialchars($song['artist_name']); ?></td>
        </tr>
        <?php endwhile; ?>
    </table>
</body>
</html>

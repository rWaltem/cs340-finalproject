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
$stmt = $conn->prepare("CALL GetPlaylistSongDetails(?)");
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
    <a href="dashboard.php">Go to Dashboard</a>
    <a href="followed_artists.php">Go to Followed Artists</a>
    <h1>Playlist: <?php echo htmlspecialchars($playlistName); ?></h1>
    <table border="1">
        <tr>
            <th>Title</th>
            <th>Artist</th>
        </tr>
        <?php while ($song = $songs->fetch_assoc()): ?>
        <tr>
            <td><a href="song_info.php?songID=<?php echo $song['songID']; ?>"><?php echo htmlspecialchars($song['song_name']); ?></a></td>
            <td><a href="artist_page.php?artistID=<?php echo $song['artistID']?>"><?php echo htmlspecialchars($song['artist_names']); ?></a></td>
        </tr>
        <?php endwhile; ?>
    </table>
</body>
</html>

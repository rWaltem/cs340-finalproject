<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

include('db_connection.php');

// Get Song ID
$songID = isset($_GET['songID']) ? intval($_GET['songID']) : 0;

if ($songID <= 0) {
    die("Invalid song ID.");
}

$stmt = $conn->prepare("CALL GetSongDetails(?)");
$stmt->bind_param("i", $songID);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    die("Song not found.");
}

$song = $result->fetch_assoc();
$stmt->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Song Details: <?php echo htmlspecialchars($song['song_name']); ?></title>
</head>
<body>
    <a href="dashboard.php">Go to Dashboard</a>
    <a href="followed_artists.php">Go to Followed Artists</a>
    <h1>Song Details</h1>
    <table border="1">
        <tr>
            <th>Song Title</th>
            <th>Artists</th>
            <th>Album</th>
            <th>Length</th>
            <th>Track Number</th>
            <th>Release Date</th>
            <th>Genres</th>
            <th></th>
        </tr>
        <tr>
            <td><?php echo htmlspecialchars($song['song_name']); ?></td>
            <td><a href="artist_page.php?artistID=<?php echo $song['artistID']?>"><?php echo htmlspecialchars($song['artist_names']); ?></a></td>
            <td><a href="album_page.php?albumID=<?php echo $song['albumID']; ?>"><?php echo htmlspecialchars($song['album_name']); ?></a></td>
            <td><?php echo htmlspecialchars($song['length']); ?></td>
            <td><?php echo htmlspecialchars($song['trackNumber']); ?></td>
            <td><?php echo htmlspecialchars($song['releaseDate']); ?></td>
            <td><?php echo htmlspecialchars($song['genre_names']); ?></td>
            <td><a href="choose_playlist.php?songID=<?php echo $song['songID']; ?>">Add to Playlist</a></td>
        </tr>
    </table>
</body>
</html>
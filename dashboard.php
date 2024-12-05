<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

$userID = $_SESSION['userID'];
include('db_connection.php');

// Fetch user's playlists
$stmt = $conn->prepare("SELECT * FROM Playlist WHERE userID = ?");
$stmt->bind_param("i", $userID);
$stmt->execute();
$playlists = $stmt->get_result();

// Fetch all songs with their artists
$songsQuery = "
    SELECT Song.songID, Song.name AS song_name, GROUP_CONCAT(Artist.name ORDER BY Artist.name ASC) AS artist_names
    FROM Song
    LEFT JOIN Song_Artist ON Song.songID = Song_Artist.songID
    LEFT JOIN Artist ON Song_Artist.artistID = Artist.artistID
    GROUP BY Song.songID
";
$songs = $conn->query($songsQuery);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <h1>Welcome to Your Dashboard</h1>
    <h2>Your Playlists</h2>
    <ul>
        <?php while ($playlist = $playlists->fetch_assoc()) : ?>
            <li>
                <?php echo htmlspecialchars($playlist['name']); ?>
                <a href="view_playlist.php?playlistID=<?php echo $playlist['playlistID']; ?>">View Playlist</a>
            </li>
        <?php endwhile; ?>
    </ul>

    <h2>All Songs</h2>
    <table border="1">
        <tr>
            <th>Song Title</th>
            <th>Artist</th>
            <th>Action</th>
        </tr>
        <?php while ($song = $songs->fetch_assoc()) : ?>
        <tr>
            <td><strong><?php echo htmlspecialchars($song['song_name']); ?></strong></td>
            <td><?php echo htmlspecialchars($song['artist_names']); ?></td>
            <!-- Redirect to choose_playlist.php with songID as a URL parameter -->
            <td><a href="choose_playlist.php?songID=<?php echo $song['songID']; ?>">Add to Playlist</a></td>
        </tr>
        <?php endwhile; ?>
    </table>

    <script>
        function addToPlaylist(songID) {
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "add_to_playlist.php", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onload = function () {
                alert(this.responseText);
            };
            xhr.send("songID=" + songID);
        }
    </script>
</body>
</html>

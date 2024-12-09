<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

$userID = $_SESSION['userID'];
include('db_connection.php');

// Fetch user playlists
$stmt = $conn->prepare("SELECT * FROM Playlist WHERE userID = ?");
$stmt->bind_param("i", $userID);
$stmt->execute();
$playlists = $stmt->get_result();

// Fetch all songs
$songsQuery = "
    SELECT
        Song.songID,
        Song.name AS song_name,
        Song.releaseDate AS release_date,
        GROUP_CONCAT(Artist.name SEPARATOR ', ') AS artist_names,
        Album.albumID,
        Artist.artistID,
        Album.name AS album_name
    FROM Song
    LEFT JOIN Song_Artist ON Song.songID = Song_Artist.songID
    LEFT JOIN Artist ON Song_Artist.artistID = Artist.artistID
    LEFT JOIN Album ON Song.albumID = Album.albumID
    GROUP BY Song.songID, Album.albumID
    ORDER BY release_date DESC
";
$songs = $conn->query($songsQuery);

// Handle create playlist form
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['playlist_name'])) {
    $playlistName = $_POST['playlist_name'];
    if (!empty($playlistName)) {
        $stmt = $conn->prepare("INSERT INTO Playlist (userID, name) VALUES (?, ?)");
        $stmt->bind_param("is", $userID, $playlistName);
        $stmt->execute();
        $stmt->close();
        header("Location: dashboard.php");
        exit;
    }
}

// Handle delete playlist
if (isset($_GET['deletePlaylistID'])) {
    $deletePlaylistID = $_GET['deletePlaylistID'];
    $stmt = $conn->prepare("DELETE FROM Playlist WHERE playlistID = ? AND userID = ?");
    $stmt->bind_param("ii", $deletePlaylistID, $userID);
    $stmt->execute();
    $stmt->close();
    header("Location: dashboard.php");
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <a href="followed_artists.php">Followed Artists</a>
    <a href="admin_options.html">Add Songs</a>

    <h1>Welcome to Your Dashboard</h1>

    <!-- Logout Button -->
    <form method="POST" action="logout.php">
        <button type="submit">Logout</button>
    </form>

    <h2>Your Playlists</h2>
    <ul>
        <?php while ($playlist = $playlists->fetch_assoc()) : ?>
            <li>
                <?php echo htmlspecialchars($playlist['name']); ?>
                <a href="view_playlist.php?playlistID=<?php echo $playlist['playlistID']; ?>">View Playlist</a>
                <a href="dashboard.php?deletePlaylistID=<?php echo $playlist['playlistID']; ?>" onclick="return confirm('Are you sure you want to delete this playlist?');">Delete Playlist</a>
            </li>
        <?php endwhile; ?>
    </ul>

    <!-- Create Playlist Form -->
    <h3>Create New Playlist</h3>
    <form method="POST" action="dashboard.php">
        <label for="playlist_name">Playlist Name:</label>
        <input type="text" id="playlist_name" name="playlist_name" required>
        <button type="submit">Create Playlist</button>
    </form>

    <h2>All Songs</h2>
    <table border="1">
        <tr>
            <th>Song Title</th>
            <th><a href="all_albums.php">Album</a></th>
            <th><a href="all_artists.php">Artist</a></th>
            <th>Release Date</th>
            <th></th>
        </tr>
    <?php while ($song = $songs->fetch_assoc()) : ?>
    <tr>
        <td><strong><a href="song_info.php?songID=<?php echo $song['songID']; ?>"><?php echo htmlspecialchars($song['song_name']); ?></a></strong></td>
        <td><a href="album_page.php?albumID=<?php echo $song['albumID']; ?>"><?php echo htmlspecialchars($song['album_name']); ?></a></td>
        <td><a href="artist_page.php?artistID=<?php echo $song['artistID']?>"><?php echo htmlspecialchars($song['artist_names']); ?></a></td>
        <td><?php echo htmlspecialchars($song['release_date']); ?></td>
        <td><a href="choose_playlist.php?songID=<?php echo $song['songID']; ?>">Add to Playlist</a></td>
    </tr>
    <?php endwhile; ?>
</table>

</body>
</html>

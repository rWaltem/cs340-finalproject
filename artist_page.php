<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

include('db_connection.php');

$userID = $_SESSION['userID'];
$artistID = isset($_GET['artistID']) ? intval($_GET['artistID']) : 0;

if ($artistID <= 0) {
    die("Invalid artist ID.");
}

// Fetch artist's name and debut date
$artistQuery = $conn->prepare("SELECT name, debutDate FROM Artist WHERE artistID = ?");
$artistQuery->bind_param("i", $artistID);
$artistQuery->execute();
$artistResult = $artistQuery->get_result();

if ($artistResult->num_rows === 0) {
    die("Artist not found.");
}

$artist = $artistResult->fetch_assoc();
$artistName = $artist['name'];
$artistDebutDate = $artist['debutDate']; // Get debut date
$artistQuery->close();

// Fetch total songs released using GetSongCount function
$songCountQuery = $conn->prepare("SELECT GetSongCount(?) AS totalSongs");
$songCountQuery->bind_param("i", $artistID);
$songCountQuery->execute();
$songCountResult = $songCountQuery->get_result();

if ($songCountResult->num_rows === 0) {
    die("Error fetching song count.");
}

$songCount = $songCountResult->fetch_assoc();
$totalSongs = $songCount['totalSongs'];
$songCountQuery->close();

// Fetch total albums released using CountAlbumsByArtist function
$albumCountQuery = $conn->prepare("SELECT CountAlbumsByArtist(?) AS totalAlbums");
$albumCountQuery->bind_param("i", $artistID);
$albumCountQuery->execute();
$albumCountResult = $albumCountQuery->get_result();

if ($albumCountResult->num_rows === 0) {
    die("Error fetching album count.");
}

$albumCount = $albumCountResult->fetch_assoc();
$totalAlbums = $albumCount['totalAlbums'];
$albumCountQuery->close();

// Check if the user is already following the artist
$followCheck = $conn->prepare("SELECT * FROM User_Follow WHERE userID = ? AND artistID = ?");
$followCheck->bind_param("ii", $userID, $artistID);
$followCheck->execute();
$isFollowing = $followCheck->get_result()->num_rows > 0;
$followCheck->close();

// Handle follow/unfollow actions
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!$isFollowing) {
        $followStmt = $conn->prepare("INSERT INTO User_Follow (userID, artistID) VALUES (?, ?)");
        $followStmt->bind_param("ii", $userID, $artistID);
        $followStmt->execute();
        $followStmt->close();
        $isFollowing = true;
    } else {
        $unfollowStmt = $conn->prepare("DELETE FROM User_Follow WHERE userID = ? AND artistID = ?");
        $unfollowStmt->bind_param("ii", $userID, $artistID);
        $unfollowStmt->execute();
        $unfollowStmt->close();
        $isFollowing = false;
    }
}

// Fetch artist's albums with number of songs and release date
$stmt = $conn->prepare("
    SELECT
        Album.albumID,
        Album.name AS album_name,
        COUNT(Song.songID) AS song_count,
        Album.releaseDate
    FROM Album
    LEFT JOIN Song ON Album.albumID = Song.albumID
    WHERE Album.artistID = ?
    GROUP BY Album.albumID
    ORDER BY Album.releaseDate DESC
");
$stmt->bind_param("i", $artistID);
$stmt->execute();
$albums = $stmt->get_result();

// Fetch all songs by the artist
$songsQuery = "
    SELECT
        Song.songID,
        Song.name AS song_name,
        Song.releaseDate AS song_release_date,
        Album.name AS album_name,
        Album.albumID
    FROM Song
    LEFT JOIN Album ON Song.albumID = Album.albumID
    WHERE Album.artistID = ?
    ORDER BY Song.releaseDate DESC
";
$songsStmt = $conn->prepare($songsQuery);
$songsStmt->bind_param("i", $artistID);
$songsStmt->execute();
$songsResult = $songsStmt->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Artist Page: <?php echo htmlspecialchars($artistName); ?></title>
</head>
<body>
    <a href="dashboard.php">Go to Dashboard</a>
    <a href="followed_artists.php">Go to Followed Artists</a>
    <h1>Artist: <?php echo htmlspecialchars($artistName); ?></h1>

    <!-- Display debut date, total songs, and total albums -->
    <p><strong>Debut Date:</strong> <?php echo htmlspecialchars($artistDebutDate); ?></p>
    <p><strong>Total Songs Released:</strong> <?php echo htmlspecialchars($totalSongs); ?></p>
    <p><strong>Total Albums Released:</strong> <?php echo htmlspecialchars($totalAlbums); ?></p>

    <form method="POST">
        <button type="submit">
            <?php echo $isFollowing ? "Unfollow" : "Follow"; ?>
        </button>
    </form>

    <h2>Albums</h2>
    <table border="1">
        <tr>
            <th>Name</th>
            <th>Number of Songs</th>
            <th>Release Date</th>
        </tr>
        <?php while ($album = $albums->fetch_assoc()): ?>
            <tr>
                <td><a href="album_page.php?albumID=<?php echo $album['albumID']; ?>"><?php echo htmlspecialchars($album['album_name']); ?></a></td>
                <td><?php echo $album['song_count']; ?></td>
                <td><?php echo htmlspecialchars($album['releaseDate']); ?></td>
            </tr>
        <?php endwhile; ?>
    </table>

    <h2>Songs</h2>
    <table border="1">
        <tr>
            <th>Song Title</th>
            <th>Album</th>
            <th>Release Date</th>
            <th></th>
        </tr>
        <?php while ($song = $songsResult->fetch_assoc()): ?>
            <tr>
                <td><a href="song_info.php?songID=<?php echo $song['songID']?>"><?php echo htmlspecialchars($song['song_name']); ?></a></td>
                <td><a href="album_page.php?albumID=<?php echo $song['albumID']; ?>"><?php echo htmlspecialchars($song['album_name']); ?></a></td>
                <td><?php echo htmlspecialchars($song['song_release_date']); ?></td>
                <td><a href="choose_playlist.php?songID=<?php echo $song['songID']; ?>">Add to Playlist</a></td>
            </tr>
        <?php endwhile; ?>
    </table>
</body>
</html>

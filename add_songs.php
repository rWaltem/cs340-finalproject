<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}


include('db_connection.php');

// Fetch genres for dropdown
$genreStmt = $conn->prepare("SELECT genreID, name FROM Genre");
$genreStmt->execute();
$genresResult = $genreStmt->get_result();
$genres = [];
while ($row = $genresResult->fetch_assoc()) {
    $genres[] = $row;
}
$genreStmt->close();

// Initialize variables
$artistName = '';
$albumName = '';
$albumReleaseDate = '';
$numTracks = 0;
$songs = [];

// Process form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['artistName'], $_POST['albumName'], $_POST['releaseDate'], $_POST['numTracks'])) {
        $artistName = trim($_POST['artistName']);
        $albumName = trim($_POST['albumName']);
        $albumReleaseDate = $_POST['releaseDate'];
        $numTracks = intval($_POST['numTracks']);

        if ($numTracks > 0 && isset($_POST['songs'])) {
            $songs = $_POST['songs'];

            // Check if artist exists
            $artistCheckStmt = $conn->prepare("SELECT artistID FROM Artist WHERE name = ?");
            $artistCheckStmt->bind_param("s", $artistName);
            $artistCheckStmt->execute();
            $artistCheckResult = $artistCheckStmt->get_result();

            if ($artistCheckResult->num_rows > 0) {
                // Use existing artist ID
                $artistID = $artistCheckResult->fetch_assoc()['artistID'];
            } else {
                // Insert new artist
                $artistStmt = $conn->prepare("INSERT INTO Artist (name) VALUES (?)");
                $artistStmt->bind_param("s", $artistName);
                $artistStmt->execute();
                $artistID = $artistStmt->insert_id;
                $artistStmt->close();
            }
            $artistCheckStmt->close();

            // Insert Album
            $albumStmt = $conn->prepare("INSERT INTO Album (name, artistID, releaseDate) VALUES (?, ?, ?)");
            $albumStmt->bind_param("sis", $albumName, $artistID, $albumReleaseDate);
            $albumStmt->execute();
            $albumID = $albumStmt->insert_id;

            // Insert Songs and Song_Genre
            $songStmt = $conn->prepare("INSERT INTO Song (name, length, albumID, releaseDate, trackNumber) VALUES (?, ?, ?, ?, ?)");
            $songGenreStmt = $conn->prepare("INSERT INTO Song_Genre (songID, genreID) VALUES (?, ?)");
            $songArtistStmt = $conn->prepare("INSERT INTO Song_Artist (songID, artistID, role) VALUES (?, ?, ?)");

            foreach ($songs as $index => $song) {
                $trackNumber = $index; // Track number matches the row in the table
                $songStmt->bind_param("ssisi", $song['name'], $song['length'], $albumID, $albumReleaseDate, $trackNumber);
                $songStmt->execute();
                $songID = $songStmt->insert_id;

                // Insert song-genre mapping
                if (isset($song['genreID']) && !empty($song['genreID'])) {
                    $songGenreStmt->bind_param("ii", $songID, $song['genreID']);
                    $songGenreStmt->execute();
                }

                // Insert into Song_Artist with "Main" role
                $role = 'Main'; // Hardcoded role as "Main"
                $songArtistStmt->bind_param("iis", $songID, $artistID, $role);
                $songArtistStmt->execute();
            }

            echo "<a href='admin_options.html'>Dashboard</a>";
            echo "<h1>Songs added successfully!</h1>";
            echo "<p>Want to add another album? <a href='add_songs.php'>Click here</a>.</p>";
            $albumStmt->close();
            $songStmt->close();
            $songGenreStmt->close();
            $songArtistStmt->close();
            $conn->close();
            exit;
        }
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Add Songs</title>
</head>
<body>
    <a href="admin_options.html">Editing Dashboard</a>
    <h1>Add Songs</h1>
    <form method="POST" action="">
        <label>Artist Name:</label>
        <input type="text" name="artistName" required><br><br>

        <label>Album Name:</label>
        <input type="text" name="albumName" required><br><br>

        <label>Album Release Date:</label>
        <input type="date" name="releaseDate" required><br><br>

        <label>Number of Tracks:</label>
        <input type="number" name="numTracks" min="1" required>
        <button type="submit" name="generate">Generate Table</button>
    </form>

    <?php if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['numTracks']) && $numTracks > 0): ?>
        <form method="POST" action="">
            <input type="hidden" name="artistName" value="<?php echo htmlspecialchars($artistName); ?>">
            <input type="hidden" name="albumName" value="<?php echo htmlspecialchars($albumName); ?>">
            <input type="hidden" name="releaseDate" value="<?php echo htmlspecialchars($albumReleaseDate); ?>">
            <input type="hidden" name="numTracks" value="<?php echo $numTracks; ?>">

            <h2>Add Songs for Album: <?php echo htmlspecialchars($albumName); ?></h2>
            <table border="1">
                <tr>
                    <th>Track #</th>
                    <th>Song Name</th>
                    <th>Length (e.g., 00:03:45)</th>
                    <th>Genre</th>
                </tr>
                <?php for ($i = 1; $i <= $numTracks; $i++): ?>
                    <tr>
                        <td><?php echo $i; ?></td>
                        <td><input type="text" name="songs[<?php echo $i; ?>][name]" required></td>
                        <td><input type="text" name="songs[<?php echo $i; ?>][length]" required></td>
                        <td>
                            <select name="songs[<?php echo $i; ?>][genreID]" required>
                                <option value="">Select Genre</option>
                                <?php foreach ($genres as $genre): ?>
                                    <option value="<?php echo $genre['genreID']; ?>"><?php echo htmlspecialchars($genre['name']); ?></option>
                                <?php endforeach; ?>
                            </select>
                        </td>
                    </tr>
                <?php endfor; ?>
            </table>
            <button type="submit">Add Songs</button>
        </form>
    <?php endif; ?>
</body>
</html>

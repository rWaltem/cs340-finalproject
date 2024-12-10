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

$userID = $_SESSION['userID'];

// Fetch user's existing rating
$userRatingStmt = $conn->prepare("SELECT rating FROM Ratings WHERE userID = ? AND songID = ?");
$userRatingStmt->bind_param("ii", $userID, $songID);
$userRatingStmt->execute();
$userRatingResult = $userRatingStmt->get_result();

if ($userRatingResult->num_rows > 0) {
    $userRating = $userRatingResult->fetch_assoc()['rating'];
} else {
    $userRating = "Unrated";
}

$userRatingStmt->close();

// Handle Rating Submission
$ratingMessage = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['rate_song'])) {
    $rating = intval($_POST['rating']);

    if ($rating < 1 || $rating > 5) {
        $ratingMessage = "Rating must be between 1 and 5.";
    } else {
        $ratingStmt = $conn->prepare("REPLACE INTO Ratings (userID, songID, rating) VALUES (?, ?, ?)");
        if ($ratingStmt === false) {
            die("Error preparing rating statement: " . $conn->error);
        }

        $ratingStmt->bind_param("iii", $userID, $songID, $rating);
        $ratingStmt->execute();

        if ($ratingStmt->affected_rows > 0) {
            $ratingMessage = "Your rating has been submitted!";
            $userRating = $rating;
        } else {
            $ratingMessage = "Failed to submit your rating. Please try again.";
        }

        $ratingStmt->close();
    }
}

$conn->close();
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
            <th>Genre</th>
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

    <h2>Rate this Song</h2>
    <p>Your Current Rating: <?php echo htmlspecialchars($userRating); ?></p>
    <form method="POST" action="">
        <label for="rating">Your Rating (1-5):</label>
        <select name="rating" id="rating" required>
            <option value="" disabled selected>Select</option>
            <?php for ($i = 1; $i <= 5; $i++): ?>
                <option value="<?php echo $i; ?>" <?php echo ($userRating == $i ? 'selected' : ''); ?>><?php echo $i; ?></option>
            <?php endfor; ?>
        </select>
        <button type="submit" name="rate_song">Submit Rating</button>
    </form>

    <?php if (!empty($ratingMessage)): ?>
        <p style="color: green;"><?php echo htmlspecialchars($ratingMessage); ?></p>
    <?php endif; ?>
</body>
</html>

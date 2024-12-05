<?php
session_start();

// Ensure the user is logged in
if (!isset($_SESSION['userID'])) {
    echo "You must log in first.";
    exit;
}

$userID = $_SESSION['userID'];
$songID = isset($_GET['songID']) ? intval($_GET['songID']) : 0;

include('db_connection.php');

// Fetch all playlists for the user
$stmt = $conn->prepare("SELECT playlistID, name FROM Playlist WHERE userID = ?");
$stmt->bind_param("i", $userID);
$stmt->execute();
$playlists = $stmt->get_result();

// Check if the user has any playlists
if ($playlists->num_rows > 0) {
    // Display a form to choose a playlist
    echo "<h1>Select a Playlist to Add the Song</h1>";
    echo "<form method='POST' action='add_to_playlist.php'>";

    while ($playlist = $playlists->fetch_assoc()) {
        echo "<input type='radio' name='playlistID' value='" . $playlist['playlistID'] . "'> " . htmlspecialchars($playlist['name']) . "<br>";
    }

    echo "<input type='hidden' name='songID' value='" . $songID . "'>";
    echo "<button type='submit'>Add to Playlist</button>";
    echo "</form>";
} else {
    echo "No playlists found for this user.";
}
?>

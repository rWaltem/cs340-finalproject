<?php
session_start();

// Ensure the user is logged in
if (!isset($_SESSION['userID'])) {
    echo "You must log in first.";
    exit;
}

$userID = $_SESSION['userID'];
$songID = isset($_POST['songID']) ? intval($_POST['songID']) : 0;
$playlistID = isset($_POST['playlistID']) ? intval($_POST['playlistID']) : 0;

include('db_connection.php');

// Check if the playlistID is valid
if ($playlistID > 0) {
    // Insert the song into the selected playlist
    $insert = $conn->prepare("INSERT INTO Playlist_Song (playlistID, songID) VALUES (?, ?)");
    if ($insert === false) {
        die('MySQL prepare error: ' . $conn->error);
    }

    $insert->bind_param("ii", $playlistID, $songID);
    
    if ($insert->execute()) {
        // Song added successfully, show success message with links to go back to dashboard or view the playlist
        echo "<h1>Song added successfully!</h1>";
        echo "<a href='dashboard.php'>Go back to Dashboard</a><br>";

        // Add a link to view the playlist that the song was added to
        echo "<a href='view_playlist.php?playlistID=" . $playlistID . "'>Go to Playlist</a>";
    } else {
        echo "Error adding song: " . $insert->error;
    }
} else {
    echo "Invalid playlist selected.";
}
?>

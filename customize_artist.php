<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

include('db_connection.php');

// Initialize variables
$artistID = 0;
$artistName = '';
$artistBio = '';
$artistDebutDate = '';
$successMessage = '';
$errorMessage = '';

// Check if the form to search for an artist has been submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['search_artist'])) {
    // Get the artist name to search for
    $searchName = trim($_POST['artistName']);

    // Fetch the artist's details
    $stmt = $conn->prepare("SELECT artistID, name, bio, debutDate FROM Artist WHERE name = ?");
    if ($stmt === false) {
        die("Error preparing statement: " . $conn->error);
    }

    $stmt->bind_param("s", $searchName);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Artist found, populate the form
        $artist = $result->fetch_assoc();
        $artistID = $artist['artistID'];
        $artistName = $artist['name'];
        $artistBio = $artist['bio']; // This can be NULL
        $artistDebutDate = $artist['debutDate'];
    } else {
        $errorMessage = "Artist not found.";
    }

    $stmt->close();
}

// Handle artist update form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_artist']) && $artistID > 0) {
    $newName = trim($_POST['name']);
    $newBio = isset($_POST['bio']) ? trim($_POST['bio']) : NULL; // Handle NULL bio
    $newDebutDate = $_POST['debutDate'];

    // Update artist details in the database
    $updateStmt = $conn->prepare("UPDATE Artist SET name = ?, bio = ?, debutDate = ? WHERE artistID = ?");
    if ($updateStmt === false) {
        die("Error preparing update statement: " . $conn->error);
    }

    $updateStmt->bind_param("sssi", $newName, $newBio, $newDebutDate, $artistID);
    $updateStmt->execute();

    // Check if the update was successful
    if ($updateStmt->affected_rows > 0) {
        $successMessage = "Artist details updated successfully!";
    } else {
        $errorMessage = "No changes were made. Please check the data and try again.";
    }

    $updateStmt->close();
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customize Artist</title>
</head>
<body>
    <a href="admin_options.html">Editing Dashboard</a>
    <h1>Customize Artist</h1>

    <form method="POST" action="">
        <label for="artistName">Enter Artist Name to Edit:</label>
        <input type="text" name="artistName" id="artistName" required>
        <button type="submit" name="search_artist">Search Artist</button>
    </form>

    <?php if (isset($errorMessage)): ?>
        <p style="color: red;"><?php echo htmlspecialchars($errorMessage); ?></p>
    <?php endif; ?>

    <?php if ($artistID > 0): ?>
        <h2>Edit Artist Details</h2>
        <form method="POST" action="">
            <input type="hidden" name="artistID" value="<?php echo $artistID; ?>">

            <label for="name">Artist Name:</label>
            <input type="text" name="name" id="name" value="<?php echo htmlspecialchars($artistName); ?>" required><br><br>

            <label for="bio">Artist Bio:</label>
            <textarea name="bio" id="bio"><?php echo htmlspecialchars($artistBio); ?></textarea><br><br>

            <label for="debutDate">Debut Date:</label>
            <input type="date" name="debutDate" id="debutDate" value="<?php echo $artistDebutDate; ?>" required><br><br>

            <button type="submit" name="update_artist">Update Artist</button>
        </form>
    <?php endif; ?>

    <?php if (isset($successMessage)): ?>
        <p style="color: green;"><?php echo htmlspecialchars($successMessage); ?></p>
    <?php endif; ?>
</body>
</html>

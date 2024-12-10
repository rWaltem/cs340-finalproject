<?php
session_start();

// Redirect if the user is not logged in
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

// Include database connection
include('db_connection.php');

// Initialize variables
$artistID = 0;
$artistName = '';
$artistBio = '';
$artistDebutDate = '';
$successMessage = '';
$errorMessage = '';

// Handle search form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['search_artist'])) {
    $searchName = trim($_POST['artistName']);

    // Fetch the artist's details
    $stmt = $conn->prepare("SELECT artistID, name, bio, debutDate FROM Artist WHERE name LIKE ?");
    if ($stmt) {
        $searchPattern = "%" . $searchName . "%";
        $stmt->bind_param("s", $searchPattern);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $artist = $result->fetch_assoc();
            $artistID = $artist['artistID'];
            $artistName = $artist['name'];
            $artistBio = $artist['bio'] ?? '';
            $artistDebutDate = $artist['debutDate'];
        } else {
            $errorMessage = "No artist found with the name \"$searchName\".";
        }

        $stmt->close();
    } else {
        $errorMessage = "Error preparing search statement.";
    }
}

// Handle update form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_artist']) && !empty($_POST['artistID'])) {
    $artistID = (int)$_POST['artistID'];
    $newName = trim($_POST['name']);
    $newBio = trim($_POST['bio']) ?: null; // Allow NULL bio
    $newDebutDate = $_POST['debutDate'];

    // Update artist details
    $stmt = $conn->prepare("UPDATE Artist SET name = ?, bio = ?, debutDate = ? WHERE artistID = ?");
    if ($stmt) {
        $stmt->bind_param("sssi", $newName, $newBio, $newDebutDate, $artistID);
        $stmt->execute();

        if ($stmt->affected_rows > 0) {
            $successMessage = "Artist details updated successfully!";
        } else {
            $errorMessage = "No changes were made or artist not found.";
        }

        $stmt->close();
    } else {
        $errorMessage = "Error preparing update statement.";
    }
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

    <!-- Search Form -->
    <form method="POST" action="">
        <label for="artistName">Enter Artist Name to Edit:</label>
        <input type="text" name="artistName" id="artistName" required>
        <button type="submit" name="search_artist">Search Artist</button>
    </form>

    <!-- Error Message -->
    <?php if (!empty($errorMessage)): ?>
        <p style="color: red;"><?php echo htmlspecialchars($errorMessage); ?></p>
    <?php endif; ?>

    <!-- Edit Form -->
    <?php if ($artistID > 0): ?>
        <h2>Edit Artist Details</h2>
        <form method="POST" action="">
            <input type="hidden" name="artistID" value="<?php echo $artistID; ?>">

            <label for="name">Artist Name:</label>
            <input type="text" name="name" id="name" value="<?php echo htmlspecialchars($artistName); ?>" required><br><br>

            <label for="bio">Artist Bio:</label>
            <textarea name="bio" id="bio"><?php echo htmlspecialchars($artistBio); ?></textarea><br><br>

            <label for="debutDate">Debut Date:</label>
            <input type="date" name="debutDate" id="debutDate" value="<?php echo htmlspecialchars($artistDebutDate); ?>" required><br><br>

            <button type="submit" name="update_artist">Update Artist</button>
        </form>
    <?php endif; ?>

    <!-- Success Message -->
    <?php if (!empty($successMessage)): ?>
        <p style="color: green;"><?php echo htmlspecialchars($successMessage); ?></p>
    <?php endif; ?>
</body>
</html>

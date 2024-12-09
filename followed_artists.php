<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

include('db_connection.php');

$userID = $_SESSION['userID'];

// Fetch the user's username
$userQuery = $conn->prepare("SELECT username FROM User WHERE userID = ?");
$userQuery->bind_param("i", $userID);
$userQuery->execute();
$userResult = $userQuery->get_result();

if ($userResult->num_rows === 0) {
    die("User not found.");
}

$user = $userResult->fetch_assoc();
$username = $user['username'];
$userQuery->close();

// Handle unfollow actions
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['artistID'])) {
    $artistID = intval($_POST['artistID']);
    $unfollowStmt = $conn->prepare("DELETE FROM User_Follow WHERE userID = ? AND artistID = ?");
    $unfollowStmt->bind_param("ii", $userID, $artistID);
    $unfollowStmt->execute();
    $unfollowStmt->close();
}

// Fetch the list of followed artists
$followedArtistsQuery = "
    SELECT Artist.artistID, Artist.name AS artist_name
    FROM User_Follow
    INNER JOIN Artist ON User_Follow.artistID = Artist.artistID
    WHERE User_Follow.userID = ?
    ORDER BY Artist.name ASC
";
$followedArtistsStmt = $conn->prepare($followedArtistsQuery);
$followedArtistsStmt->bind_param("i", $userID);
$followedArtistsStmt->execute();
$followedArtists = $followedArtistsStmt->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Followed Artists</title>
</head>
<body>
    <a href="dashboard.php">Go back to Dashboard</a>
    <h1><?php echo htmlspecialchars($username); ?>'s Followed Artists</h1>

    <table border="1">
        <tr>
            <th>Artist Name</th>
            <th></th>
        </tr>
        <?php while ($artist = $followedArtists->fetch_assoc()): ?>
            <tr>
                <td>
                    <a href="artist_page.php?artistID=<?php echo $artist['artistID']; ?>">
                        <?php echo htmlspecialchars($artist['artist_name']); ?>
                    </a>
                </td>
                <td>
                    <form method="POST" style="display:inline;">
                        <input type="hidden" name="artistID" value="<?php echo $artist['artistID']; ?>">
                        <button type="submit">Unfollow</button>
                    </form>
                </td>
            </tr>
        <?php endwhile; ?>
    </table>

    <?php if ($followedArtists->num_rows === 0): ?>
        <p>You are not following any artists.</p>
    <?php endif; ?>

    <?php
    // Close the database connections
    $followedArtistsStmt->close();
    $conn->close();
    ?>
</body>
</html>

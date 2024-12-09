<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

include('db_connection.php');

// Call the stored procedure to get album details
$stmt = $conn->prepare("CALL GetAllAlbums()");
$stmt->execute();
$result = $stmt->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>All Albums</title>
</head>
<body>
    <a href="dashboard.php">Go to Dashboard</a>
    <h1>All Albums</h1>

    <table border="1">
        <tr>
            <th>Album Name</th>
            <th>Artist</th>
            <th>Number of Tracks</th>
            <th>Release Date</th>
        </tr>

        <?php while ($album = $result->fetch_assoc()) : ?>
            <tr>
                <td><a href="album_page.php?albumID=<?php echo $album['albumID']; ?>"><?php echo htmlspecialchars($album['album_name']); ?></a></td>
                <td><a href="artist_page.php?artistID=<?php echo $album['artistID']?>"><?php echo htmlspecialchars($album['artist_names']); ?></a></td>
                <td><?php echo htmlspecialchars($album['song_count']); ?></td>
                <td><?php echo htmlspecialchars($album['releaseDate']); ?></td>
            </tr>
        <?php endwhile; ?>

    </table>

    <?php
    // Close the statement
    $stmt->close();
    ?>
</body>
</html>

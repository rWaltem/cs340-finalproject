<?php
session_start();
if (!isset($_SESSION['userID'])) {
    header('Location: login.php');
    exit;
}

include('db_connection.php');

// Call the stored procedure to get all artists' details
$stmt = $conn->prepare("CALL GetAllArtists()");
$stmt->execute();
$result = $stmt->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>All Artists</title>
</head>
<body>
    <a href="dashboard.php">Go to Dashboard</a>
    <h1>All Artists</h1>

    <table border="1">
        <tr>
            <th>Name</th>
            <th>Number of Albums</th>
            <th>Number of Songs</th>
            <th>Debut Date</th>
        </tr>

        <?php while ($artist = $result->fetch_assoc()) : ?>
            <tr>
                <td><a href="artist_page.php?artistID=<?php echo $artist['artistID']?>"><?php echo htmlspecialchars($artist['artist_name']); ?></a></td>
                <td><?php echo htmlspecialchars($artist['album_count']); ?></td>
                <td><?php echo htmlspecialchars($artist['song_count']); ?></td>
                <td><?php echo htmlspecialchars($artist['debut_date']); ?></td>
            </tr>
        <?php endwhile; ?>

    </table>

    <?php
    // Close the statement
    $stmt->close();
    ?>
</body>
</html>

<?php
session_start();
include('db_connection.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    // Prepare and execute query
    $stmt = $conn->prepare("SELECT userID, password FROM User WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        // Compare plain-text passwords
        if ($password === $row['password']) {
            $_SESSION['userID'] = $row['userID'];
            header('Location: dashboard.php');
            exit;
        } else {
            $error = "Invalid password.";
        }
    } else {
        $error = "Username not found.";
    }
    $stmt->close();
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <form method="POST">
        <h2>Login</h2>
        <?php if (!empty($error)) echo "<p style='color:red;'>$error</p>"; ?>
        <label>Username:</label>
        <input type="text" name="username" required>
        <label>Password:</label>
        <input type="password" name="password" required>
        <button type="submit">Login</button>
    </form>
</body>
</html>

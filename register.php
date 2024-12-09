<?php
session_start();
include('db_connection.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = trim($_POST['username']);
    $email = trim($_POST['email']);
    $password = trim($_POST['password']);

    // Check if username or email already exists
    $stmt = $conn->prepare("SELECT userID FROM User WHERE username = ? OR email = ?");
    $stmt->bind_param("ss", $username, $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $error = "Username or email already exists.";
    } else {
        $joinDate = date('Y-m-d H:i:s'); // Get current date and time

        // Insert the new user into the database (storing the password as plain text)
        $stmt = $conn->prepare("INSERT INTO User (username, email, password, joinDate) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $username, $email, $password, $joinDate);
        if ($stmt->execute()) {
            header('Location: login.php'); // Redirect to login page after successful registration
            exit;
        } else {
            $error = "An error occurred. Please try again.";
        }
    }
    $stmt->close();
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
</head>
<body>
    <form method="POST">
        <h2>Create an Account</h2>
        <?php if (!empty($error)) echo "<p style='color:red;'>$error</p>"; ?>
        <label>Username:</label>
        <input type="text" name="username" required>
        <label>Email:</label>
        <input type="email" name="email" required>
        <label>Password:</label>
        <input type="password" name="password" required>
        <button type="submit">Create Account</button>
    </form>
    <p>Already have an account? <a href="login.php">Login here</a>.</p>
</body>
</html>

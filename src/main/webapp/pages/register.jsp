<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="com.car.tuneshift.models.User" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register - TuneShift</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    :root {
      --primary: #FF6B35;
      --dark: #2A2A2A;
      --light: #F8F9FA;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Poppins', sans-serif;
    }

    body {
      background: var(--light);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .navbar {
      padding: 1.5rem 5%;
      background: rgba(255,255,255,0.98);
      box-shadow: 0 2px 15px rgba(0,0,0,0.1);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .logo {
      font-size: 2rem;
      font-weight: 700;
      color: var(--primary);
      text-decoration: none;
    }

    .register-container {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }

    .register-card {
      background: white;
      padding: 3rem;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.1);
      width: 100%;
      max-width: 500px;
      animation: fadeIn 0.5s ease;
    }

    .register-title {
      text-align: center;
      margin-bottom: 2rem;
      color: var(--dark);
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      color: var(--dark);
      font-weight: 500;
    }

    .form-control {
      width: 100%;
      padding: 0.8rem 1rem;
      border: 2px solid #ddd;
      border-radius: 8px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }

    .form-control:focus {
      outline: none;
      border-color: var(--primary);
    }

    .password-strength {
      height: 4px;
      background: #eee;
      border-radius: 2px;
      margin-top: 0.5rem;
      overflow: hidden;
    }

    .strength-bar {
      height: 100%;
      width: 0;
      background: #ff4444;
      transition: all 0.3s ease;
    }

    .btn-primary {
      background: var(--primary);
      color: white;
      padding: 1rem 2rem;
      border: none;
      border-radius: 8px;
      width: 100%;
      font-size: 1rem;
      cursor: pointer;
      transition: transform 0.3s ease;
      margin-top: 1rem;
    }

    .btn-primary:hover {
      transform: translateY(-2px);
    }

    .login-link {
      text-align: center;
      margin-top: 1.5rem;
      color: var(--dark);
    }

    .login-link a {
      color: var(--primary);
      text-decoration: none;
      font-weight: 500;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>

<%
  String error = request.getParameter("error");
  String message = "";
  if (error != null) {
    switch (error) {
      case "empty": message = "All fields are required"; break;
      case "exists": message = "Username already exists"; break;
      case "password_mismatch": message = "Passwords do not match"; break;
      case "io": message = "Registration failed. Please try again."; break;
      default: message = "An unknown error occurred.";
    }
  }
%>
<% if (!message.isEmpty()) { %>
<div style="color: red; margin-bottom: 1rem; text-align: center;">
  <%= message %>
</div>
<% } %>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}" class="logo">TuneShift</a>
</nav>

<div class="register-container">
  <div class="register-card">
    <h2 class="register-title">Create Account</h2>
    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">

      <!-- Full Name -->
      <div class="form-group">
        <label>Full Name</label>
        <input type="text" name="fullName" class="form-control" required placeholder="Enter your full name">
      </div>

      <!-- Email -->
      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" class="form-control" required placeholder="Enter your email address">
      </div>

      <!-- Phone Number -->
      <div class="form-group">
        <label>Phone Number</label>
        <input type="text" name="phone" class="form-control" required placeholder="Enter your phone number">
      </div>

      <!-- Username -->
      <div class="form-group">
        <label>Username</label>
        <input type="text" name="username" class="form-control" required placeholder="Choose a username">
      </div>

      <!-- Password -->
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" id="password" class="form-control" required placeholder="Enter your password" oninput="updateStrength()">
        <div class="password-strength">
          <div class="strength-bar" id="strengthBar"></div>
        </div>
      </div>

      <!-- Confirm Password -->
      <div class="form-group">
        <label>Confirm Password</label>
        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required placeholder="Confirm your password">
      </div>

      <!-- Show Password Toggle -->
      <div class="form-group">
        <input type="checkbox" id="showPassword" onclick="togglePasswordVisibility()"> Show Password
      </div>

      <!-- Submit Button -->
      <button type="submit" class="btn-primary">Register</button>
    </form>

    <!-- Login Link -->
    <p class="login-link">Already have an account? <a href="${pageContext.request.contextPath}/pages/login.jsp">Login here</a></p>
  </div>
</div>

<script>
  function updateStrength() {
    const password = document.getElementById('password').value;
    const strengthBar = document.getElementById('strengthBar');
    const strength = Math.min(password.length * 10, 100);

    strengthBar.style.width = strength + '%';
    strengthBar.style.backgroundColor =
            strength < 40 ? '#ff4444' :
                    strength < 70 ? '#ffc107' : '#00C851';
  }

  function togglePasswordVisibility() {
    const passwordField = document.getElementById('password');
    const confirmPasswordField = document.getElementById('confirmPassword');
    const isChecked = document.getElementById('showPassword').checked;

    if (isChecked) {
      passwordField.type = 'text';
      confirmPasswordField.type = 'text';
    } else {
      passwordField.type = 'password';
      confirmPasswordField.type = 'password';
    }
  }

  // Simple validation for password confirmation
  document.querySelector("form").addEventListener("submit", function(e) {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (password !== confirmPassword) {
      alert("Passwords do not match!");
      e.preventDefault(); // Prevent form submission
    }
  });
</script>

</body>
</html>

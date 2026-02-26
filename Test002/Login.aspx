<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Login | Product Management System</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            /* Rich Gradient Background matching your theme */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        /* The Glass Card Container */
        .login-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
            padding: 40px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.5);
            transition: transform 0.3s ease;
        }

        .login-card:hover {
            transform: translateY(-5px);
        }

        .brand-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin: 0 auto 20px;
            box-shadow: 0 10px 20px rgba(118, 75, 162, 0.3);
        }

        .form-control {
            background: #f4f6f9;
            border: none;
            border-radius: 10px;
            padding: 15px;
            padding-left: 45px; 
            font-size: 0.95rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            background: #fff;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0a5b9;
            transition: color 0.3s;
        }

        .input-group:focus-within .input-icon {
            color: #764ba2;
        }

        .btn-login {
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 1px;
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.3);
            transition: all 0.3s;
        }

        .btn-login:hover {
            transform: scale(1.02);
            box-shadow: 0 8px 20px rgba(118, 75, 162, 0.5);
        }

        .forgot-link {
            color: #a0a5b9;
            font-size: 0.85rem;
            text-decoration: none;
            transition: color 0.3s;
        }
        .forgot-link:hover { color: #764ba2; }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="login-card">
            
            <div class="brand-icon">
                <i class="fas fa-layer-group"></i>
            </div>

            <h3 class="fw-bold mb-1 text-dark">Log In</h3>
            <p class="text-muted small mb-4">Please sign in to continue</p>

            <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3 text-danger fw-bold small"></asp:Label>

            <div class="position-relative mb-3 input-group">
                <i class="fas fa-user input-icon"></i>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username"></asp:TextBox>
            </div>

            <div class="position-relative mb-4 input-group">
                <i class="fas fa-lock input-icon"></i>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="LOGIN" CssClass="btn btn-login w-100 text-white mb-3" OnClick="btnLogin_Click" />

            <div class="d-flex justify-content-between align-items-center mt-3">
                <a href="#" class="forgot-link">Forgot Password?</a>
                <a href="Account/Register.aspx" class="forgot-link fw-bold text-primary">Create Account</a>
            </div>

        </div>

    </form>
</body>
</html>
<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <style>
        /* Card Animation */
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .glass-card:hover {
            transform: translateY(-5px);
        }

        .header-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 20px;
            text-align: center;
            color: white;
        }

        .form-control {
            border-radius: 10px;
            border: 2px solid #eee;
            padding: 12px;
            background: #f9f9f9;
        }

        .form-control:focus {
            border-color: #764ba2;
            box-shadow: none;
            background: #fff;
        }

        .btn-gradient {
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px; 
            padding: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }

        .btn-gradient:hover {
            transform: scale(1.02);
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.4);
        }
    </style>

    <div class="container d-flex justify-content-center align-items-center" style="height: 85vh;">
        
        <div class="glass-card w-100" style="max-width: 450px;">
            
            <div class="header-gradient">
                <h2 class="fw-bold mb-1">Join the Team</h2>
                <p class="mb-0 opacity-75">Create a new access account</p>
            </div>

            <div class="p-5">
                <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-4 text-center fw-bold"></asp:Label>
                
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold text-uppercase">Username</label>
                    <div class="input-group">
                        <span class="input-group-text border-0 bg-transparent ps-0"><i class="fas fa-user text-primary"></i></span>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username" />
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold text-uppercase">Password</label>
                    <div class="input-group">
                        <span class="input-group-text border-0 bg-transparent ps-0"><i class="fas fa-lock text-primary"></i></span>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••" />
                    </div>
                </div>

                <div class="mb-5">
                    <label class="form-label text-muted small fw-bold text-uppercase">Role Assignment</label>
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select form-control">
                        <asp:ListItem Text="Standard User" Value="User" />
                        <asp:ListItem Text="Administrator" Value="Admin" />
                    </asp:DropDownList>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-gradient w-100 text-white" OnClick="btnRegister_Click" />
            </div>

        </div>

    </div>

</asp:Content>
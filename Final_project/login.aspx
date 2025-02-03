<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Final_project.login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .login-container {
            max-width: 400px;
            margin: 0 auto;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            background-color: #ffffff;
            overflow: hidden;
            border-radius: 8px;
        }
        .form-control {
            margin: 0 !important;
        }
        .container {
            padding: 0 15px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-5">
        <h2 class="text-center mb-4">Login</h2>

        <div class="login-container">
            <asp:Login ID="loginUser" runat="server"
                CreateUserText="Criar conta"
                CreateUserUrl="~/create_account.aspx" 
                DestinationPageUrl="~/Main_page.aspx" 
                OnLoggedIn="loginUtilizador_LoggedIn"
                CssClass="w-100">
            </asp:Login>
        </div>
    </div>
</asp:Content>

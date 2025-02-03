<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Edit_profile.aspx.cs" Inherits="Final_project.Utilizadores.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            background-color: #ffffff;
            overflow: hidden;
        }
        .w-45 {
            width: 48%;
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
        <h2 class="text-center mb-4">Editar Perfil</h2>

        <div class="form-container rounded">
            <%-- Name --%>
            <div class="mb-3">
                <label for="TextBoxUsername" class="form-label fw-bold">Nome de Utilizador</label>
                <asp:TextBox runat="server" ID="TextBoxUsername" CssClass="form-control w-100" placeholder="Insira o seu nome" />
                <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="TextBoxUsername" runat="server" Display="Dynamic" ForeColor="#CC0000" CssClass="form-text text-danger" />
            </div>

            <%-- Email --%>
            <div class="mb-3">
                <label for="TextBoxEmail" class="form-label fw-bold">Email</label>
                <asp:TextBox ID="TextBoxEmail" runat="server" CssClass="form-control w-100" placeholder="Insira o seu email" />
                <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="TextBoxEmail" runat="server" Display="Dynamic" ForeColor="#CC0000" CssClass="form-text text-danger" />
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Insira um formato de email válido"
                    ControlToValidate="TextBoxEmail" ForeColor="Red" Operator="DataTypeCheck" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    Display="Dynamic" CssClass="form-text text-danger" />
            </div>

            <%-- Birthday --%>
            <div class="mb-3">
                <label for="TextBoxDate" class="form-label fw-bold">Data de nascimento</label>
                <asp:TextBox ID="TextBoxDate" CssClass="form-control w-100" runat="server" TextMode="Date" />
                <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="TextBoxDate" runat="server" Display="Dynamic" ForeColor="#CC0000" CssClass="form-text text-danger" />
                <asp:CompareValidator ID="validarDataNascimento" runat="server" ControlToValidate="TextBoxDate" CssClass="form-text text-danger" />
            </div>

            <!-- Save and Cancel buttons -->
            <div class="d-flex justify-content-between mt-4">
                <asp:Button ID="ButtonGuardar" runat="server" Text="Guardar" OnClick="Button_guardar_profile" CssClass="btn btn-primary w-45" CausesValidation="false" />
                <asp:Button ID="Button_cancelar" runat="server" Text="Cancelar" OnClick="Button_cancel" CssClass="btn btn-outline-secondary w-45" CausesValidation="false" />
            </div>
        </div>
    </div>
</asp:Content>
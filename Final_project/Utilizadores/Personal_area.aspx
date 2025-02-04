<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Personal_area.aspx.cs" Inherits="Final_project.Utilizadores.Personal_area" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #Button1 {
            margin-left: 0 !important;
        }
        .card-img-top {
            height: 200px;
            object-fit: cover;
        }
        .card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <div class="row g-4">
            <asp:DataList runat="server" ID="listLocais" RepeatColumns="3" RepeatDirection="Horizontal">
                <ItemTemplate>
                    <div class="col-md-4">
                        <div class="card h-100 shadow-sm">
                            <img src='../<%# Eval("PrimeiraFoto") %>' alt='<%# Eval("NomeLocal") %>' class="card-img-top rounded-top" />
                            <div class="card-body text-center">
                                <h5 class="card-title fw-bold"><%# Eval("NomeLocal") %></h5>
                                <asp:LinkButton ID="editLocal" runat="server"
                                    CommandArgument='<%# Eval("LocalID") %>'
                                    OnCommand="Link_details_Command"
                                    CssClass="btn btn-outline-primary mt-3 w-100">
                                    Editar Local
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:DataList>
        </div>

        <div class="text-center mt-5">
            <asp:Button ID="Button1" runat="server" Text="Criar Local" OnClick="Button_create_local" CssClass="btn btn-success px-4 py-2" />
        </div>
    </div>
</asp:Content>

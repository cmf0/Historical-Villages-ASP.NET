<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Personal_area.aspx.cs" Inherits="Final_project.Utilizadores.Personal_area" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #ContentPlaceHolder1_listLocaisAreaPessoal {
            width: 100%;
        }

            #ContentPlaceHolder1_listLocaisAreaPessoal tbody tr {
                display: flex;
                gap: 20px;
                margin-bottom:  20px;
            }

                #ContentPlaceHolder1_listLocaisAreaPessoal tbody tr td {
                    display: flex;
                    flex-direction: column;
                    flex: 1;
                }

        .imagemDataList {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="row">
        <asp:DataList runat="server" ID="listLocaisAreaPessoal" RepeatDirection="Horizontal"
            RepeatColumns="4">
            <ItemTemplate>

                <img src='../<%# Eval("PrimeiraFoto") %>' alt='<%# Eval("NomeLocal") %>' class="imagemDataList" />
                <div class="text-center">
                    <p class="fw-bold d-flex" style="overflow: hidden; height: 80px"><%# Eval("NomeLocal") %></p>
                    <asp:LinkButton ID="editLocal" runat="server"
                        CommandArgument='<%# Eval("LocalID") %>'
                        OnCommand="Link_details_Command"
                        CssClass="btn btn-outline-primary mt-3 w-100">
                                    Editar Local
                                </asp:LinkButton>
                </div>

            </ItemTemplate>
        </asp:DataList>
    </div>

    <div class="text-center mt-5">
        <asp:Button ID="Button1" runat="server" Text="Criar Local" OnClick="Button_create_local" CssClass="btn btn-success px-4 py-2" />
    </div>
</asp:Content>

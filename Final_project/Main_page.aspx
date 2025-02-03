<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Main_page.aspx.cs" Inherits="Final_project.Main_page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        .scrollable-container::-webkit-scrollbar {
            width: 12px; /* width of the entire scrollbar */
            height: 12px;
        }

        .scrollable-container::-webkit-scrollbar-track {
            background: white; /* color of the tracking area */
        }

        .scrollable-container::-webkit-scrollbar-thumb {
            background-color: rgba(0, 0, 0, 0.2); /* color of the scroll thumb */
            border-radius: 20px; /* roundness of the scroll thumb */
            /*border: 3px solid darkgrey;*/ /* creates padding around scroll thumb */
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- First Section: Scrollable Horizontal DataList -->
    <h3>Locais</h3>
    <div class="row text-center scrollable-container" style="overflow-x: auto; padding-bottom: 20px; margin: 0">
        <asp:DataList ID="listLocais" runat="server" DataKeyField="LocalID" RepeatDirection="Horizontal" CssClass="d-flex justify-content-start flex-wrap">
            <ItemTemplate>
                <!-- Card Container -->
                <div class="card mb-3" style="width: 18rem; margin-right: 10px;">

                    <!-- Image Section -->
                    <a href='<%# "Local.aspx?id=" + Eval("LocalID") %>' class="link">
                        <asp:Image ID="Image1" runat="server"
                            ImageUrl='<%# string.IsNullOrEmpty(Convert.ToString(Eval("PrimeiraFoto"))) ? "~/Imagens/placeholder.png" : Eval("PrimeiraFoto") %>'
                            CssClass="card-img-top" Style="object-fit: cover; height: 200px; width: 100%;" />
                    </a>

                    <!-- Location Details Section -->
                    <div class="location-details text-center">
                        <a href='<%# "Local.aspx?id=" + Eval("LocalID") %>' class="link">
                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("NomeLocal") %>' class="card-title" />
                        </a>
                    </div>

                    <!-- Location Info Section -->
                    <div class="location-info text-center mt-2">
                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("Concelho") + ",&#160;&#160;&#160;" + Eval("Distrito") %>' class="card-text" />
                    </div>
                </div>
            </ItemTemplate>
        </asp:DataList>
    </div>

    <!-- Second Section: Top 10 Locais -->
    <h3>Top 10</h3>
    <div class="row mt-4 mt-md-4 text-center scrollable-container" style="overflow-x: auto; flex-wrap:nowrap; padding-bottom: 20px; margin:0;">   
        <asp:Repeater ID="topLocaisRepeater" runat="server" OnItemDataBound="topLocaisRepeater_ItemDataBound">
            <ItemTemplate>
                <!-- Card Container (each card) -->
                <div class="card mb-3" style="width: 18rem; margin-right: 10px;">
                    <!-- Image Section -->
                    <a href='<%# "Local.aspx?id=" + Eval("LocalId") %>' class="link" style="text-decoration: none;">
                        <asp:Image ID="ImageTop" runat="server" ImageUrl='<%# Eval("PrimeiraImagem") %>' CssClass="card-img-top"
                            Style="object-fit: cover; height: 200px; width: 100%;" />
                    </a>
                    <!-- Card Body -->
                    <div class="card-body">
                        <!-- Name Section -->
                        <h5 class="card-title">
                            <asp:Label ID="LabelTopName" runat="server" Text='<%# Eval("LocalNome") %>' class="fs-7" />
                        </h5>
                        <!-- Star Rating Section -->
                        <div class="star-rating text-center mt-2">
                            <asp:Literal ID="LiteralStars" runat="server" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>


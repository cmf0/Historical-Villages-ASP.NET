<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Local.aspx.cs" Inherits="Final_project.Local" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
    <link href="Style/Local.css" rel="stylesheet" />
    <style>
        #mapid {
            height: 400px;
            width: 100%;
        }

        /* Carousel image styles */
        .carousel-item {
            height: 600px; /* Set a fixed height for the carousel items */
        }

            .carousel-item img {
                width: 100%; /* Make the image take up the full width */
                height: 100%; /* Make the image take up the full height */
                object-fit: cover; /* Ensures the image covers the container without distortion */
            }

        /* Carousel container size */
        .carousel-inner {
            min-width: 400px;
            max-height: 600px; /* Ensure the carousel stays within a set height */
            overflow: hidden; /* Hide any overflowed content */
        }

        /* Remove the left margin of the carousel controls */
        .carousel-control-prev, .carousel-control-next {
            margin-left: 0 !important; /* Remove any left margin */
        }

        /* Optional: to adjust if needed */
        .carousel-control-prev {
            margin-right: 0 !important;
        }

        .carousel-control-next {
            margin-left: 0 !important;
        }

        /* Updated styles for centering and justifying description */
        .description-container {
            font-family: 'Times New Roman', Times, serif; /* Optional: Use a serif font for the first letter */
            text-align: justify;
            width: 100%; /* Make it take up 100% of the available space */
            max-width: 900px; /* Increased max-width for more space */
            margin: 0 auto; /* Centers the block */
            padding: 0 15px; /* Optional: Add padding for some spacing around the text */
            line-height: 1.6; /* Makes the text more readable */
            font-size: 18px; /* Optional: increase font size if you want */
        }

            /* First letter capitalization like old scripts */
            .description-container::first-letter {
                font-size: 5em; /* Larger size for the first letter */
                font-weight: bold; /* Optional: make the first letter bold */
                float: left; /* Ensures it floats on the left */
                margin-right: 10px; /* Space between first letter and the rest of the text */
                line-height: 1; /* Prevents the large first letter from affecting line height */
            }
    </style>
    <title>Local</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="d-flex flex-column justify-content-center align-content-center p-4">

        <!-- Carousel -->
        <div id="bs-carousel" class="fade-carousel carousel slide d-flex justify-content-center" data-bs-ride="carousel" data-bs-interval="3000">
            <!-- Carousel items -->
            <div class="carousel-inner w-50">
                <asp:Repeater ID="listLocais" runat="server">
                    <ItemTemplate>
                        <div class="carousel-item <%# Container.ItemIndex == 0 ? "active" : "" %>" id="carousel_fade">
                            <asp:Image CssClass="d-block w-100 Image1" runat="server" ImageUrl='<%# Eval("Ficheiro") %>' Alt='<%# Eval("Legenda") %>' />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <!-- Carousel controls -->
                <button class="carousel-control-prev" type="button" data-bs-target="#bs-carousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="false"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#bs-carousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="false"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>

        <div class="text-center mt-4">
            <asp:Label ID="nameLocal" runat="server" Text="" CssClass="h2"></asp:Label>
            <asp:Label ID="localization" runat="server" Text="" CssClass="h4 text-muted"></asp:Label>
        </div>
    </div>

    <div class="container mt-5">
        <!-- Section Information text -->
        <section class="row">
            <div class="col-md-12">
                <p class="lead description-container">
                    <asp:Label ID="description" runat="server" Text=""></asp:Label>
                </p>
            </div>
        </section>
    </div>

    <hr class="my-5">

    <!-- Section Informações Uteis -->
    <section class="row">
        <div class="col-md-6">
            <h4 class="text-center my-5">Como chegar</h4>
            <div id="map" style="height: 400px" class="w-100 rounded"></div>
        </div>
        <div class="col-md-6">
            <h4 class="text-center my-5">Como vai estar o tempo</h4>
            <div id="forecastContainer" class="text-center"></div>
        </div>
    </section>

    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12">
                <asp:Label ID="description2" runat="server" Text="" CssClass="lead"></asp:Label>
            </div>
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:UpdatePanel ID="updatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="container mt-5">
                <asp:DataList runat="server" ID="listComentarios" CssClass="w-100">
                    <ItemTemplate>
                        <div class="card mb-3">
                            <div class="card-body">
                                <p class="card-text">
                                    <asp:Label ID="comentario" runat="server" Text='<%# Eval("comentario") %>' />
                                </p>
                                <p class="card-text">
                                    <small class="text-muted">
                                        <asp:Label Text='<%# "Classificação - " + Eval("classificacao")?.ToString()%>' runat="server" />
                                        <i class="bi bi-star-fill"></i>
                                    </small>
                                </p>
                                <p class="card-text">
                                    <small class="text-muted">
                                        <asp:Label ID="utilizador" runat="server" Text='<%# Eval("utilizador") %>' />
                                    </small>
                                </p>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:DataList>

                <div class="d-flex justify-content-center my-4">
                    <asp:LinkButton Text="Primeira" runat="server" ID="linkPrimeira" CssClass="btn btn-outline-secondary mx-2" OnClick="linkFirst_click" />
                    <asp:LinkButton Text="Anterior" runat="server" ID="linkAnterior" CssClass="btn btn-outline-secondary mx-2" OnClick="linkPrevious_click" />
                    <asp:LinkButton Text="Seguinte" runat="server" ID="linkSeguinte" CssClass="btn btn-outline-secondary mx-2" OnClick="linkNext_click" />
                    <asp:LinkButton Text="Última" runat="server" ID="linkUltima" CssClass="btn btn-outline-secondary mx-2" OnClick="linkLast_click" />
                </div>

                <div class="my-5" id="divComentario" runat="server">
                    <div class="form-group">
                        <asp:TextBox runat="server" ID="textComentario" CssClass="form-control border-secondary" Height="100" TextMode="MultiLine" placeholder="Escreva o seu comentário..." />
                    </div>
                    <div class="form-group mt-3">
                        <asp:DropDownList ID="listClassificacao" runat="server" CssClass="form-select w-25">
                            <asp:ListItem Text="★" Value="1" />
                            <asp:ListItem Text="★★" Value="2" />
                            <asp:ListItem Text="★★★" Value="3" />
                            <asp:ListItem Text="★★★★" Value="4" />
                            <asp:ListItem Text="★★★★★" Value="5" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group mt-3">
                        <asp:Button Text="Comentar" runat="server" ID="buttonComentar" OnClick="buttonComentar_Click" CssClass="btn btn-primary" />
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:HiddenField ID="hiddenDistritoId" runat="server" Value="" ClientIDMode="Static" />
    <script src="Javascript/tempo.js"></script>
    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
    <script>
        var lat = parseFloat('<%= Latitude %>');
        var lng = parseFloat('<%= Longitude %>');
        var nome = '<%= Nome %>';
        var map = L.map('map').setView([lat, lng], 11);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 15
        }).addTo(map);
        L.marker([lat, lng]).addTo(map)
            .bindPopup(nome)
            .openPopup();
    </script>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Add_local.aspx.cs" Inherits="Final_project.Utilizadores.Add_local" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <h2 class="text-center mb-4">Criar Local</h2>

    <div class="row">
        <div class="col-md-6">
            <div class="mb-3">
                <label for="text_name" class="form-label">Nome</label>
                <asp:TextBox ID="text_name" runat="server" CssClass="form-control" placeholder="Nome do local"></asp:TextBox>
                <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="text_name" runat="server" Display="Dynamic" ForeColor="#CC0000" />
            </div>

            <div class="mb-3">
                <label for="text_description" class="form-label">Descrição</label>
                <asp:TextBox ID="text_description" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Descrição detalhada"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="text_address" class="form-label">Morada</label>
                <asp:TextBox ID="text_address" runat="server" CssClass="form-control" placeholder="Endereço completo"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="text_town" class="form-label">Localidade</label>
                <asp:TextBox ID="text_town" runat="server" CssClass="form-control" placeholder="Cidade ou vila"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label for="list_district" class="form-label">Distrito</label>
                <asp:DropDownList ID="list_district" runat="server" AutoPostBack="true" OnSelectedIndexChanged="listDistrito_SelectedIndexChanged" CssClass="form-select">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="list_district" runat="server" Display="Dynamic" ForeColor="#CC0000" />
            </div>

            <div class="mb-3">
                <label for="list_council" class="form-label">Concelho</label>
                <asp:DropDownList ID="list_council" runat="server" CssClass="form-select"></asp:DropDownList>
                <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="list_council" runat="server" Display="Dynamic" ForeColor="#CC0000" />
            </div>
            <hr />

            <h3 class="text-center mt-4">Fotos do Local</h3>

            <asp:DataList ID="list_photos" runat="server" RepeatDirection="Horizontal" RepeatColumns="3" CellPadding="5" OnItemCommand="list_photos_ItemCommand">
                <ItemTemplate>
                    <div style="border: 1px solid #ccc; padding: 10px; text-align: center;">
                        <asp:Image ID="photoImage" runat="server" ImageUrl='<%# "/" + Eval("Ficheiro") %>' Width="150px" Height="150px" />
                        <br />
                        <asp:Label ID="photoCaption" runat="server" Text='<%# Eval("Legenda") %>'></asp:Label>
                        <br />
                        <asp:Button ID="edit_photo_button" runat="server" CssClass="btn btn-warning" Text="Editar Legenda" OnClick="button_edit_legend" CommandName="Edit" CommandArgument='<%# Eval("Id") %>'/>
                        <asp:Button ID="eliminate_photo_button" runat="server" CssClass="btn btn-danger" Text="Delete" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' />
                    </div>
                </ItemTemplate>
            </asp:DataList>

            <div class="mb-3">
                <label for="photo_upload" class="form-label">Selecionar Foto</label>
                <asp:FileUpload ID="photo_upload" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label for="text_legend" class="form-label">Legenda da Foto</label>
                <asp:TextBox ID="text_legend" runat="server" CssClass="form-control" placeholder="Legenda da imagem"></asp:TextBox>
            </div>

            <div class="d-flex justify-content-evenly">
                <asp:Button ID="save_photo_button" runat="server" CssClass="btn btn-success" Enabled="false" Text="Guardar Foto" OnClick="button_save_photo" />
                <%--<asp:Button ID="edit_photo_button" runat="server" CssClass="btn btn-warning" Enabled="false" Text="Editar Legenda" OnClick="button_edit_legend" />
                <asp:Button ID="eliminate_photo_button" runat="server" CssClass="btn btn-danger" Enabled="false" Text="Eliminar Foto" OnClick="button_eliminate_photo" />--%>
                <asp:Button ID="cancel_everything_button" runat="server" CssClass="btn btn-secondary" Enabled="false" Text="Cancelar Foto" OnClick="clear_fields" />
            </div>
        </div>

        <div class="col-md-6">
            <h4 class="text-center">Localização no Mapa</h4>
            <div id="map" class="rounded shadow" style="height: 400px;"></div>
            <asp:HiddenField ID="latitude" runat="server" />
            <asp:HiddenField ID="longitude" runat="server" />
        </div>
    </div>

    <div class="text-center mt-4">
        <asp:Button ID="save_button" runat="server" CssClass="btn btn-primary px-4" Text="Guardar Local" OnClick="button_save_local" />
        <asp:Button ID="cancel_button" runat="server" CssClass="btn btn-outline-secondary px-4" Text="Cancelar" OnClick="button_cancel" />
    </div>

    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
    <script>
        let mapOptions = {
            center: [39.69484, - 8.13031],
            zoom: 6
        }
        let map = new L.map('map', mapOptions);
        let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
        map.addLayer(layer);
        let marker = null;
        const latitudeField = document.getElementById('<%= latitude.ClientID %>');
        const longitudeField = document.getElementById('<%= longitude.ClientID %>');

        map.on('click', (event) => {
            if (marker != null) {
                map.removeLayer(marker);
            }
            marker = L.marker([event.latlng.lat, event.latlng.lng]).addTo(map);

            // Update the HiddenField values
            if (latitudeField && longitudeField) {
                latitudeField.value = event.latlng.lat;
                longitudeField.value = event.latlng.lng;
            } else {
                console.error('Hidden fields not found');
            }
        });
    </script>

</asp:Content>

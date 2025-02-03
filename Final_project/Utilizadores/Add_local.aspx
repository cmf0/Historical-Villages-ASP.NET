<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Add_local.aspx.cs" Inherits="Final_project.Utilizadores.Add_local" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Page Title -->
    <h2>Criar Local</h2>

    <!-- Form for adding local details -->
    <div class="form-group">
        <label for="text_name">Nome</label>
        <asp:TextBox ID="text_name" runat="server" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="text_name" runat="server" Display="Dynamic" ForeColor="#CC0000" />
    </div>

    <div class="form-group">
        <label for="text_description">Descrição</label>
        <asp:TextBox ID="text_description" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div class="form-group">
        <label for="text_address">Morada</label>
        <asp:TextBox ID="text_address" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div class="form-group">
        <label for="text_town">Localidade</label>
        <asp:TextBox ID="text_town" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div class="form-group">
        <label for="list_district">Distrito</label>
        <asp:DropDownList ID="list_district" runat="server" AutoPostBack="true" OnSelectedIndexChanged="listDistrito_SelectedIndexChanged" CssClass="form-control">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="list_district" InitialValue="Selecione um Distrito" runat="server" Display="Dynamic" ForeColor="#CC0000" />
    </div>

    <div class="form-group">
        <label for="list_council">Concelho</label>
        <asp:DropDownList ID="list_council" runat="server" CssClass="form-control"></asp:DropDownList>
        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="list_council" InitialValue="Selecione um Concelho" runat="server" Display="Dynamic" ForeColor="#CC0000" />
    </div>
    <br />

    <br />
    <!-- Photos Section -->
    <h3>Fotos do Local</h3>

    <asp:DataList ID="list_photos" runat="server" RepeatColumns="2" RepeatDirection="Horizontal" CssClass="row">
        <ItemTemplate>
            <div class="col-md-6">
                <table class="table table-borderless">
                    <tr style="height: 220px; vertical-align: middle;">
                        <td style="text-align: center;">
                            <img src='../<%# Eval("Ficheiro") %>' alt='<%# Eval("Legenda") %>' class="img-fluid" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label Text='<%# Eval("Legenda") %>' runat="server" CssClass="fs-5" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:LinkButton ID="lnkDetalhes" runat="server" CommandArgument='<%# Eval("ID") %>' OnCommand="link_details_Command" CssClass="btn btn-info">Selecionar</asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </div>
        </ItemTemplate>
    </asp:DataList>

    <!-- File upload section -->
    <div class="form-group">
        <label for="photo_upload">Selecionar Foto</label>
        <asp:FileUpload ID="photo_upload" runat="server" CssClass="form-control-file" />
    </div>

    <div class="form-group">
        <label for="text_legend">Legenda</label>
        <asp:TextBox ID="text_legend" runat="server" CssClass="form-control"></asp:TextBox>
    </div>
    <br />
    <!-- Photo action buttons -->
    <div class="form-group">
        <asp:Button ID="save_photo_button" runat="server" class="btn btn-dark" Text="Guardar Foto" OnClick="button_save_photo" />
        <asp:Button ID="edit_photo_button" runat="server" class="btn btn-dark" Text="Editar Legenda" OnClick="button_edit_legend" />
        <asp:Button ID="eliminate_photo_button" runat="server" class="btn btn-dark" Text="Eliminar Foto" OnClick="button_eliminate_photo" />
        <asp:Button ID="cancel_everything_button" runat="server" class="btn btn-dark" Text="Cancelar Tudo" OnClick="button_cancel" />
    </div>

    <tr style="height: 600px; vertical-align: middle;">
        <td style="width: 150px;"></td>
        <td colspan="3" style="text-align: center;">
            <div id="map" style="width: 90%; height: 560px"></div>
            <asp:HiddenField ID="latitude" runat="server" />
            <asp:HiddenField ID="longitude" runat="server" />
        </td>
    </tr>

    <!-- Save and Cancel Buttons -->
    <div class="form-group">
        <asp:Button ID="save_button" runat="server" class="btn btn-primary" Text="Guardar" OnClick="button_save_local" />
        <asp:Button ID="cancel_button" runat="server" class="btn btn-secondary" Text="Cancelar" OnClick="clear_fields" />
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

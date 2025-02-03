<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Edit_local.aspx.cs" Inherits="Final_project.Utilizadores.Edit_local" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Editar Local</h2>

    <!-- Form for creating and editing local details -->
    <div class="form-group">
        <label for="nomeLocal">Localidade</label>
        <asp:TextBox ID="nomeLocal" runat="server" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="nomeLocal" runat="server" Display="Dynamic" ForeColor="#CC0000" />
    </div>

    <div class="form-group">
        <label for="textNome">Nome</label>
        <asp:TextBox ID="textNome" runat="server" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="textNome" runat="server" Display="Dynamic" ForeColor="#CC0000" />
    </div>

    <div class="form-group">
        <label for="textMorada">Morada</label>
        <asp:TextBox ID="textMorada" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div class="form-group">
        <label for="textLocalidade">Localidade</label>
        <asp:TextBox ID="textLocalidade" runat="server" CssClass="form-control"></asp:TextBox>
    </div>

    <div class="form-group">
        <label for="listDistrito">Distrito</label>
        <asp:DropDownList ID="listDistrito" runat="server" AutoPostBack="true" OnSelectedIndexChanged="listDistrito_SelectedIndexChanged" CssClass="form-control">
        </asp:DropDownList>
        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="listDistrito" InitialValue="Selecione um Distrito" runat="server" Display="Dynamic" ForeColor="#CC0000" />
    </div>

    <div class="form-group">
        <label for="listConcelho">Concelho</label>
        <asp:DropDownList ID="listConcelho" runat="server" CssClass="form-control"></asp:DropDownList>
        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="listConcelho" InitialValue="Selecione um Concelho" runat="server" Display="Dynamic" ForeColor="#CC0000" />
    </div>

    <div class="form-group">
        <label for="textDescricao">Descrição</label>
        <asp:TextBox ID="textDescricao" runat="server" CssClass="form-control"></asp:TextBox>
    </div>
    <br />
    <!-- Save and Cancel buttons -->
    <div class="form-group">
        <asp:Button ID="ButtonGuardar" runat="server" Text="Guardar" OnClick="Button_guardar_local" CssClass="btn btn-primary" />
        <asp:Button ID="Button_cancelar" runat="server" Text="Cancelar" OnClick="button_cancel" CssClass="btn btn-secondary" />
        <asp:Button ID="Button_eliminar" runat="server" Text="Eliminar" OnClick="button_delete_local" CssClass="btn btn-danger" />
    </div>
    <br />
    <!-- Photo Management Section -->
    <h3>Gerir Fotos</h3>

    <asp:Repeater ID="listFotos" runat="server" OnItemCommand="listFotos_ItemCommand">
        <HeaderTemplate>
            <table class="table">
                <thead>
                    <tr>
                        <th hidden>ID</th>
                        <th></th>
                        <th>Foto</th>
                        <th>Legenda</th>
                    </tr>
                </thead>
                <tbody>
        </HeaderTemplate>

        <ItemTemplate>
            <tr>
                <td><asp:LinkButton ID="lnkDetalhes" runat="server" CommandArgument='<%# Eval("Id") %>' OnCommand="lnkDetalhes_Command" CssClass="btn btn-info">Selecionar</asp:LinkButton></td>
                <td hidden><%# Eval("Id") %></td>
                <td><img src='<%# ResolveUrl("../" + Eval("Ficheiro").ToString()) %>' alt="Photo" style="width: 100px; height: 100px;" /></td>
                <td><%# Eval("Legenda") %></td>
            </tr>
        </ItemTemplate>

        <FooterTemplate>
                </tbody>
            </table>
        </FooterTemplate>
    </asp:Repeater>

    <div class="form-group">
        <label for="ficheiro">Selecionar Foto</label>
        <asp:FileUpload ID="ficheiro" runat="server" CssClass="form-control-file" />
    </div>

    <div class="form-group">
        <label for="textLegenda">Legenda</label>
        <asp:TextBox ID="textLegenda" runat="server" CssClass="form-control"></asp:TextBox>
    </div>
    <br />

    <!-- Buttons for managing photos -->
    <div class="form-group">
        <asp:Button ID="save_photo_button" runat="server" Text="Guardar Foto" OnClick="button_save_photo" CssClass="btn btn-dark" />
        <asp:Button ID="edit_legenda_button" runat="server" Text="Editar Legenda" OnClick="button_edit_legenda" CssClass="btn btn-dark" />
        <asp:Button ID="eliminate_photo_button" runat="server" Text="Eliminar Foto" OnClick="button_eliminate_photo" CssClass="btn btn-dark" />
        <asp:Button ID="cancel_photo_button" runat="server" Text="Cancelar Tudo" OnClick="button_cancel_photo" CssClass="btn btn-dark" />
    </div>

</asp:Content>

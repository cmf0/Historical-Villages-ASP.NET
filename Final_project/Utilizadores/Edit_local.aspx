<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Edit_local.aspx.cs" Inherits="Final_project.Utilizadores.Edit_local" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container py-4">
        <h2 class="mb-4 text-center">Editar Local</h2>

        <!-- Form Card -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="nomeLocal" class="form-label">Localidade *</label>
                        <asp:TextBox ID="nomeLocal" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="nomeLocal" runat="server" Display="Dynamic" ForeColor="red" />
                    </div>

                    <div class="col-md-6">
                        <label for="textNome" class="form-label">Nome *</label>
                        <asp:TextBox ID="textNome" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="textNome" runat="server" Display="Dynamic" ForeColor="red" />
                    </div>

                    <div class="col-md-6">
                        <label for="textMorada" class="form-label">Morada</label>
                        <asp:TextBox ID="textMorada" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label for="textLocalidade" class="form-label">Localidade</label>
                        <asp:TextBox ID="textLocalidade" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label for="listDistrito" class="form-label">Distrito *</label>
                        <asp:DropDownList ID="listDistrito" runat="server" AutoPostBack="true" OnSelectedIndexChanged="listDistrito_SelectedIndexChanged" CssClass="form-select" />
                        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="listDistrito" InitialValue="Selecione um Distrito" runat="server" Display="Dynamic" ForeColor="red" />
                    </div>

                    <div class="col-md-6">
                        <label for="listConcelho" class="form-label">Concelho *</label>
                        <asp:DropDownList ID="listConcelho" runat="server" CssClass="form-select" />
                        <asp:RequiredFieldValidator ErrorMessage="Obrigatório" ControlToValidate="listConcelho" InitialValue="Selecione um Concelho" runat="server" Display="Dynamic" ForeColor="red" />
                    </div>

                    <div class="col-12">
                        <label for="textDescricao" class="form-label">Descrição</label>
                        <asp:TextBox ID="textDescricao" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Photo Management Section -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-dark text-white">
                <h4 class="mb-0">Gerir Fotos</h4>
            </div>
            <div class="card-body">
                <asp:Repeater ID="listFotos" runat="server" OnItemCommand="listFotos_ItemCommand">
                    <HeaderTemplate>
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Selecionar</th>
                                    <th>Foto</th>
                                    <th>Legenda</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>

                    <ItemTemplate>
                        <tr>
                            <td>
                                <asp:LinkButton ID="lnkDetalhes" runat="server" CommandArgument='<%# Eval("Id") %>' OnCommand="lnkDetalhes_Command" CssClass="btn btn-info btn-sm">Selecionar</asp:LinkButton>
                            </td>
                            <td>
                                <img src='<%# ResolveUrl("../" + Eval("Ficheiro").ToString()) %>' alt="Photo" class="img-thumbnail" style="width: 100px; height: 100px;" />
                            </td>
                            <td><%# Eval("Legenda") %></td>
                        </tr>
                    </ItemTemplate>

                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <div class="mb-3">
                    <label for="ficheiro" class="form-label">Selecionar Foto</label>
                    <asp:FileUpload ID="ficheiro" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label for="textLegenda" class="form-label">Legenda</label>
                    <asp:TextBox ID="textLegenda" runat="server" CssClass="form-control" />
                </div>

                <div class="d-flex gap-2">
                    <asp:Button ID="save_photo_button" runat="server" Text="Guardar Foto" OnClick="button_save_photo" CssClass="btn btn-success" />
                    <asp:Button ID="edit_legenda_button" runat="server" Text="Editar Legenda" OnClick="button_edit_legenda" CssClass="btn btn-warning" />
                    <asp:Button ID="eliminate_photo_button" runat="server" Text="Eliminar Foto" OnClick="button_eliminate_photo" CssClass="btn btn-danger" />
                    <asp:Button ID="cancel_photo_button" runat="server" Text="Cancelar Tudo" OnClick="button_cancel_photo" CssClass="btn btn-secondary" />
                </div>
            </div>
        </div>

        <!-- Save/Cancel Buttons -->
        <div class="d-flex justify-content-between">
            <asp:Button ID="ButtonGuardar" runat="server" Text="Guardar" OnClick="Button_guardar_local" CssClass="btn btn-primary btn-lg" />
            <asp:Button ID="Button_cancelar" runat="server" Text="Cancelar" OnClick="button_cancel" CssClass="btn btn-outline-secondary btn-lg" />
            <asp:Button ID="Button_eliminar" runat="server" Text="Eliminar" OnClick="button_delete_local" CssClass="btn btn-danger btn-lg" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>

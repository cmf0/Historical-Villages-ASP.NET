using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace Final_project.Utilizadores
{
    public partial class Edit_local : System.Web.UI.Page
    {
        private static string connectionString = @"data source=.\sqlexpress; initial catalog = Locais; integrated security=true;";
        SqlConnection connection = new SqlConnection(connectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Local"] == null)
                {
                    Response.Redirect("ErrorPage.aspx"); // Or show an error message
                    return;
                }
                //1 - ler dados do local
                SqlCommand command = new SqlCommand();
                command.Connection = connection;
                command.CommandText = " SELECT L.Nome, L.Morada, L.Localidade, L.Descricao, " +
                 "CAST(L.Concelho AS NVARCHAR), CAST(C.Distrito AS NVARCHAR) " +
                 "FROM Local L JOIN Concelho C ON L.Concelho = C.Id WHERE L.Id = @local";
                command.Parameters.AddWithValue("@local", Session["Local"]);
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                //variáveis a utilizar na seleção do concelho e respetivo distrito
                string idDistrito = "", idConcelho = "";
                while (reader.Read())
                {
                    nomeLocal.Text = reader.GetString(0);
                    textNome.Text = reader.GetString(0);
                    textMorada.Text = reader.GetValue(1)?.ToString() ?? string.Empty;
                    textLocalidade.Text = reader.GetString(2);
                    textDescricao.Text = reader.GetString(3);
                    idConcelho = reader.GetString(4).ToString();
                    idDistrito = reader.GetString(5).ToString();
                }
                reader.Close();
                connection.Close();

                //2 - carregar distritos
                ObterDistritos();
                //selecionar o distrito
                if (listDistrito.Items.FindByValue(idDistrito) != null)
                {
                    listDistrito.SelectedValue = idDistrito;
                    listDistrito_SelectedIndexChanged(null, null); // atualiza os concelhos
                }

                //3 - selecionar o concelho
                if (listConcelho.Items.FindByValue(idConcelho) != null)
                {
                    listConcelho.SelectedValue = idConcelho;
                }

                //4 - carregar as fotos
                GetFotosLocal(Session["Local"].ToString());
                ViewState["idLocal"] = Session["Local"];
            }
        }

        void ObterDistritos()
        {
            using (SqlCommand commandDistritos = new SqlCommand
           ("SELECT Id, Nome FROM Distrito", connection))
            {
                connection.Open();
                SqlDataReader readerDistritos = commandDistritos.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(readerDistritos);
                listDistrito.DataSource = table;
                listDistrito.DataTextField = "Nome";
                listDistrito.DataValueField = "Id";
                listDistrito.DataBind();
                connection.Close();
            }
        }
        void ObterConcelhos(int distrito)
        {
            using (SqlCommand commandConcelhos = new SqlCommand
            ("SELECT Id, Nome FROM Concelho WHERE Distrito = @distrito", connection))
            {
                commandConcelhos.Parameters.AddWithValue("@distrito", distrito);
                connection.Open();
                SqlDataReader reader = commandConcelhos.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                listConcelho.DataSource = table;
                listConcelho.DataTextField = "Nome";
                listConcelho.DataValueField = "Id";
                listConcelho.DataBind();
                connection.Close();
            }
        }
        protected void listDistrito_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedDistrito = int.Parse(listDistrito.SelectedValue);
            ObterConcelhos(selectedDistrito);
        }
        void GetFotosLocal(string local)
        {
            SqlCommand command = new SqlCommand();
            command.Connection = connection;
            command.CommandText =
            "SELECT Id, Ficheiro, Legenda FROM Foto WHERE Local = @local";
            //ID do local
            command.Parameters.AddWithValue("@local", local);
            connection.Open();
            SqlDataReader reader = command.ExecuteReader();
            DataTable table = new DataTable();
            table.Load(reader);
            reader.Close();
            connection.Close();
            listFotos.DataSource = table;
            listFotos.DataBind();
        }

        protected void Button_guardar_local(object sender, EventArgs e)
        {
            SqlCommand command = new SqlCommand();
            command.Connection = connection;
            //definição do Stored Procedure que cria o registo na base de dados
            command.CommandText = "LocalEditar";
            command.CommandType = CommandType.StoredProcedure;
            //definição dos valores a alterar na tabela
            command.Parameters.AddWithValue("@id", Session["Local"]);
            command.Parameters.AddWithValue("@nome", textNome.Text);
            command.Parameters.AddWithValue("@descricao", textDescricao.Text);
            if (textMorada.Text == "")
                command.Parameters.AddWithValue("@morada", DBNull.Value);
            else
                command.Parameters.AddWithValue("@morada", textMorada.Text);
            command.Parameters.AddWithValue("@localidade", textLocalidade.Text);
            command.Parameters.AddWithValue("@concelho", listConcelho.SelectedValue);
            command.Parameters.AddWithValue("@latitude", DBNull.Value);
            command.Parameters.AddWithValue("@longitude", DBNull.Value);
            connection.Open();
            command.ExecuteNonQuery();
            connection.Close();
            Response.Write("<script>alert('Local atualizado com sucesso!');</script>");
        }

        protected void button_save_photo(object sender, EventArgs e)
        {
            // Check if a file has been uploaded
            if (ficheiro.HasFile)
            {
                SqlCommand command = new SqlCommand();
                command.Connection = connection;
                command.CommandText = "LocalFotoCriar";
                command.CommandType = CommandType.StoredProcedure;

                // Validate ViewState["idLocal"]
                if (ViewState["idLocal"] == null || string.IsNullOrEmpty(ViewState["idLocal"].ToString()))
                {
                    Response.Write("<script>alert('Error: Local ID not found. Please try again.');</script>");
                    return;
                }

                // Set parameters for the stored procedure
                command.Parameters.AddWithValue("@local", ViewState["idLocal"].ToString());
                command.Parameters.AddWithValue("@legenda", textLegenda.Text);

                // Validate file extension
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".tiff" };
                string fileExtension = Path.GetExtension(ficheiro.FileName).ToLower();
                if (!allowedExtensions.Contains(fileExtension))
                {
                    Response.Write("<script>alert('Invalid file type. Allowed types: .jpg, .jpeg, .png, .gif, .tiff');</script>");
                    return;
                }

                // Generate a unique file name and save the file
                Guid fileId = Guid.NewGuid();
                string fileName = $"{fileId}-{ficheiro.FileName}";
                string filePath = Server.MapPath("../imagens/") + fileName;
                ficheiro.SaveAs(filePath);

                // Add file path parameter
                command.Parameters.AddWithValue("@ficheiro", "imagens/" + fileName);

                // Execute the command
                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();

                Response.Write("<script>alert('Photo uploaded successfully!');</script>");

                // Refresh the photos list
                GetFotosLocal(ViewState["idLocal"].ToString());
            }
            else
            {
                Response.Write("<script>alert('Please select a file to upload.');</script>");
            }
        }

        protected void lnkDetalhes_Command(object sender,
        System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (e.CommandArgument != null)
            {
                // Ensure that the photo ID is being stored in ViewState correctly
                ViewState["idFoto"] = e.CommandArgument.ToString();

                SqlCommand commandFoto = new SqlCommand();
                commandFoto.Connection = connection;
                commandFoto.CommandText = "SELECT Legenda FROM Foto WHERE Id = @id";
                commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);
                connection.Open();
                SqlDataReader reader = commandFoto.ExecuteReader();
                while (reader.Read())
                {
                    textLegenda.Text = reader[0].ToString();
                }
                reader.Close();
                connection.Close();
            }
        }

        protected void button_edit_legenda(object sender, EventArgs e)
        {
            SqlCommand commandFoto = new SqlCommand();
            commandFoto.Connection = connection;
            commandFoto.CommandText = "UPDATE Foto SET Legenda = @legenda WHERE Id = @id";
            commandFoto.CommandType = CommandType.Text;
            //ID da foto definido quando a foto é selecionada
            commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);
            commandFoto.Parameters.AddWithValue("@legenda", textLegenda.Text);
            connection.Open();
            commandFoto.ExecuteNonQuery();
            connection.Close();
            textLegenda.Text = string.Empty;
            //atualizar DataList fotos do local
            GetFotosLocal(Session["Local"].ToString());
        }

        protected void button_eliminate_photo(object sender, EventArgs e)
        {
            //eliminar ficheiro
            SqlCommand commandFoto = new SqlCommand();
            commandFoto.Connection = connection;
            commandFoto.CommandText = "SELECT Ficheiro FROM Foto WHERE Id = @id";
            //ID da foto definido quando a foto é selecionada
            commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);
            connection.Open();
            //obter nome do ficheiro a eliminar
            SqlDataReader reader = commandFoto.ExecuteReader();
            while (reader.Read())
            {
                string ficheiro = Server.MapPath("../" + reader[0].ToString());
                //eliminar ficheiro
                if (File.Exists(ficheiro))
                    File.Delete(ficheiro);
            }
            reader.Close();
            //eliminar dados na tabela
            commandFoto.Parameters.Clear();
            commandFoto.CommandText = "DELETE Foto WHERE Id = @id";
            commandFoto.CommandType = CommandType.Text;
            commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);
            commandFoto.ExecuteNonQuery();
            connection.Close();
            textLegenda.Text = string.Empty;
            Response.Write("<script>alert('Foto eliminada com sucesso!');</script>");
            //atualizar DataList fotos do local
            GetFotosLocal(Session["Local"].ToString());
        }

        protected void button_delete_local(object sender, EventArgs e)
        {
            //eliminar ficheiros
            //obter nome dos ficheiros a eliminar
            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand commandFotos = new SqlCommand();
            commandFotos.Connection = connection;
            commandFotos.CommandText = "SELECT Ficheiro FROM Foto WHERE Local = @id";
            commandFotos.Parameters.AddWithValue("@id", Session["local"]);
            connection.Open();

            SqlDataReader readerFotos = commandFotos.ExecuteReader();

            while (readerFotos.Read())
            {

                string ficheiro = Server.MapPath("../" + readerFotos[0].ToString());
                //eliminar ficheiro
                if (File.Exists(ficheiro))
                {
                    File.Delete(ficheiro);
                }

            }

            readerFotos.Close();

            //eliminar dados na base de dados

            SqlCommand commandLocal = new SqlCommand();
            commandLocal.Connection = connection;
            commandLocal.CommandText = "LocalEliminar";
            commandLocal.CommandType = CommandType.StoredProcedure;
            commandLocal.Parameters.AddWithValue("@idLocal", Session["local"]);

            commandLocal.ExecuteNonQuery();

            connection.Close();
            Response.Write("<script>alert('Local eliminado!'); window.location='Personal_area.aspx';</script>");
            Response.End();
        }

        protected void button_cancel(object sender, EventArgs e)
        {
            Response.Redirect("Personal_area.aspx");
        }

        protected void button_cancel_photo(object sender, EventArgs e)
        {
            textLegenda.Text = string.Empty;
            //o ficheiro selecionado é removido -
            //o valor do FileUpload não é mantido em ViewState
        }

        protected void listFotos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

        }
    }
}
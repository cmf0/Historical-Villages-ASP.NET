using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Final_project
{
    public partial class Local : System.Web.UI.Page
    {
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string Nome { get; set; }

        private int pagina;
        private static string connectionString = @"data source=.\sqlexpress; initial catalog = Locais; integrated security=true;";
        SqlConnection connection = new SqlConnection(connectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ObterComentarios();
                ViewState["contador"] = 0;

                //mostrar/ocultar DIV que permite comentar
                divComentario.Visible =
                HttpContext.Current.User.Identity.IsAuthenticated && PodeComentar();
                using (SqlConnection connection = new SqlConnection(
                @"data source=.\sqlexpress; initial catalog = Locais; " +
                "integrated security = true;"))
                {
                    // query para obter as fotos
                    string query = "SELECT Id, Legenda, Ficheiro FROM Foto WHERE Local = @id";

                    using (SqlCommand commandFotos = new SqlCommand(query, connection))
                    {
                        commandFotos.Parameters.AddWithValue("@id", Request.QueryString["id"]);
                        SqlDataAdapter adapter = new SqlDataAdapter(commandFotos);
                        DataTable fotos = new DataTable();
                        adapter.Fill(fotos);

                        listLocais.DataSource = fotos;
                        listLocais.DataBind();
                    }

                    // query para obter os dados
                    query = "SELECT L.Nome, L.Descricao, L.Localidade, C.Nome 'Concelho', " +
                    " D.Nome 'Distrito', " +
                    "L.Latitude, L.Longitude " +
                    "FROM Local L JOIN Concelho C ON L.Concelho = C.Id " +
                    "JOIN Distrito D ON C.Distrito = D.Id WHERE L.Id = @id";

                    using (SqlCommand commandDados = new SqlCommand(query, connection))
                    {
                        commandDados.Parameters.AddWithValue("@id",
                        Request.QueryString["id"]);
                        connection.Open();
                        SqlDataReader reader = commandDados.ExecuteReader();
                        while (reader.Read())
                        {
                            nameLocal.Text = "<h4>" + (!reader.IsDBNull(0) ? reader.GetString(0) : "Sem Descrição disponivel") + "</h4>";
                            description.Text = !reader.IsDBNull(1) ? reader.GetString(1) : "Sem Descrição disponivel";

                            string localidade = !reader.IsDBNull(2) ? reader.GetString(2) : "Sem Localidade";
                            string concelho = !reader.IsDBNull(3) ? reader.GetString(3) : "Sem Concelho";
                            string distrito = !reader.IsDBNull(4) ? reader.GetString(4) : "Sem Distrito";

                            localization.Text = $"Localidade: {localidade}<br />Concelho: {concelho}<br />Distrito: {distrito}";

                            Nome = reader[0].ToString();
                            Latitude = reader[5].ToString();
                            Longitude = reader[6].ToString();
                        }
                        reader.Close();

                    }


                    // query para obter o id do distrito
                    query = "SELECT D.Id FROM Local L JOIN Concelho C ON L.Concelho = C.Id " +
                    "JOIN Distrito D ON C.Distrito = D.Id WHERE L.Id = @id";

                    using (SqlCommand commandDistrito = new SqlCommand(query, connection))
                    {
                        commandDistrito.Parameters.AddWithValue("@id", Request.QueryString["id"]);
                        object result = commandDistrito.ExecuteScalar();
                        if (result != null)
                        {
                            hiddenDistritoId.Value = result.ToString();
                        }
                    }
                }

            }

            pagina = (int)ViewState["contador"];
        }

        void ObterComentarios()
        {
            using (SqlCommand commandComentarios = new SqlCommand("LocalComentarios", connection))
            {
                commandComentarios.CommandType = CommandType.StoredProcedure;
                commandComentarios.Parameters.AddWithValue("@local", Request.QueryString["id"]);
                SqlDataReader reader;
                DataTable table = new DataTable();
                connection.Open();
                reader = commandComentarios.ExecuteReader();
                table.Load(reader);
                connection.Close();
                BindListComentarios(table);
                updatePanel1.Update();
            }
        }

        void BindListComentarios(DataTable table)
        {

            PagedDataSource paged = new PagedDataSource();
            paged.DataSource = table.DefaultView;
            paged.PageSize = 5;
            paged.AllowPaging = true;
            paged.CurrentPageIndex = pagina;
            linkPrimeira.Enabled = !paged.IsFirstPage;
            linkAnterior.Enabled = !paged.IsFirstPage;
            linkSeguinte.Enabled = !paged.IsLastPage;
            linkUltima.Enabled = !paged.IsLastPage;
            ViewState["contador"] = paged.PageCount;
            listComentarios.DataSource = paged;
            listComentarios.DataBind();
            ViewState["dataSource"] = table;
        }

        bool PodeComentar()
        {
            //verificar se já comentou
            SqlCommand commandComentarios = new SqlCommand();
            commandComentarios.Connection = connection;
            commandComentarios.CommandText =
            "SELECT COUNT(*) FROM Comentario C JOIN Local L ON C.Local = L.Id " +
            "WHERE C.Utilizador = @utilizador AND L.Id = @local";
            commandComentarios.Parameters.AddWithValue("@utilizador", Session["id_utilizador"]);
            commandComentarios.Parameters.AddWithValue("@local", Request.QueryString["id"]);
            connection.Open();
            int i = (int)commandComentarios.ExecuteScalar();
            connection.Close();
            if (i >= 2)
                return false;
            //verificar se é autor do local
            SqlCommand commandAutorLocal = new SqlCommand();
            commandAutorLocal.Connection = connection;
            commandAutorLocal.CommandText = "SELECT COUNT(*) FROM Local L JOIN Utilizador U " +
            "ON L.Utilizador = U.ID WHERE L.Id = @id AND L.Utilizador = @utilizador";
            commandAutorLocal.Parameters.AddWithValue("@id", Request.QueryString["id"]);
            commandAutorLocal.Parameters.AddWithValue("@utilizador", Session["id_utilizador"]);
            connection.Open();
            i = (int)commandAutorLocal.ExecuteScalar();
            connection.Close();
            if (i > 0)
                return false;
            return true;
        }

        protected void buttonComentar_Click(object sender, EventArgs e)
        {
            SqlCommand command = new SqlCommand();
            command.Connection = connection;
            command.CommandText = "INSERT Comentario(Comentario, Classificacao, Data, " +
            "Local, Utilizador) " + "VALUES (@comentario, @classificacao, @data, @local, @utilizador)";
            command.Parameters.AddWithValue("@comentario", textComentario.Text);
            command.Parameters.AddWithValue("@classificacao", listClassificacao.SelectedValue);
            command.Parameters.AddWithValue("@data", DateTime.Now);
            command.Parameters.AddWithValue("@local", Request.QueryString["id"]);
            command.Parameters.AddWithValue("@utilizador", Session["id_utilizador"]);
            connection.Open();
            command.ExecuteNonQuery();
            connection.Close();
            //ocultar DIV que permite comentar
            divComentario.Visible =
            HttpContext.Current.User.Identity.IsAuthenticated && PodeComentar();
            //atualizar comentários
            ObterComentarios();
        }

        protected void linkFirst_click(object sender, EventArgs e)
        {
            pagina = 0;
            ViewState["contador"] = pagina;
            //GetLocais();
        }

        protected void linkPrevious_click(object sender, EventArgs e)
        {
            pagina = (int)ViewState["contador"];
            pagina -= 1;
            ViewState["contador"] = pagina;
            BindListComentarios((DataTable)ViewState["dataSource"]);
        }

        protected void linkNext_click(object sender, EventArgs e)
        {
            pagina = (int)ViewState["contador"];
            pagina += 1;
            ViewState["contador"] = pagina;
            BindListComentarios((DataTable)ViewState["dataSource"]);
        }

        protected void linkLast_click(object sender, EventArgs e)
        {
            pagina = (int)ViewState["contador"] - 1;
            ViewState["contador"] = pagina;
            BindListComentarios((DataTable)ViewState["dataSource"]);
        }
    }
}
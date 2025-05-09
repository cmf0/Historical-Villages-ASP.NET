﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace Final_project.Utilizadores
{
    public partial class Add_local : System.Web.UI.Page
    {

        private string connectionString = @"data source=.\sqlexpress; initial catalog = Locais; integrated security=true;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                list_council.Items.Insert(0, "Escolha um Distrito primeiro");
                load_distritos();
                ViewState["idLocal"] = 0;
            }
        }



        private void load_distritos()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Nome FROM Distrito ", conn);
                SqlDataReader reader = cmd.ExecuteReader();
                list_district.DataSource = reader;
                list_district.DataTextField = "Nome";
                list_district.DataValueField = "Id";
                list_district.DataBind();

                list_district.Items.Insert(0, "Selecione um Distrito");
            }
        }



        private void load_concelhos(int distritoId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT Id, Nome FROM Concelho " +
                "WHERE Distrito = @DistritoId", conn);
                cmd.Parameters.AddWithValue("@DistritoId", distritoId);
                SqlDataReader reader = cmd.ExecuteReader();
                list_council.DataSource = reader;
                list_council.DataTextField = "Nome";
                list_council.DataValueField = "Id";
                list_council.DataBind();

                list_council.Items.Insert(0, "Selecione um Concelho");
            }
        }



        protected void listDistrito_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (list_district.SelectedValue != "Selecione um Distrito")
            {
                load_concelhos(int.Parse(list_district.SelectedValue));
            }
            else
            {
                list_council.Items.Clear();
                list_council.Items.Insert(0, "Escolha um Distrito primeiro");
            }
        }


        protected void button_save_local(object sender, EventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand();
                command.Connection = connection;
                command.CommandText = "LocalCriar";
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@nome", text_name.Text);
                command.Parameters.AddWithValue("@descricao", text_description.Text);
                if (string.IsNullOrEmpty(text_address.Text))
                    command.Parameters.AddWithValue("@morada", DBNull.Value);
                else
                    command.Parameters.AddWithValue("@morada", text_address.Text);
                command.Parameters.AddWithValue("@localidade", text_town.Text);
                command.Parameters.AddWithValue("@concelho", list_council.SelectedValue);
                command.Parameters.AddWithValue("@utilizador", Session["id_utilizador"]);

                if (latitude.Value == "")
                {



                    //obter latitude e longitude
                    Datum localizacao = new Datum();
                    string key = ConfigurationManager.AppSettings["WeatherApiKey"];
                    string local = $"{text_town.Text},Portugal";
                    WebRequest request = WebRequest.Create

                    ($"https://api.positionstack.com/v1/forward?access_key={key}&query={local}");
                    WebResponse response = request.GetResponse();
                    if (response != null)
                    {
                        Stream stream = response.GetResponseStream();
                        StreamReader reader = new StreamReader(stream);
                        string json = reader.ReadToEnd();
                        Root geoResult = JsonConvert.DeserializeObject<Root>(json);
                        // obter latitude e longitude
                        if (geoResult.Data != null && geoResult.Data.Count > 0)
                        {
                            localizacao = geoResult.Data[0];

                            command.Parameters.AddWithValue("@latitude", localizacao.Latitude ?? (object)DBNull.Value);
                            command.Parameters.AddWithValue("@longitude", localizacao.Longitude ?? (object)DBNull.Value);
                        }
                        else
                        {
                            command.Parameters.AddWithValue("@latitude", DBNull.Value);
                            command.Parameters.AddWithValue("@longitude", DBNull.Value);
                        }
                    }
                }

                else
                {

                    command.Parameters.AddWithValue("@latitude", latitude.Value);
                    command.Parameters.AddWithValue("@longitude", longitude.Value);
                }



                connection.Open();

                // Execute the command and get the new local ID
                object result = command.ExecuteScalar();

                if (result != null)
                {
                    ViewState["idLocal"] = Convert.ToInt32(result);
                    save_photo_button.Enabled = true;
                    //edit_photo_button.Enabled = true;
                    //eliminate_photo_button.Enabled = true;
                    cancel_everything_button.Enabled = true;
                    Response.Write("<script>alert('Local criado com sucesso.');</script>");
                }
                else
                {
                    // Handle the case where the local creation failed
                    Response.Write("<script>alert('Failed to create local.');</script>");
                }


            }
        }

        protected void GetFotosLocal()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand();
                command.Connection = connection;
                command.CommandText = "SELECT Id, Ficheiro, Legenda FROM Foto WHERE Local = @local";

                command.Parameters.AddWithValue("@local", ViewState["idLocal"]);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                reader.Close();

                list_photos.DataSource = table;
                list_photos.DataBind();
            }
        }


        protected void button_save_photo(object sender, EventArgs e)
        {
            if (photo_upload.HasFile)
            {
                if (ViewState["idLocal"] == null || (int)ViewState["idLocal"] == 0)
                {
                    // No local selected - cancel SQL command and show error message
                    Response.Write("<script>alert('Não tem nenhum local selecionado. Caso queira adicionar fotos a locais que tenha adicionado anteriormente " +
                        "por favor faça-o desde a sua área pessoal.');</script>");
                    return;
                }
                else
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        SqlCommand command = new SqlCommand();
                        command.Connection = connection;
                        command.CommandText = "LocalFotoCriar";
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@local", ViewState["idLocal"]);
                        command.Parameters.AddWithValue("@legenda", text_legend.Text);

                        // Types of files allowed
                        string[] ext = { ".jpg", ".jpeg", ".png", ".gif", ".tiff" };
                        bool ok = false;

                        // Get the file extension
                        string extensao = Path.GetExtension(photo_upload.FileName).ToString();

                        // Check if the extension is valid
                        foreach (string item in ext)
                            if (extensao == item)
                                ok = true;

                        if (ok)
                        {
                            // Generates a GUID to stop repeating names
                            Guid g = Guid.NewGuid();
                            string fileName = $"{g}-{photo_upload.FileName}";
                            photo_upload.SaveAs(Server.MapPath("../imagens/") + fileName);

                            command.Parameters.AddWithValue("@ficheiro", "imagens/" + fileName);

                            connection.Open();
                            command.ExecuteNonQuery();

                            Response.Write("<script>alert('Foto adicionada com sucesso.');</script>");

                            // Updates the DataList with the photos from the Local
                            GetFotosLocal();
                        }
                        else
                        {
                            // Invalid file type - cancel SQL command and show error message
                            Response.Write("<script>alert('Selecione um ficheiro do tipo \".jpg\", \".jpeg\", " +
                               "\".png\", \".gif\" ou \".tiff.');</script>");
                            return;
                        }
                    }
                }
            }
            else
            {
                // No photo selected - cancel SQL command and show error message
                Response.Write("<script>alert('Selecione um ficheiro.');</script>");
                return;
            }
        }



        protected void link_details_Command(object sender, System.Web.UI.WebControls.CommandEventArgs e)
        {
            if (e.CommandArgument != null)
            {

                using (SqlConnection connection = new SqlConnection(connectionString))
                {

                    // Puts the photo ID on the viewstate
                    ViewState["idFoto"] = e.CommandArgument.ToString();

                    // Selects the Legenda fro mthe selected photo
                    SqlCommand commandFoto = new SqlCommand();
                    commandFoto.Connection = connection;
                    commandFoto.CommandText = "SELECT Legenda FROM Foto WHERE Id = @id";
                    commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);

                    connection.Open();
                    SqlDataReader reader = commandFoto.ExecuteReader();

                    while (reader.Read())
                    {
                        text_legend.Text = reader[0].ToString();
                    }
                    reader.Close();
                }
            }
        }

        protected void button_edit_legend(object sender, EventArgs e)
        {

            if (ViewState["idFoto"] == null)
            {

                // No photo selected - cancel sql command and show error message
                Response.Write("<script>alert('Selecione uma foto.');</script>");
                return;
            }

            else
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    SqlCommand commandFoto = new SqlCommand();
                    commandFoto.Connection = connection;
                    commandFoto.CommandText = "UPDATE Foto SET Legenda = @legenda WHERE Id = @id";
                    commandFoto.CommandType = CommandType.Text;

                    //ID da foto definido quando a foto é selecionada
                    commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);
                    commandFoto.Parameters.AddWithValue("@legenda", text_legend.Text);
                    connection.Open();
                    commandFoto.ExecuteNonQuery();

                    text_legend.Text = string.Empty;

                    Response.Write("<script>alert('Legenda alterada com sucesso.');</script>");

                    // Updates the DataList with the photos from the Local
                    GetFotosLocal();
                }
            }
        }

        protected void button_eliminate_photo(object sender, EventArgs e)
        {

            if (ViewState["idFoto"] == null)
            {

                // No photo selected - cancel sql command and show error message
                Response.Write("<script>alert('Selecione uma foto.');</script>");
                return;
            }

            else
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // Eliminates the file
                    SqlCommand commandFoto = new SqlCommand();
                    commandFoto.Connection = connection;
                    commandFoto.CommandText = "SELECT Ficheiro FROM Foto WHERE Id = @id";

                    // ID of the photo definited when the photo is selected
                    commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);
                    connection.Open();

                    // Get the name of the file
                    SqlDataReader reader = commandFoto.ExecuteReader();
                    while (reader.Read())
                    {
                        string ficheiro = Server.MapPath("../" + reader[0].ToString());
                        //eliminar ficheiro
                        if (File.Exists(ficheiro))
                            File.Delete(ficheiro);
                    }
                    reader.Close();

                    // Eliminates the data on the databse table
                    commandFoto.Parameters.Clear();
                    commandFoto.CommandText = "DELETE Foto WHERE Id = @id";
                    commandFoto.CommandType = CommandType.Text;
                    commandFoto.Parameters.AddWithValue("@id", ViewState["idFoto"]);
                    commandFoto.ExecuteNonQuery();

                    text_legend.Text = string.Empty;

                    Response.Write("<script>alert('Foto eliminada com sucesso.');</script>");

                    // Updates the DataList with the photos from the Local
                    GetFotosLocal();
                }
            }
        }

        public class Datum
        {
            [JsonProperty("latitude")]
            public double? Latitude { get; set; }

            [JsonProperty("longitude")]
            public double? Longitude { get; set; }

            [JsonProperty("label")]
            public string Label { get; set; }
        }

        public class Root
        {
            [JsonProperty("data")]
            public List<Datum> Data { get; set; }
        }



        protected void clear_fields(object sender, EventArgs e)
        {
            // Limpa o campo da legenda
            text_legend.Text = string.Empty;

            // Limpa o controlo de upload de ficheiro
            // O controlo FileUpload não mantém o ficheiro após o postback,
            // por isso, para "resetá-lo", podemos recarregar a página parcialmente
            photo_upload.Attributes.Clear();

            // Limpa o ID da foto do ViewState, caso uma foto estivesse selecionada
            ViewState["idFoto"] = null;
        }

        protected void list_photos_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                ViewState["idFoto"] = e.CommandArgument.ToString();
                button_edit_legend(this, EventArgs.Empty); // Calls the existing edit method
            }
            else if (e.CommandName == "Delete")
            {
                ViewState["idFoto"] = e.CommandArgument.ToString();
                button_eliminate_photo(this, EventArgs.Empty); // Calls the existing delete method
            }
        }

        protected void button_cancel(object sender, EventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {


                if (ViewState["idLocal"] == null || (int)ViewState["idLocal"] == 0)
                {

                    // No Local selected - clear fields of the page
                    clear_fields(sender, e);
                    return;
                }

                else
                {
                    // Gets the name of the files associated with the Local
                    SqlCommand commandFotos = new SqlCommand();
                    commandFotos.Connection = connection;
                    commandFotos.CommandText = "SELECT Ficheiro FROM Foto WHERE Local = @local";
                    commandFotos.Parameters.AddWithValue("@local", ViewState["idLocal"]);

                    Response.Write("Current idLocal: " + ViewState["idLocal"]?.ToString());

                    connection.Open();
                    SqlDataReader reader = commandFotos.ExecuteReader();
                    while (reader.Read())
                    {
                        string file = Server.MapPath("../" + reader[0].ToString());
                        // Eleminates the file
                        if (File.Exists(file))
                            File.Delete(file);
                    }
                    reader.Close();

                    // Eliminates the data from the database tables
                    SqlCommand commandLocal = new SqlCommand();
                    commandLocal.Connection = connection;
                    commandLocal.CommandText = "LocalEliminar";
                    commandLocal.CommandType = CommandType.StoredProcedure;


                    if (ViewState["idLocal"] == null)
                    {
                        Response.Write("Error: idLocal is null");
                        return;
                    }
                    else
                    {
                        Response.Write("Current idLocal: " + ViewState["idLocal"]?.ToString());
                        commandLocal.Parameters.AddWithValue("@idlocal", ViewState["idLocal"]);
                        commandLocal.ExecuteNonQuery();
                        ViewState["idLocal"] = null;
                    }
                }
            }
        }

    }
}
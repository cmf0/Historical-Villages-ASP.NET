using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Final_project.Utilizadores
{ 
    public partial class WebForm1 : System.Web.UI.Page
    {
        string connectionString = @"data source=.\Sqlexpress; initial catalog = Locais; integrated security = true;";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Populate the fields with the current values if it's the first load
                getDadosUtilizador();
            }
            
            
        }

        protected void getDadosUtilizador()
        {
            string username = User.Identity.Name;
            string email = "";
            string data_nascimento = "";
            string id = "";
            using (SqlConnection connection = new SqlConnection(
            @"data source=.\Sqlexpress; initial catalog = Locais; integrated security = true;"))
            {
                using (SqlCommand command = new SqlCommand())
                {
                    command.Connection = connection;
                    command.CommandText = "SELECT * FROM Utilizador WHERE Nome = @user_name";
                    command.Parameters.AddWithValue("@user_name", username);
                    connection.Open();
                    SqlDataReader reader;
                    reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        id = reader[0].ToString();
                        username = reader[1].ToString();
                        email = reader[2].ToString();
                        data_nascimento = reader[3].ToString();
                    }
                    connection.Close();
                }
            }
            TextBoxUsername.Text = username;
            TextBoxEmail.Text = email;
            // Parse and format the date
            if (DateTime.TryParse(data_nascimento, out DateTime parsedDate))
            {
                TextBoxDate.Text = parsedDate.ToString("yyyy-MM-dd");
            }
            else
            {
                TextBoxDate.Text = ""; // Optional: handle invalid date
            }
        }

        protected void Button_guardar_profile(object sender, EventArgs e)
        {

            string username = TextBoxUsername.Text;
            string email = TextBoxEmail.Text;
            string dataNascimento = TextBoxDate.Text; // Will be in yyyy-MM-dd format
            string userId = Session["id_utilizador"].ToString(); // You might need to retrieve or store the user's ID

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        // Update user data in Utilizadores table
                        using (SqlCommand command = new SqlCommand(@"
                            UPDATE Utilizador
                            SET Nome = @username, Email = @Email, DataNascimento = @DataNascimento
                            WHERE Id = @Id", connection, transaction))
                        {
                            command.Parameters.AddWithValue("@username", username);
                            command.Parameters.AddWithValue("@Email", email);
                            command.Parameters.AddWithValue("@DataNascimento", DateTime.Parse(dataNascimento));
                            command.Parameters.AddWithValue("@Id", userId);

                            int rowsAffected = command.ExecuteNonQuery();

                            if (rowsAffected == 0)
                            {
                                throw new Exception("No rows updated in Utilizador table. Check the provided data.");
                            }
                        }

                        // Update user email in Memberships table
                        using (SqlCommand command = new SqlCommand(@"
                            UPDATE Memberships
                            SET Email = @Email
                            WHERE UserId = @Id", connection, transaction))
                        {
                            command.Parameters.AddWithValue("@Email", email);
                            command.Parameters.AddWithValue("@Id", userId);

                            int rowsAffected = command.ExecuteNonQuery();


                            if (rowsAffected == 0)
                            {
                                throw new Exception("No rows updated in Memberships table. Check the provided data.");
                            }
                        }

                        // Update user username in Users table
                        using (SqlCommand command = new SqlCommand(@"
                            UPDATE Users
                            SET UserName = @UserName
                            WHERE UserId = @Id", connection, transaction))
                        {
                            command.Parameters.AddWithValue("@UserName", username);
                            command.Parameters.AddWithValue("@Id", userId);

                            int rowsAffected = command.ExecuteNonQuery();

                            if (rowsAffected == 0)
                            {
                                throw new Exception("No rows updated in Users table. Check the provided data.");
                            }
                        }

                        // Commit transaction if all updates succeed
                        transaction.Commit();
                        // Register the alert message and redirect after it's shown
                        string script = "alert('Dados alterados com sucesso! Por favor inicie sessão de novo.'); window.location = '/login.aspx';";
                        ClientScript.RegisterStartupScript(this.GetType(), "Redirect", script, true);

                        // Sign out the user from the Forms Authentication
                        FormsAuthentication.SignOut();

                        // Abandon the session 
                        Session.Abandon();

                    }
                    catch (Exception ex)
                    {
                        // Roll back transaction if any update fails
                        transaction.Rollback();
                        Response.Write($"<script>alert('Error: {ex.Message}');</script>");
                    }
                }
            }
        }

        protected void Button_cancel(object sender, EventArgs e)
        {
            Response.Redirect("~/Main_page.aspx");
        }

    }
}
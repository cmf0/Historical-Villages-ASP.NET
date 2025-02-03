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
    public partial class Main_page : System.Web.UI.Page
    {
        private int currentPage;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetTop10Locais();
                GetLocais();
                ViewState["contador"] = 0;
            }

            currentPage = (int)ViewState["contador"];
        }

        void GetTop10Locais()
        {
            // Create a new connection to the database
            SqlConnection connection = new SqlConnection(@"data source=.\sqlexpress; initial catalog=Locais; integrated security=true;");

            // Call the GetTop10Locais stored procedure
            SqlCommand command = new SqlCommand("GetTop10Locais", connection);
            command.CommandType = CommandType.StoredProcedure;

            connection.Open();
            SqlDataReader reader = command.ExecuteReader();

            // Check if there are any results
            if (reader.HasRows)
            {
                // Bind the results to the Repeater control
                topLocaisRepeater.DataSource = reader;
                topLocaisRepeater.DataBind();
            }
            else
            {
                // Handle cases where no locals are found
                topLocaisRepeater.Visible = false; // Optionally hide the repeater if no data
            }

            connection.Close();
        }


        void GetLocais()
        {
            SqlConnection connection = new SqlConnection
            (@"data source=.\sqlexpress; initial catalog = Locais; integrated security=true;");

            SqlCommand command = new SqlCommand();
            command.CommandText = "GetLocais";
            command.CommandType = CommandType.StoredProcedure;

            command.Connection = connection;
            SqlDataReader reader;
            DataTable table = new DataTable();
            connection.Open();
            reader = command.ExecuteReader();
            table.Load(reader);
            connection.Close();
            BindListLocais(table);
        }

        void BindListLocais(DataTable table)
        {
            PagedDataSource paged = new PagedDataSource();
            paged.DataSource = table.DefaultView;
            //paged.PageSize = 6;
            //paged.AllowPaging = true;
            paged.CurrentPageIndex = currentPage;

            //linkFirst.Enabled = !paged.IsFirstPage;
            //linkPrevious.Enabled = !paged.IsFirstPage;
            //linkNext.Enabled = !paged.IsLastPage;
            //linkLast.Enabled = !paged.IsLastPage;

            ViewState["total"] = paged.PageCount;
            listLocais.DataSource = paged;
            listLocais.DataBind();
            ViewState["dataSource"] = table;
        }


        //protected void linkFirst_click(object sender, EventArgs e)
        //{
        //    currentPage = 0;
        //    ViewState["contador"] = currentPage;
        //    GetLocais();
        //}

        //protected void linkPrevious_click(object sender, EventArgs e)
        //{
        //    currentPage = (int)ViewState["contador"];
        //    currentPage -= 1;
        //    ViewState["contador"] = currentPage;
        //    BindListLocais((DataTable)ViewState["dataSource"]);
        //}

        //protected void linkNext_click(object sender, EventArgs e)
        //{
        //    currentPage = (int)ViewState["contador"];
        //    currentPage += 1;
        //    ViewState["contador"] = currentPage;
        //    BindListLocais((DataTable)ViewState["dataSource"]);
        //}

        //protected void linkLast_click(object sender, EventArgs e)
        //{
        //    currentPage = (int)ViewState["total"] - 1;
        //    ViewState["contador"] = currentPage;
        //    BindListLocais((DataTable)ViewState["dataSource"]);
        //}
        protected void topLocaisRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Retrieve the MediaClassificacao value (assumes decimal in database)
                decimal classification = Convert.ToDecimal(DataBinder.Eval(e.Item.DataItem, "MediaClassificacao"));

                Console.WriteLine(classification);

                // Generate stars dynamically
                string starsHtml = "";
                for (int i = 1; i <= 5; i++)
                {
                    if (i <= Math.Floor(classification))
                    {
                        // Full star
                        starsHtml += "<i class=\"bi bi-star-fill\"></i>";
                    }
                    else if (i == Math.Ceiling(classification) && classification % 1 != 0)
                    {
                        // Half star
                        starsHtml += "<i class=\"bi bi-star-half\"></i>";
                    }
                    else
                    {
                        // Empty star
                        starsHtml += "<i class=\"bi bi-star\"></i>";
                    }
                }

                // Find the Literal control and set the generated stars
                Literal literalStars = (Literal)e.Item.FindControl("LiteralStars");
                if (literalStars != null)
                {
                    literalStars.Text = starsHtml;
                }
            }
        }

    }
}
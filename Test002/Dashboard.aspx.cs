using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Dashboard : System.Web.UI.Page
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }

        if (!IsPostBack)
        {
            LoadStats();
        }
    }

    void LoadStats()
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            try
            {
                con.Open();

                // 1. Count Total Products
                SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM Products", con);
                int count = (int)cmd1.ExecuteScalar();
                lblTotalProducts.Text = count.ToString();

                // 2. Total Inventory Value 
                SqlCommand cmd2 = new SqlCommand("SELECT ISNULL(SUM(Price * Quantity), 0) FROM Products", con);
                decimal totalValue = (decimal)cmd2.ExecuteScalar();
                lblTotalValue.Text = totalValue.ToString("C"); // Formats as Currency ($)

                // 3. Low Stock Items if Less than 10 units
                SqlCommand cmd3 = new SqlCommand("SELECT COUNT(*) FROM Products WHERE Quantity < 10", con);
                int lowStock = (int)cmd3.ExecuteScalar();
                lblLowStock.Text = lowStock.ToString();
            }
            catch (Exception ex)
            {
                // If something goes wrong, just show 0
                lblTotalProducts.Text = "0";
                lblTotalValue.Text = "$0.00";
                lblLowStock.Text = "0";
            }
        }
    }
}
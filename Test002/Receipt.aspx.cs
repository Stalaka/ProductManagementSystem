using System;
using System.Configuration;
using System.Data.SqlClient;

public partial class Receipt : System.Web.UI.Page
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (Request.QueryString["id"] != null)
        {
            int saleId = Convert.ToInt32(Request.QueryString["id"]);
            LoadReceiptData(saleId);
        }
        else
        {
            
            Response.Redirect("Sales.aspx");
        }
    }

    void LoadReceiptData(int saleId)
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            
            string query = "SELECT s.SaleId, pr.ProductName, s.Quantity, s.UnitPrice, s.TotalAmount, s.CustomerName, s.SaleDate " +
                           "FROM Sales s " +
                           "INNER JOIN Products pr ON s.ProductId = pr.ProductId " +
                           "WHERE s.SaleId = @id";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@id", saleId);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                
                lblReceiptId.Text = "INV-" + rdr["SaleId"].ToString().PadLeft(5, '0'); 
                lblDate.Text = Convert.ToDateTime(rdr["SaleDate"]).ToString("dd MMM yyyy, HH:mm");

                string customer = rdr["CustomerName"].ToString();
                lblCustomer.Text = string.IsNullOrEmpty(customer) ? "Walk-in Customer" : customer;

                lblProduct.Text = rdr["ProductName"].ToString();
                lblQty.Text = rdr["Quantity"].ToString();

                
                lblPrice.Text = Convert.ToDecimal(rdr["UnitPrice"]).ToString("N0");
                lblTotal.Text = Convert.ToDecimal(rdr["TotalAmount"]).ToString("N0");
            }
        }
    }
}
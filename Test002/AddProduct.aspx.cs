using System;
using System.Configuration;
using System.Data.SqlClient;

public partial class AddProduct : System.Web.UI.Page
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                
                string query = "INSERT INTO Products (ProductName, Category, Price, Quantity, Description) VALUES (@name, @cat, @price, @qty, @desc)";
                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@name", txtName.Text);
                cmd.Parameters.AddWithValue("@cat", txtCategory.Text);
                cmd.Parameters.AddWithValue("@price", Convert.ToDecimal(txtPrice.Text));
                cmd.Parameters.AddWithValue("@qty", Convert.ToInt32(txtQty.Text));

                
                string description = string.IsNullOrEmpty(txtDescription.Text) ? "" : txtDescription.Text;
                cmd.Parameters.AddWithValue("@desc", description);

                con.Open();
                cmd.ExecuteNonQuery();

              
                lblMessage.Text = "Product Added Successfully!";
                lblMessage.CssClass = "text-success fw-bold";

                
                txtName.Text = "";
                txtCategory.Text = "";
                txtPrice.Text = "";
                txtQty.Text = "";
                txtDescription.Text = "";
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = "Error: " + ex.Message;
            lblMessage.CssClass = "text-danger fw-bold";
        }
    }
}
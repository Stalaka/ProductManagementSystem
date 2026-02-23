using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Sales : System.Web.UI.Page
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null) Response.Redirect("~/Login.aspx");
        if (!IsPostBack)
        {
            LoadProductsDropdown();
            LoadSalesGrid();
        }
    }

    void LoadProductsDropdown()
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT ProductId, ProductName FROM Products ORDER BY ProductName ASC", con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            ddlProducts.DataSource = dt;
            ddlProducts.DataTextField = "ProductName";
            ddlProducts.DataValueField = "ProductId";
            ddlProducts.DataBind();
            ddlProducts.Items.Insert(0, new ListItem("-- Select Product --", "0"));
        }
    }

    void LoadSalesGrid()
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            // UPDATED: Now grabs Rating and CustomerReview for the star ratings!
            string query = "SELECT s.SaleId, pr.ProductName, s.Quantity, s.UnitPrice, s.TotalAmount, s.CustomerName, s.SaleDate, s.Status, s.CustomerFeedback, s.Rating, s.CustomerReview " +
                           "FROM Sales s " +
                           "INNER JOIN Products pr ON s.ProductId = pr.ProductId " +
                           "ORDER BY s.SaleDate DESC";

            SqlDataAdapter da = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvSales.DataSource = dt;
            gvSales.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (ddlProducts.SelectedIndex == 0) throw new Exception("Please select a product.");
            if (string.IsNullOrWhiteSpace(txtQuantity.Text) || string.IsNullOrWhiteSpace(txtPrice.Text)) throw new Exception("Please enter quantity and price.");

            int productId = Convert.ToInt32(ddlProducts.SelectedValue);
            int qtyToSell = Convert.ToInt32(txtQuantity.Text);
            decimal price = Convert.ToDecimal(txtPrice.Text);
            string customer = txtCustomer.Text.Trim();

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmdCheck = new SqlCommand("SELECT Quantity FROM Products WHERE ProductId = @id", con);
                cmdCheck.Parameters.AddWithValue("@id", productId);

                object stockResult = cmdCheck.ExecuteScalar();
                int currentStock = stockResult != null ? Convert.ToInt32(stockResult) : 0;

                if (qtyToSell > currentStock) throw new Exception("Not enough stock! You only have " + currentStock + " left in inventory.");

                // Set status to 'Completed' on new sales
                string query = "INSERT INTO Sales (ProductId, Quantity, UnitPrice, CustomerName, SaleDate, Status) " +
                               "VALUES (@pid, @qty, @price, @cust, GETDATE(), 'Completed')";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@pid", productId);
                cmd.Parameters.AddWithValue("@qty", qtyToSell);
                cmd.Parameters.AddWithValue("@price", price);
                cmd.Parameters.AddWithValue("@cust", customer);
                cmd.ExecuteNonQuery();
            }

            LoadSalesGrid();
            ClientScript.RegisterStartupScript(this.GetType(), "Pop", "$('#saleModal').modal('hide'); showToast('Sale Recorded!', true);", true);

            txtQuantity.Text = "1";
            txtPrice.Text = "";
            txtCustomer.Text = "";
            ddlProducts.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            string cleanMsg = ex.Message.Replace("'", "").Replace("\r", "").Replace("\n", " ");
            ClientScript.RegisterStartupScript(this.GetType(), "Error", "$('#saleModal').modal('hide'); showToast('Error: " + cleanMsg + "', false);", true);
        }
    }

    protected void gvSales_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvSales.PageIndex = e.NewPageIndex;
        LoadSalesGrid();
    }
}
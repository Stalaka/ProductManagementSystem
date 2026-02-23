using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Purchases : System.Web.UI.Page
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
            LoadProductsDropdown();
            LoadPurchasesGrid();
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

    void LoadPurchasesGrid()
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
          
            string query = "SELECT p.PurchaseId, pr.ProductName, p.Quantity, p.UnitPrice, p.TotalAmount, p.Supplier, p.PurchaseDate " +
                           "FROM Purchases p " +
                           "INNER JOIN Products pr ON p.ProductId = pr.ProductId " +
                           "ORDER BY p.PurchaseDate DESC";

            SqlDataAdapter da = new SqlDataAdapter(query, con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvPurchases.DataSource = dt;
            gvPurchases.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            if (ddlProducts.SelectedIndex == 0) throw new Exception("Please select a product.");

            int productId = Convert.ToInt32(ddlProducts.SelectedValue);
            int qty = Convert.ToInt32(txtQuantity.Text);
            decimal price = Convert.ToDecimal(txtPrice.Text);
            string supplier = txtSupplier.Text;

            using (SqlConnection con = new SqlConnection(cs))
            {
                
                string query = "INSERT INTO Purchases (ProductId, Quantity, UnitPrice, Supplier, PurchaseDate) " +
                               "VALUES (@pid, @qty, @price, @sup, GETDATE())";

                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@pid", productId);
                cmd.Parameters.AddWithValue("@qty", qty);
                cmd.Parameters.AddWithValue("@price", price);
                cmd.Parameters.AddWithValue("@sup", supplier);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadPurchasesGrid();

            
            string script = "$('#purchaseModal').modal('hide'); showToast('Purchase Recorded Successfully!', true);";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", script, true);

            
            txtQuantity.Text = "1";
            txtPrice.Text = "";
            txtSupplier.Text = "";
            ddlProducts.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            
            string cleanMsg = ex.Message.Replace("'", "").Replace("\r", "").Replace("\n", " ");
            string script = "$('#purchaseModal').modal('hide'); showToast('Error: " + cleanMsg + "', false);";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Error", script, true);
        }
    }

    protected void gvPurchases_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvPurchases.PageIndex = e.NewPageIndex;
        LoadPurchasesGrid();
    }
}
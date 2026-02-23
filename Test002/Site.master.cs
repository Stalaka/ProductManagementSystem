using System;
using System.IO;
using System.Web.Security;

public partial class Site : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string currentPage = Request.Url.AbsolutePath.ToLower();

        
        if (currentPage.Contains("login.aspx") || currentPage.Contains("register.aspx"))
            return;

        if (Session["username"] == null || Session["role"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        
        if (!IsPostBack)
        {
            ApplyUserPermissions();
        }
    }

    private void ApplyUserPermissions()
    {
       
        string role = Session["role"].ToString();

        if (role == "Admin")
        {
            // You are the boss. You see everything.
        }
        else if (role == "Supplier")
        {
            // Suppliers only need to see what they sold to you (Purchases)
            lnkInventory.Visible = false;
            lnkSales.Visible = false;
            lnkAddProduct.Visible = false;
            lnkRegister.Visible = false;
        }
        else if (role == "Customer")
        {
            // Customers only need to see what they bought from you (Sales/Receipts)
            lnkInventory.Visible = false;
            lnkPurchases.Visible = false;
            lnkAddProduct.Visible = false;
            lnkRegister.Visible = false;
        }
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        FormsAuthentication.SignOut();
        Response.Redirect("~/Login.aspx");
    }
}
using System;

public partial class ViewProducts : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (Session["username"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
    }
}
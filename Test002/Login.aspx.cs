using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Security;

public partial class Login : System.Web.UI.Page
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            
            string query = "SELECT Role FROM Users WHERE Username=@user AND Password=@pass";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@pass", txtPassword.Text.Trim());

            try
            {
                con.Open();

                
                object roleResult = cmd.ExecuteScalar();

                
                if (roleResult != null)
                {
                    string userRole = roleResult.ToString(); 

                    
                    FormsAuthentication.SetAuthCookie(txtUsername.Text.Trim(), false);
                    Session["username"] = txtUsername.Text.Trim();

                    
                    Session["role"] = userRole;

                   
                    Response.Redirect("~/Dashboard.aspx");
                }
                else
                {
                    lblMessage.Text = "Invalid username or password.";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
            }
        }
    }
}
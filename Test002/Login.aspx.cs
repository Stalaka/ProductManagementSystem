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

            string query = "SELECT Password, Role FROM Users WHERE Username=@user";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());

            try
            {
                con.Open();

                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        string storedPassword = rdr["Password"].ToString();
                        string userrole = rdr["Role"].ToString();

                        if (!PasswordHasher.VerifyPassword(txtPassword.Text.Trim(), storedPassword))
                        {
                            lblMessage.Text = "Invalid username or password.";

                            return;
                        }

                        //Auto-upgrade legacy plain-text passwords to hashed format on successful login
                        if (!PasswordHasher.IsHashedValue(storedPassword))
                        {
                            UpgradePasswordHash(txtUsername.Text.Trim(), txtPassword.Text.Trim());
                        }

                        FormsAuthentication.SetAuthCookie(txtUsername.Text.Trim(), false);
                        Session["username"] = txtUsername.Text.Trim();

                        Session["role"] = userrole;

                        Response.Redirect("~/Dashboard.aspx");
                            }
                    else
                        lblMessage.Text = "Invalid username or password.";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
            }
        }
    }

    private void UpgradePasswordHash(string username, string plainPassword)
    {
        string hashedPassword = PasswordHasher.HashPassword(plainPassword);

        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();
            string query = "UPDATE Users SET Password=@pass WHERE Username=@user";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@pass", hashedPassword);
            cmd.Parameters.AddWithValue("@user", username);
            cmd.ExecuteNonQuery();
        }
    }
}
using System;
using System.Configuration;
using System.Data.SqlClient;

public partial class Register : System.Web.UI.Page
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        // 1. Check if inputs are empty
        if (string.IsNullOrWhiteSpace(txtUsername.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
        {
            lblMsg.Text = "Please fill in all fields.";
            lblMsg.CssClass = "alert alert-warning";
            return;
        }

        using (SqlConnection con = new SqlConnection(cs))
        {
            // 2. Insert into database
            string query = "INSERT INTO Users (Username, Password, Role) VALUES (@user, @pass, @role)";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@user", txtUsername.Text.Trim());
            cmd.Parameters.AddWithValue("@pass", txtPassword.Text.Trim());
            cmd.Parameters.AddWithValue("@role", ddlRole.SelectedValue);

            try
            {
                con.Open();
                cmd.ExecuteNonQuery();

                // 3. Success message
                lblMsg.Text = "User registered successfully!";
                lblMsg.CssClass = "alert alert-success";

                // 4. Clear form
                txtUsername.Text = "";
                txtPassword.Text = "";
            }
            catch (Exception ex)
            {
                // 5. Error handling
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "alert alert-danger";
            }
        }
    }
}
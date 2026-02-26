<%@ Application Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="System.Web.Http" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // This MUST be the first line!
        GlobalConfiguration.Configure(WebApiConfig.Register);

        try
        {
            PasswordMigrationResult migration = PasswordMigration.UpgradeAllPlainTextPasswords();
            System.Diagnostics.Debug.WriteLine("Password migration completed. Total=" + migration.TotalUsers
                + ", Upgraded=" + migration.Upgraded
                + ", AlreadyHashed=" + migration.AlreadyHashed
                + ", SkippedEmpty=" + migration.SkippedEmpty
                + ", NotUpdated=" + migration.NotUpdated);
        }
        catch (Exception ex)
        {
            
            System.Diagnostics.Debug.WriteLine("Password migration failed during Application_Start: " + ex.Message);
        }
    }

</script>
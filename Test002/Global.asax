<%@ Application Language="C#" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="System.Web.Http" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // This MUST be the first line!
        GlobalConfiguration.Configure(WebApiConfig.Register);
    }

</script>
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

public partial class Dashboard : System.Web.UI.Page
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    
    public string DatesJson { get; set; }
    public string RevenueJson { get; set; }
    public string ProductNamesJson { get; set; }
    public string ProductQtyJson { get; set; }

    // Initialize the variables in the constructor
    public Dashboard()
    {
        DatesJson = "[]";
        RevenueJson = "[]";
        ProductNamesJson = "[]";
        ProductQtyJson = "[]";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null) Response.Redirect("~/Login.aspx");
        if (!IsPostBack)
        {
            LoadMetricCards();
            LoadChartData();
        }
    }

    void LoadMetricCards()
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            // 1. Total Revenue (Completed Sales Only)
            SqlCommand cmdRev = new SqlCommand("SELECT ISNULL(SUM(TotalAmount), 0) FROM Sales WHERE Status = 'Completed'", con);
            // 2. Total Items Sold
            SqlCommand cmdSold = new SqlCommand("SELECT ISNULL(SUM(Quantity), 0) FROM Sales WHERE Status = 'Completed'", con);
            // 3. Total Remaining Inventory
            SqlCommand cmdInv = new SqlCommand("SELECT ISNULL(SUM(Quantity), 0) FROM Products", con);
            // 4. Total Refunds Processed
            SqlCommand cmdRef = new SqlCommand("SELECT COUNT(SaleId) FROM Sales WHERE Status = 'Refunded'", con);

            con.Open();
            lblRevenue.Text = Convert.ToDecimal(cmdRev.ExecuteScalar()).ToString("N0") + " KES";
            lblSold.Text = cmdSold.ExecuteScalar().ToString();
            lblInventory.Text = cmdInv.ExecuteScalar().ToString();
            lblRefunds.Text = cmdRef.ExecuteScalar().ToString();
        }
    }

    void LoadChartData()
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            
            string queryLine = @"
                SELECT TOP 7 CONVERT(varchar, SaleDate, 107) AS DateStr, SUM(TotalAmount) as DailyRev 
                FROM Sales 
                WHERE Status = 'Completed' 
                GROUP BY CONVERT(varchar, SaleDate, 107), CAST(SaleDate as Date)
                ORDER BY CAST(SaleDate as Date) ASC";

            SqlDataAdapter daLine = new SqlDataAdapter(queryLine, con);
            DataTable dtLine = new DataTable();
            daLine.Fill(dtLine);

            StringBuilder dates = new StringBuilder("[");
            StringBuilder revs = new StringBuilder("[");
            foreach (DataRow row in dtLine.Rows)
            {
                
                dates.Append("'" + row["DateStr"].ToString() + "',");
                revs.Append(row["DailyRev"].ToString() + ",");
            }
            if (dtLine.Rows.Count > 0) { dates.Length--; revs.Length--; } 
            dates.Append("]"); revs.Append("]");

            DatesJson = dates.ToString();
            RevenueJson = revs.ToString();

            
            string queryPie = @"
                SELECT TOP 5 p.ProductName, SUM(s.Quantity) as TotalQty 
                FROM Sales s 
                INNER JOIN Products p ON s.ProductId = p.ProductId 
                WHERE s.Status = 'Completed' 
                GROUP BY p.ProductName 
                ORDER BY TotalQty DESC";

            SqlDataAdapter daPie = new SqlDataAdapter(queryPie, con);
            DataTable dtPie = new DataTable();
            daPie.Fill(dtPie);

            StringBuilder pNames = new StringBuilder("[");
            StringBuilder pQtys = new StringBuilder("[");
            foreach (DataRow row in dtPie.Rows)
            {
               
                pNames.Append("'" + row["ProductName"].ToString().Replace("'", "\\'") + "',");
                pQtys.Append(row["TotalQty"].ToString() + ",");
            }
            if (dtPie.Rows.Count > 0) { pNames.Length--; pQtys.Length--; } 
            pNames.Append("]"); pQtys.Append("]");

            ProductNamesJson = pNames.ToString();
            ProductQtyJson = pQtys.ToString();
        }
    }
}
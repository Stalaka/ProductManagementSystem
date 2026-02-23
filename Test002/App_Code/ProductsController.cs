using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Net.Http;
using System.Web.Http;

public class ProductsController : ApiController
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    // 1. GET ALL PRODUCTS
    [Route("api/products")]
    [HttpGet]
    public IHttpActionResult GetProducts()
    {
        List<Product> productList = new List<Product>();
        using (SqlConnection con = new SqlConnection(cs))
        {
            try
            {
                con.Open();
                string query = "SELECT ProductId, ProductName, Category, Price, Quantity, Description FROM Products ORDER BY ProductId DESC";
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    productList.Add(new Product
                    {
                        ProductId = Convert.ToInt32(rdr["ProductId"]),
                        ProductName = rdr["ProductName"].ToString(),
                        Category = rdr["Category"].ToString(),
                        Price = Convert.ToDecimal(rdr["Price"]),
                        Quantity = Convert.ToInt32(rdr["Quantity"]),
                        Description = rdr["Description"] == DBNull.Value ? "" : rdr["Description"].ToString()
                    });
                }
                return Ok(productList);
            }
            catch (Exception ex)
            {
                return InternalServerError(new Exception("Error fetching products: " + ex.Message));
            }
        }
    }

    // 2. UPDATE PRODUCT
    [Route("api/products/{id}")]
    [HttpPut]
    public IHttpActionResult UpdateProduct(int id, Product p)
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            try
            {
                con.Open();
                string query = "UPDATE Products SET ProductName=@name, Category=@cat, Price=@price WHERE ProductId=@id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@name", p.ProductName);
                cmd.Parameters.AddWithValue("@cat", p.Category);
                cmd.Parameters.AddWithValue("@price", p.Price);
                cmd.Parameters.AddWithValue("@id", id);

                int rows = cmd.ExecuteNonQuery();

                if (rows == 0) return NotFound();
                return Ok();
            }
            catch (Exception ex)
            {
                return InternalServerError(new Exception("Error updating product: " + ex.Message));
            }
        }
    }

    // 3. DELETE PRODUCT
    [Route("api/products/{id}")]
    [HttpDelete]
    public IHttpActionResult DeleteProduct(int id)
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            try
            {
                con.Open();
                string query = "DELETE FROM Products WHERE ProductId = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);

                int rows = cmd.ExecuteNonQuery();

                if (rows == 0) return NotFound();
                return Ok();
            }
            catch (Exception ex)
            {
                return InternalServerError(new Exception("Error deleting product: " + ex.Message));
            }
        }
    }

    // ==========================================
    // 4. DELETE PURCHASE (Fixes the Typos!)
    // ==========================================
    [Route("api/purchases/{id}")]
    [HttpDelete]
    public IHttpActionResult DeletePurchase(int id)
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            try
            {
                con.Open();
                string query = "DELETE FROM Purchases WHERE PurchaseId = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);

                int rows = cmd.ExecuteNonQuery();

                if (rows == 0) return NotFound();
                return Ok();
            }
            catch (Exception ex)
            {
                return InternalServerError(new Exception("Error deleting purchase: " + ex.Message));
            }
        }
    }

    // ==========================================
    // 5. UPDATE SALE (The Blue Pen)
    // ==========================================
    [Route("api/sales/{id}")]
    [HttpPut]
    public IHttpActionResult UpdateSale(int id, SaleData s)
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            try
            {
                con.Open();
                // Note: We don't update TotalAmount here because your SQL Database calculates it automatically!
                string query = "UPDATE Sales SET Quantity=@qty, UnitPrice=@price, CustomerName=@cust WHERE SaleId=@id";
                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@qty", s.Quantity);
                cmd.Parameters.AddWithValue("@price", s.UnitPrice);
                // The ?? "" prevents errors if the customer name is left blank
                cmd.Parameters.AddWithValue("@cust", s.CustomerName ?? "");
                cmd.Parameters.AddWithValue("@id", id);

                int rows = cmd.ExecuteNonQuery();

                if (rows == 0) return NotFound();
                return Ok();
            }
            catch (Exception ex)
            {
                return InternalServerError(new Exception("Error updating sale: " + ex.Message));
            }
        }
    }

    // ==========================================
    // 6. DELETE SALE (The Red Bin)
    // ==========================================
    [Route("api/sales/{id}")]
    [HttpDelete]
    public IHttpActionResult DeleteSale(int id)
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            try
            {
                con.Open();
                string query = "DELETE FROM Sales WHERE SaleId = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);

                int rows = cmd.ExecuteNonQuery();

                if (rows == 0) return NotFound();
                return Ok();
            }
            catch (Exception ex)
            {
                return InternalServerError(new Exception("Error deleting sale: " + ex.Message));
            }
        }
    }
} 
public class SaleData
{
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public string CustomerName { get; set; }
}
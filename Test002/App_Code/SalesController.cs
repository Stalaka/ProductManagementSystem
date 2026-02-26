using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web.Http;

public class SaleUpdateDto
{
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public string CustomerName { get; set; }
}

public class RefundRequestDto
{
    public int SaleId { get; set; }
    public string Feedback { get; set; }
}

public class SalesController : ApiController
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    // ==========================================
    // PUT: api/sales/{id} -> EDITS A SALE
    // ==========================================
    public IHttpActionResult Put([FromUri] int id, [FromBody] SaleUpdateDto data)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand getOldSale = new SqlCommand("SELECT ProductId, Quantity FROM Sales WHERE SaleId = @id", con);
                getOldSale.Parameters.AddWithValue("@id", id);

                int productId = 0;
                int oldQuantity = 0;

                using (SqlDataReader reader = getOldSale.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        productId = Convert.ToInt32(reader["ProductId"]);
                        oldQuantity = Convert.ToInt32(reader["Quantity"]);
                    }
                    else return NotFound();
                }

                int quantityDifference = oldQuantity - data.Quantity;
                SqlCommand updateStock = new SqlCommand("UPDATE Products SET Quantity = Quantity + @diff WHERE ProductId = @pid", con);
                updateStock.Parameters.AddWithValue("@diff", quantityDifference);
                updateStock.Parameters.AddWithValue("@pid", productId);
                updateStock.ExecuteNonQuery();

                string updateQuery = "UPDATE Sales SET Quantity = @qty, UnitPrice = @price, TotalAmount = (@qty * @price), CustomerName = @cust WHERE SaleId = @id";
                SqlCommand cmd = new SqlCommand(updateQuery, con);
                cmd.Parameters.AddWithValue("@qty", data.Quantity);
                cmd.Parameters.AddWithValue("@price", data.UnitPrice);
                cmd.Parameters.AddWithValue("@cust", string.IsNullOrWhiteSpace(data.CustomerName) ? (object)DBNull.Value : data.CustomerName);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();

                return Ok();
            }
        }
        catch (Exception ex)
        {
            // UPGRADED: Using Debug.WriteLine
            System.Diagnostics.Debug.WriteLine("Edit Error: " + ex.Message);
            return Content(System.Net.HttpStatusCode.InternalServerError, ex.Message);
        }
    }

    // ==========================================
    // POST: api/sales -> REFUNDS A SALE
    // ==========================================
    public IHttpActionResult Post([FromBody] RefundRequestDto data)
    {
        try
        {
            if (data == null) return BadRequest("Invalid request payload.");
            int id = data.SaleId;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand getSale = new SqlCommand("SELECT ProductId, Quantity, Status FROM Sales WHERE SaleId = @id", con);
                getSale.Parameters.AddWithValue("@id", id);

                int productId = 0;
                int quantitySold = 0;
                string currentStatus = "";

                using (SqlDataReader reader = getSale.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        productId = Convert.ToInt32(reader["ProductId"]);
                        quantitySold = Convert.ToInt32(reader["Quantity"]);
                        currentStatus = reader["Status"] != DBNull.Value ? reader["Status"].ToString() : "Completed";
                    }
                    else return NotFound();
                }

                if (currentStatus == "Refunded") return BadRequest("Already refunded.");

                SqlCommand updateStock = new SqlCommand("UPDATE Products SET Quantity = Quantity + @qty WHERE ProductId = @pid", con);
                updateStock.Parameters.AddWithValue("@qty", quantitySold);
                updateStock.Parameters.AddWithValue("@pid", productId);
                updateStock.ExecuteNonQuery();

                string feedback = !string.IsNullOrWhiteSpace(data.Feedback) ? data.Feedback : "No feedback provided";

                SqlCommand refundCmd = new SqlCommand("UPDATE Sales SET Status = 'Refunded', CustomerFeedback = @feedback WHERE SaleId = @id", con);
                refundCmd.Parameters.AddWithValue("@id", id);
                refundCmd.Parameters.AddWithValue("@feedback", feedback);
                refundCmd.ExecuteNonQuery();

                return Ok();
            }
        }
        catch (Exception ex)
        {
            // UPGRADED: Using Debug.WriteLine
            System.Diagnostics.Debug.WriteLine("Refund Error: " + ex.Message);
            return Content(System.Net.HttpStatusCode.InternalServerError, ex.Message);
        }
    }

    // ==========================================
    // DELETE: api/sales/{id} -> PERMANENT DELETE
    // ==========================================
    public IHttpActionResult Delete([FromUri] int id)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand getSale = new SqlCommand("SELECT ProductId, Quantity, Status FROM Sales WHERE SaleId = @id", con);
                getSale.Parameters.AddWithValue("@id", id);

                int productId = 0;
                int quantitySold = 0;
                string currentStatus = "";

                using (SqlDataReader reader = getSale.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        productId = Convert.ToInt32(reader["ProductId"]);
                        quantitySold = Convert.ToInt32(reader["Quantity"]);
                        currentStatus = reader["Status"] != DBNull.Value ? reader["Status"].ToString() : "Completed";
                    }
                    else return NotFound();
                }

                if (currentStatus != "Refunded")
                {
                    SqlCommand updateStock = new SqlCommand("UPDATE Products SET Quantity = Quantity + @qty WHERE ProductId = @pid", con);
                    updateStock.Parameters.AddWithValue("@qty", quantitySold);
                    updateStock.Parameters.AddWithValue("@pid", productId);
                    updateStock.ExecuteNonQuery();
                }

                SqlCommand deleteCmd = new SqlCommand("DELETE FROM Sales WHERE SaleId = @id", con);
                deleteCmd.Parameters.AddWithValue("@id", id);
                deleteCmd.ExecuteNonQuery();

                return Ok();
            }
        }
        catch (Exception ex)
        {
            // UPGRADED: Using Debug.WriteLine
            System.Diagnostics.Debug.WriteLine("Delete Error: " + ex.Message);
            return Content(System.Net.HttpStatusCode.InternalServerError, ex.Message);
        }
    }
}
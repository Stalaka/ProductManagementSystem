using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Http;

public class ReviewController : ApiController
{
    string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;

    // POST: api/Review?id=1&rating=5&text=Great
    [HttpPost]
    public IHttpActionResult Post(int id, int rating, string text = "")
    {
        try
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Save the Star Rating and the Customer's written review
                string query = "UPDATE Sales SET Rating = @rating, CustomerReview = @text WHERE SaleId = @id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@rating", rating);
                cmd.Parameters.AddWithValue("@text", string.IsNullOrWhiteSpace(text) ? (object)DBNull.Value : text);
                cmd.Parameters.AddWithValue("@id", id);

                cmd.ExecuteNonQuery();

                return Ok();
            }
        }
        catch (Exception ex)
        {
            return InternalServerError(ex);
        }
    }
}
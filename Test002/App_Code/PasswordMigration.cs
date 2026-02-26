using System;
using System.Configuration;
using System.Data.SqlClient;

public static class PasswordMigration
{
    public static PasswordMigrationResult UpgradeAllPlainTextPasswords()
    {
        string cs = ConfigurationManager.ConnectionStrings["ProductDBConnection"].ConnectionString;
        return UpgradeAllPlainTextPasswords(cs);
    }

    public static PasswordMigrationResult UpgradeAllPlainTextPasswords(string connectionString)
    {
        PasswordMigrationResult result = new PasswordMigrationResult();

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            con.Open();

            string selectQuery = "SELECT UserId, Password FROM Users";
            using (SqlCommand selectCmd = new SqlCommand(selectQuery, con))
            using (SqlDataReader reader = selectCmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    result.TotalUsers++;

                    int userId = Convert.ToInt32(reader["UserId"]);
                    string passwordValue = Convert.ToString(reader["Password"]);

                    if (string.IsNullOrWhiteSpace(passwordValue))
                    {
                        result.SkippedEmpty++;
                        continue;
                    }

                    string normalizedValue = passwordValue.Trim();
                    if (PasswordHasher.IsHashedValue(normalizedValue))
                    {
                        result.AlreadyHashed++;
                        continue;
                    }

                    string hashedPassword = PasswordHasher.HashPassword(normalizedValue);
                    if (UpdatePasswordByUserId(con, userId, hashedPassword))
                        result.Upgraded++;
                    else
                        result.NotUpdated++;
                }
            }
        }

        return result;
    }

    private static bool UpdatePasswordByUserId(SqlConnection con, int userId, string hashedPassword)
    {
        string updateQuery = "UPDATE Users SET Password=@pass WHERE UserId=@userId";

        using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
        {
            updateCmd.Parameters.AddWithValue("@pass", hashedPassword);
            updateCmd.Parameters.AddWithValue("@userId", userId);
            return updateCmd.ExecuteNonQuery() > 0;
        }
    }
}

public class PasswordMigrationResult
{
    public int TotalUsers { get; set; }
    public int AlreadyHashed { get; set; }
    public int Upgraded { get; set; }
    public int SkippedEmpty { get; set; }
    public int NotUpdated { get; set; }
}
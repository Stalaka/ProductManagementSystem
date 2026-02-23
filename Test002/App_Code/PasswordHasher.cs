using System;
using System.Security.Cryptography;

public static class PasswordHasher
{
    private const int SaltSize = 16;
    private const int KeySize = 32;
    private const int Iterations = 100000;
    private const string FormatMarker = "PBKDF2";

    public static string HashPassword(string password)
    {
        if (string.IsNullOrWhiteSpace(password))
            throw new ArgumentException("Password cannot be empty.", "password");

        byte[] salt = new byte[SaltSize];
        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(salt);
        }

        byte[] hash;
        using (var derive = new Rfc2898DeriveBytes(password, salt, Iterations))
        {
            hash = derive.GetBytes(KeySize);
        }

        return string.Join("$",
            FormatMarker,
            Iterations,
            Convert.ToBase64String(salt),
            Convert.ToBase64String(hash));
    }

    public static bool VerifyPassword(string password, string storedValue)
    {
        if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(storedValue))
            return false;

        if (!storedValue.StartsWith(FormatMarker + "$", StringComparison.Ordinal))
            return password == storedValue;

        string[] parts = storedValue.Split('$');
        if (parts.Length != 4)
            return false;

        int iterations;
        if (!int.TryParse(parts[1], out iterations))
            return false;

        byte[] salt;
        byte[] expectedHash;

        try
        {
            salt = Convert.FromBase64String(parts[2]);
            expectedHash = Convert.FromBase64String(parts[3]);
        }
        catch (FormatException)
        {
            return false;
        }

        byte[] actualHash;
        using (var derive = new Rfc2898DeriveBytes(password, salt, iterations))
        {
            actualHash = derive.GetBytes(expectedHash.Length);
        }

        return FixedTimeEquals(actualHash, expectedHash);
    }

    public static bool IsHashedValue(string storedValue)
    {
        return !string.IsNullOrEmpty(storedValue) && storedValue.StartsWith(FormatMarker + "$", StringComparison.Ordinal);
    }

    private static bool FixedTimeEquals(byte[] a, byte[] b)
    {
        if (a == null || b == null || a.Length != b.Length)
            return false;

        int diff = 0;
        int i;
        for (i = 0; i < a.Length; i++)
        {
            diff |= a[i] ^ b[i];
        }

        return diff == 0;
    }
}
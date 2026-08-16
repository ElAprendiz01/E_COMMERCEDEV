using System;
using System.Collections.Generic;
using System.Text;


namespace APLICATION.Interfaces
{
    public interface IJwtService
    {
        string GenerarToken(int userId, string userEmail, string userFullName);
    }
}
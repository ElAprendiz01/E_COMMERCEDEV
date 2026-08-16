using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Data.SqlClient;

namespace INFRASTRUCTURE.DB
{
    public class DBconexionfactory
    {
        private readonly string _connectionString;

        public DBconexionfactory(string connectionString)
        {
            _connectionString = connectionString;
        }
        public SqlConnection CreateConnection()
        {
            return new SqlConnection(_connectionString);
        }
    }
}

#include "demo.h"
#include "sqlite3.h"
#include <iostream>



using namespace std;

class SQL {
	public:
	
	int Run(const char *query, const char *dbName = "Sqlite_Test.db") 
	{
		int rt = 0;
		try 
		{
			//Testing 
			//throw std::logic_error( "Test exception handling" );
			
			sqlite3 *db;
			char *szErrMsg = 0;

			// open database
			int rc = sqlite3_open(dbName, &db);

			if(rc)
			{
				std::cout << "Can't open database\n";
			} else {
				std::cout << "Open database successfully\n";
			}

			rc = sqlite3_exec(db, query, this->callback, 0, &szErrMsg);
			
						
			if(rc != SQLITE_OK)
			{
				std::cout << "SQL Error: " << szErrMsg << std::endl;
				sqlite3_free(szErrMsg);
			}

			// close database
			if(db)
			{
				sqlite3_close(db);
			}
		}catch(...)
		{
			rt = 1;
		}
	  	return rt;
	}
	
	// This is the callback function to display the select data in the table
	static int callback(void *NotUsed, int argc, char **argv, char **szColName)
	{
		for(int i = 0; i < argc; i++)
		{
			std::cout << szColName[i] << " = " << argv[i] << std::endl;
		}

		std::cout << "\n";

		return 0;
	}
	
};


int main(){
	SQL sql;
	return sql.Run("SELECT * FROM Employee");
}
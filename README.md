#SQL-Server-Tools
* sp_ColumnsInATable - Lists the columns in a table in a comma delimited list. Useful to copy and paste to a select or insert statement.
* sp_CreateForeignKey - Given a primary table, primary key, foreign table, foreign key, output the sql to create the foreign key.
* sp_CreateUserDefinedType - Helps deal with issues of user defined types such as not being able to update it because it's being used.
** CREATE - Drop/Creates a new user defined type. Only works if no proc is using it.
** LIST - Lists all the procedures using this user defined type.
** DROP - Drops the type IF it's not being used.
** KILL - Drops the type AND all procs using it.
** ALTER - Drops all the procs using it, drops the type, creates the new type, then recreates the new procedures.
** FORCE - Similar to ALTER, except:
*** 1. ALTER will fail if the change would cause a stored proc to fail to compile.
*** 2. If this user defined type would cause a proc to not compile, FORCE drops that proc, then lists it.
* sp_DropColumn - Alter table drop column doesn't work if it has a constraint. This finds and drops the constraints too.
* sp_Find - Searches all databases for a column, table, or procedure name containing the text you are searching for.
* sp_FindColumn - Searches all databases for a column name containing the text you are searching for. If you give it two parameters, both strings are used.
* sp_FindInAllProcs - Searches all databases in all procedures for the text you specified. If you specify two parameters, both are used. A good use for this is to search for a table name and the word insert.
* sp_FindInProc - Searches the current databases in all procedures for the text you specified. If you specify two parameters, both are used. A good use for this is to search for a table name and the word insert.
* sp_List - Lists a stored procedure if an exact match is found to what you passed in. Otherwise, lists stored procedures containing that string.
* sp_varinsp - Searches a stored procedure you specify for a text string you specify. Recursively searches all the procedures this procedure calls also. Will output a tree diagram of where the text is in and how to traverse there in the stored procedure heirarchy.

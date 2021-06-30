#SQL-Server-Tools
<ul>
  <li>sp_ColumnsInATable - Lists the columns in a table in a comma delimited list. Useful to copy and paste to a select or insert statement.</li>
  <li>sp_CreateForeignKey - Given a primary table, primary key, foreign table, foreign key, output the sql to create the foreign key.</li>
  <li>sp_CreateUserDefinedType - Helps deal with issues of user defined types such as not being able to update it because it's being used. 6 actions are available:
  <ol><li>CREATE - Drop/Creates a new user defined type. Only works if no proc is using it.</li>
    <li>LIST - Lists all the procedures using this user defined type.</li>
    <li>DROP - Drops the type IF it's not being used.</li>
    <li>KILL - Drops the type AND all procs using it.</li>
    <li>ALTER - Drops all the procs using it, drops the type, creates the new type, then recreates the new procedures.</li>
    <li>FORCE - Similar to ALTER, except:<ol type='A'>
      <li>ALTER will fail if the change would cause a stored proc to fail to compile.</li>
      <li>If this user defined type would cause a proc to not compile, FORCE drops that proc, then lists it.</li></ol></ol></li>
  <li>sp_DropColumn - Alter table drop column doesn't work if it has a constraint. This finds and drops the constraints too.</li>
  <li>sp_Find - Searches all databases for a column, table, or procedure name containing the text you are searching for.</li>
  <li>sp_FindColumn - Searches all databases for a column name containing the text you are searching for. If you give it two parameters, both strings are used.</li>
  <li>sp_FindInAllProcs - Searches all databases in all procedures for the text you specified. If you specify two parameters, both are used. A good use for this is to search for a table name and the word insert.</li>
  <li>sp_FindInProc - Searches the current databases in all procedures for the text you specified. If you specify two parameters, both are used. A good use for this is to search for a table name and the word insert.</li>
  <li>sp_List - Lists a stored procedure if an exact match is found to what you passed in. Otherwise, lists stored procedures containing that string.</li>
  <li>sp_ListFields - Lists the columns in a table. Also displays field types, column comments and foreign key relationships.</li>
  <li>sp_varinsp - Searches a stored procedure you specify for a text string you specify. Recursively searches all the procedures this procedure calls also. Will output a tree diagram of where the text is in and how to traverse there in the stored procedure heirarchy.</li>
  <li>fn_SplitPK - Split a comma delimited list of integers into a table. Assumes that the list is unique. The table is indexed. This helps for inner joining with large tables.</li>
</ul>

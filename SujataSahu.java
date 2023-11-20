import java.sql.Connection;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.time.format.DateTimeFormatter;
import java.io.*;
import java.math.BigDecimal;
import java.sql.CallableStatement;

public class indProject {
	// Database credentials
		final static String HOSTNAME = "sahu0001-sql-server.database.windows.net";
		final static String DBNAME = "cs-dsa-4513-sql-db";
		final static String USERNAME = "sahu0001";
		final static String PASSWORD = "Jaijagannath2023@";
		// Database connection string
		final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
				HOSTNAME, DBNAME, USERNAME, PASSWORD);
		// Query templates
		final static String QUERY_TEMPLATE_1 = "EXEC EnterNewCustomer @new_customer_name = ?, @new_customer_address = ?, @new_category = ?;";
		final static String QUERY_TEMPLATE_2 = "EXEC EnterNewDepartment @new_department_num = ?, @new_department_data = ?;";
		final static String QUERY_TEMPLATE_3 = "EXEC EnterNewProcess @process_id = ?, @department_num = ?, @process_type = ?, @process_info=?, @machine_type=?, @cutting_type=?, @painting_method=?, @paint_type=?, @process_data=?;";
		final static String QUERY_TEMPLATE_4 = "EXEC NewAssembly @assembly_id = ?, @date_ordered = ?, @customer_name = ?, @assembly_details = ?, @process_id = ?;";
		final static String QUERY_TEMPLATE_5 = "EXEC CreateAccount @account_num = ?, @date_account_established = ?, @process_id=?, @cost_details_3=?, @cost_details_2=?, @cost_details_1=?, @department_data=?, @assembly_details=?, @account_type=?, @department_num=?, @assembly_id=?;";
		final static String QUERY_TEMPLATE_6 = "EXEC EnterNewJob @job_no = ?, @assembly_id = ?, @process_id=?, @job_commenced_date=?, @job_type=?, @color=?, @volume=?, @machine_type_used=?, @material_used=?;";
		final static String QUERY_TEMPLATE_7 = "EXEC InsertJobData @job_no = ?, @completion_date=?, @process_type=?, @labour_time=?, @time_machine_used=?;";
		final static String QUERY_TEMPLATE_8 = "EXEC enterTransactionNum @transaction_num = ?, @sup_cost = ?, @account_num=?;";
		final static String QUERY_TEMPLATE_9 = "EXEC GetTotalCostForAssembly @assembly_id=?, @total_cost=?;";
		final static String QUERY_TEMPLATE_10 = "EXEC GetTotalLaborTime @department_num=?, @completion_date=?, @total_labor_time=? ;";
		final static String QUERY_TEMPLATE_11 = "EXEC GetProcessDepartmentDetails @assembly_id=?";
		final static String QUERY_TEMPLATE_12 = "EXEC GetCustomersByCategoryRange @start_category=?, @end_category=?;";
		final static String QUERY_TEMPLATE_13 = "EXEC DeleteCutJobsByJobNoRange @start_job_no=?, @end_job_no=?;";
		final static String QUERY_TEMPLATE_14 = "EXEC ChangePaintJobColor @job_no=?, @new_color=?;";

		final static String QUERY_TEMPLATE_15 = "SELECT * FROM Performer;";
		final static String QUERY_TEMPLATE_16 = "EXEC ExportCustomer @min=?, @max=?;";
		final static String QUERY_TEMPLATE_17 = "SELECT * FROM Performer;";

		final static DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MM-dd-yyyy");

		// User input prompt
		final static String PROMPT =
				"\nPlease select one of the options below: \n" +
						"(1) Enter a new customer \n" +
						"(2) Enter a new department \n" +
						"(3) Enter a new process-id and its department together with its type and information \n" +
						"\trelevant to the type\n" +
						"(4) Enter a new assembly with its customer-name, assembly-details, assembly-id, \n" +
						"\tand dateordered and associate it with one or more processes\n" +
						"(5) Create a new account and associate it with the process, assembly, or department \n" +
						"\tto which it is applicable\n" +
						"(6) Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced\n" +
						"(7) At the completion of a job, enter the date it completed and the information \n" +
						"\trelevant to the type of job \n" +
						"(8) Enter a transaction-no and its sup-cost and update all the costs (details) of the \n" +
						"\taffected accounts by adding sup-cost to their current values of details \n" +
						"(9) Retrieve the total cost incurred on an assembly-id \n" +
						"(10) Retrieve the total labor time within a department for jobs completed in the \n" +
						"\tdepartment during a given date\n" +
						"(11) Retrieve the processes through which a given assembly-id has passed so far \n" +
						"\t(in datecommenced order) and the department responsible for each process\n"+
						"(12) Retrieve the customers (in name order) whose category is in a given range\n" +
						"(13) Delete all cut-jobs whose job-no is in a given range\n" +
						"(14) Change the color of a given paint job\n" +
						"(15) Import: enter new customers from a data file until the file is empty \n" +
						"(\tthe user must be asked to enter the input file name). \n" +
						"(16) Export: Retrieve the customers (in name order) whose category is in a given range \n" + "\tand output them to a data file instead of screen (the user must be asked to enter the output file name).\n" +
						"(17) Quit\n";

		public static void main(String[] args) throws SQLException, IOException {
			System.out.println("WELCOME TO THE JOB-SHOP ACCOUNTING DATABASE SYSTEM !");
			final Scanner sc = new Scanner(System.in);

			String option = "";

			while (!option.equals("17")) {
				System.out.println(PROMPT);
				System.out.println("Enter your option : ");
				option = sc.next();

				switch (option) {
				case "1":
					System.out.println("name:");
					final String new_customer_name = sc.next();

					System.out.println("address:");
					final String new_customer_address = sc.next();

					System.out.println("category:");
					final int new_category = sc.nextInt();
					System.out.println("Connecting to the database...");

					try (final Connection connection = DriverManager.getConnection(URL)) {
						try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_1)) {
							statement.setString(1, new_customer_name);
							statement.setString(2, new_customer_address);
							statement.setInt(3, new_category);
							statement.execute();
						}
					}
					break;

				case "2":
					System.out.println("department number:");
					final int new_department_num = sc.nextInt();

					System.out.println("department data:");
					final String new_department_data = sc.next();

					System.out.println("Connecting to the database...");

					try (final Connection connection = DriverManager.getConnection(URL)) {
						try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_2)) {
							statement.setInt(1, new_department_num);
							statement.setString(2, new_department_data);
							statement.execute();
						}
					}
					break;

				case "3":

					System.out.println("process id:");
					final int new_process_id = sc.nextInt();

					System.out.println("department number:");
					final int new_department_num1 = sc.nextInt();

					System.out.println("process_type (Cut, Paint, Fit) case-sensitive:");
					final String new_type = sc.next();

					System.out.println("new info:");
					final String new_information = sc.next();

					System.out.println("machine type:");
					final String machine_type = sc.next();

					System.out.println("cutting type:");
					final String cutting_type = sc.next();

					System.out.println("painting method:");
					final String painting_method = sc.next();

					System.out.println("paint type:");
					final String paint_type = sc.next();

					System.out.println("process data:");
					final String process_data = sc.next();

					System.out.println("Connecting to the database...");

					try (final Connection connection = DriverManager.getConnection(URL)) {
						System.out.println("Dispatching the query...");
						try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_3)) {
							statement.setInt(1, new_process_id);
							statement.setInt(2, new_department_num1);
							statement.setString(3, new_type);
							statement.setString(4, new_information);
							statement.setString(5, machine_type);
							statement.setString(6, cutting_type);
							statement.setString(7, painting_method);
							statement.setString(8, paint_type);
							statement.setString(9, process_data);
							statement.execute();
						}	
					}
						break;
					case "4":
						System.out.println("assembly id param:");
						final int assembly_id_param = sc.nextInt();

						System.out.println("date ordered param (MM-dd-yyyy):");
						final String date_ordered_param = sc.next();

						System.out.println("customer name param:");
						final String customer_name_param = sc.next();
						
						System.out.println("assembly ordered param:");
						final String assembly_details_param = sc.next();

						System.out.println("process id param:");
						final String process_ids_param = sc.next();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_4)) {
								statement.setInt(1, assembly_id_param);					        
								statement.setString(2, date_ordered_param);
								statement.setString(3, customer_name_param);
								statement.setString(4, assembly_details_param);
								statement.setString(5, process_ids_param);
								statement.execute();
							}
						}
						break;

					case "5":
						
						System.out.println("account number:");
						final int account_num = sc.nextInt();

						System.out.println("date established:");
						final String date_established = sc.next();
						
						System.out.println("process id:");
						final int process_id = sc.nextInt();

						System.out.println("cost detail 3:");
						final float cost_details_3 = sc.nextFloat();

						System.out.println("cost detail 2:");
						final float cost_details_2 = sc.nextFloat();

						System.out.println("cost detail 1:");
						final float cost_details_1 = sc.nextFloat();
						
						System.out.println("dept data:");
						final String department_data = sc.next();

						System.out.println("assembly details:");
						final String assembly_details = sc.next();
						
						System.out.println("account type (PROCESS, DEPARTMENT, ASSEMBLY) case-sensitive:");
						final String account_type = sc.next();

						System.out.println("dept number:");
						final int department_num = sc.nextInt();

						System.out.println("assembly id:");
						final int assembly_id = sc.nextInt();
						
						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_5)) {
								statement.setInt(1, account_num);
								statement.setString(2, date_established);
								statement.setInt(3, process_id);
								statement.setFloat(4, cost_details_3);
								statement.setFloat(5, cost_details_2);
								statement.setFloat(6, cost_details_1);
								statement.setString(7, department_data);
								statement.setString(8, assembly_details);
								statement.setString(9, account_type);
								statement.setInt(10, department_num);
								statement.setInt(11, assembly_id);
								statement.execute();
							}
						}
						break;
					case "6":
						System.out.println("job no:");
						final int job_no = sc.nextInt();

						System.out.println("assembly id:");
						final int assembly_id1 = sc.nextInt();

						System.out.println("process id:");
						final int process_id1 = sc.nextInt();

						System.out.println("job commenced date:");
						final String job_commenced_date = sc.next();
						
						System.out.println("job type (paint, fit, cut) case-sensitive:");
						final String job_type = sc.next();
						
						System.out.println("color:");
						final String color = sc.next();

						System.out.println("volume:");
						final String volume = sc.next();
						
						System.out.println("machine type used:");
						final String machine_type_used = sc.next();

						System.out.println("material used:");
						final String material_used = sc.next();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_6)) {
								statement.setInt(1, job_no);
								statement.setInt(2, assembly_id1);
								statement.setInt(3, process_id1);
								statement.setString(4, job_commenced_date);
								statement.setString(5, job_type);
								statement.setString(6, color);
								statement.setString(7, volume);
								statement.setString(8, machine_type_used);
								statement.setString(9, material_used);
								statement.execute();
							}
						}
						break;
					case "7":

						System.out.println("job no:");
						final int job_no1 = sc.nextInt();
						
						System.out.println("job competion date:");
						final String completion_date = sc.next();
						
						System.out.println("process type:");
						final String process_type = sc.next();

						System.out.println("labour time:");
						final float labour_time = sc.nextFloat();
						
						System.out.println("time machine used:");
						final float time_machine_used = sc.nextFloat();
						
						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_7)) {
								cs.setInt(1, job_no1);
								cs.setString(2, completion_date);
								cs.setString(3, process_type);
								cs.setFloat(4, labour_time);
								cs.setFloat(5, time_machine_used);
								// Execute the stored procedure
						        cs.execute();
							}
						}
						break;
					case "8":

						System.out.println("transaction number:");
						final int transaction_num = sc.nextInt();

						System.out.println("sup cost:");
						final float sup_cost = sc.nextFloat();
						
						System.out.println("account number:");
						final int acc_no = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_8)) {
								statement.setInt(1, transaction_num);
								statement.setFloat(2, sup_cost);
								statement.setInt(3, acc_no);
								statement.execute();
							}
						}
						break;
					case "9":

						System.out.println("assembly id:");
						final int assembly_id3 = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_9)) {

								cs.setInt(1, assembly_id3);
								cs.registerOutParameter(2, Types.DECIMAL);
								// Execute the stored procedure
						        cs.execute();

						        // Retrieve the output parameter value
						        BigDecimal totalCost = cs.getBigDecimal(2);
						        System.out.println("Total cost: " + totalCost);
							}
						}
						break;
					case "10":

						System.out.println("department number:");
						final int department_number = sc.nextInt();
						
						System.out.println("job completed date:");
						final String job_completed_date2 = sc.next();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_10);
							// Set the assigned value(s) to the procedures input
							cs.setInt(1, department_number);
							cs.setString(2, job_completed_date2);
							// Run the stored procedure and store values in resultSet
							cs.registerOutParameter(3, Types.DECIMAL);
							// Execute the stored procedure
					        cs.execute();

					        // Retrieve the output parameter value
					        BigDecimal totalCost = cs.getBigDecimal(3);
					        System.out.println("Total cost: " + totalCost);
						}
						break;
					case "11":

						System.out.println("assembly id:");
						final int assembly_id4 = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							// Prepare a call to the stored procedure
							CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_11);
							// Set the assigned value(s) to the procedures input
							cs.setInt(1, assembly_id4);
							// Run the stored procedure and store values in resultSet
							System.out.println("Dispatching the query...");
							ResultSet resultSet = cs.executeQuery();
							System.out.println("Done.");
							System.out.println("\nProcess for assembly-id: " + assembly_id4 +
									", and its departement number; Sorted by date commenced.");
							System.out.println("processID | deptNo");
							// Unpack the tuples returned by the database and print them out to the user
							while (resultSet.next()) {
								System.out.println(String.format("%s | %s ",
										resultSet.getString(1),
										resultSet.getString(2)));
							}
						}
						break;
					case "12":

						System.out.println("start category:");
						final int range_start = sc.nextInt();

						System.out.println("end category:");
						final int range_end = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_12);) {
								// Set the assigned value(s) to the procedures input
								cs.setInt(1, range_start);
								cs.setInt(2, range_end);
								// Run the stored procedure and store values in resultSet
								System.out.println("Dispatching the query...");
								ResultSet resultSet = cs.executeQuery();
								System.out.println("Done.");
								System.out.println("\nJobs from start date " + range_start +
										" completed on: " + range_end);
								System.out.println("customer name");
								// Unpack the tuples returned by the database and print them out to the user
								while (resultSet.next()) {
									System.out.println(String.format("%s",
											resultSet.getString(1)));

								}
							}
						}
						break;
					case "13":
						
						System.out.println("job number start:");
						final int job_number_start = sc.nextInt();

						System.out.println("job number end:");
						final int job_number_end = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_13)) {
								statement.setInt(1, job_number_start);
								statement.setInt(2, job_number_end);
								statement.executeUpdate();
							}
						}
						break;
					case "14":

						System.out.println("job number:");
						final int job_number = sc.nextInt();

						System.out.println("color:");
						final String color1 = sc.next();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_14)) {
								statement.setInt(1, job_number);
								statement.setString(2, color1);
								int rows = statement.executeUpdate();
								System.out.println(rows);
							}
						}
						break;
					case "15":
						System.out.println("Please enter the location and name of a CSV file with customer data:" +
								"\n>> ONLY INSERT CSV FILE <<");

						String filename = sc.next();
						// create insert statement with values from csv file
						String query = readCSV(filename);
						// Get a database connection and prepare a query statement

						try (final Connection connection = DriverManager.getConnection(URL)) {
							// Prepare a call to the stored procedure
							PreparedStatement ps = connection.prepareCall(query);
							System.out.println("Dispatching the query...");
							// Actually execute the populated query
							final int rows_inserted = ps.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
						}
						break;
					case "16":
						// Set the query
						System.out.println("Please enter MIN category number (integer from 1 - 10, inclusive):");
						int min = sc.nextInt();
						System.out.println("Please enter MAX category number (integer from 1 - 10, inclusive):");
						int max = sc.nextInt();
						System.out.println("Please enter the file output name:");
						sc.nextLine();
						filename = sc.nextLine();
						// Get a database connection and prepare a query statement
						try (final Connection connection = DriverManager.getConnection(URL)) {
							// Prepare a call to the stored procedure
							CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_16);
							// Set the assigned value(s) to the procedures input
							cs.setInt("min", min);
							cs.setInt("max", max);
							// Run the stored procedure and store values in resultSet

							System.out.println("Dispatching the query...");
							ResultSet resultSet = cs.executeQuery();
							try {
								FileWriter myWriter = new FileWriter(filename + ".csv");
								myWriter.write("name,address,category\n");
								// Unpack the tuples returned by the database and print them out to the user
								while (resultSet.next()) {
									myWriter.write(String.format("%s,%s,%s\n",
											resultSet.getString(1),
											resultSet.getString(2),
											resultSet.getString(3)));
								}
								// close the writer
								myWriter.close();
							} catch (IOException e) {
								System.out.println("Error with file name.");
								e.printStackTrace();
							}
						}
						System.out.println("Done. File Location here:");
						System.out.println(filename + ".csv");
						break;
					case "17":
						System.out.println("Finished! Your work here is done.");
						break;
					default:
						System.out.println("In the default part. Something went wrong. Perhaps, wrong option !!");
						break;
					}
				}

				sc.close();
			}


			// Function to read in a csv file and return a concatenated into an insert statement
			public static String readCSV(String filename) throws IOException, SQLException {
				// Number of columns in the customer table (3)
				final int NUM_CUST_COLS = 3;
				// string that will hold the insert statement
				String insertStatement = "INSERT INTO Customer VALUES (";
				// Create input reader
				BufferedReader input = new BufferedReader(new FileReader(filename));
				String line = "";
				int iterCount = 0; // keep track of iterations
				final int FIRST_ITER = 0;
				// Iterate through each 'row' of the csv
				while ((line = input.readLine()) != null) {
					// IF the first iteration, then do nothing. else concatenate parenthesis
					if (iterCount != FIRST_ITER) {
						insertStatement += ", (";
					} else {
						++iterCount;
					}
					// Iterate through each 'column' of the csv file
					for (int col = 0; col < NUM_CUST_COLS; ++col) {
						// Add a ' in front of the string vars
						if (col != NUM_CUST_COLS - 1) {
							insertStatement += "'";
						}
						// return the value of the row for each column index (1 through 3)
						insertStatement += line.split(",")[col];
						// If not at last column, add comma to the string
						// Add a ' at end of the string vars
						if (col != NUM_CUST_COLS - 1) {
							insertStatement += "', ";
						}
						// End the values insert
						else {
							insertStatement += ")";
						}
					}
				}
				// close the input method
				input.close();
				// return the insert statement
				return (insertStatement);
			}
}

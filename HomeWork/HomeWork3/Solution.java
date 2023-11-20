import java.sql.Connection;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.sql.CallableStatement;


public class group37 {
    // Database credentials
    final static String HOSTNAME = "sahu0001-sql-server.database.windows.net";
    final static String DBNAME = "cs-dsa-4513-sql-db";
    final static String USERNAME = "sahu0001";
    final static String PASSWORD = "Jaijagannath2023@";
    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
    		HOSTNAME, DBNAME, USERNAME, PASSWORD);
    // Query templates
    final static String QUERY_TEMPLATE_1 = "EXEC Performerprocedure @pid = ?, @pname = ?, @age = ?;";
    final static String QUERY_TEMPLATE_3 = "EXEC Performerprocedure3 @pid = ?, @pname = ?, @age = ?, @did=?;";

    final static String QUERY_TEMPLATE_2 = "SELECT * FROM Performer;";

    // User input prompt
    final static String PROMPT =
        "\nPlease select one of the options below: \n" +
        "1) Insert pid, pname, age; \n" +
        "2) Insert Pid, pname,age, did; \n" +
        "3) Display all the list; \n"+
        "4) Quit! ";

    public static void main(String[] args) throws SQLException {
        System.out.println("Welcome to the sample application!");
        final Scanner sc = new Scanner(System.in);

        String option = "";

        while (!option.equals("4")) {
            System.out.println(PROMPT);
            option = sc.next();

            switch (option) {
                case "1":
                    System.out.println("pid:");
                    final int pid = sc.nextInt();

                    System.out.println("Please enter pname:");
                    sc.nextLine();
                    final String pname = sc.nextLine();

                    System.out.println("Please enter age:");
                    final int age = sc.nextInt();
                    System.out.println("Connecting to the database...");

                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_1)) {
                            statement.setInt(1, pid);
                            statement.setString(2, pname);
//                            statement.registerOutParameter(3, Types.INTEGER);
                            statement.setInt(3, age);

                            statement.execute();
//                            System.out.println("Dispatching the query...");
//
//                            final int rows_inserted = statement.executeUpdate();
//                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    break;

                case "2":
                	System.out.println("pid:");
                    final int second_pid = sc.nextInt();

                    System.out.println("Please enter pname:");
                    sc.nextLine();
                    final String second_pname = sc.nextLine();

                    System.out.println("Please enter age:");
                    final int second_age = sc.nextInt();
                    
                    System.out.println("Please enter did:");
                    final int did = sc.nextInt();
                    
                    System.out.println("Connecting to the database...");

                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_3)) {
                            statement.setInt(1, second_pid);
                            statement.setString(2, second_pname);
//                            statement.registerOutParameter(3, Types.INTEGER);
                            statement.setInt(3, second_age);
                            statement.setInt(4, did);

                            statement.execute();
//                            System.out.println("Dispatching the query...");
//
//                            final int rows_inserted = statement.executeUpdate();
//                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    break;
                    
                case "3":
                    System.out.println("Connecting to the database...");

                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Dispatching the query...");

                        try (final Statement statement = connection.createStatement(); final ResultSet resultSet = statement.executeQuery(QUERY_TEMPLATE_2)) {
                            System.out.println("Contents of the Performer table:");
                            System.out.println("ID | Name | YEARS_OF_EXPERIENCE | AGE ");

                            while (resultSet.next()) {
                                System.out.println(String.format("%s | %s | %s | %s ",
                                        resultSet.getString(1),
                                        resultSet.getString(2),
                                        resultSet.getString(3),
                                        resultSet.getString(4)));
                            }
                        }
                    }
                    break;  
                 
                case "4":
                    System.out.println("Exiting! Good-bye!");
                    break;

                default:
                    System.out.println(String.format(
                            "Unrecognized option: %s\n" +
                                    "Please try again!",
                            option));
                    break;
            }
        }

        sc.close();
    }
}

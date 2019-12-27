import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet; 
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList; 
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;
import java.io.*;

public class Administrator {

    private static String user = "filipcl"; // Input your UiO-username
    private static String pwd = "ephooCh7Us"; // Input the password for the _priv-user you got in a mail
    // Connection details
    private static String connectionStr = 
        "user=" + user + "_priv&" + 
        "port=5432&" +  
        "password=" + pwd + "";
    private static String host = "jdbc:postgresql://dbpg-ifi-kurs.uio.no"; 

    public static void main(String[] agrs) {

        try {
            // Load driver for PostgreSQL
            Class.forName("org.postgresql.Driver");
            // Create a connection to the database
            Connection connection = DriverManager.getConnection(host + "/" + user
                    + "?sslmode=require&ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&" + connectionStr);

            int ch = 0;
            while (ch != 3) {
                System.out.println("-- ADMINISTRATOR --");
                System.out.println("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit");
                ch = getIntFromUser("Option: ", true);

                if (ch == 1) {
                    makeBills(connection);
                } else if (ch == 2) {
                    insertProduct(connection);
                }
            }
        } catch (SQLException|ClassNotFoundException ex) {
            System.err.println("Error encountered: " + ex.getMessage());
        }

    }

    private static void makeBills(Connection connection)  throws SQLException {
        // TODO: Oppg 2
        String name = "";
        String address = "";
        float price = 0;

        String username = getStrFromUser("Username: "); 
        String sql1 = "SELECT u.name , u.address , SUM(o.num + p.price) as tot FROM ws.users u INNER JOIN ws.orders o on u.uid = o.uid INNER JOIN ws.products p ON o.pid = p.pid WHERE payed = 0  GROUP BY (u.name, u.address);";
        String sql2 = "SELECT u.name , u.address , SUM(o.num + p.price) as tot FROM ws.users u INNER JOIN ws.orders o on u.uid = o.uid INNER JOIN ws.products p ON o.pid = p.pid WHERE payed = 0  AND username = ? GROUP BY (u.name, u.address);";
        PreparedStatement statement = connection.prepareStatement(sql1);
        

        if(username.isEmpty()){
            statement = connection.prepareStatement(sql1);
        }else{
            statement = connection.prepareStatement(sql2);
            statement.setString(1 , username);
        }
        ResultSet rows = statement.executeQuery();
        
        try{

            while (rows.next()) {
                name = rows.getString("name");
                address = rows.getString("address");
                price = rows.getFloat("tot");
                System.out.println("");
                System.out.print("-- Bill -- \n" );
                System.out.print("Name: " + name + "\n");
                System.out.print("Address: " + address + "\n");
                System.out.println("Total due: " + price + "\n");
                System.out.println("");
        }

            
        } catch (SQLException e ) {
            System.out.println("SQLException caugth");
        }    
    }
    
    private static void insertProduct(Connection connection) throws SQLException  {
        
        System.out.println("-- INSERT NEW PRODUCT --");
        String sql ="INSERT INTO ws.products as p (name, price, cid ,description ) VALUES ( ? , ? , (SELECT cid FROM ws.categories as c WHERE c.cid = ?) , ?);";
        PreparedStatement statement = connection.prepareStatement(sql);
        String productName = getStrFromUser("Product name: "); 
        String pn = new String(productName);

        String productPrice = getStrFromUser("Price: ");
        Float pp = new Float(productPrice);
        
        System.out.println("");
        System.out.println("-- SELECT PRODUCT CATEGORY --");
        System.out.println(" 1: Food ");
        System.out.println(" 2: Electronics ");
        System.out.println(" 3: Clothing ");
        System.out.println(" 4: Games ");
        System.out.println("");

        String productCategory = getStrFromUser("Category type : ");
        Integer cid = new Integer (productCategory);

        String productDescription = getStrFromUser("Description: ");
        statement.setString(1 ,pn);
        statement.setFloat(2 ,pp);
        statement.setInt(3 ,cid);
        statement.setString(4 ,productDescription);
        statement.executeUpdate();

        String sql1 = "SELECT p.name , p.price , c.name as cat , p.description from ws.products p INNER JOIN ws.categories c using (cid) WHERE p.name LIKE" + "'%" + pn + "%'" + ";";
        statement = connection.prepareStatement(sql1);
        ResultSet rows1 =  statement.executeQuery();
    
        while (rows1.next()) {
            System.out.println("");
            System.out.println("-- NEW PRODUCT --");
            System.out.println("Name: " + rows1.getString(1));
            System.out.println("Price: " + rows1.getFloat(2));
            System.out.println("Category: " + rows1.getString(3));
            System.out.println("Description: " + rows1.getString(4));
            System.out.println("");
        };
    }

    /**
     * Utility method that gets an int as input from user
     * Prints the argument message before getting input
     * If second argument is true, the user does not need to give input and can leave
     * the field blank (resulting in a null)
     */
    private static Integer getIntFromUser(String message, boolean canBeBlank) {
        while (true) {
            String str = getStrFromUser(message);
            if (str.equals("") && canBeBlank) {
                return null;
            }
            try {
                return Integer.valueOf(str);
            } catch (NumberFormatException ex) {
                System.out.println("Please provide an integer or leave blank.");
            }
        }
    }

    /**
     * Utility method that gets a String as input from user
     * Prints the argument message before getting input
     */
    private static String getStrFromUser(String message) {        
        Scanner s = new Scanner(System.in);
        System.out.print(message);
        return s.nextLine();
    }
}
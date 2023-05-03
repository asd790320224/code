package Insert;
import java.sql.*;


public class InsertAccount {
    public static void register(String username, String password, String email, String role) {
        String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
        Connection conn;
        try{
            conn = DriverManager.getConnection(url,"eshop","93576881");
            String sql = "insert into 账号数据 " +
                    "values('"  + username +
                    "','"+ password +
                    "','"+ email +
                    "','"+ role +
                    "')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.execute();
        }catch (SQLException e){
            e.printStackTrace();
        }
    }
}

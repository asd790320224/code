package Select;

import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name = "SelectRegister", value = "/SelectRegister")
public class SelectRegister {
    static String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
    public static boolean username_check(String username) {
        try {
            Connection conn;
            conn = DriverManager.getConnection(url, "eshop", "93576881");
            String sql = "select 用户名 from 账号数据 ";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            List<String> name = new ArrayList<>();
            while (rs.next())
            {
                name.add(rs.getString("用户名"));
            }
            Object[] c_name = name.toArray();
            boolean repeat = false;
            for (Object o : c_name) {
                if (username.equals(o)) {
                    repeat = true;
                    break;
                }
            }
            return repeat;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean email_check(String email) {
        try {
            Connection conn;
            conn = DriverManager.getConnection(url, "eshop", "93576881");
            String sql = "select 电子邮箱 from 账号数据 ";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            List<String> mail = new ArrayList<>();
            while (rs.next())
            {
                mail.add(rs.getString("电子邮箱"));
            }
            Object[] c_email = mail.toArray();
            boolean repeat = false;
            for (Object o : c_email) {
                if (email.equals(o)) {
                    repeat = true;
                    break;
                }
            }
            return repeat;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

package Insert;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.*;
import java.util.*;

public class ProductUploadServlet {
    public static int upload(String name, String description, double price_, String phone, String email, String username, int stock_, byte[] thumbnailData) {
        String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
        Connection conn;
        //生成随机数id
        int min = 10000000;
        int max = 99999999;
        Random random;
        try {
            random = SecureRandom.getInstanceStrong();
        } catch (NoSuchAlgorithmException ex) {
            throw new RuntimeException(ex);
        }
        int id = random.nextInt(max) % (max - min + 1) + min;
        // 插入新记录
        try {
            conn = DriverManager.getConnection(url, "eshop", "93576881");
            String sql = "INSERT INTO 商品信息 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price_);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, username);
            ps.setInt(7, id);
            ps.setInt(8, 0);
            ps.setInt(9, stock_);
            ps.setBytes(10, thumbnailData);
            ps.setInt(11, 0);
            ps.executeUpdate();
            return id;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
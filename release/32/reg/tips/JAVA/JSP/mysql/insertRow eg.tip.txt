<%@ tag pageEncoding="utf-8" %>
<%@ tag import="java.sql.*" %>
<%@ tag import="java.util.Calendar" %>
<%@ attribute name="number" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="year" required="true" %>
<%@ attribute name="price" required="true" %>
<%
    float p = Float.parseFloat(price);


    try {
        Class.forName("com.mysql.jdbc.Driver");  ////驱动程序名
    } catch (Exception e) {
        e.printStackTrace();
        System.out.println(e.getMessage());
    } finally {
    }

    Connection con = null;
    Statement sql;
    ResultSet rs;
    int n = 0;
    Calendar calendar = Calendar.getInstance();

    try{
        String uri = "jdbc:mysql://localhost:3306/" + "warehouse" + "?useUnicode=true&characterEncoding=utf-8"; //数据库名;
        String user = "root";
        String password = "Zzerp123";
        con = DriverManager.getConnection(uri, user, password);
        sql = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        rs = sql.executeQuery("SELECT * FROM product");
        rs.moveToInsertRow();
        rs.updateString(1, number);
        rs.updateString(2, name);
        String []str = year.split("[-/]");
        int yearme = Integer.parseInt(str[0]);
        int month = Integer.parseInt(str[1]);
        int day = Integer.parseInt(str[2]);
        calendar.set(yearme, month - 1, day);
        java.sql.Date date = new java.sql.Date(calendar.getTimeInMillis());
        rs.updateDouble(3,p);
        rs.updateDate(4, date);
        rs.insertRow();  //向product表插入一行记录
        con.close();
    } catch (SQLException e) {
        out.println("" + e);
    }

%>
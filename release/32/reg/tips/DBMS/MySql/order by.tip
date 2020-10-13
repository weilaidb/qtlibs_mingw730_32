<%@ tag pageEncoding="utf-8" %>
<%@ tag import="java.sql.*" %>
<%@ attribute name="orderType" required="true" %>
<%@ variable name-given="orderResult" scope="AT_END" %>
<%
    String orderCondition  =
            "SELECT * FROM product ORDER BY " + orderType;

    StringBuffer result;
    result = new StringBuffer();
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

    try{
        result.append("<table border=1>");
        String uri = "jdbc:mysql://localhost:3306/" + "warehouse" + "?useUnicode=true&characterEncoding=utf-8"; //数据库名;
        String user = "root";
        String password = "Zzerp123";
        con = DriverManager.getConnection(uri, user, password);
        DatabaseMetaData metadata = con.getMetaData();
        String tableName = "product";
        ResultSet rs1 = metadata.getColumns(null, null, tableName, null);
        int 字段个数 = 0;
        result.append("<tr>");
        while (rs1.next()) {
            字段个数++;
            String columnName = rs1.getString(4);
            result.append("<td>" + columnName + "</td>");
        }
        result.append("</tr>");
        sql = con.createStatement();
        rs = sql.executeQuery(orderCondition);
        while (rs.next()) {
            result.append("<tr>");
            for (int i = 1; i <= 字段个数; i++) {
                result.append("<td>" + rs.getString(i) + "</td>");
            }
            result.append("</tr>");
        }
        result.append("</table>");
        con.close();
    } catch (SQLException e) {
        e.printStackTrace();
        result.append(e);
    }

    jspContext.setAttribute("orderResult", new String(result));

%>
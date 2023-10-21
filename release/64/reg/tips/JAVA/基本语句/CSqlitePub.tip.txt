package sql;

import base.CStringPub;
import file.CFilePub;

import java.io.*;
import java.sql.*;

public class CSqlitePub {
    static String firstpath = "mydb/";
    static String secondpath = "sqlite/";
    static String filename = "config.txt";

    public static String getFilenameautojcode() {
        return filenameautojcode;
    }

    public static String getDirnameautojcode() {
        return firstpath + secondpath;
    }

    static String filenameautojcode = "autojcodeconfig.txt";
    static int showlen = 60;
    static String linktable = "link";


    public static String getLinktable() {
        return linktable;
    }

    public static void setLinktable(String linktable) {
        CSqlitePub.linktable = linktable;
    }

    static public String expCreateTable(String table)
    {
        return "CREATE TABLE " + table +"(" +
                "[ID] INTEGER PRIMARY KEY," +
                "[content] varchar(100)," +
                "[note] varchar(100)," +
                "httpflag integer DEFAULT 0," +
                "delflag integer DEFAULT 0," +
                "CreatedTime TimeStamp NOT NULL DEFAULT (datetime('now'," +
                "'localtime'))" +
                ");";
    }

    static public String expDropTable(String table)
    {
        return "DROP  TABLE " + table +";";
    }

    static public String expDeleteCondition(String table, int id)
    {
        return "DELETE FROM " + table + " WHERE ID = '" + id +"';";
    }

    static public String expSelectCondition(String table, String item,  int id)
    {
        return "SELECT " + item + " FROM " + table + " WHERE ID = '" + id +"';";
    }

    static public String expSelectCondition(String table)
    {
        return "SELECT * FROM " + table + ";";
    }

    static public String expSelectIDConditionContentNote(String table)
    {
        return "SELECT id,content,note FROM " + table + ";";
    }

    static public String expUpdateCondition(String table,String item, String val, int id)
    {
        val = procContentWithSpeciSign(val);
        val = procContentWithChinese(val);
//        UPDATE COMPANY SET ADDRESS = 'Texas' WHERE ID = 6;
        return "UPDATE " + table + " SET "+ item +"='" + val + "'" + " WHERE ID = '" + id +"';";
    }

    static public String procContentWithSpeciSign(String content)
    {
        return content.replaceAll("\'","\'\'");
    }

    static public String procContentWithChinese(String content)
    {
        try {
//            String content = request.getParameter("boy");
            byte cc[] = content.getBytes("ISO-8859-1");
//            byte cc[] = content.getBytes("GBK");
//            byte cc[] = content.getBytes("UTF-8");
//            byte cc[] = content.getBytes("unicode");
            content = new String(cc);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return content;
    }

    static public String procItemWithAll(String item)
    {
        item = procContentWithSpeciSign(item);
        item = procContentWithChinese(item);
        return item;
    }


    static public String expInsertTable(String table,String content)
    {
        content = procItemWithAll(content);
        return "INSERT INTO " + table + "([content]) VALUES( '" + content + "')";
    }

    static public String expInsertTable(String table,String content,String note)
    {
        content = procItemWithAll(content);
        note = procItemWithAll(note);
        return "INSERT INTO " + table + "(content,note) VALUES( '" + content + "' ,'"+ note +"')";
    }


    //加载驱动
    static public StringBuffer loadSqliteClass(StringBuffer result)
    {
        try {
            Class.forName("org.sqlite.JDBC");  //Sqlite3驱动程序名
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            result.append(e);
        } finally {
        }

        return result;
    }
    //deal  order
    static public String procOrder(String order, String orderCondition)
    {
        if(order.trim().equals("order"))
        {
            orderCondition += " ORDER BY ID desc ";
        }
        return orderCondition;
    }

    //deal  limit
    static public String procLimit(String limit, String orderCondition)
    {
        if(limit.trim().equals("limit"))
        {
            orderCondition += " limit 50";
        }
        else
        {
            orderCondition += "";
        }
        return orderCondition;
    }

    //is show little
    static public boolean isShowLittle(String showlittle)
    {
        if(CStringPub.ifNullSetEmpty(showlittle).equals("showlittle"))
        {
            return true;
        }
        return false;
    }

    //query all
    static public StringBuffer procSelectAll(Connection con
            ,String database
            ,String tableName
            ,StringBuffer result
            ,String orderCondition
            ,String showlittle
            ,int columnNum
    )
    {
        ResultSet rs = null;
        Statement sql = null;
        try{
            //表的所有列
            int 字段个数 = 0;
            DatabaseMetaData metadata = con.getMetaData();
            ResultSet rs1 = metadata.getColumns(null, null, tableName, null);
            result.append("<tr>");
            while (rs1.next()) {
                字段个数++;
                if((字段个数>columnNum) && (columnNum != -1))
                {
                    break;
                }
                String columnName = rs1.getString(4);
                result.append("<td>" + columnName + "</td>");
            }
            result.append("</tr>");
            System.out.println("字段个数: " + 字段个数);

            sql = con.createStatement();
            rs = sql.executeQuery(orderCondition);
            while (rs.next()) {
                result.append("<tr>");
                for (int i = 1; i <= 字段个数; i++) {
                    procShowLittle(database, tableName, showlittle, i, rs,result);
                }
                result.append("</tr>");
            }
            result.append("</table>");
        } catch (SQLException e) {
            e.printStackTrace();
            result.append(e);
        }

        return result;
    }
    //query link table
    static public StringBuffer procSelectLinkTable(Connection con
            ,String tableName
            ,StringBuffer result
            ,String orderCondition
    )
    {
        ResultSet rs;
        Statement sql = null;
        try{
            //表的所有列
            int 字段个数 = 3;
            sql = con.createStatement();
            rs = sql.executeQuery(orderCondition);
            while (rs.next()) {
                result.append("<font size=5>");
                result.append(
                        "<a href=\""+ rs.getString(2) +"\" target=\"_blank\">"
                        + "["
                        + rs.getString(1)
                        + "] "
                        + rs.getString(3)
                        +"</a><br/>");
                result.append("</font>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result.append(e);
        }

        return result;
    }

    //查找内容是否包含以空格分隔的关键字
    static public boolean findWordWithSpace(String content, String findWord)
    {
        String[] listWord = findWord.split(" ");
        int num = 0;
        for (String item:
             listWord) {
            if(CStringPub.isTrimEmpty(item))
            {
                continue;
            }
            if(content.trim().toLowerCase().contains(item.trim().toLowerCase()))
            {
                num++;
            }
            else
            {
                break;
            }
        }

        if(num == listWord.length)
        {
            return true;
        }
        return false;
    }


    //query with findwords
    static public StringBuffer procFindWord(Connection con
            ,String database
            ,String tableName
            ,StringBuffer result
            ,String findwords
            ,String strCols
            ,String order
            ,String showlittle
            ,int columnNum
    )
    {
        String orderCondition = null;
        ResultSet rs = null;
        Statement sql = null;
        try{
            int 字段个数 = 0;
            result.append("<tr>");
            String[] listStrCol = strCols.trim().split(",");
            for (String m_item :
                    listStrCol) {
                字段个数++;
                String columnName = m_item;
                result.append("<td>" + columnName + "</td>");
            }
            result.append("</tr>");
            System.out.println("字段个数: " + 字段个数);

            try {
                byte aa[] = findwords.getBytes("ISO-8859-1");
                findwords = new String(aa);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }

            orderCondition  = "SELECT " + strCols + " FROM " + tableName ;
            orderCondition = procOrder(order, orderCondition);

            sql = con.createStatement();
            rs = sql.executeQuery(orderCondition);
            while (rs.next()) {
                String m_ColContentVal = rs.getString(2);
                if(!findWordWithSpace(m_ColContentVal, findwords)){
                    continue;
                }
                result.append("<tr>");
                for (int i = 1; i <= 字段个数; i++) {
                    procShowLittle(database, tableName, showlittle, i, rs,result);
                }
                result.append("</tr>");
            }
            result.append("</table>");
        } catch (SQLException e) {
            e.printStackTrace();
            result.append(e);
        }

        return result;
    }

    static public String getFormButton(String database, String table,String submit)
    {
        String showButton = "<form action=\"updateTable.jsp\" method=\"post\" name=\"form\" class=\"form\" accept-charset=\"gbk\" target=\"_blank\" >  " +
                "    <input type=\"hidden\" name=\"database\" value=\"" + database + "\"/>                                      " +
                "    <input type=\"hidden\" name=\"table\" value=\"" +table + "\"/>                                            " +
                "    <input type=\"hidden\" name=\"id\" value=\"" + submit + "\"/>                                            " +
                "    <input type=\"submit\" name=\"table\" value=\"" + submit + "\" class=\"submitbtn\"/>                             " +
                "</form>  ";
        return showButton;
    }

    static public void procShowLittle(String database, String table, String showlittle, int i, ResultSet rs, StringBuffer result)
    {
        try {
            if (CSqlitePub.isShowLittle(showlittle)) {
                String tempStr = rs.getString(i);
                tempStr = CStringPub.ifNullSetEmpty(tempStr);
                int strlen = tempStr.length();
                int minlen = strlen > showlen ? showlen : strlen;
                if(i != 1) {
                    result.append("<td>" + tempStr.substring(0, minlen) + "</td>");
                }else {
                    String showButton = getFormButton(database, table, tempStr.substring(0, minlen));
                    result.append("<td>" +  showButton + "</td>");
                }
            } else {
                if (i != 1) {
                    result.append("<td>" + rs.getString(i) + "</td>");
                } else {
                    String showButton = getFormButton(database, table, rs.getString(i));
                    result.append("<td>" + showButton + "</td>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    static public String getStoreDbFileName()
    {
        return "" + firstpath + secondpath  + firstpath;
    }

    static public String getSqlitePathFromFileSingle(String prefix)
    {
        StringBuffer str = new StringBuffer();
        try{
            File dir = new File(prefix + firstpath,secondpath);
            dir.mkdirs();
            File f = new File(dir,filename);
            if(!f.exists())
            {
                try {
                    f.createNewFile(); //如果文件不存在则创建文件
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return "";
            }
            FileReader in = new FileReader(f);
            BufferedReader bufferin = new BufferedReader(in);
            String temp;
            while ((temp = bufferin.readLine()) != null) {
                if(CStringPub.isTrimEmpty(temp))
                {
                    continue;
                }
                str.append(temp);
                //只取第一行
                break;
            }
            bufferin.close();
            in.close();
            System.out.println("found sqlite db:" + str);
            return str.toString().trim();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("no found sqlite db:" + e);
            return e.toString();
        }
    }

    static public String getSqlitePathFromFile()
    {
        String[] prepath = {"D:/","E:/","C:/"};
        for (String pre:
             prepath) {
            try{
                return getSqlitePathFromFileSingle(pre);
            } catch (Exception e) {
                e.printStackTrace();
                continue;
            }
        }
        return "";
    }

    static public String getAutoJcodePathFromFile(String predir, String filename)
    {
        String[] prepath = {"D:/","E:/","C:/"};
        for (String pre:
             prepath) {
            try{
                return CFilePub.getFileFirstContent(pre + predir, filename);
            } catch (Exception e) {
                e.printStackTrace();
                continue;
            }
        }
        return "";
    }

    static public String getSqliteWholePath()
    {
        String dbPath = getSqlitePathFromFile();
        try {
//            byte bb[] = dbPath.getBytes("ISO-8859-1");
//        byte bb[] = dbPath.getBytes("GBK");
        byte bb[] = dbPath.getBytes("UTF-8");
//        byte bb[] = dbPath.getBytes("unicode");
            dbPath = new String(bb);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        
        return "jdbc:sqlite:" + getSqlitePathFromFile();
    }
    static public String getSqliteWholePath(String databaseProc)
    {
        databaseProc = CStringPub.ifNullSetEmpty(databaseProc);
        if(databaseProc.isEmpty())
        {
            return getSqliteWholePath();
        }
        else {
            return getSqlitePathWithDriver(databaseProc);
        }
    }

    static public String getSqlitePathWithDriver(String database)
    {
        String prefix = "jdbc:sqlite:";
        if(false == database.trim().contains(prefix))
        {
            return  prefix + database;
        }
        return database;
    }
    static public String getSqlitePathTrimDriver(String database)
    {
        return database.replaceAll("jdbc:sqlite:","");
    }

    //查询数据库表名(默认)
    static public String qrySqliteDefault(String tablename, String qryVal) {
        String result = "";
        String sql = "";  //查询语句
        Connection connection = null;
        try {
            Class.forName("org.sqlite.JDBC");
            String dbpath = CSqlitePub.getSqliteWholePath();
            dbpath = CSqlitePub.getSqlitePathWithDriver(dbpath);
            connection = DriverManager.getConnection(dbpath);
            Statement statement = connection.createStatement();   //创建连接对象，是Java的一个操作数据库的重要接口

            if (tablename.trim().isEmpty()) {
                tablename = "c_table";
            }

            boolean isfull = false;
            if (qryVal.trim().isEmpty()) {
                sql = "SELECT * from " + tablename + " order by id desc limit 50;";  //查询语句
                isfull = true;
            } else {
                sql = "SELECT * from " + tablename + " order by id desc;";  //查询语句
            }

            ResultSet rSet = statement.executeQuery(sql);//搜索数据库，将搜索的放入数据集ResultSet中
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    CSqlitePub()
    {

    }
}

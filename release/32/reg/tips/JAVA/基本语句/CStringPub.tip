package base;

import com.sun.deploy.net.HttpRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CStringPub {
    public static boolean isTrimEmpty(String string)
    {
        if(null == string)
        {
            string = "";
            return true;
        }
        return string.trim().isEmpty();
    }

    public static String ifNullSetEmpty(String string)
    {
        if(null == string)
        {
            string = "";
        }
        return string.trim();
    }

    public static boolean isBufferTrimEmpty(StringBuffer buffer)
    {
        return buffer.toString().trim().isEmpty();
    }
    public static int splitBySignSize(String buffer, String sign)
    {
        return buffer.split(sign).length;
    }
    public static int splitByDouSize(String buffer)
    {
        return splitBySignSize(buffer,",");
    }

    public static String requesParaIfNullSetEmpty(HttpServletRequest request, String key)
    {
        return ifNullSetEmpty(request.getParameter(key));
    }

    public static String emptyString()
    {
        return "";
    }

}

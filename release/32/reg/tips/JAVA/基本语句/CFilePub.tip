package codec;

import java.io.UnsupportedEncodingException;

public class CCodecPub {
    //源码是UTF-8，编码成GBK
    static public String UTF8ToGBK(String textContent)
    {
        try {
            return new String(textContent.getBytes("GBK"), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return e.toString();
        }
    }

    //源码是ISO-8859-1，编码成GBK
    static public String ISOToGBK(String textContent)
    {
        try {
            return new String(textContent.getBytes("GBK"), "ISO-8859-1");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return e.toString();
        }
    }

    //源码是ISO-8859-1，编码成UTF-8
    static public String ISOToUTF8(String textContent)
    {
        try {
            return new String(textContent.getBytes("UTF-8"), "ISO-8859-1");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return e.toString();
        }
    }

    //源码是UTF-8，编码成ISO-8859-1
    static public String UTF8ToISO(String textContent)
    {
        try {
            return new String(textContent.getBytes("ISO-8859-1"), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return e.toString();
        }
    }


}

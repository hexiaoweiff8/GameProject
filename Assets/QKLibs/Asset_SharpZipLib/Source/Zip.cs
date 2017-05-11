using ICSharpCode.SharpZipLib;
using ICSharpCode.SharpZipLib.GZip;
using System.IO;
using System.Text;
using MonoEX;
public class Zip
{
    /// <summary>
    /// Ñ¹Ëõ×Ö½ÚÁ÷
    /// </summary>
    public static byte[] Compress(byte[] buffer)
    {
        using (MemoryStream ms = new MemoryStream())
        {
            using (GZipOutputStream gzip = new GZipOutputStream(ms))
                gzip.Write(buffer, 0, buffer.Length);

            return ms.ToArray();
        }
    }

    /// <summary>
    /// Ñ¹Ëõ×Ö·û´®
    /// </summary>
    public static byte[] Compress(string str)
    {
        return Compress(Encoding.UTF8.GetBytes(str));
    }


    /// <summary>
    /// ½âÑ¹ËõÎª×Ö½ÚÁ÷
    /// </summary> 
    public static byte[] Decompress(byte[] bytes)
    {
        using (GZipInputStream gzi = new GZipInputStream(new MemoryStream(bytes)))
        {
            using (MemoryStream re = new MemoryStream())
            {
                int count = 0;
                while ((count = gzi.Read(TempBuff.Buffer1024, 0, TempBuff.Buffer1024.Length)) != 0)
                    re.Write(TempBuff.Buffer1024, 0, count);

                return re.ToArray();
            }
        }
    }

    /// <summary>
    /// ½âÑ¹ËõÎª×Ö·û´®
    /// </summary> 
    public static void Decompress(byte[] bytes, out string out_string)
    {
        var buff = Decompress(bytes);
        out_string = Encoding.UTF8.GetString(buff);
    } 
}




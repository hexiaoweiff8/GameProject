
using System.Text;
using System.IO;
using System;
using System.Security.Cryptography;
using UnityEngine;
using MonoEX;

//解密方法
public class DefsDate
{
    private static string crykey = "qwertyuiop";
    private static byte[] Keys = { 0x41, 0x72, 0x65, 0x79, 0x6F, 0x75, 0x6D, 0x79,
                                             0x53,0x6E, 0x6F, 0x77, 0x6D, 0x61, 0x6E, 0x3F };

    private static string dncrykey = "";
    private static string Dncrykey
    {
        get {
            if (dncrykey == "")
            {
                dncrykey = GetSubString(crykey, 0, 32, "");
                dncrykey = dncrykey.PadRight(32, ' ');
            }
            return dncrykey; 
        }
    }

    /// <summary>
    /// 判定是否为assetbundle包
    /// </summary>
    public static bool bundleJudge(byte[] InputFile)
    {
        if (InputFile.Length < 5) return false;//文件长度不足，肯定不是一个加密包

        return InputFile[0] != 'U' || InputFile[1] != 'n' || InputFile[2] != 'i' || InputFile[3] != 't' || InputFile[4] != 'y';
    }

    /// <summary>
    /// 内存中将字节数组解密 需要与加密秘钥相同
    /// </summary>
    public static bool SupDecToStream(byte[] inout_InputFile)
    {
        try
        {
            using (MemoryStream fr = new MemoryStream(inout_InputFile))
            {

                using (RijndaelManaged rijndaelProvider = new RijndaelManaged())
                {
                    rijndaelProvider.Key = Encoding.UTF8.GetBytes(Dncrykey);
                    rijndaelProvider.IV = Keys;

                    ICryptoTransform Decrypto = rijndaelProvider.CreateDecryptor();
                    using (CryptoStream Defr = new CryptoStream(fr, Decrypto, CryptoStreamMode.Read))
                    {
                        int sizeCount = Math.Min(inout_InputFile.Length, 1024);//计算需要解密的字节数
                        Defr.Read(TempBuff.Buffer1024, 0, sizeCount);//解密到公共临时缓存，减少GC
                        Buffer.BlockCopy(TempBuff.Buffer1024, 0, inout_InputFile, 0, sizeCount);
                    }
                }
            }
        }
        catch
        {
            //文件异常
            return false;
        }
        return true;
    }


    /// <summary>
    /// 按字节长度(按字节,一个汉字为2个字节)取得某字符串的一部分 补齐密码
    /// </summary>
    /// <param name="sourceString">源字符串</param>
    /// <param name="startIndex">索引位置，以0开始</param>
    /// <param name="length">所取字符串字节长度</param>
    /// <param name="tailString">附加字符串(当字符串不够长时，尾部所添加的字符串，一般为"...")</param>
    /// <returns>某字符串的一部分</returns>mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    private static string GetSubString(string sourceString, int startIndex, int length, string tailString)
    {
        string myResult = sourceString;

        //当是日文或韩文时(注:中文的范围:\u4e00 - \u9fa5, 日文在\u0800 - \u4e00, 韩文为\xAC00-\xD7A3)
        if (System.Text.RegularExpressions.Regex.IsMatch(sourceString, "[\u0800-\u4e00]+") ||
            System.Text.RegularExpressions.Regex.IsMatch(sourceString, "[\xAC00-\xD7A3]+"))
        {
            //当截取的起始位置超出字段串长度时
            if (startIndex >= sourceString.Length)
            {
                return string.Empty;
            }
            else
            {
                return sourceString.Substring(startIndex,
                    ((length + startIndex) > sourceString.Length) ? (sourceString.Length - startIndex) : length);
            }
        }

        //中文字符，如"中国人民abcd123"
        if (length <= 0)
        {
            return string.Empty;
        }
        byte[] bytesSource = Encoding.Default.GetBytes(sourceString);

        //当字符串长度大于起始位置
        if (bytesSource.Length > startIndex)
        {
            int endIndex = bytesSource.Length;

            //当要截取的长度在字符串的有效长度范围内
            if (bytesSource.Length > (startIndex + length))
            {
                endIndex = length + startIndex;
            }
            else
            {   //当不在有效范围内时,只取到字符串的结尾
                length = bytesSource.Length - startIndex;
                tailString = "";
            }

            int[] anResultFlag = new int[length];
            int nFlag = 0;
            //字节大于127为双字节字符
            for (int i = startIndex; i < endIndex; i++)
            {
                if (bytesSource[i] > 127)
                {
                    nFlag++;
                    if (nFlag == 3)
                    {
                        nFlag = 1;
                    }
                }
                else
                {
                    nFlag = 0;
                }
                anResultFlag[i] = nFlag;
            }
            //最后一个字节为双字节字符的一半
            if ((bytesSource[endIndex - 1] > 127) && (anResultFlag[length - 1] == 1))
            {
                length = length + 1;
            }

            byte[] bsResult = new byte[length];
            Array.Copy(bytesSource, startIndex, bsResult, 0, length);
            myResult = Encoding.Default.GetString(bsResult);
            myResult = myResult + tailString;

            return myResult;
        }

        return string.Empty;

    }
}

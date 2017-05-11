using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
//using MonoEX;
namespace YQ2Common.CSecurity
{
    public static class CSafeData
    {

        // 默认密钥向量
        private static byte[] Keys = { 0x21, 0x57, 0x39, 0x64, 0x82, 0x41, 0x76, 0xDE, 0xFC, 0xFA, 0xD6 };

        // 默认密钥
        private static char[] DefaultKey = { 'F', '%', 'K', '#', '$','A','B','.' };

        /// <summary>
        /// 安全转码
        /// </summary>
        /// <param name="content"></param>
        /// <returns></returns>
        public static byte[] SecEncode(string content)
        {
            content = EncryptDES(content, new String(DefaultKey));

            return Zip.Compress(content);
            //byte[] tempBytes = Encoding.UTF8.GetBytes(content);
            //return LZMA.Compress(tempBytes, 0, tempBytes.Length, 0);
        }

        /// <summary>
        /// 安全解码
        /// </summary>
        /// <param name="content"></param>
        /// <returns></returns>
        public static string SecDecode(byte[] content)
        {
            //byte[] tempBytes = LZMA.Decompress(content, 0);
            //string tempResult = Encoding.UTF8.GetString(tempBytes);
            string tempResult; Zip.Decompress(content, out tempResult);
            return DecryptDES(tempResult, new String(DefaultKey));
        }

        /// <summary>
        /// DES加密字符串
        /// </summary>
        /// <param name="encryptString">待加密的字符串</param>
        /// <param name="encryptKey">加密密钥,要求为8位</param>
        /// <returns>加密成功返回加密后的字符串，失败返回源串</returns>
        public static string EncryptDES(string encryptString, string encryptKey)
        {
            try
            {
                byte[] rgbKey = Encoding.UTF8.GetBytes(encryptKey.Substring(0, 8));
                byte[] rgbIV = Keys;
                byte[] inputByteArray = Encoding.UTF8.GetBytes(encryptString);
                DESCryptoServiceProvider dCSP = new DESCryptoServiceProvider();
                MemoryStream mStream = new MemoryStream();
                CryptoStream cStream = new CryptoStream(mStream, dCSP.CreateEncryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
                cStream.Write(inputByteArray, 0, inputByteArray.Length);
                cStream.FlushFinalBlock();
                return Convert.ToBase64String(mStream.ToArray());
            }
            catch
            {
                return encryptString;
            }
        }

        /// <summary>
        /// DES解密字符串
        /// </summary>
        /// <param name="decryptString">待解密的字符串</param>
        /// <param name="decryptKey">解密密钥,要求为8位,和加密密钥相同</param>
        /// <returns>解密成功返回解密后的字符串，失败返源串</returns>
        public static string DecryptDES(string decryptString, string decryptKey)
        {
            try
            {
                byte[] rgbKey = Encoding.UTF8.GetBytes(decryptKey);
                byte[] rgbIV = Keys;
                byte[] inputByteArray = Convert.FromBase64String(decryptString);
                DESCryptoServiceProvider DCSP = new DESCryptoServiceProvider();
                MemoryStream mStream = new MemoryStream();
                CryptoStream cStream = new CryptoStream(mStream, DCSP.CreateDecryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
                cStream.Write(inputByteArray, 0, inputByteArray.Length);
                cStream.FlushFinalBlock();
                return Encoding.UTF8.GetString(mStream.ToArray());
            }
            catch
            {
                return decryptString;
            }
        } 
    }

}

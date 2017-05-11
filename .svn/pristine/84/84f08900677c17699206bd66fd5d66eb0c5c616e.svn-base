using System;
using System.Text;
using System.Security.Cryptography;
using System.IO;

namespace YQ2Common.CSecurity
{
    /// <summary>
    /// 扩展类
    /// </summary>
    public static class ExtendsCalss
    {
        /// <summary>
        /// 试着转64位编码
        /// </summary>
        public static string TryToBase64String(this string source)
        {
            return Convert.ToBase64String(Encoding.UTF8.GetBytes(source));
        }

        /// <summary>
        /// 试着64位解码
        /// </summary>
        public static string TryFromBase64String(this string encodeString)
        {
            return Encoding.UTF8.GetString(Convert.FromBase64String(encodeString));
        }

        /// <summary>
        /// MD5序列化
        /// </summary>
        public static string TryToMD5(this string str )
        {
            byte[] Bytes = Encoding.UTF8.GetBytes(str);

            using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider())
            {
                byte[] result = md5.ComputeHash(Bytes);

                StringBuilder sb = new StringBuilder();

                for (int i = 0; i < result.Length; i++)

                    sb.Append(result[i].ToString("x2"));

                return sb.ToString();
            }
        }
    }

    public class CRSA
    {
        /*
         *   .NET Framework 中提供的 RSA 算法规定：
　　     *      待加密的字节数不能超过密钥的长度值除以 8 再减去 11（即：RSACryptoServiceProvider.KeySize / 8 - 11）;
         *      而加密后得到密文的字节数，正好是密钥的长度值除以 8（即：RSACryptoServiceProvider.KeySize / 8）。
         * 
         */

        /// <summary>
        /// 生成密钥
        /// </summary>
        /// <param name="publicKey">公钥</param>
        /// <param name="privateKey">私钥</param>
        public static void BuildKey(out string publicKey,out string privateKey)
        {
            RSACryptoServiceProvider tProvider = new RSACryptoServiceProvider();
            publicKey = tProvider.ToXmlString(false);
            privateKey = tProvider.ToXmlString(true);
        }

        /// <summary>
        /// 加密明文内容
        /// </summary>
        /// <param name="publicKey">公钥</param>
        /// <param name="content">明文内容</param>
        /// <returns>密文</returns>
        public static string Encode(string publicKey, string content)
        {
            try 
            {
                using (RSACryptoServiceProvider crypt = new RSACryptoServiceProvider())
                {
                    crypt.FromXmlString(publicKey);
                    int maxBlockSize = crypt.KeySize / 8 - 11; // 最大加密块长度

                    Byte[] contentBlock = Encoding.UTF8.GetBytes(content);

                    using (MemoryStream contentStream = new MemoryStream(contentBlock)) // 源数据
                    {
                        using (MemoryStream encodeStream = new MemoryStream()) // 加密后的数据
                        {
                            if (contentBlock.Length <= maxBlockSize)
                            {
                                Byte[] encodBlock = crypt.Encrypt(contentBlock, false); // 加密后的数据块
                                encodeStream.Write(encodBlock, 0, encodBlock.Length);
                            }
                            else
                            {
                                Byte[] tBlock = new Byte[maxBlockSize]; // 以 “最大加密块长度” 分块加密
                                int readSize = contentStream.Read(tBlock, 0, maxBlockSize);
                                while (readSize > 0)
                                {
                                    Byte[] needEncodeBlock = new Byte[readSize]; // 有效数据块
                                    Array.Copy(tBlock, 0, needEncodeBlock, 0, readSize); // 读取有效数据
                                    Byte[] encodBlock = crypt.Encrypt(needEncodeBlock, false); // 加密后的数据块
                                    encodeStream.Write(encodBlock, 0, encodBlock.Length);

                                    readSize = contentStream.Read(tBlock, 0, maxBlockSize); // 递进
                                }
                            }

                            return Convert.ToBase64String(encodeStream.ToArray(), Base64FormattingOptions.None); // 64位编码的字符串
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 解密密文内容
        /// </summary>
        /// <param name="privateKey">私钥</param>
        /// <param name="content">密文内容</param>
        /// <returns>明文</returns>
        public static string Decode(string privateKey, string content)
        {
            try
            {
                using (RSACryptoServiceProvider crypt = new RSACryptoServiceProvider())
                {
                    crypt.FromXmlString(privateKey);
                    int maxBlockSize = crypt.KeySize / 8; // 最大解密块长度
                    Byte[] contentBlock = Convert.FromBase64String(content); // 待解密数据块

                    using (MemoryStream contentStream = new MemoryStream(contentBlock)) // 待解密数据流
                    {
                        using (MemoryStream decodeStream = new MemoryStream()) // 解密后的数据流
                        {
                            if (contentBlock.Length <= maxBlockSize)
                            {
                                Byte[] decodeBlock = crypt.Decrypt(contentBlock, false);
                                decodeStream.Write(decodeBlock, 0, decodeBlock.Length);
                            }
                            else
                            {
                                Byte[] tBlock = new Byte[maxBlockSize]; // 以 “最大解密块长度” 分块解密
                                int readSize = contentStream.Read(tBlock, 0, maxBlockSize);
                                while (readSize > 0)
                                {
                                    Byte[] needDecodeBlock = new Byte[readSize]; // 有效数据块
                                    Array.Copy(tBlock, 0, needDecodeBlock, 0, readSize); // 读取有效数据
                                    Byte[] decodBlock = crypt.Decrypt(needDecodeBlock, false); // 解密后的数据块
                                    decodeStream.Write(decodBlock, 0, decodBlock.Length);

                                    readSize = contentStream.Read(tBlock, 0, maxBlockSize); // 递进
                                }
                            }
                            return Encoding.UTF8.GetString(decodeStream.ToArray());
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                throw ex;
            }
        }

    }
}

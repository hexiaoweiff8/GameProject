using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
 
public class QKEncoding
{
    public const string LoginToken = "_I6342CCWK_QK@1465";
     
    public static string MD5(string v)
    {
        string a = BitConverter.ToString(m_Md5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(v)));
        a = a.Replace("-", "");
        return a.ToLower();
    }

    public static string BuildCKey(string ckey)
	{ 

        int len = ckey.Length;
        char[] nkey = new char[len];

		for(int i=0;i<len;i++)
		{
			nkey[i] = ckey[(i + 5) % len];
		}
         

        return MD5(LoginToken + new String( nkey) );
	}
    

    static MD5CryptoServiceProvider m_Md5 = new MD5CryptoServiceProvider();
}


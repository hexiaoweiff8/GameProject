using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.IO;

public class DebugConfig {

	public string GetConfig(string key)
	{
		if (mConfig.ContainsKey (key)) {
			return mConfig [key];
		}
		return string.Empty;
	}

	public static DebugConfig Single
	{
		get
		{
			if (null == mSingle) {
				mSingle = new DebugConfig ();
			}

			mSingle.ReLoad ();

			return mSingle;
		}
	}

	void ReLoad()
	{
		mConfig.Clear ();
		if (File.Exists ("DebugConfig.inl")) {

			string[] lines = File.ReadAllLines ("DebugConfig.inl");
			foreach (string line in lines) {

				string[] kv = line.Split (':');
				mConfig.Add (kv [0], kv [1]);
			}
		}
	}

	DebugConfig()
	{
		
	}

	Dictionary<string,string> mConfig = new Dictionary<string, string> ();

	static DebugConfig mSingle = null;
}

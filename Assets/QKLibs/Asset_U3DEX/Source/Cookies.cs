using System;
using System.Collections.Generic;
using UnityEngine;

public class Cookies
{
    static public bool HasKey(string key)
    {
        return PlayerPrefs.HasKey(key);
    }

    static public void SetInt(string key, int v)
    {
        PlayerPrefs.SetInt(key, v);
    }

    static public void SetFloat(string key, float v)
    {
        PlayerPrefs.SetFloat(key, v);
    }

    static public void SetString(string key, string v)
    {
        PlayerPrefs.SetString(key, v);
    }

    static public float GetFloat(string key)
    {
        return PlayerPrefs.GetFloat(key);
    }

    static public int GetInt(string key)
    {
        return PlayerPrefs.GetInt(key);
    }

    static public string GetString(string key)
    {
        return PlayerPrefs.GetString(key);
    }

    static public void Delete(string key)
    {
        PlayerPrefs.DeleteKey(key);
    }

    static public void Save()
    {
        PlayerPrefs.Save();
    }
}

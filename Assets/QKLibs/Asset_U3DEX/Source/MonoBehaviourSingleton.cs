using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class MonoBehaviourSingleton<T>:MonoBehaviour where T:class
{
    protected MonoBehaviourSingleton()  {  _Single = this as T;  }

    public static T Single { get { return _Single; } }
    static T _Single = null;
} 

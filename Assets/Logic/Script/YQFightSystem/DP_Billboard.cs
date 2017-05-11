 

using UnityEngine;
using System.Collections;

public class DP_Billboard : MonoBehaviour
{
    public Camera EyeCamera;  //相机

    //public float rotation_x = 0;
     
    void Start()
    {
      //  Quaternion m_r = Quaternion.Euler (rotation_x, 0, 0);
        transform.rotation = EyeCamera.transform.rotation;// *m_r; 
    }
    /*
    void OnEnable ()
    {
        CoroutineManage.Single.RegComponentUpdate(IUpdate);
    }
     
	void IUpdate () {
        if (!(bool)this) return;

        
	}

    void OnDestroy()
    {
        CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
    }*/

    
    Quaternion direction;  
}

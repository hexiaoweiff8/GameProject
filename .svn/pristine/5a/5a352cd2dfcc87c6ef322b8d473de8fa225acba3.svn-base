using UnityEngine;
using System.Collections;

public class CMBillboard : MonoBehaviour {
	
    public Vector3 Normal = new Vector3(0, 0, 1);  //本地法线
    public Camera EyeCamera;  //相机

    void OnEnable ()
    {
        CoroutineManage.Single.RegComponentUpdate(IUpdate);
    }

	void Start () { 
        //GameObject cameraObj = GameObject.Find("/Main Camera");
        //m_camera = cameraObj.GetComponent<Camera>();
		direction=Quaternion.FromToRotation (new Vector3 (0, 0, 1), Normal);
        
	}
	
	// Update is called once per frame
	void IUpdate () {
        if (!(bool)this) return;
       
        transform.rotation = EyeCamera.transform.rotation * direction; 
	}

    void OnDestroy()
    {
        CoroutineManage.Single.UnRegComponentUpdate(IUpdate);
    }

    
    Quaternion direction;  
}

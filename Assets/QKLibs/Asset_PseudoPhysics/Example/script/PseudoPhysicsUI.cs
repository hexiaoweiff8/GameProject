using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
public class PseudoPhysicsUI : MonoBehaviour {

	// Use this for initialization
	void Start () {
	     
	}
	
	// Update is called once per frame
	void Update () {
	
	}

   public void OnClick()
    {
        //if(GUILayout.Button("震动"))
        {
            ShakeManage skm = GameObject.FindObjectOfType<ShakeManage>();
            skm.Shake("testShake",0.3f);
        }
    }
}

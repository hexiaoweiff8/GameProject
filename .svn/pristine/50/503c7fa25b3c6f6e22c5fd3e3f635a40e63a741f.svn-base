using UnityEngine;
using System.Collections;
using QKFrameWork.CQKCommand;

public class QKSDKDemo : MonoBehaviour {

    public void OnShowLogin()
    {
        QKCommand tempCommand = new QKCommand("ShowLoginUI");
        tempCommand.Send();
    }

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    void Awake()
    {
        CoroutineManage.AutoInstance();
    }
}

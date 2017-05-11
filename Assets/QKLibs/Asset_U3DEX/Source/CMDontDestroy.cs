using UnityEngine;
using System.Collections;

//绑定该脚本的对象，切换场景时不被销毁
public class CMDontDestroy : MonoBehaviour {

	// Use this for initialization
	void Start () {
		UnityEngine.GameObject.DontDestroyOnLoad (gameObject);
	} 
}

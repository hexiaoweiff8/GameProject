using UnityEngine;
using System.Collections;

/// <summary>
/// UITextList内容填充组件
/// </summary>
[AddComponentMenu("QK/UI/UITextListContent")]
[RequireComponent(typeof(UITextList))]
public class UITextListContent : MonoBehaviour
{
    [SerializeField]
    [HideInInspector] 
    public  string mText;

	// Use this for initialization
	void Start () {
        if (string.IsNullOrEmpty(mText)) return;

        UITextList uilist = GetComponent<UITextList>();
        string[] lines = mText.Split('\n');
        foreach(string line in lines)
        {
            uilist.Add(line);
        }
	}
	
	 
}

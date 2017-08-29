using System.Linq;
using DG.Tweening;
using UnityEngine;

public class UIFollowMe : MonoBehaviour
{
    private GameObject  uitag;
    private Camera      _sceneCamera;
    private Camera      _uiCamera;
    private Quaternion  _lastViewRotation;
    public Transform    FollowTargetPosition;

	void Start () {
        _sceneCamera = (from cam in Camera.allCameras where cam.tag == "MainSceneCamera" select cam).First();
        _uiCamera = Camera.allCameras.Where(cam =>{ return cam.tag == "UICamera";}).First();
        uitag = NGUITools.AddChild(_uiCamera.transform.parent.gameObject, Resources.Load("UITag"));
	    uitag.name = "tag_" + gameObject.name;
	    uitag.GetComponent<UILabel>().text = gameObject.name;
	    uitag.transform.localScale = Vector3.one;

        _sceneCamera.GetComponent<CameraController>().Add_OnCameraToggle2Moving_EventListener(HandleOnCameraToggle2Moving);
        _sceneCamera.GetComponent<CameraController>().Add_OnCameraToggle2Static_EventListener(HandleOnOnCameraToggle2Static);
    }

    private void HandleOnCameraToggle2Moving()
    {
        DOAlphaTo(uitag.GetComponent<UILabel>(), 0);
    }

    private void HandleOnOnCameraToggle2Static()
    {
        DOAlphaTo(uitag.GetComponent<UILabel>(), 1);
    }

    void Update()
	{
        if (_lastViewRotation == _sceneCamera.transform.rotation)
            return;

        Vector3 screenPos = _sceneCamera.WorldToScreenPoint(FollowTargetPosition.transform.position);

        Vector3 uiscreenPos = _uiCamera.ScreenToWorldPoint(screenPos);

        uitag.transform.position = uiscreenPos;

        _lastViewRotation = _sceneCamera.transform.rotation;
	}

    private Tween DOAlphaTo(UIWidget widget,float endValue)
    {
        return DOTween.ToAlpha(() => widget.color, newColor => widget.color = newColor, endValue, 0.5f);
    }
}

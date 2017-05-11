using UnityEngine;
using System.Collections;

[RequireComponent(typeof(UICamera))]
class UICameraAdjustor : MonoBehaviour
{
    // the design size
    public float standard_width = 1024;
    public float standard_height = 768;
    // the screen size
    float device_width = 0f;
    float device_height = 0f;
    void Awake()
    {
        device_width = Screen.width;
        device_height = Screen.height;
        SetCameraSize();
    }

    private void SetCameraSize()
    {
        float adjustor = 0f;
        float standard_aspect = standard_width / standard_height;
        float device_aspect = device_width / device_height;
        //print("standard_aspect= " + standard_aspect + "\t device_aspect= " + device_aspect);
        Camera camera = GetComponent<Camera>();
        if (device_aspect < standard_aspect)
        {
            adjustor = standard_aspect / device_aspect;
            camera.orthographicSize = adjustor;
            //print ("set camera size =" + adjustor);
        }
        camera.orthographicSize *= 1.57f;
    }
}
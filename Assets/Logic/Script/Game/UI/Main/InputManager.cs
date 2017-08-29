using UnityEngine;

public delegate void MouseMoved(float xMovement, float yMovement);
public delegate void FingerMoved(float xMovement, float yMovement);

public class InputManager : MonoBehaviour
{
    #region Private References
    private float _xMovement;
    private float _yMovement;
    #endregion

    #region Events
    public static event MouseMoved MouseMoved;
    public static event FingerMoved FingerMoved;
    #endregion

    #region Event Invoker Methods
    private static void OnMouseMoved(float xmovement, float ymovement)
    {
        var handler = MouseMoved;
        if (handler != null) handler(xmovement, ymovement);
    }

    private static void OnFingerMoved(float xmovement, float ymovement)
    {
        var handler = FingerMoved;
        if (handler != null) handler(xmovement, ymovement);
    }
    #endregion

    #region Private Methods
    private void InvokeActionOnInput()
    {
#if UNITY_EDITOR
        if (Input.GetMouseButton(0))
        {
            _xMovement = Input.GetAxis("Mouse X");
            _yMovement = Input.GetAxis("Mouse Y");
            OnMouseMoved(_xMovement, _yMovement);
        }
#endif
#if UNITY_ANDROID
        if (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Moved)
        {
            _xMovement = -Input.GetAxis("Mouse X");
            _yMovement = Input.GetAxis("Mouse Y");
            OnFingerMoved(_xMovement, _yMovement);
        }
#endif
    }
    #endregion

    #region Unity CallBacks

    void Update()
    {
        InvokeActionOnInput();
    }
#endregion
}

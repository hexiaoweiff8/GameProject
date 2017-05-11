using UnityEngine;
using System.Collections;


[RequireComponent(typeof(UIWidget))]
[AddComponentMenu("QK/UI/UICompositeButton")]
public class UICompositeButton : MonoBehaviour
{
    public GameObject hover;
    public GameObject pressed;
    public GameObject disabled;
    public GameObject normal;
    public State  CurrState = State.normal;  

    void Start()
    { 
        isEnabled = isEnabled;//刷新外观
    } 

    void UpdateFace()
    {
        if (normal == null) return;

        bool normal_v = false;
        bool hover_v = false;
        bool pressed_v = false;
        bool disabled_v = false;


        switch (CurrState)
        {
            case State.normal:
                normal_v = true;
                break;
            case State.hover:
                if (hover != null)
                    hover_v = true;
                else
                    normal_v = true;
                break;
            case State.pressed:
                if (pressed != null)
                    pressed_v = true;
                else
                    normal_v = true;
                break;
            case State.disabled:
                if (disabled != null)
                    disabled_v = true;
                else
                    normal_v = true;
                break;
        };

        normal.SetActive(normal_v);
        hover.SetActive(hover_v);
        pressed.SetActive(pressed_v);
        disabled.SetActive(disabled_v);

    }

    public bool isEnabled
    {
        get { return CurrState != State.disabled; }
        set {
            if (isEnabled)
            {
                if (CurrState == State.disabled) CurrState = State.normal;
            }
            else
                CurrState = State.disabled;

            UpdateFace();
        }
    }



    protected virtual void OnDragOver ( )
    {
        if (!isEnabled) return;
        CurrState = State.pressed;
        UpdateFace();
    }

    protected virtual void OnDragOut ( )
    {
        if (!isEnabled) return;

        CurrState = State.normal;
        UpdateFace();
    }

    virtual protected void OnPress( bool isPressed)
    {
        if (!isEnabled) return;

        CurrState = isPressed ? State.pressed : State.hover;
        UpdateFace();
    }

    virtual protected void OnHover( bool isOver)
    {
        if (!isEnabled) return;

        CurrState = isOver ? State.hover : State.normal;
        UpdateFace();
    }

    public enum State
    {
        hover,
        pressed,
        normal,
        disabled,
    }
   
}

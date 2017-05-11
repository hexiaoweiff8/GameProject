 

using UnityEngine;
using System.Collections;
using System;

[RequireComponent(typeof(TransformMixer))]
public class PseudoPhysicsCameraCtrl : MonoBehaviour
{

    void Awake()
    {
          m_TransformMixer = GetComponent<TransformMixer>();
    }

    //public    GameObject mcamera;
    // Use this for initialization
    void Start()
    { 
        EasyTouch.On_TouchDown += OnTouchDownHandler;
        EasyTouch.On_TouchUp += OnTouchUpHandler;
         

        EasyTouch.On_PinchIn += OnPinchIn;
        EasyTouch.On_PinchOut += OnPinchOut; 

        m_ScrollObject = GetComponent<BoxScrollObject>(); 
         
    }
     

    void OnPinchIn(Gesture gesture)
    {
        
        Vector3 pos = m_ScrollObject.ScrollLogicPosition;
        Vector3 dir = (m_TransformMixer.MainRotationTransform.Value * Vector3.forward).normalized;
        pos += dir * gesture.deltaPinch * TouchScale;
        if (pos.y > 0.5) m_ScrollObject.MoveTo(pos);
         
    }

    void OnPinchOut(Gesture gesture)
    {
        Vector3 pos = m_ScrollObject.ScrollLogicPosition;

        Vector3 dir = (m_TransformMixer.MainRotationTransform.Value * Vector3.forward).normalized;
        pos += dir * -gesture.deltaPinch * TouchScale;
        if (pos.y > 0.5) m_ScrollObject.MoveTo(pos);
       
    }
     

    void OnTouchDownHandler(Gesture gesture)
    {
        if (gesture.touchCount == 2)
        {
            //Debug.Log(string.Format("pos:{0} startpos:{1} deltaPosition:{2}", gesture.position, gesture.startPosition, gesture.deltaPosition));
            Quaternion q = m_TransformMixer.MainRotationTransform.Value;
            Vector3 euler = q.eulerAngles;
            euler.x += gesture.deltaPosition.y * TouchScale;
            euler.x = Mathf.Clamp(euler.x, 0, 90);
            if (euler.x < 30) euler.x = 30;
            if (euler.x > 85) euler.x = 85;
            q .eulerAngles = euler;
            m_TransformMixer.MainRotationTransform.Value = q;
             
        }
        else
        {
            const float movescale = TouchScale;

            Vector3 localPos = m_ScrollObject.ScrollLogicPosition; 
            localPos.x += gesture.deltaPosition.x * movescale;
            localPos.z += gesture.deltaPosition.y * movescale;

            m_ScrollObject.MoveTo(localPos); 

        }
         
    }

    void OnTouchUpHandler(Gesture gesture)
    {
        m_ScrollObject.MoveEnd();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    const float TouchScale = 0.5f;

    BoxScrollObject m_ScrollObject;
    TransformMixer m_TransformMixer;
}

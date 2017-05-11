using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
[ExecuteInEditMode]
[RequireComponent(typeof(TransformMixer))]
public class RotationTransform : MonoBehaviour
{
    public string tag;
     
    void Awake()
    {
        m_owner = GetComponent<TransformMixer>();
    }

    void OnEnable()
    { 
        m_owner._RegTransform(this);
    }

    void OnDisable()
    {
        m_owner._UnregTransform(this);
    }

    public Quaternion Value
    {
        set
        {
            m_Rotation = value;
            m_owner._SetRotationChanged();
            if (OnValueChanged != null) OnValueChanged(this );
        }

        get { return m_Rotation; }
    }


    public event OnValueChangedDelegate OnValueChanged;

    public TransformMixer OwnerTransformMixer { get { return m_owner; } }

    [SerializeField]
    [HideInInspector]
    Quaternion m_Rotation = Quaternion.identity;
    TransformMixer m_owner;

    public delegate void OnValueChangedDelegate(RotationTransform self);
}

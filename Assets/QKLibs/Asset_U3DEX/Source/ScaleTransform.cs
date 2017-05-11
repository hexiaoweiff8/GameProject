﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
[ExecuteInEditMode]
[RequireComponent(typeof(TransformMixer))]
public class ScaleTransform : MonoBehaviour
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
   
    public Vector3 Value
    {
        set
        {
            m_Scale = value;
            m_owner._SetScaleChanged();
            if (OnValueChanged != null) OnValueChanged(this );
        }

        get { return m_Scale; }
    }


    public event OnValueChangedDelegate OnValueChanged;

    public TransformMixer OwnerTransformMixer { get { return m_owner; } }

    [SerializeField]
    [HideInInspector]
    Vector3 m_Scale = Vector3.one;
    TransformMixer m_owner;

    public delegate void OnValueChangedDelegate(ScaleTransform self);
}

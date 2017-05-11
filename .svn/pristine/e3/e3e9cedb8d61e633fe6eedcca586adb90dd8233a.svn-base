using System;
using UnityEngine;
using System.Collections;

public class Move : MonoBehaviour
{


    public float speed = 1;

    public float r = 10;



    private int counter = 0;


    void Update ()
	{
	    var angle = (float)counter / 360 * speed;

        transform.localPosition = new Vector3((float)Math.Sin(angle), (float)Math.Cos(angle), 0).normalized * r;
	    counter++;
	    if (angle >= 360 || angle < -360)
	    {
	        counter = 0;

	    }

	}
}

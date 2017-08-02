using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

class AI_Single : MonoEX.Singleton<AI_Single>
{
    public AI_Single()
    {
        Battlefield = new AI_Battlefield();
       
    }

    public readonly AI_Battlefield Battlefield;
}
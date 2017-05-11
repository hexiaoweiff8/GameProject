using UnityEngine;
using System.Collections;

public class BehindInfo {

    public AI_FightUnit LeftBehindX;//左军最后面一排位置
    public AI_ArmySquare LeftBehind;//左军最后面阵

    public AI_FightUnit RightBehindX;//右军最后面一排位置
    public AI_ArmySquare RightBehind;//右军最后面阵

    public void Reset()
    {
        LeftBehindX = RightBehindX = null;
        LeftBehind = RightBehind = null;
    }
}

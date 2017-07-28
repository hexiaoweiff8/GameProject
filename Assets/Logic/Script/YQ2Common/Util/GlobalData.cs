using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


/// <summary>
/// 全局数据
/// </summary>
public static class GlobalData
{

    /// <summary>
    /// 是否暂停游戏
    /// </summary>
    public static bool IsPause = false;

    /// <summary>
    /// 用户数据
    /// </summary>
    public static class UserData
    {

        /// <summary>
        /// 我方基地等级
        /// </summary>
        public static int BaseLevel = 1;

        /// <summary>
        /// 防御塔等级
        /// </summary>
        public static int TurretLevel = 1;

        /// <summary>
        /// 我方种族
        /// </summary>
        public static int Race = 0;

        /// <summary>
        /// 是否已经设置数据
        /// 如果该标志位false则不能使用
        /// </summary>
        public static bool IsSetData = false;
    }



    /// <summary>
    /// 战斗数据
    /// </summary>
    public static class FightData
    {
        /// <summary>
        /// 我方基地等级
        /// </summary>
        public static int BaseLevel = 1;

        /// <summary>
        /// 防御塔等级
        /// </summary>
        public static int TurretLevel = 1;

        /// <summary>
        /// 我方种族
        /// </summary>
        public static int Race = 0;

        /// <summary>
        /// 敌方基地等级
        /// </summary>
        public static int EnemyBaseLevel = 1;

        /// <summary>
        /// 敌方防御塔等级
        /// </summary>
        public static int EnemyTurretLevel = 1;

        /// <summary>
        /// 敌方种族
        /// </summary>
        public static int EnemyRace = 0;

        /// <summary>
        /// 地图Id
        /// </summary>
        public static int MapId = -1;

        /// <summary>
        /// 是否已经设置数据
        /// 如果该标志位false则不能使用
        /// </summary>
        public static bool IsSetData = false;

        /// <summary>
        /// 是否在线战斗
        /// </summary>
        public static bool IsOnline = false;


        /// <summary>
        /// 设置数据
        /// </summary>
        /// <param name="baseLevel">我方基地等级</param>
        /// <param name="turretLevel">防御塔等级</param>
        /// <param name="race">我方种族</param>
        /// <param name="enemyBaseLevel">敌方基地等级</param>
        /// <param name="enemyTurretLevel">敌方防御塔等级</param>
        /// <param name="enemyRace">敌方种族</param>
        /// <param name="mapId">地图Id</param>
        public static void SetData(int baseLevel, int turretLevel, int race, int enemyBaseLevel, int enemyTurretLevel, int enemyRace, int mapId)
        {
            BaseLevel = baseLevel;
            TurretLevel = turretLevel;
            Race = race;
            EnemyBaseLevel = enemyBaseLevel;
            EnemyTurretLevel = enemyTurretLevel;
            EnemyRace = enemyRace;
            MapId = mapId;
        }

        /// <summary>
        /// 清空数据
        /// </summary>
        public static void Clear()
        {
            BaseLevel = 1;
            Race = 0;
            EnemyBaseLevel = 1;
            EnemyRace = 0;
            MapId = -1;
            IsSetData = false;
        }
    }
}
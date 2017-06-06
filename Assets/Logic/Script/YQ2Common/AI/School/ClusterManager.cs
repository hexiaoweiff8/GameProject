using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 集群管理
/// 集群行为都在这里集中实现
/// </summary>
public class ClusterManager : ILoopItem
{

    public static ClusterManager Single
    {
        get
        {
            if (single == null)
            {
                single = new ClusterManager();
                looperNum = LooperManager.Single.Add(single);
            }
            return single;
        }
    }


    private static ClusterManager single = null;

    // -------------------------公有属性-------------------------------
    public Vector3 MovementPlanePosition;


    public float MovementWidth;


    public float MovementHeight;
    
    /// <summary>
    /// 判定前方角度
    /// 在单位前方ForwardAngle角度内为该单位forward
    /// </summary>
    public float ForwardAngle = 90;

    /// <summary>
    /// 碰撞拥挤权重
    /// </summary>
    public float CollisionWeight = 5f;

    ///// <summary>
    ///// 碰撞挤开系数
    ///// </summary>
    public float CollisionThrough = 10f;

    /// <summary>
    /// 摩擦力系数
    /// </summary>
    public float Friction = 5;

    /// <summary>
    /// 单位格子宽度
    /// </summary>
    public int UnitWidth = 1;

    ///// <summary>
    ///// 组列表(全局)
    ///// </summary>
    //public static List<ClusterGroup> GroupList = new List<ClusterGroup>();


    // -------------------------私有属性-------------------------------

    /// <summary>
    /// 极限速度
    /// </summary>
    private float upTopSpeed = 100f;

    /// <summary>
    /// 目标列表
    /// </summary>
    private TargetList<PositionObject> targetList;


    /// <summary>
    /// 已对比碰撞对象ID的列表
    /// </summary>
    private Dictionary<long, bool> areadyCollisionList = new Dictionary<long, bool>();


    /// <summary>
    /// 暂停标志
    /// </summary>
    private bool pause = false;

    /// <summary>
    /// 是否停止标志
    /// </summary>
    private bool isStop = false;

    /// <summary>
    /// 在循环器中的ID编号
    /// </summary>
    private static long looperNum = -1;

    // -----------------------------公有方法------------------------------


    /// <summary>
    /// 单次循环
    /// </summary>
    public void Do()
    {
        if (targetList != null)
        {
            // 刷新四叉树
            targetList.Refresh();
            // 刷新地图对应位置
            targetList.RebulidMapInfo();
            // 单位移动
            AllMemberMove(targetList.List);
            // 绘制四叉树
            DrawQuadTreeLine(targetList.QuadTree);
        }
    }

    /// <summary>
    /// 是否执行完毕
    /// </summary>
    /// <returns>是否执行结束标志</returns>
    public bool IsEnd()
    {
        return isStop;
    }

    /// <summary>
    /// 被销毁时执行
    /// </summary>
    public void OnDestroy()
    {
        // TODO 清空数据
        // 防止内存泄漏
    }




    /// <summary>
    /// 加入单位
    /// </summary>
    /// <param name="member">单位</param>
    public void Add(PositionObject member)
    {
        targetList.Add(member);
    }

    /// <summary>
    /// 删除对象
    /// </summary>
    /// <param name="member">被删除对象</param>
    public void Remove(PositionObject member)
    {
        targetList.Remove(member);
    }

    /// <summary>
    /// 初始化
    /// </summary>
    /// <param name="x">四叉树位置x</param>
    /// <param name="y">四叉树位置y</param>
    /// <param name="w">四叉树宽度</param>
    /// <param name="h">四叉树高度</param>
    /// <param name="unitw">地面单位格宽度</param>
    /// <param name="map">地图二维数据</param>
    public void Init(float x, float y, int w, int h, int unitw, int[][] map)
    {
        targetList = new TargetList<PositionObject>(x, y, w, h, unitw);
        targetList.MapInfo = new MapInfo<PositionObject>();
        targetList.MapInfo.AddMap(unitw, w, h, map);
        MovementHeight = h;
        MovementWidth = w;
        UnitWidth = unitw;
    }

    /// <summary>
    /// 清理现有对象
    /// </summary>
    //public static void ClearAllGroup()
    //{
    //    foreach (var group in GroupList)
    //    {
    //        group.CleanGroup();
    //    }
    //    GroupList.Clear();
    //}

    /// <summary>
    /// 暂停
    /// </summary>
    public void Pause()
    {
        pause = true;
    }

    /// <summary>
    /// 继续
    /// </summary>
    public void GoOn()
    {
        pause = false;
    }

    /// <summary>
    /// 停止并销毁该集群管理
    /// </summary>
    private void Stop()
    {
        ClearAll();
        isStop = true;
        LooperManager.Single.Remove(looperNum);
        single = null;
    }


    /// <summary>
    /// 清除所有组
    /// </summary>
    public void ClearAll()
    {
        // 清除已有所有单元
        //foreach (var group in GroupList)
        //{
        //    group.CleanGroup();
        //}

        //if (GroupList != null)
        //{
        //    GroupList.Clear();
        //}
        if (targetList != null)
        {
            targetList.Clear();
        }
    }

    ///// <summary>
    ///// 根据ID查询group
    ///// </summary>
    ///// <param name="groupId">被查询groupId</param>
    ///// <returns>返回查询到的groupId 如果不存在则返回null</returns>
    //public ClusterGroup GetGroupById(int groupId)
    //{
    //    for (var i = 0; i < GroupList.Count; i++)
    //    {
    //        var tmpGroup = GroupList[i];
    //        if (tmpGroup.GroupId == groupId)
    //        {
    //            return tmpGroup;
    //        }
    //    }
    //    return null;
    //}

    /// <summary>
    /// 获取图形范围内的单位
    /// </summary>
    /// <param name="graphics">图形对象</param>
    /// <returns>范围内单位列表</returns>
    public IList<PositionObject> GetPositionObjectListByGraphics(ICollisionGraphics graphics)
    {
        if (targetList == null)
        {
            return null;
        }
        IList<PositionObject> result = targetList.QuadTree.GetScope(graphics);
        return result;
    } 

    // ------------------------私有方法--------------------------


    /// <summary>
    /// 所有成员判断组队行进与碰撞
    /// </summary>
    /// <param name="memberList">成员列表</param>
    private void AllMemberMove(IList<PositionObject> memberList)
    {
        // 验证数据有效性
        if (memberList == null || memberList.Count == 0 || pause)
        { return; }

        // 前方角度/2
        var cosForwardAngle = (float)Math.Cos(ForwardAngle / 2f);
        // 遍历所有成员
        for (var i = 0; i < memberList.Count; i++)
        {
            // 当前成员
            var member = memberList[i];
            if (member is ClusterData)
            {
                OneMemberMove(member as ClusterData, cosForwardAngle);
            }
            else if (member is FixtureData)
            {
                // 不移动
                // TODO 是否对周围产生斥力?
            }
        }

        // 清空对比列表
        areadyCollisionList.Clear();
    }

    /// <summary>
    /// 可移动单位移动
    /// </summary>
    /// <param name="member">单个单位</param>
    /// <param name="cosForwardAngle">前方角度</param>
    private void OneMemberMove(ClusterData member, float cosForwardAngle)
    {
        if (member == null || !member.IsMoving)
        {
            return;
        }
        // 单位状态切换
        ChangeMemberState(member);
        // 当前单位到目标的方向
        Vector3 targetDir = member.TargetPos - member.Position;
        // 转向角度
        float rotate = 0f;
        // 标准化目标方向
        Vector3 normalizedTargetDir = targetDir.normalized;
        // 计算后最终方向
        var finalDir = GetGroupGtivity(member, cosForwardAngle);
        Debug.DrawLine(member.Position, member.Position + finalDir, Color.cyan);
        // 当前方向与目标方向夹角
        var angleForTarget = Vector3.Dot(normalizedTargetDir, member.Direction);

        // 当前单位位置减去周围单位的位置的和, 与最终方向相加, 这个向量做处理, 只能指向目标方向的左右90°之内, 防止调头
        // 获取周围成员(不论敌友, 包括障碍物)的斥力引力
        // 直线移动防止抖动
        if (angleForTarget < 0.999f)
        {
            // 计算转向
            rotate = Vector3.Dot(finalDir.normalized, member.DirectionRight) * 180;
            if (rotate > 180 || rotate < -180)
            {
                rotate += ((int)rotate / 180) * 180 * (Mathf.Sign(rotate));
            }
        }


        // 转向
        member.Rotate = Vector3.up * rotate * member.RotateSpeed * Time.deltaTime;
        
        // 前进
        Debug.DrawLine(member.Position, member.Position + member.PhysicsInfo.SpeedDirection, Color.white);
        member.Position += member.PhysicsInfo.SpeedDirection * Time.deltaTime;
        GetCloseMemberGrivity2(member);
        // 速度由于摩擦力的原因衰减
        member.PhysicsInfo.SpeedDirection -= member.PhysicsInfo.SpeedDirection.normalized * Friction * Time.deltaTime;
        // TODO 最大速度限制, 方式有待确认
        var speed = member.PhysicsInfo.SpeedDirection.magnitude;
        if (speed > member.PhysicsInfo.MaxSpeed)
        {
            member.PhysicsInfo.SpeedDirection *= member.PhysicsInfo.MaxSpeed / speed;
        }
    }

    /// <summary>
    /// 计算队伍引力
    /// </summary>
    /// <param name="member">队员对象</param>
    /// <param name="cosForwardAngle">前方角度</param>
    /// <param name="speed"></param>
    /// <returns></returns>
    private Vector3 GetGroupGtivity(ClusterData member, float cosForwardAngle)
    {
        var result = Vector3.zero;
        
        // 同队伍聚合
        if (member != null) // && member.Group != null
        {
            var grivity = member.TargetPos - member.Position;
            // 如果当前方向与引力方向
            // 速度不稳定问题
            member.PhysicsInfo.SpeedDirection = grivity.normalized * member.PhysicsInfo.MaxSpeed;

            // 加入最大速度限制, 防止溢出
            //member.PhysicsInfo.SpeedDirection *= GetUpTopSpeed(member.PhysicsInfo.SpeedDirection.magnitude);
            result = grivity;
        }

        return result;
    }

    /// <summary>
    /// 获取同区域内成员引力斥力
    /// </summary>
    /// <param name="member"></param>
    /// <returns></returns>
    private void GetCloseMemberGrivity(ClusterData member)
    {
        if (member == null)
        {
            return;
        }
        // 遍历附近单位(不论敌友), 检测碰撞并排除碰撞, (挤开效果), 列表中包含障碍物
        var graphics = member.MyCollisionGraphics;
        var closeMemberList = targetList.QuadTree.GetScope(graphics);
        // 目标方向
        var targetDir = member.TargetPos - member.Position;
        // 释放压力方向
        var pressureReleaseDir = Vector3.zero;
        // 是否需要躲避
        var collisionCount = 0;
        // 碰撞前进方向
        var collisionThoughDir = Vector3.zero;
        // 碰撞不能前进方向(不能移动的物体)
        var collisionCouldNotThoughDir = Vector3.zero;
        var collisionCouldNotThoughCount = 0;
        for (var k = 0; closeMemberList !=null && k < closeMemberList.Count; k++)
        {
            var closeMember = closeMemberList[k];
            if (closeMember.Equals(member))
            {
                continue;
            }

            // 计算周围人员的位置, 相对位置的倒数相加, 并且不往来时方向移动
            var diffPosition = member.Position - closeMember.Position;
            pressureReleaseDir -= diffPosition;
            // 判断两对象是否已计算过, 如果计算过不再计算
            var compereId1 = member.Id + closeMember.Id << 32;
            var compereId2 = closeMember.Id + member.Id << 32;
            if (!areadyCollisionList.ContainsKey(compereId1) &&
                !areadyCollisionList.ContainsKey(compereId2))
            {
                // 获取附近单位的图形
                var closeGraphics = closeMember.MyCollisionGraphics;
                // 检测当前单位是否与其有碰撞
                if (graphics.CheckCollision(closeGraphics))
                {
                    // 如果碰撞来自前方, 则增加
                    if (Vector3.Angle(targetDir, -diffPosition) < 90)
                    {
                        collisionCount++;
                    }

                    var minDistance = member.Diameter + closeMember.Diameter;

                    var departSpeed = closeMember.PhysicsInfo.SpeedDirection - member.PhysicsInfo.SpeedDirection;
                    
                    // TODO 定最终拥挤方向
                    // TODO 排斥力未做
                    // 基础排斥力
                    if (diffPosition.magnitude < minDistance)
                    {
                        // TODO 排除力有时无效
                        // 计算不可移动方向
                        var diffPosNor = diffPosition.normalized;
                        collisionThoughDir += diffPosNor * (minDistance - diffPosition.magnitude) * CollisionThrough * Time.deltaTime;
                        if (!closeMember.CouldMove)
                        {
                            // 如果目标不能移动则
                            collisionCouldNotThoughDir += diffPosNor;
                            collisionCouldNotThoughCount++;
                        }
                        else
                        {
                            // 可移动附近单位也移动
                            closeMember.Position -= diffPosNor * Time.deltaTime;
                        }
                    }

                    // 求出射角度, 出射角度*出射量
                    // 使用向量法线计算求出出射标准向量
                    // TODO 角度有问题
                    var outDir =
                        ((member.PhysicsInfo.SpeedDirection +
                          Vector3.Dot(member.PhysicsInfo.SpeedDirection, diffPosition) *diffPosition)*2 -
                         member.PhysicsInfo.SpeedDirection).normalized;
                    

                    // 质量比例
                    var qualityRate = member.PhysicsInfo.Quality * member.PhysicsInfo.Quality / (closeMember.PhysicsInfo.Quality * closeMember.PhysicsInfo.Quality);
                    departSpeed *= 0.5f;

                    // 当前对象的弹出角度为镜面弹射角度
                    var partForMember = -outDir * departSpeed.magnitude / qualityRate;
                    var partForCloseMember = departSpeed * qualityRate;
                    if (partForMember.magnitude > departSpeed.magnitude)
                    {
                        partForMember *= departSpeed.magnitude / partForMember.magnitude;
                    }
                    if (partForCloseMember.magnitude > departSpeed.magnitude)
                    {
                        partForCloseMember *= departSpeed.magnitude / partForCloseMember.magnitude;
                    }
                    // TODO 这个力和某个力冲突导致移动缓慢
                    //member.PhysicsInfo.SpeedDirection += partForMember;
                    closeMember.PhysicsInfo.SpeedDirection -= partForCloseMember;
                    // 加入最大速度限制, 防止溢出
                    member.PhysicsInfo.SpeedDirection *= GetUpTopSpeed(member.PhysicsInfo.SpeedDirection.magnitude);
                    closeMember.PhysicsInfo.SpeedDirection *= GetUpTopSpeed(closeMember.PhysicsInfo.SpeedDirection.magnitude);
                    // 加入已对比列表
                    areadyCollisionList.Add(compereId1, true);
                    Debug.DrawLine(member.Position, partForMember + member.Position, Color.green);
                }
            }
        }

        // 物体移动, 并且不能超不可移动方向移动
        if (collisionThoughDir != Vector3.zero)
        {
            // 排除掉移动向量中不可移动方向的移动量
            // 计算当前移动方向与不可移动的反方向是否角度小于90
            // 如果小于90则无问题, 如果大于90则将与超过的角度部分抹掉
            //var angleCollisionThoughDir = Vector3.Angle(collisionThoughDir, collisionCouldNotThoughDir);
            //if (angleCollisionThoughDir > 90)
            //{
            //    angleCollisionThoughDir -= 90;
            //    var subDirLength = (float)Math.Cos(angleCollisionThoughDir)*collisionThoughDir.magnitude;
            //    // 求不能前进的反方向的垂直向量
            //    collisionThoughDir = Vector3.Cross(collisionCouldNotThoughDir, Vector3.up).normalized * subDirLength;
            //}
            member.Position += collisionThoughDir;
        }

        // 判断是否需要躲避
        if (collisionCount > 1)
        {
            // TODO 引力方向是附近的空格子
            // TODO 躲避力始终朝向同一方向, 导致群聚旋转
            // TODO 重写绕障功能
            // 获取周围的格子
            //var aroundNodes = targetList.MapInfo.GetAroundPos(member, 2);
            // 给予横向拉扯力
            // 求聚合位置向量的垂直向量
            var transverseDir = Vector3.Cross(pressureReleaseDir, Vector3.up);
            // 随机左右
            member.PhysicsInfo.SpeedDirection += transverseDir * member.PhysicsInfo.MaxSpeed;// * (new Random((int)DateTime.Now.Ticks).Next(10) > 5 ? -1 : 1);
        }
    }

    /// <summary>
    /// 获取同区域内成员引力斥力
    /// </summary>
    /// <param name="member"></param>
    /// <returns></returns>
    private void GetCloseMemberGrivity2(ClusterData member)
    {
        if (member == null)
        {
            return;
        }
        // 遍历附近单位(不论敌友), 检测碰撞并排除碰撞, (挤开效果), 列表中包含障碍物
        var graphics = member.MyCollisionGraphics;
        var closeMemberList = targetList.QuadTree.GetScope(graphics);
        // 目标方向
        var targetDir = member.TargetPos - member.Position;
        // 释放压力方向
        var pressureReleaseDir = Vector3.zero;
        // 是否需要躲避
        var collisionCount = 0;
        // 碰撞前进方向
        var collisionThoughDir = Vector3.zero;
        // 碰撞不能前进方向(不能移动的物体)
        //var collisionCouldNotThoughDir = Vector3.zero;
        //var collisionCouldNotThoughCount = 0;
        // 当前单位的体积*速度
        var memberEnergy = member.PhysicsInfo.Quality * member.PhysicsInfo.MaxSpeed;
        for (var k = 0; closeMemberList != null && k < closeMemberList.Count; k++)
        {
            var closeMember = closeMemberList[k];
            if (closeMember.Equals(member))
            {
                continue;
            }

            // 计算周围人员的位置, 相对位置的倒数相加, 并且不往来时方向移动
            var diffPosition = member.Position - closeMember.Position;
            pressureReleaseDir -= diffPosition;
            // 判断两对象是否已计算过, 如果计算过不再计算
            var compereId1 = member.Id + closeMember.Id << 32;
            var compereId2 = closeMember.Id + member.Id << 32;
            if (!areadyCollisionList.ContainsKey(compereId1) &&
                !areadyCollisionList.ContainsKey(compereId2))
            {
                // 获取附近单位的图形
                var closeGraphics = closeMember.MyCollisionGraphics;
                // 检测当前单位是否与其有碰撞
                if (graphics.CheckCollision(closeGraphics))
                {
                    // 如果碰撞来自前方, 则增加
                    if (Vector3.Angle(targetDir, -diffPosition) < 90)
                    {
                        collisionCount++;
                    }

                    var minDistance = member.Diameter + closeMember.Diameter;

                    var departSpeed = closeMember.PhysicsInfo.SpeedDirection - member.PhysicsInfo.SpeedDirection;

                    // 基础排斥力
                    if (diffPosition.magnitude < minDistance)
                    {
                        // TODO 排除力有时无效
                        // 计算不可移动方向
                        var diffPosNor = diffPosition.normalized;
                        // 对比速度与体积
                        var closeMemberEnergy = closeMember.PhysicsInfo.MaxSpeed * closeMember.PhysicsInfo.Quality;

                        collisionThoughDir += diffPosNor
                            * (minDistance / diffPosition.magnitude)
                            * CollisionThrough 
                            * Utils.GetRange(0.1f, 5f, closeMemberEnergy / memberEnergy) 
                            * Time.deltaTime;
                        if (closeMember.CouldMove)
                        {
                            // 可移动附近单位也移动
                            closeMember.Position -= diffPosNor * Utils.GetRange(0.1f, 5f, memberEnergy / closeMemberEnergy * Time.deltaTime);
                        }
                    }

                    // 求出射角度, 出射角度*出射量
                    // 使用向量法线计算求出出射标准向量
                    var outDir =
                        ((member.PhysicsInfo.SpeedDirection +
                          Vector3.Dot(member.PhysicsInfo.SpeedDirection, diffPosition) * diffPosition) * 2 -
                         member.PhysicsInfo.SpeedDirection).normalized;


                    // 质量比例
                    var qualityRate = member.PhysicsInfo.Quality * member.PhysicsInfo.Quality / (closeMember.PhysicsInfo.Quality * closeMember.PhysicsInfo.Quality);
                    departSpeed *= 0.5f;

                    // 当前对象的弹出角度为镜面弹射角度
                    var partForMember = -outDir * departSpeed.magnitude / qualityRate;

                    // 加入最大速度限制, 防止溢出
                    member.PhysicsInfo.SpeedDirection *= GetUpTopSpeed(member.PhysicsInfo.SpeedDirection.magnitude);
                    closeMember.PhysicsInfo.SpeedDirection *= GetUpTopSpeed(closeMember.PhysicsInfo.SpeedDirection.magnitude);
                    // 加入已对比列表
                    areadyCollisionList.Add(compereId1, true);
                    Debug.DrawLine(member.Position, partForMember + member.Position, Color.green);
                }
            }
        }

        // 碰撞移动
        if (collisionThoughDir != Vector3.zero)
        {
            member.Position += collisionThoughDir;
        }
    }

    /// <summary>
    /// 变更单位状态
    /// </summary>
    /// <param name="member"></param>
    private void ChangeMemberState(ClusterData member)
    {
        if (member == null)
        {
            return;
        }

        if (member.State == SchoolItemState.Unstart)
        {
            member.State = SchoolItemState.Moving;
            if (member.Moveing != null)
            {
                member.Moveing(member.ItemObj);
            }
        }

        if (member.PhysicsInfo.SpeedDirection.magnitude < 1)
        {
            // 开始等待
            if (member.State != SchoolItemState.Waiting && member.State != SchoolItemState.Complete)
            {
                member.State = SchoolItemState.Waiting;
                if (member.Wait != null)
                {
                    member.Wait(member.ItemObj);
                }
            }
        }
        else
        {
            // 根据角度获得差速, 直线移动最快
            if (member.State != SchoolItemState.Moving && member.State != SchoolItemState.Complete)
            {
                // 结束等待, 开始移动
                member.State = SchoolItemState.Moving;
                if (member.Moveing != null)
                {
                    member.Moveing(member.ItemObj);
                }
            }
        }

        if ((member.Position - member.TargetPos).magnitude < member.Diameter * UnitWidth)
        {
            if (member.State != SchoolItemState.Complete)
            {
                //member.Group.CompleteMemberCount++;
                // 将单位的下一位置pop出来 如果没有则
                if (!member.PopTarget())
                {
                    // 单位状态修改为complete
                    member.State = SchoolItemState.Complete;
                    // 调用到达
                    if (member.Complete != null) { member.Complete(member.ItemObj); }
                }
            }
        }

        // 判断组队是否到达
        //if (!member.Group.IsComplete && member.Group.CompleteMemberCount * 100 / member.Group.MemberList.Count > member.Group.ProportionOfComplete)
        //{
        //    if (member.Group.Complete != null)
        //    {
        //        member.Group.IsComplete = true;
        //        member.Group.Complete(member.Group);
        //    }
        //}
    }


    /// <summary>
    /// 控制极限速度
    /// </summary>
    /// <param name="speed">当前速度</param>
    /// <returns>如果speed超过极限速度则将其置为极限速度系数</returns>
    private float GetUpTopSpeed(float speed)
    {
        var result = 1f;
        if (speed > upTopSpeed)
        {
            result = upTopSpeed / speed;
        }
        return result;
    }


    /// <summary>
    /// 绘制单元位置与四叉树分区情况
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="argQuadTree"></param>
    private void DrawQuadTreeLine<T>(QuadTree<T> argQuadTree) where T : IGraphicsHolder
    {
        var colorForItem = Color.green;
        // 绘制四叉树边框
        Utils.DrawGraphics(argQuadTree.GetRectangle(), Color.white);
        // 遍历四叉树内容
        foreach (var item in argQuadTree.GetItemList())
        {
            // 绘制当前对象
            Utils.DrawGraphics(item.MyCollisionGraphics, colorForItem);
        }

        if (argQuadTree.GetSubNodes()[0] != null)
        {
            foreach (var node in argQuadTree.GetSubNodes())
            {
                DrawQuadTreeLine(node);
            }
        }
    }


    ///// <summary>
    ///// 绘制矩形
    ///// </summary>
    ///// <param name="rectangle">被绘制矩形</param>
    ///// <param name="color">绘制颜色</param>
    //private void DrawRect(RectGraphics rectangle, Color color)
    //{
    //    var pos = rectangle.Postion;
    //    Debug.DrawLine(new Vector3(pos.x, 0, pos.y), new Vector3(pos.x, 0, pos.y + rectangle.Height), color);
    //    Debug.DrawLine(new Vector3(pos.x, 0, pos.y), new Vector3(pos.x + rectangle.Width, 0, pos.y), color);
    //    Debug.DrawLine(new Vector3(pos.x + rectangle.Width, 0, pos.y + rectangle.Height), new Vector3(pos.x, 0, pos.y + rectangle.Height), color);
    //    Debug.DrawLine(new Vector3(pos.x + rectangle.Width, 0, pos.y + rectangle.Height), new Vector3(pos.x + rectangle.Width, 0, pos.y), color);
    //}

}
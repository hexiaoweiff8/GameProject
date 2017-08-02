using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.UI;

/// <summary>
/// 技能效果测试
/// </summary>
public class TestSkillEditor : MonoBehaviour
{
     
    // ------------------------------公有属性-----------------------------------
    /// <summary>
    /// 主相机
    /// </summary>
    public Camera MainCamera;

    /// <summary>
    /// 地图宽度
    /// </summary>
    public int MapWidth;

    /// <summary>
    /// 地图高度
    /// </summary>
    public int MapHeight;

    /// <summary>
    /// 单位宽度
    /// </summary>
    public int UnitWidth = 1;

    /// <summary>
    /// 加载按钮
    /// </summary>
    public Button LoadButton;

    /// <summary>
    /// 删除按钮
    /// </summary>
    public Button DelButton;

    /// <summary>
    /// SkillId输入框
    /// </summary>
    public InputField SkillId;

    /// <summary>
    /// BuffId输入框
    /// </summary>
    public InputField BuffId;

    /// <summary>
    /// 生命值变更量
    /// </summary>
    public InputField HealthChange;

    /// <summary>
    /// 事件Level1
    /// </summary>
    public Dropdown TriggerLevel1;

    /// <summary>
    /// 事件Level2
    /// </summary>
    public Dropdown TriggerLevel2;

    /// <summary>
    /// Skill滚动父级
    /// </summary>
    public GameObject SkillScrollParent;

    /// <summary>
    /// Buff滚动父级
    /// </summary>
    public GameObject BuffScrollParent;


    // ------------------------------私有属性----------------------------------

    /// <summary>
    /// 当前活动单位
    /// </summary>
    private ClusterData workingObj = null;

    /// <summary>
    /// 当前目标单位
    /// </summary>
    private ClusterData targetObj = null;

    /// <summary>
    /// 单位列表
    /// </summary>
    private IList<ClusterData> memberList = new List<ClusterData>();

    /// <summary>
    /// 单位的编号
    /// </summary>
    private int memberNum = 1;

    /// <summary>
    /// 随机生成器
    /// </summary>
    private System.Random random = new System.Random();

    /// <summary>
    /// 单位名称
    /// </summary>
    private string itemName = "item";

    /// <summary>
    /// skill按钮
    /// </summary>
    private Button skillButton;

    /// <summary>
    /// buff按钮
    /// </summary>
    private Button buffButton;

    /// <summary>
    /// 被选择Skill
    /// </summary>
    private long selectedSkill;

    /// <summary>
    /// 被选择Buff
    /// </summary>
    private long selectedBuff;

    /// <summary>
    /// 计数器
    /// </summary>
    private int counter = 0;

	void Start ()
	{
        // 初始化集群管理器
	    InitClusterManager();
        // 初始化列表
	    InitList();
	}


    private void Update()
    {
        // 控制
        Control();
        // 刷新技能与buff列表
        RefreshSkillAndBuff();
        // 输出数据
        Log();
    }

    void LateUpdate()
    {
        // 绘制活动单位
        DrawWorkingMember();
    }

    // -------------------------------公共方法----------------------------------

    /// <summary>
    /// 加载脚本
    /// </summary>
    public void LoadScript()
    {
        // 读取SkillId号加载文件
        var skillId = SkillId.text;
        // 读取BuffId号加载文件
        var buffId = BuffId.text;

        if (targetObj == null || workingObj == null)
        {
            Debug.Log("请选择当前目标与活动单位.");
            return;
        }
        // 如果skillId存在
        if (!string.IsNullOrEmpty(skillId))
        {
            // 加载Skill
            var skill = SkillManager.Single.CreateSkillInfo(Convert.ToInt32(skillId), null);
            if (skill != null)
            {
                // 挂载技能
                if (workingObj.AllData.SkillInfoList == null)
                {
                    workingObj.AllData.SkillInfoList = new List<SkillInfo>();
                }
                workingObj.AllData.SkillInfoList.Add(skill);
            }
            else
            {
                Debug.Log("SkillId:" + skillId + "脚本不存在");
            }
        }
        // 如果buffId存在
        if (!string.IsNullOrEmpty(buffId))
        {
            // 加载Buff
            var buff = BuffManager.Single.CreateBuffInfo(Convert.ToInt32(buffId), new DisplayOwner(targetObj.gameObject, targetObj), new DisplayOwner(workingObj.gameObject, workingObj));
            if (buff != null)
            {
                // 挂载buff
                BuffManager.Single.DoBuff(buff, BuffDoType.Attach, FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(buff.ReleaseMember, buff.ReceiveMember, buff, -1));
            }
            else
            {
                Debug.Log("BuffId:" + buffId + "脚本不存在");
            }
        }
        // 刷新显示skill与buff
        ShowSkillAndBuff(workingObj);

        // 清空SkillId号与BuffId号
        SkillId.text = "";
        BuffId.text = "";
    }

    /// <summary>
    /// 删除挂载在身上的脚本
    /// </summary>
    public void DelScript()
    {
        
    }

    /// <summary>
    /// 触发技能
    /// </summary>
    public void TriggerSkill()
    {
        if (targetObj == null || workingObj == null)
        {
            Debug.Log("目标或活动单位为空");
            return;
        }
        var skill = SkillManager.Single.GetSkillInstance(selectedSkill);
        if (skill == null)
        {
            Debug.Log("没有该Id技能技能:"+ selectedSkill);
            return;
        }

        // 触发被选中技能
        SkillManager.Single.DoSkillInfo(
            skill, 
            FormulaParamsPackerFactroy.Single.GetFormulaParamsPacker(
                new DisplayOwner(workingObj.gameObject, workingObj),
                new DisplayOwner(targetObj.gameObject, targetObj), 
                skill, 
                -1));
    }

    /// <summary>
    /// 抛出事件
    /// </summary>
    public void PopTrigger()
    {
        var triggerLevel1 = (TriggerLevel1)Enum.Parse(typeof(TriggerLevel1), TriggerLevel1.captionText.text.Split('#')[1]);
        var triggerLevel2 = (TriggerLevel2)Enum.Parse(typeof(TriggerLevel2), TriggerLevel2.captionText.text.Split('#')[1]);
        float healthChange = 0;
        try
        {
            healthChange = Convert.ToSingle(HealthChange.text.Trim());
        }
        catch
        {
            Debug.Log("伤害值不合法:" + HealthChange.text);
            return;
        }
        SkillManager.Single.SetTriggerData(new TriggerData()
        {
            HealthChangeValue = healthChange,
            ReceiveMember = new DisplayOwner(targetObj.gameObject, targetObj),
            ReleaseMember = new DisplayOwner(workingObj.gameObject, workingObj),
            TypeLevel1 = triggerLevel1,
            TypeLevel2 = triggerLevel2,
        });
    }


    // -------------------------------私有方法----------------------------------

    /// <summary>
    /// 控制
    /// </summary>
    private void Control()
    {
        // 验证
        if (MainCamera == null)
        {
            Debug.Log("主相机未设置");
            return;
        }

        // 点击选择活动目标
        if (Input.GetMouseButtonUp(0))
        {
            // 如果点击到目标则将活动目标设置为当前选择目标
            var ray = MainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            // 如果点击到测试单位
            var hitObj = hit.collider;
            if (hitObj != null && hitObj.name.StartsWith(itemName))
            {
                // 获取目标身上的ClusterData脚本
                var clusterData = hitObj.GetComponent<ClusterData>();
                if (clusterData != null)
                {
                    // 设置为活动单位
                    workingObj = clusterData;
                    ClearSelectedId();
                    ShowSkillAndBuff(workingObj);
                    Debug.Log("变更活动对象:" + workingObj.name);

                }
            }
        }
        // 右键选择目标单位
        if (Input.GetMouseButtonUp(1))
        {
            // 如果点击到目标则将活动目标设置为当前选择目标
            var ray = MainCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            // 如果点击到测试单位
            var hitObj = hit.collider;
            if (hitObj != null && hitObj.name.StartsWith(itemName))
            {
                // 获取目标身上的ClusterData脚本
                var clusterData = hitObj.GetComponent<ClusterData>();
                if (clusterData != null)
                {
                    // 设置为活动单位
                    targetObj = clusterData;
                    Debug.Log("变更目标对象:" + workingObj.name);

                }
            }
        }

        // 创建活动单位Cube
        if (Input.GetKey(KeyCode.C))
        {
            CreateMember();
            Debug.Log("创建新单位");
        }

        // 初始化
        if (Input.GetKey(KeyCode.R))
        {
            // 创建数组
            InitClusterManager();
            Debug.Log("初始化");
        }


        // --------------------------相机操作---------------------------
        // 上下左右移动
        if (Input.GetKey(KeyCode.UpArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z + 1);
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z - 1);
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x - 1, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x + 1, MainCamera.transform.localPosition.y, MainCamera.transform.localPosition.z);
        }
        // 升高下降
        if (Input.GetKey(KeyCode.PageUp))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y + 1, MainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.PageDown))
        {
            MainCamera.transform.localPosition = new Vector3(MainCamera.transform.localPosition.x, MainCamera.transform.localPosition.y - 1, MainCamera.transform.localPosition.z);
        }
        if (Input.GetKey(KeyCode.P))
        {
            // 暂停
            ClusterManager.Single.Pause();
        }
        if (Input.GetKey(KeyCode.G))
        {
            // 继续
            ClusterManager.Single.GoOn();
        }
    }

    /// <summary>
    /// 绘制活动单位
    /// </summary>
    private void DrawWorkingMember()
    {
        // 绘制当前单位颜色
        if (workingObj != null)
        {
            Utils.DrawGraphics(workingObj.MyCollisionGraphics, Color.black);
        }

        // 绘制目标单位颜色
        if (targetObj != null)
        {
            Utils.DrawGraphics(targetObj.MyCollisionGraphics, Color.red);
        }
    }

    /// <summary>
    /// 显示单位身上的skill与buff
    /// </summary>
    private void ShowSkillAndBuff(ClusterData clusterData)
    {
        if (clusterData == null)
        {
            return;
        }
        // 清空列表
        for (var i = SkillScrollParent.transform.childCount - 1; i >= 0; i--)
        {
            Destroy(SkillScrollParent.transform.GetChild(i).gameObject);
        }
        for (var i = BuffScrollParent.transform.childCount - 1; i >= 0; i--)
        {
            Destroy(BuffScrollParent.transform.GetChild(i).gameObject);
        }

        // 将技能加载到列表中
        foreach (var skill in clusterData.AllData.SkillInfoList)
        {
            // 将skill显示在列表中
            var copySkillButton = Instantiate(skillButton);
            var mySkill = skill;
            copySkillButton.GetComponentInChildren<Text>().text = "SkillNum" + mySkill.Num + "," + mySkill.AddtionId;
            copySkillButton.onClick.AddListener(delegate()
            {
                // 点击事件
                selectedSkill = mySkill.AddtionId;
                Debug.Log("选中技能:" + selectedSkill);
            });
            copySkillButton.gameObject.transform.parent = SkillScrollParent.transform;
        }

        // 将buff加载到列表中
        foreach (var buff in clusterData.AllData.BuffInfoList)
        {
            // 将buff显示在列表中
            var copyBufflButton = Instantiate(buffButton);
            var myBuff = buff;
            copyBufflButton.GetComponentInChildren<Text>().text = "BuffNum" + myBuff.Num + "," + myBuff.AddtionId;
            copyBufflButton.onClick.AddListener(delegate()
            {
                selectedBuff = myBuff.AddtionId;
                Debug.Log("选中Buff:" + selectedBuff);
            });
            copyBufflButton.gameObject.SetActive(true);
            copyBufflButton.gameObject.transform.parent = BuffScrollParent.transform;
        }

    }

    /// <summary>
    /// 清空已选择单位
    /// </summary>
    private void ClearSelectedId()
    {
        selectedSkill = -1;
        selectedBuff = -1;
    }

    /// <summary>
    /// 刷新技能与Buff列表
    /// </summary>
    private void RefreshSkillAndBuff()
    {
        if (counter > 100)
        {
            ShowSkillAndBuff(workingObj);
            counter = 0;
        }
        else
        {
            counter++;
        }
    }


    private void Log()
    {
        if (workingObj != null)
        {
            Debug.Log(workingObj.AllData.MemberData.ToString());
        }
    }

    /// <summary>
    /// 创建单位
    /// </summary>
    private void CreateMember()
    {
        var objId = new ObjectID(ObjectID.ObjectType.MySoldier);
        var schoolItem = GameObject.CreatePrimitive(PrimitiveType.Cube);
        var school = schoolItem.AddComponent<ClusterData>();
        school.AllData.MemberData = new VOBase()
        {
            AttackRange = 20,
            SpaceSet = 3,
            ObjID = objId,
            MoveSpeed = UnitWidth,
        };
        school.RotateSpeed = 10;
        // 随机位置
        school.transform.localPosition = new Vector3(random.Next(-MapWidth / 2, MapWidth / 2), 0, random.Next(-MapHeight / 2, MapHeight / 2));
        // 单位名称
        school.name = itemName + memberNum;
        //school.TargetPos = target;
        // 单位大小
        school.Diameter = UnitWidth;

        // 挂载状态机运行器
        var fsmRunner = schoolItem.AddComponent<TriggerRunner>();
        fsmRunner.Display = new DisplayOwner(schoolItem, school);

        // 目标选择权重数据
        var fightData = new SelectWeightData
        {
            AirWeight = 100,
            BuildWeight = 100,
            SurfaceWeight = 100,
            HumanWeight = 10,
            OrcWeight = 10,
            OmnicWeight = 10,
            HideWeight = -1,
            TauntWeight = 1000,
            HealthMaxWeight = 0,
            HealthMinWeight = 10,
            DistanceMaxWeight = 0,
            DistanceMinWeight = 10
        };

        school.AllData.SelectWeightData = fightData;
        school.AllData.MemberData.CurrentHP = 99;
        school.AllData.MemberData.TotalHp = 100;

        // 创建测试技能
        school.AllData.SkillInfoList = new List<SkillInfo>();
        // 单位放入集群管理器
        ClusterManager.Single.Add(school);
        DisplayerManager.Single.AddElement(objId, new DisplayOwner(schoolItem, school));
        // 单位放入成员列表
        memberList.Add(school);
        // 设置活动目标为最新创建目标
        workingObj = school;

        memberNum++;
    }


    /// <summary>
    /// 初始化Manager
    /// </summary>
    private void InitClusterManager()
    {
        var map = new int[MapHeight][];
        for (var i = 0; i < map.Length; i++)
        {
            map[i] = new int[MapWidth];
        }
        ClusterManager.Single.ClearAll();
        ClusterManager.Single.Init(0, 0, MapWidth, MapHeight, UnitWidth, map);
        LoadMap.Single.Init(map, UnitWidth);
        DisplayerManager.AutoInstance();
    }

    /// <summary>
    /// 初始化列表
    /// </summary>
    private void InitList()
    {
        // 将列表中的单位取出
        skillButton = SkillScrollParent.GetComponentInChildren<Button>();
        skillButton.gameObject.transform.parent = null;
        buffButton = BuffScrollParent.GetComponentInChildren<Button>();
        buffButton.gameObject.transform.parent = null;
    }

}

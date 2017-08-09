---
--- Created by Administrator.
--- DateTime: 2017/7/8 17:21
---
local class = require("common/middleclass")
local UIModel = class("UIModel")

---临时动画表
local AniNameList = {
    "gongji",
    "shengli",
    "shibai",
    "yidong"
}
---正在播放的动画index
local aniIndex = 0
---模型的默认动画
local defaultAni = "daiji"

function UIModel:initialize(parent)
    self.UIModel = GameObjectExtension.InstantiateFromPacket("ui_equip", "UIModel", parent).gameObject
    self.playerModelTexture = self.UIModel.transform:Find("playerModelTexture").gameObject
    self.camera3D = self.UIModel.transform:Find("Camera3D").gameObject
    self:show3DModel(101001)
end

function UIModel:show3DModel(cardId)
    if self.modelToShow then
        Object.Destroy(self.modelToShow.gameObject)
    end
    --添加RenderTexture 实现UI上添加3d模型
    self.myTexture = UnityEngine.RenderTexture(1024, 1024, 24)
    self.myTexture:Create()
    self.camera3D:GetComponent(typeof(UnityEngine.Camera)).targetTexture = self.myTexture
    self.playerModelTexture:GetComponent(typeof(UITexture)).mainTexture = self.myTexture
    --添加玩家3d模型
    self.modelToShow = Model:CreateUIModel(cardId).transform
    --self.modelToShow = DP_FightPrefabManage.InstantiateAvatar(CreateActorParam(AvatarCM.Infantry_R, false, 0, "gongjianbing", "gongjianbing", true, 0, 0)).transform
    self.modelToShow.parent = self.camera3D.transform
    self.modelToShow.localScale = Vector3(0.8, 0.8, 0.8);
    self.modelToShow.localRotation = Quaternion(0, 180, 0, 1);
    self.modelToShow.localPosition = Vector3(0, -7, 500);
    self.modelToShow.gameObject:SetActive(true)
    self.modelToShow.gameObject.layer = UnityEngine.LayerMask.NameToLayer("3DUI")
    for i = 0, self.modelToShow.childCount - 1 do
        self.modelToShow:GetChild(i).gameObject.layer = UnityEngine.LayerMask.NameToLayer("3DUI")
    end
    local ani = self.modelToShow:GetComponent("Animation")
    ani.wrapMode = UnityEngine.WrapMode.Loop
    ani:Play(defaultAni)
    local aniTimer
    self.playerModelTexture:GetComponent(typeof(SpinWithMouse)).target = self.modelToShow
    UIEventListener.Get(self.playerModelTexture.gameObject).onClick = function(go)
        aniIndex = aniIndex + 1
        if aniIndex > #AniNameList then
            aniIndex = 1
        end
        ani:Play(AniNameList[aniIndex])
        if aniTimer then
            aniTimer:Kill()
        end
        aniTimer = TimeUtil:CreateTimer(3, function ()
            ani:Play(defaultAni)
            aniTimer:Kill()
        end)
    end
end

function UIModel:setDepth(depth)
    self.UIModel:GetComponent("UIPanel").depth = depth
end


return UIModel
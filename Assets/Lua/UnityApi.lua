Debugger = {} 
--*
----Void Debugger.Log(String str)
--Void Debugger.Log(Object message)
--Void Debugger.Log(String str,Object arg0)
--Void Debugger.Log(String str,Object arg0,Object arg1)
--Void Debugger.Log(String str,Object arg0,Object arg1,Object arg2)
--Void Debugger.Log(String str,Object[] param)
function Debugger.Log() end 

----Void Debugger.LogWarning(String str)
--Void Debugger.LogWarning(Object message)
--Void Debugger.LogWarning(String str,Object arg0)
--Void Debugger.LogWarning(String str,Object arg0,Object arg1)
--Void Debugger.LogWarning(String str,Object arg0,Object arg1,Object arg2)
--Void Debugger.LogWarning(String str,Object[] param)
function Debugger.LogWarning() end 

----Void Debugger.LogError(String str)
--Void Debugger.LogError(Object message)
--Void Debugger.LogError(String str,Object arg0)
--Void Debugger.LogError(String str,Object arg0,Object arg1)
--Void Debugger.LogError(String str,Object arg0,Object arg1,Object arg2)
--Void Debugger.LogError(String str,Object[] param)
function Debugger.LogError() end 

----Void Debugger.LogException(Exception e)
--Void Debugger.LogException(String str,Exception e)
function Debugger.LogException() end 

DOTween = {} 
--*
--[Comment]
--consturctor for DOTween overrides:
--*
--DOTween.New()
--*

function DOTween.New() end
--*
--[Comment]
-- property: LogBehaviour DOTween.logBehaviour	get	set	
--Default: LogBehaviour.ErrorsOnly
logBehaviour = nil 
--*
----IDOTweenInit DOTween.Init(Nullable`1 recycleAllByDefault,Nullable`1 useSafeMode,Nullable`1 logBehaviour)
function DOTween.Init() end 

----Void DOTween.SetTweensCapacity(Int32 tweenersCapacity,Int32 sequencesCapacity)
function DOTween.SetTweensCapacity() end 

----Void DOTween.Clear(Boolean destroy)
function DOTween.Clear() end 

----Void DOTween.ClearCachedTweens()
function DOTween.ClearCachedTweens() end 

----Int32 DOTween.Validate()
function DOTween.Validate() end 

----TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Single endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Double endValue,Single duration)
--Tweener DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Int32 endValue,Single duration)
--Tweener DOTween.To(DOGetter`1 getter,DOSetter`1 setter,UInt32 endValue,Single duration)
--Tweener DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Int64 endValue,Single duration)
--Tweener DOTween.To(DOGetter`1 getter,DOSetter`1 setter,UInt64 endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,String endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Vector2 endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Vector3 endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Vector4 endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Vector3 endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Color endValue,Single duration)
--TweenerCore`3 DOTween.To(DOGetter`1 getter,DOSetter`1 setter,Rect endValue,Single duration)
--Tweener DOTween.To(DOGetter`1 getter,DOSetter`1 setter,RectOffset endValue,Single duration)
--Tweener DOTween.To(DOSetter`1 setter,Single startValue,Single endValue,Single duration)
function DOTween.To() end 

----TweenerCore`3 DOTween.ToAxis(DOGetter`1 getter,DOSetter`1 setter,Single endValue,Single duration,AxisConstraint axisConstraint)
function DOTween.ToAxis() end 

----Tweener DOTween.ToAlpha(DOGetter`1 getter,DOSetter`1 setter,Single endValue,Single duration)
function DOTween.ToAlpha() end 

----TweenerCore`3 DOTween.Punch(DOGetter`1 getter,DOSetter`1 setter,Vector3 direction,Single duration,Int32 vibrato,Single elasticity)
function DOTween.Punch() end 

----TweenerCore`3 DOTween.Shake(DOGetter`1 getter,DOSetter`1 setter,Single duration,Single strength,Int32 vibrato,Single randomness,Boolean ignoreZAxis)
--TweenerCore`3 DOTween.Shake(DOGetter`1 getter,DOSetter`1 setter,Single duration,Vector3 strength,Int32 vibrato,Single randomness)
function DOTween.Shake() end 

----TweenerCore`3 DOTween.ToArray(DOGetter`1 getter,DOSetter`1 setter,Vector3[] endValues,Single[] durations)
function DOTween.ToArray() end 

----Sequence DOTween.Sequence()
function DOTween.Sequence() end 

----Int32 DOTween.CompleteAll(Boolean withCallbacks)
function DOTween.CompleteAll() end 

----Int32 DOTween.Complete(Object targetOrId,Boolean withCallbacks)
function DOTween.Complete() end 

----Int32 DOTween.FlipAll()
function DOTween.FlipAll() end 

----Int32 DOTween.Flip(Object targetOrId)
function DOTween.Flip() end 

----Int32 DOTween.GotoAll(Single to,Boolean andPlay)
function DOTween.GotoAll() end 

----Int32 DOTween.Goto(Object targetOrId,Single to,Boolean andPlay)
function DOTween.Goto() end 

----Int32 DOTween.KillAll(Boolean complete)
--Int32 DOTween.KillAll(Boolean complete,Object[] idsOrTargetsToExclude)
function DOTween.KillAll() end 

----Int32 DOTween.Kill(Object targetOrId,Boolean complete)
function DOTween.Kill() end 

----Int32 DOTween.PauseAll()
function DOTween.PauseAll() end 

----Int32 DOTween.Pause(Object targetOrId)
function DOTween.Pause() end 

----Int32 DOTween.PlayAll()
function DOTween.PlayAll() end 

----Int32 DOTween.Play(Object targetOrId)
--Int32 DOTween.Play(Object target,Object id)
function DOTween.Play() end 

----Int32 DOTween.PlayBackwardsAll()
function DOTween.PlayBackwardsAll() end 

----Int32 DOTween.PlayBackwards(Object targetOrId)
function DOTween.PlayBackwards() end 

----Int32 DOTween.PlayForwardAll()
function DOTween.PlayForwardAll() end 

----Int32 DOTween.PlayForward(Object targetOrId)
function DOTween.PlayForward() end 

----Int32 DOTween.RestartAll(Boolean includeDelay)
function DOTween.RestartAll() end 

----Int32 DOTween.Restart(Object targetOrId,Boolean includeDelay)
--Int32 DOTween.Restart(Object target,Object id,Boolean includeDelay)
function DOTween.Restart() end 

----Int32 DOTween.RewindAll(Boolean includeDelay)
function DOTween.RewindAll() end 

----Int32 DOTween.Rewind(Object targetOrId,Boolean includeDelay)
function DOTween.Rewind() end 

----Int32 DOTween.SmoothRewindAll()
function DOTween.SmoothRewindAll() end 

----Int32 DOTween.SmoothRewind(Object targetOrId)
function DOTween.SmoothRewind() end 

----Int32 DOTween.TogglePauseAll()
function DOTween.TogglePauseAll() end 

----Int32 DOTween.TogglePause(Object targetOrId)
function DOTween.TogglePause() end 

----Boolean DOTween.IsTweening(Object targetOrId)
function DOTween.IsTweening() end 

----Int32 DOTween.TotalPlayingTweens()
function DOTween.TotalPlayingTweens() end 

----List`1 DOTween.PlayingTweens()
function DOTween.PlayingTweens() end 

----List`1 DOTween.PausedTweens()
function DOTween.PausedTweens() end 

----List`1 DOTween.TweensById(Object id,Boolean playingOnly)
function DOTween.TweensById() end 

----List`1 DOTween.TweensByTarget(Object target,Boolean playingOnly)
function DOTween.TweensByTarget() end 

Tween = {} 
--*
--[Comment]
-- property: Single Tween.fullPosition	get	set	
fullPosition = nil 
--*
Sequence = {} 
--*
--[Comment]
-- property: Single Sequence.fullPosition	get	set	
fullPosition = nil 
--*
Tweener = {} 
--*
--[Comment]
-- property: Single Tweener.fullPosition	get	set	
fullPosition = nil 
--*
----Tweener Tweener:ChangeStartValue(Object newStartValue,Single newDuration)
function ChangeStartValue() end 

----Tweener Tweener:ChangeEndValue(Object newEndValue,Single newDuration,Boolean snapStartValue)
--Tweener Tweener:ChangeEndValue(Object newEndValue,Boolean snapStartValue)
function ChangeEndValue() end 

----Tweener Tweener:ChangeValues(Object newStartValue,Object newEndValue,Single newDuration)
function ChangeValues() end 

LoopType = {} 

Restart = nil;

Yoyo = nil;

Incremental = nil;

PathMode = {} 

Ignore = nil;

Full3D = nil;

TopDown2D = nil;

Sidescroller2D = nil;

PathType = {} 

Linear = nil;

CatmullRom = nil;

RotateMode = {} 

Fast = nil;

FastBeyond360 = nil;

WorldAxisAdd = nil;

LocalAxisAdd = nil;

Component = {} 
--*
--[Comment]
--consturctor for Component overrides:
--*
--Component.New()
--*

function Component.New() end
--*
--[Comment]
-- property: Transform Component.transform	get	
--The Transform attached to this GameObject (null if there is none attached).
transform = nil 
--*
--[Comment]
-- property: GameObject Component.gameObject	get	
--The game object this component is attached to. A component is always attached to a game object.
gameObject = nil 
--*
--[Comment]
-- property: String Component.tag	get	set	
--The tag of this game object.
tag = nil 
--*
--[Comment]
-- property: String Component.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Component.hideFlags	get	set	
hideFlags = nil 
--*
----Component Component:GetComponent(Type type)
--Component Component:GetComponent(String type)
function GetComponent() end 

----Component Component:GetComponentInChildren(Type t,Boolean includeInactive)
--Component Component:GetComponentInChildren(Type t)
function GetComponentInChildren() end 

----Component[] Component:GetComponentsInChildren(Type t)
--Component[] Component:GetComponentsInChildren(Type t,Boolean includeInactive)
function GetComponentsInChildren() end 

----Component Component:GetComponentInParent(Type t)
function GetComponentInParent() end 

----Component[] Component:GetComponentsInParent(Type t)
--Component[] Component:GetComponentsInParent(Type t,Boolean includeInactive)
function GetComponentsInParent() end 

----Component[] Component:GetComponents(Type type)
--Void Component:GetComponents(Type type,List`1 results)
function GetComponents() end 

----Boolean Component:CompareTag(String tag)
function CompareTag() end 

----Void Component:SendMessageUpwards(String methodName,Object value,SendMessageOptions options)
--Void Component:SendMessageUpwards(String methodName,Object value)
--Void Component:SendMessageUpwards(String methodName)
--Void Component:SendMessageUpwards(String methodName,SendMessageOptions options)
function SendMessageUpwards() end 

----Void Component:SendMessage(String methodName,Object value,SendMessageOptions options)
--Void Component:SendMessage(String methodName,Object value)
--Void Component:SendMessage(String methodName)
--Void Component:SendMessage(String methodName,SendMessageOptions options)
function SendMessage() end 

----Void Component:BroadcastMessage(String methodName,Object parameter,SendMessageOptions options)
--Void Component:BroadcastMessage(String methodName,Object parameter)
--Void Component:BroadcastMessage(String methodName)
--Void Component:BroadcastMessage(String methodName,SendMessageOptions options)
function BroadcastMessage() end 

Transform = {} 
--*
--[Comment]
-- property: Vector3 Transform.position	get	set	
--The position of the transform in world space.
position = nil 
--*
--[Comment]
-- property: Vector3 Transform.localPosition	get	set	
--Position of the transform relative to the parent transform.
localPosition = nil 
--*
--[Comment]
-- property: Vector3 Transform.eulerAngles	get	set	
--The rotation as Euler angles in degrees.
eulerAngles = nil 
--*
--[Comment]
-- property: Vector3 Transform.localEulerAngles	get	set	
--The rotation as Euler angles in degrees relative to the parent transform's rotation.
localEulerAngles = nil 
--*
--[Comment]
-- property: Vector3 Transform.right	get	set	
--The red axis of the transform in world space.
right = nil 
--*
--[Comment]
-- property: Vector3 Transform.up	get	set	
--The green axis of the transform in world space.
up = nil 
--*
--[Comment]
-- property: Vector3 Transform.forward	get	set	
--The blue axis of the transform in world space.
forward = nil 
--*
--[Comment]
-- property: Quaternion Transform.rotation	get	set	
--The rotation of the transform in world space stored as a Quaternion.
rotation = nil 
--*
--[Comment]
-- property: Quaternion Transform.localRotation	get	set	
--The rotation of the transform relative to the parent transform's rotation.
localRotation = nil 
--*
--[Comment]
-- property: Vector3 Transform.localScale	get	set	
--The scale of the transform relative to the parent.
localScale = nil 
--*
--[Comment]
-- property: Transform Transform.parent	get	set	
--The parent of the transform.
parent = nil 
--*
--[Comment]
-- property: Matrix4x4 Transform.worldToLocalMatrix	get	
--Matrix that transforms a point from world space into local space (Read Only).
worldToLocalMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 Transform.localToWorldMatrix	get	
--Matrix that transforms a point from local space into world space (Read Only).
localToWorldMatrix = nil 
--*
--[Comment]
-- property: Transform Transform.root	get	
--Returns the topmost transform in the hierarchy.
root = nil 
--*
--[Comment]
-- property: Int32 Transform.childCount	get	
--The number of children the Transform has.
childCount = nil 
--*
--[Comment]
-- property: Vector3 Transform.lossyScale	get	
--The global scale of the object (Read Only).
lossyScale = nil 
--*
--[Comment]
-- property: Boolean Transform.hasChanged	get	set	
--Has the transform changed since the last time the flag was set to 'false'?
hasChanged = nil 
--*
--[Comment]
-- property: Int32 Transform.hierarchyCapacity	get	set	
--The transform capacity of the transform's hierarchy data structure.
hierarchyCapacity = nil 
--*
--[Comment]
-- property: Int32 Transform.hierarchyCount	get	
--The number of transforms in the transform's hierarchy data structure.
hierarchyCount = nil 
--*
--[Comment]
-- property: Transform Transform.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Transform.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Transform.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Transform.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Transform.hideFlags	get	set	
hideFlags = nil 
--*
----Void Transform:SetParent(Transform parent)
--Void Transform:SetParent(Transform parent,Boolean worldPositionStays)
function SetParent() end 

----Void Transform:Translate(Vector3 translation)
--Void Transform:Translate(Vector3 translation,Space relativeTo)
--Void Transform:Translate(Single x,Single y,Single z)
--Void Transform:Translate(Single x,Single y,Single z,Space relativeTo)
--Void Transform:Translate(Vector3 translation,Transform relativeTo)
--Void Transform:Translate(Single x,Single y,Single z,Transform relativeTo)
function Translate() end 

----Void Transform:Rotate(Vector3 eulerAngles)
--Void Transform:Rotate(Vector3 eulerAngles,Space relativeTo)
--Void Transform:Rotate(Single xAngle,Single yAngle,Single zAngle)
--Void Transform:Rotate(Single xAngle,Single yAngle,Single zAngle,Space relativeTo)
--Void Transform:Rotate(Vector3 axis,Single angle)
--Void Transform:Rotate(Vector3 axis,Single angle,Space relativeTo)
function Rotate() end 

----Void Transform:RotateAround(Vector3 point,Vector3 axis,Single angle)
function RotateAround() end 

----Void Transform:LookAt(Transform target)
--Void Transform:LookAt(Transform target,Vector3 worldUp)
--Void Transform:LookAt(Vector3 worldPosition,Vector3 worldUp)
--Void Transform:LookAt(Vector3 worldPosition)
function LookAt() end 

----Vector3 Transform:TransformDirection(Vector3 direction)
--Vector3 Transform:TransformDirection(Single x,Single y,Single z)
function TransformDirection() end 

----Vector3 Transform:InverseTransformDirection(Vector3 direction)
--Vector3 Transform:InverseTransformDirection(Single x,Single y,Single z)
function InverseTransformDirection() end 

----Vector3 Transform:TransformVector(Vector3 vector)
--Vector3 Transform:TransformVector(Single x,Single y,Single z)
function TransformVector() end 

----Vector3 Transform:InverseTransformVector(Vector3 vector)
--Vector3 Transform:InverseTransformVector(Single x,Single y,Single z)
function InverseTransformVector() end 

----Vector3 Transform:TransformPoint(Vector3 position)
--Vector3 Transform:TransformPoint(Single x,Single y,Single z)
function TransformPoint() end 

----Vector3 Transform:InverseTransformPoint(Vector3 position)
--Vector3 Transform:InverseTransformPoint(Single x,Single y,Single z)
function InverseTransformPoint() end 

----Void Transform:DetachChildren()
function DetachChildren() end 

----Void Transform:SetAsFirstSibling()
function SetAsFirstSibling() end 

----Void Transform:SetAsLastSibling()
function SetAsLastSibling() end 

----Void Transform:SetSiblingIndex(Int32 index)
function SetSiblingIndex() end 

----Int32 Transform:GetSiblingIndex()
function GetSiblingIndex() end 

----Transform Transform:Find(String name)
function Find() end 

----Boolean Transform:IsChildOf(Transform parent)
function IsChildOf() end 

----Transform Transform:FindChild(String name)
function FindChild() end 

----IEnumerator Transform:GetEnumerator()
function GetEnumerator() end 

----Transform Transform:GetChild(Int32 index)
function GetChild() end 

Light = {} 
--*
--[Comment]
--consturctor for Light overrides:
--*
--Light.New()
--*

function Light.New() end
--*
--[Comment]
-- property: LightType Light.type	get	set	
--The type of the light.
type = nil 
--*
--[Comment]
-- property: Color Light.color	get	set	
--The color of the light.
color = nil 
--*
--[Comment]
-- property: Single Light.intensity	get	set	
--The Intensity of a light is multiplied with the Light color.
intensity = nil 
--*
--[Comment]
-- property: Single Light.bounceIntensity	get	set	
--The multiplier that defines the strength of the bounce lighting.
bounceIntensity = nil 
--*
--[Comment]
-- property: LightShadows Light.shadows	get	set	
--How this light casts shadows
shadows = nil 
--*
--[Comment]
-- property: Single Light.shadowStrength	get	set	
--Strength of light's shadows.
shadowStrength = nil 
--*
--[Comment]
-- property: LightShadowResolution Light.shadowResolution	get	set	
--Control the resolution of the ShadowMap.
shadowResolution = nil 
--*
--[Comment]
-- property: Int32 Light.shadowCustomResolution	get	set	
--The custom resolution of the shadow map.
shadowCustomResolution = nil 
--*
--[Comment]
-- property: Single Light.shadowBias	get	set	
--Shadow mapping constant bias.
shadowBias = nil 
--*
--[Comment]
-- property: Single Light.shadowNormalBias	get	set	
--Shadow mapping normal-based bias.
shadowNormalBias = nil 
--*
--[Comment]
-- property: Single Light.shadowNearPlane	get	set	
--Near plane value to use for shadow frustums.
shadowNearPlane = nil 
--*
--[Comment]
-- property: Single Light.range	get	set	
--The range of the light.
range = nil 
--*
--[Comment]
-- property: Single Light.spotAngle	get	set	
--The angle of the light's spotlight cone in degrees.
spotAngle = nil 
--*
--[Comment]
-- property: Single Light.cookieSize	get	set	
--The size of a directional light's cookie.
cookieSize = nil 
--*
--[Comment]
-- property: Texture Light.cookie	get	set	
--The cookie texture projected by the light.
cookie = nil 
--*
--[Comment]
-- property: Flare Light.flare	get	set	
--The to use for this light.
flare = nil 
--*
--[Comment]
-- property: LightRenderMode Light.renderMode	get	set	
--How to render the light.
renderMode = nil 
--*
--[Comment]
-- property: Int32 Light.bakedIndex	get	set	
--A unique index, used internally for identifying lights contributing to lightmaps and/or light probes.
bakedIndex = nil 
--*
--[Comment]
-- property: Boolean Light.isBaked	get	
--Is the light contribution already stored in lightmaps and/or lightprobes (Read Only).
isBaked = nil 
--*
--[Comment]
-- property: Int32 Light.cullingMask	get	set	
--This is used to light certain objects in the scene selectively.
cullingMask = nil 
--*
--[Comment]
-- property: Vector2 Light.areaSize	get	set	
--The size of the area light. Editor only.
areaSize = nil 
--*
--[Comment]
-- property: Int32 Light.commandBufferCount	get	
--Number of command buffers set up on this light (Read Only).
commandBufferCount = nil 
--*
--[Comment]
-- property: Boolean Light.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Light.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Light.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Light.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Light.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Light.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Light.hideFlags	get	set	
hideFlags = nil 
--*
----Void Light:AddCommandBuffer(LightEvent evt,CommandBuffer buffer)
function AddCommandBuffer() end 

----Void Light:RemoveCommandBuffer(LightEvent evt,CommandBuffer buffer)
function RemoveCommandBuffer() end 

----Void Light:RemoveCommandBuffers(LightEvent evt)
function RemoveCommandBuffers() end 

----Void Light:RemoveAllCommandBuffers()
function RemoveAllCommandBuffers() end 

----CommandBuffer[] Light:GetCommandBuffers(LightEvent evt)
function GetCommandBuffers() end 

----Light[] Light.GetLights(LightType type,Int32 layer)
function Light.GetLights() end 

Material = {} 
--*
--[Comment]
--consturctor for Material overrides:
--*
--Material.New(Shader shader)
--Create a temporary Material.
--params:
--shader:    Create a material with a given Shader.
--source:    Create a material by copying all properties from another material.

--*

--Material.New(Material source)
--Create a temporary Material.
--params:
--shader:    Create a material with a given Shader.
--source:    Create a material by copying all properties from another material.

--*

function Material.New() end
--*
--[Comment]
-- property: Shader Material.shader	get	set	
--The shader used by the material.
shader = nil 
--*
--[Comment]
-- property: Color Material.color	get	set	
--The main material's color.
color = nil 
--*
--[Comment]
-- property: Texture Material.mainTexture	get	set	
--The material's texture.
mainTexture = nil 
--*
--[Comment]
-- property: Vector2 Material.mainTextureOffset	get	set	
--The texture offset of the main texture.
mainTextureOffset = nil 
--*
--[Comment]
-- property: Vector2 Material.mainTextureScale	get	set	
--The texture scale of the main texture.
mainTextureScale = nil 
--*
--[Comment]
-- property: Int32 Material.passCount	get	
--How many passes are in this material (Read Only).
passCount = nil 
--*
--[Comment]
-- property: Int32 Material.renderQueue	get	set	
--Render queue of this material.
renderQueue = nil 
--*
--[Comment]
-- property: String[] Material.shaderKeywords	get	set	
--Additional shader keywords set by this material.
shaderKeywords = nil 
--*
--[Comment]
-- property: MaterialGlobalIlluminationFlags Material.globalIlluminationFlags	get	set	
--Defines how the material should interact with lightmaps and lightprobes.
globalIlluminationFlags = nil 
--*
--[Comment]
-- property: String Material.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Material.hideFlags	get	set	
hideFlags = nil 
--*
----Void Material:SetColor(String propertyName,Color color)
--Void Material:SetColor(Int32 nameID,Color color)
function SetColor() end 

----Color Material:GetColor(String propertyName)
--Color Material:GetColor(Int32 nameID)
function GetColor() end 

----Void Material:SetVector(String propertyName,Vector4 vector)
--Void Material:SetVector(Int32 nameID,Vector4 vector)
function SetVector() end 

----Vector4 Material:GetVector(String propertyName)
--Vector4 Material:GetVector(Int32 nameID)
function GetVector() end 

----Void Material:SetTexture(String propertyName,Texture texture)
--Void Material:SetTexture(Int32 nameID,Texture texture)
function SetTexture() end 

----Texture Material:GetTexture(String propertyName)
--Texture Material:GetTexture(Int32 nameID)
function GetTexture() end 

----Void Material:SetTextureOffset(String propertyName,Vector2 offset)
function SetTextureOffset() end 

----Vector2 Material:GetTextureOffset(String propertyName)
function GetTextureOffset() end 

----Void Material:SetTextureScale(String propertyName,Vector2 scale)
function SetTextureScale() end 

----Vector2 Material:GetTextureScale(String propertyName)
function GetTextureScale() end 

----Void Material:SetMatrix(String propertyName,Matrix4x4 matrix)
--Void Material:SetMatrix(Int32 nameID,Matrix4x4 matrix)
function SetMatrix() end 

----Matrix4x4 Material:GetMatrix(String propertyName)
--Matrix4x4 Material:GetMatrix(Int32 nameID)
function GetMatrix() end 

----Void Material:SetFloat(String propertyName,Single value)
--Void Material:SetFloat(Int32 nameID,Single value)
function SetFloat() end 

----Single Material:GetFloat(String propertyName)
--Single Material:GetFloat(Int32 nameID)
function GetFloat() end 

----Void Material:SetFloatArray(String name,Single[] values)
--Void Material:SetFloatArray(Int32 nameID,Single[] values)
function SetFloatArray() end 

----Void Material:SetVectorArray(String name,Vector4[] values)
--Void Material:SetVectorArray(Int32 nameID,Vector4[] values)
function SetVectorArray() end 

----Void Material:SetColorArray(String name,Color[] values)
--Void Material:SetColorArray(Int32 nameID,Color[] values)
function SetColorArray() end 

----Void Material:SetMatrixArray(String name,Matrix4x4[] values)
--Void Material:SetMatrixArray(Int32 nameID,Matrix4x4[] values)
function SetMatrixArray() end 

----Void Material:SetInt(String propertyName,Int32 value)
--Void Material:SetInt(Int32 nameID,Int32 value)
function SetInt() end 

----Int32 Material:GetInt(String propertyName)
--Int32 Material:GetInt(Int32 nameID)
function GetInt() end 

----Void Material:SetBuffer(String propertyName,ComputeBuffer buffer)
function SetBuffer() end 

----Boolean Material:HasProperty(String propertyName)
--Boolean Material:HasProperty(Int32 nameID)
function HasProperty() end 

----String Material:GetTag(String tag,Boolean searchFallbacks,String defaultValue)
--String Material:GetTag(String tag,Boolean searchFallbacks)
function GetTag() end 

----Void Material:SetOverrideTag(String tag,String val)
function SetOverrideTag() end 

----Void Material:Lerp(Material start,Material end,Single t)
function Lerp() end 

----Boolean Material:SetPass(Int32 pass)
function SetPass() end 

----Void Material:CopyPropertiesFromMaterial(Material mat)
function CopyPropertiesFromMaterial() end 

----Void Material:EnableKeyword(String keyword)
function EnableKeyword() end 

----Void Material:DisableKeyword(String keyword)
function DisableKeyword() end 

----Boolean Material:IsKeywordEnabled(String keyword)
function IsKeywordEnabled() end 

Rigidbody = {} 
--*
--[Comment]
--consturctor for Rigidbody overrides:
--*
--Rigidbody.New()
--*

function Rigidbody.New() end
--*
--[Comment]
-- property: Vector3 Rigidbody.velocity	get	set	
--The velocity vector of the rigidbody.
velocity = nil 
--*
--[Comment]
-- property: Vector3 Rigidbody.angularVelocity	get	set	
--The angular velocity vector of the rigidbody.
angularVelocity = nil 
--*
--[Comment]
-- property: Single Rigidbody.drag	get	set	
--The drag of the object.
drag = nil 
--*
--[Comment]
-- property: Single Rigidbody.angularDrag	get	set	
--The angular drag of the object.
angularDrag = nil 
--*
--[Comment]
-- property: Single Rigidbody.mass	get	set	
--The mass of the rigidbody.
mass = nil 
--*
--[Comment]
-- property: Boolean Rigidbody.useGravity	get	set	
--Controls whether gravity affects this rigidbody.
useGravity = nil 
--*
--[Comment]
-- property: Single Rigidbody.maxDepenetrationVelocity	get	set	
--Maximum velocity of a rigidbody when moving out of penetrating state.
maxDepenetrationVelocity = nil 
--*
--[Comment]
-- property: Boolean Rigidbody.isKinematic	get	set	
--Controls whether physics affects the rigidbody.
isKinematic = nil 
--*
--[Comment]
-- property: Boolean Rigidbody.freezeRotation	get	set	
--Controls whether physics will change the rotation of the object.
freezeRotation = nil 
--*
--[Comment]
-- property: RigidbodyConstraints Rigidbody.constraints	get	set	
--Controls which degrees of freedom are allowed for the simulation of this Rigidbody.
constraints = nil 
--*
--[Comment]
-- property: CollisionDetectionMode Rigidbody.collisionDetectionMode	get	set	
--The Rigidbody's collision detection mode.
collisionDetectionMode = nil 
--*
--[Comment]
-- property: Vector3 Rigidbody.centerOfMass	get	set	
--The center of mass relative to the transform's origin.
centerOfMass = nil 
--*
--[Comment]
-- property: Vector3 Rigidbody.worldCenterOfMass	get	
--The center of mass of the rigidbody in world space (Read Only).
worldCenterOfMass = nil 
--*
--[Comment]
-- property: Quaternion Rigidbody.inertiaTensorRotation	get	set	
--The rotation of the inertia tensor.
inertiaTensorRotation = nil 
--*
--[Comment]
-- property: Vector3 Rigidbody.inertiaTensor	get	set	
--The diagonal inertia tensor of mass relative to the center of mass.
inertiaTensor = nil 
--*
--[Comment]
-- property: Boolean Rigidbody.detectCollisions	get	set	
--Should collision detection be enabled? (By default always enabled).
detectCollisions = nil 
--*
--[Comment]
-- property: Boolean Rigidbody.useConeFriction	get	set	
--Force cone friction to be used for this rigidbody.
useConeFriction = nil 
--*
--[Comment]
-- property: Vector3 Rigidbody.position	get	set	
--The position of the rigidbody.
position = nil 
--*
--[Comment]
-- property: Quaternion Rigidbody.rotation	get	set	
--The rotation of the rigdibody.
rotation = nil 
--*
--[Comment]
-- property: RigidbodyInterpolation Rigidbody.interpolation	get	set	
--Interpolation allows you to smooth out the effect of running physics at a fixed frame rate.
interpolation = nil 
--*
--[Comment]
-- property: Int32 Rigidbody.solverIterations	get	set	
--The solverIterations determines how accurately Rigidbody joints and collision contacts are resolved. Overrides Physics.defaultSolverIterations. Must be positive.
solverIterations = nil 
--*
--[Comment]
-- property: Int32 Rigidbody.solverVelocityIterations	get	set	
--The solverVelocityIterations affects how how accurately Rigidbody joints and collision contacts are resolved. Overrides Physics.defaultSolverVelocityIterations. Must be positive.
solverVelocityIterations = nil 
--*
--[Comment]
-- property: Single Rigidbody.sleepThreshold	get	set	
--The mass-normalized energy threshold, below which objects start going to sleep.
sleepThreshold = nil 
--*
--[Comment]
-- property: Single Rigidbody.maxAngularVelocity	get	set	
--The maximimum angular velocity of the rigidbody. (Default 7) range { 0, infinity }.
maxAngularVelocity = nil 
--*
--[Comment]
-- property: Transform Rigidbody.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Rigidbody.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Rigidbody.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Rigidbody.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Rigidbody.hideFlags	get	set	
hideFlags = nil 
--*
----Void Rigidbody:SetDensity(Single density)
function SetDensity() end 

----Void Rigidbody:AddForce(Vector3 force,ForceMode mode)
--Void Rigidbody:AddForce(Vector3 force)
--Void Rigidbody:AddForce(Single x,Single y,Single z)
--Void Rigidbody:AddForce(Single x,Single y,Single z,ForceMode mode)
function AddForce() end 

----Void Rigidbody:AddRelativeForce(Vector3 force,ForceMode mode)
--Void Rigidbody:AddRelativeForce(Vector3 force)
--Void Rigidbody:AddRelativeForce(Single x,Single y,Single z)
--Void Rigidbody:AddRelativeForce(Single x,Single y,Single z,ForceMode mode)
function AddRelativeForce() end 

----Void Rigidbody:AddTorque(Vector3 torque,ForceMode mode)
--Void Rigidbody:AddTorque(Vector3 torque)
--Void Rigidbody:AddTorque(Single x,Single y,Single z)
--Void Rigidbody:AddTorque(Single x,Single y,Single z,ForceMode mode)
function AddTorque() end 

----Void Rigidbody:AddRelativeTorque(Vector3 torque,ForceMode mode)
--Void Rigidbody:AddRelativeTorque(Vector3 torque)
--Void Rigidbody:AddRelativeTorque(Single x,Single y,Single z)
--Void Rigidbody:AddRelativeTorque(Single x,Single y,Single z,ForceMode mode)
function AddRelativeTorque() end 

----Void Rigidbody:AddForceAtPosition(Vector3 force,Vector3 position,ForceMode mode)
--Void Rigidbody:AddForceAtPosition(Vector3 force,Vector3 position)
function AddForceAtPosition() end 

----Void Rigidbody:AddExplosionForce(Single explosionForce,Vector3 explosionPosition,Single explosionRadius,Single upwardsModifier,ForceMode mode)
--Void Rigidbody:AddExplosionForce(Single explosionForce,Vector3 explosionPosition,Single explosionRadius,Single upwardsModifier)
--Void Rigidbody:AddExplosionForce(Single explosionForce,Vector3 explosionPosition,Single explosionRadius)
function AddExplosionForce() end 

----Vector3 Rigidbody:ClosestPointOnBounds(Vector3 position)
function ClosestPointOnBounds() end 

----Vector3 Rigidbody:GetRelativePointVelocity(Vector3 relativePoint)
function GetRelativePointVelocity() end 

----Vector3 Rigidbody:GetPointVelocity(Vector3 worldPoint)
function GetPointVelocity() end 

----Void Rigidbody:MovePosition(Vector3 position)
function MovePosition() end 

----Void Rigidbody:MoveRotation(Quaternion rot)
function MoveRotation() end 

----Void Rigidbody:Sleep()
function Sleep() end 

----Boolean Rigidbody:IsSleeping()
function IsSleeping() end 

----Void Rigidbody:WakeUp()
function WakeUp() end 

----Void Rigidbody:ResetCenterOfMass()
function ResetCenterOfMass() end 

----Void Rigidbody:ResetInertiaTensor()
function ResetInertiaTensor() end 

----Boolean Rigidbody:SweepTest(Vector3 direction,RaycastHit& hitInfo,Single maxDistance,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Rigidbody:SweepTest(Vector3 direction,RaycastHit& hitInfo,Single maxDistance)
--Boolean Rigidbody:SweepTest(Vector3 direction,RaycastHit& hitInfo)
function SweepTest() end 

----RaycastHit[] Rigidbody:SweepTestAll(Vector3 direction,Single maxDistance,QueryTriggerInteraction queryTriggerInteraction)
--RaycastHit[] Rigidbody:SweepTestAll(Vector3 direction,Single maxDistance)
--RaycastHit[] Rigidbody:SweepTestAll(Vector3 direction)
function SweepTestAll() end 

Camera = {} 
--*
--[Comment]
--consturctor for Camera overrides:
--*
--Camera.New()
--*

function Camera.New() end
--*
--[Comment]
-- property: Single Camera.fieldOfView	get	set	
--The field of view of the camera in degrees.
fieldOfView = nil 
--*
--[Comment]
-- property: Single Camera.nearClipPlane	get	set	
--The near clipping plane distance.
nearClipPlane = nil 
--*
--[Comment]
-- property: Single Camera.farClipPlane	get	set	
--The far clipping plane distance.
farClipPlane = nil 
--*
--[Comment]
-- property: RenderingPath Camera.renderingPath	get	set	
--The rendering path that should be used, if possible.  In some situations, it may not be possible to use the rendering path specified, in which case the renderer will automatically use a different path. For example, if the underlying gpu/platform does not support the requested one, or some other situation caused a fallback (for example, deferred rendering is not supported with orthographic projection cameras).  For this reason, we also provide the read-only property actualRenderingPath which allows you to discover which path is actually being used.
renderingPath = nil 
--*
--[Comment]
-- property: RenderingPath Camera.actualRenderingPath	get	
--The rendering path that is currently being used (Read Only).  The actual rendering path might be different from the user-specified renderingPath if the underlying gpu/platform does not support the requested one, or some other situation caused a fallback (for example, deferred rendering is not supported with orthographic projection cameras).
actualRenderingPath = nil 
--*
--[Comment]
-- property: Boolean Camera.hdr	get	set	
--High dynamic range rendering.
hdr = nil 
--*
--[Comment]
-- property: Single Camera.orthographicSize	get	set	
--Camera's half-size when in orthographic mode.
orthographicSize = nil 
--*
--[Comment]
-- property: Boolean Camera.orthographic	get	set	
--Is the camera orthographic (true) or perspective (false)?
orthographic = nil 
--*
--[Comment]
-- property: OpaqueSortMode Camera.opaqueSortMode	get	set	
--Opaque object sorting mode.
opaqueSortMode = nil 
--*
--[Comment]
-- property: TransparencySortMode Camera.transparencySortMode	get	set	
--Transparent object sorting mode.
transparencySortMode = nil 
--*
--[Comment]
-- property: Single Camera.depth	get	set	
--Camera's depth in the camera rendering order.
depth = nil 
--*
--[Comment]
-- property: Single Camera.aspect	get	set	
--The aspect ratio (width divided by height).
aspect = nil 
--*
--[Comment]
-- property: Int32 Camera.cullingMask	get	set	
--This is used to render parts of the scene selectively.
cullingMask = nil 
--*
--[Comment]
-- property: Int32 Camera.eventMask	get	set	
--Mask to select which layers can trigger events on the camera.
eventMask = nil 
--*
--[Comment]
-- property: Color Camera.backgroundColor	get	set	
--The color with which the screen will be cleared.
backgroundColor = nil 
--*
--[Comment]
-- property: Rect Camera.rect	get	set	
--Where on the screen is the camera rendered in normalized coordinates.
rect = nil 
--*
--[Comment]
-- property: Rect Camera.pixelRect	get	set	
--Where on the screen is the camera rendered in pixel coordinates.
pixelRect = nil 
--*
--[Comment]
-- property: RenderTexture Camera.targetTexture	get	set	
--Destination render texture.
targetTexture = nil 
--*
--[Comment]
-- property: Int32 Camera.pixelWidth	get	
--How wide is the camera in pixels (Read Only).
pixelWidth = nil 
--*
--[Comment]
-- property: Int32 Camera.pixelHeight	get	
--How tall is the camera in pixels (Read Only).
pixelHeight = nil 
--*
--[Comment]
-- property: Matrix4x4 Camera.cameraToWorldMatrix	get	
--Matrix that transforms from camera space to world space (Read Only).
cameraToWorldMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 Camera.worldToCameraMatrix	get	set	
--Matrix that transforms from world to camera space.
worldToCameraMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 Camera.projectionMatrix	get	set	
--Set a custom projection matrix.
projectionMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 Camera.nonJitteredProjectionMatrix	get	set	
--Get or set the raw projection matrix with no camera offset (no jittering). 
nonJitteredProjectionMatrix = nil 
--*
--[Comment]
-- property: Vector3 Camera.velocity	get	
--Get the world-space speed of the camera (Read Only).
velocity = nil 
--*
--[Comment]
-- property: CameraClearFlags Camera.clearFlags	get	set	
--How the camera clears the background.
clearFlags = nil 
--*
--[Comment]
-- property: Boolean Camera.stereoEnabled	get	
--Stereoscopic rendering.
stereoEnabled = nil 
--*
--[Comment]
-- property: Single Camera.stereoSeparation	get	set	
--Distance between the virtual eyes.
stereoSeparation = nil 
--*
--[Comment]
-- property: Single Camera.stereoConvergence	get	set	
--Distance to a point where virtual eyes converge.
stereoConvergence = nil 
--*
--[Comment]
-- property: CameraType Camera.cameraType	get	set	
--Identifies what kind of camera this is.
cameraType = nil 
--*
--[Comment]
-- property: Boolean Camera.stereoMirrorMode	get	set	
--Render only once and use resulting image for both eyes.
stereoMirrorMode = nil 
--*
--[Comment]
-- property: StereoTargetEyeMask Camera.stereoTargetEye	get	set	
--When Virtual Reality is enabled, the stereoTargetEye value determines which eyes of the Head Mounted Display (HMD) this camera renders to. The default is to render both eyes.  The values passed to stereoTargetEye are found in the StereoTargetEyeMask enum. Every camera will render to the Main Game Window by default. If you do not want to see the content from this camera in the Main Game Window, use a camera with a higher depth value than this camera, or set the Camera's showDeviceView value to false.
stereoTargetEye = nil 
--*
--[Comment]
-- property: Int32 Camera.targetDisplay	get	set	
--Set the target display for this Camera.
targetDisplay = nil 
--*
--[Comment]
-- property: Camera Camera.main	get	
--The first enabled camera tagged "MainCamera" (Read Only).
main = nil 
--*
--[Comment]
-- property: Camera Camera.current	get	
--The camera we are currently rendering with, for low-level render control only (Read Only).
current = nil 
--*
--[Comment]
-- property: Camera[] Camera.allCameras	get	
--Returns all enabled cameras in the scene.
allCameras = nil 
--*
--[Comment]
-- property: Int32 Camera.allCamerasCount	get	
--The number of cameras in the current scene.
allCamerasCount = nil 
--*
--[Comment]
-- property: Boolean Camera.useOcclusionCulling	get	set	
--Whether or not the Camera will use occlusion culling during rendering.
useOcclusionCulling = nil 
--*
--[Comment]
-- property: Matrix4x4 Camera.cullingMatrix	get	set	
--Sets a custom matrix for the camera to use for all culling queries.
cullingMatrix = nil 
--*
--[Comment]
-- property: Single[] Camera.layerCullDistances	get	set	
--Per-layer culling distances.
layerCullDistances = nil 
--*
--[Comment]
-- property: Boolean Camera.layerCullSpherical	get	set	
--How to perform per-layer culling for a Camera.
layerCullSpherical = nil 
--*
--[Comment]
-- property: DepthTextureMode Camera.depthTextureMode	get	set	
--How and if camera generates a depth texture.
depthTextureMode = nil 
--*
--[Comment]
-- property: Boolean Camera.clearStencilAfterLightingPass	get	set	
--Should the camera clear the stencil buffer after the deferred light pass?
clearStencilAfterLightingPass = nil 
--*
--[Comment]
-- property: Int32 Camera.commandBufferCount	get	
--Number of command buffers set up on this camera (Read Only).
commandBufferCount = nil 
--*
--[Comment]
-- property: Boolean Camera.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Camera.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Camera.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Camera.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Camera.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Camera.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Camera.hideFlags	get	set	
hideFlags = nil 
--*
----Void Camera:SetTargetBuffers(RenderBuffer colorBuffer,RenderBuffer depthBuffer)
--Void Camera:SetTargetBuffers(RenderBuffer[] colorBuffer,RenderBuffer depthBuffer)
function SetTargetBuffers() end 

----Void Camera:ResetWorldToCameraMatrix()
function ResetWorldToCameraMatrix() end 

----Void Camera:ResetProjectionMatrix()
function ResetProjectionMatrix() end 

----Void Camera:ResetAspect()
function ResetAspect() end 

----Void Camera:ResetFieldOfView()
function ResetFieldOfView() end 

----Void Camera:SetStereoViewMatrices(Matrix4x4 leftMatrix,Matrix4x4 rightMatrix)
function SetStereoViewMatrices() end 

----Matrix4x4 Camera:GetStereoViewMatrix(StereoscopicEye eye)
function GetStereoViewMatrix() end 

----Void Camera:SetStereoViewMatrix(StereoscopicEye eye,Matrix4x4 matrix)
function SetStereoViewMatrix() end 

----Void Camera:ResetStereoViewMatrices()
function ResetStereoViewMatrices() end 

----Void Camera:SetStereoProjectionMatrices(Matrix4x4 leftMatrix,Matrix4x4 rightMatrix)
function SetStereoProjectionMatrices() end 

----Matrix4x4 Camera:GetStereoProjectionMatrix(StereoscopicEye eye)
function GetStereoProjectionMatrix() end 

----Void Camera:SetStereoProjectionMatrix(StereoscopicEye eye,Matrix4x4 matrix)
function SetStereoProjectionMatrix() end 

----Void Camera:ResetStereoProjectionMatrices()
function ResetStereoProjectionMatrices() end 

----Vector3 Camera:WorldToScreenPoint(Vector3 position)
function WorldToScreenPoint() end 

----Vector3 Camera:WorldToViewportPoint(Vector3 position)
function WorldToViewportPoint() end 

----Vector3 Camera:ViewportToWorldPoint(Vector3 position)
function ViewportToWorldPoint() end 

----Vector3 Camera:ScreenToWorldPoint(Vector3 position)
function ScreenToWorldPoint() end 

----Vector3 Camera:ScreenToViewportPoint(Vector3 position)
function ScreenToViewportPoint() end 

----Vector3 Camera:ViewportToScreenPoint(Vector3 position)
function ViewportToScreenPoint() end 

----Ray Camera:ViewportPointToRay(Vector3 position)
function ViewportPointToRay() end 

----Ray Camera:ScreenPointToRay(Vector3 position)
function ScreenPointToRay() end 

----Int32 Camera.GetAllCameras(Camera[] cameras)
function Camera.GetAllCameras() end 

----Void Camera:Render()
function Render() end 

----Void Camera:RenderWithShader(Shader shader,String replacementTag)
function RenderWithShader() end 

----Void Camera:SetReplacementShader(Shader shader,String replacementTag)
function SetReplacementShader() end 

----Void Camera:ResetReplacementShader()
function ResetReplacementShader() end 

----Void Camera:ResetCullingMatrix()
function ResetCullingMatrix() end 

----Void Camera:RenderDontRestore()
function RenderDontRestore() end 

----Void Camera.SetupCurrent(Camera cur)
function Camera.SetupCurrent() end 

----Boolean Camera:RenderToCubemap(Cubemap cubemap)
--Boolean Camera:RenderToCubemap(Cubemap cubemap,Int32 faceMask)
--Boolean Camera:RenderToCubemap(RenderTexture cubemap)
--Boolean Camera:RenderToCubemap(RenderTexture cubemap,Int32 faceMask)
function RenderToCubemap() end 

----Void Camera:CopyFrom(Camera other)
function CopyFrom() end 

----Void Camera:AddCommandBuffer(CameraEvent evt,CommandBuffer buffer)
function AddCommandBuffer() end 

----Void Camera:RemoveCommandBuffer(CameraEvent evt,CommandBuffer buffer)
function RemoveCommandBuffer() end 

----Void Camera:RemoveCommandBuffers(CameraEvent evt)
function RemoveCommandBuffers() end 

----Void Camera:RemoveAllCommandBuffers()
function RemoveAllCommandBuffers() end 

----CommandBuffer[] Camera:GetCommandBuffers(CameraEvent evt)
function GetCommandBuffers() end 

----Matrix4x4 Camera:CalculateObliqueMatrix(Vector4 clipPlane)
function CalculateObliqueMatrix() end 

AudioSource = {} 
--*
--[Comment]
--consturctor for AudioSource overrides:
--*
--AudioSource.New()
--*

function AudioSource.New() end
--*
--[Comment]
-- property: Single AudioSource.volume	get	set	
--The volume of the audio source (0.0 to 1.0).
volume = nil 
--*
--[Comment]
-- property: Single AudioSource.pitch	get	set	
--The pitch of the audio source.
pitch = nil 
--*
--[Comment]
-- property: Single AudioSource.time	get	set	
--Playback position in seconds.
time = nil 
--*
--[Comment]
-- property: Int32 AudioSource.timeSamples	get	set	
--Playback position in PCM samples.
timeSamples = nil 
--*
--[Comment]
-- property: AudioClip AudioSource.clip	get	set	
--The default AudioClip to play.
clip = nil 
--*
--[Comment]
-- property: AudioMixerGroup AudioSource.outputAudioMixerGroup	get	set	
--The target group to which the AudioSource should route its signal.
outputAudioMixerGroup = nil 
--*
--[Comment]
-- property: Boolean AudioSource.isPlaying	get	
--Is the clip playing right now (Read Only)?
isPlaying = nil 
--*
--[Comment]
-- property: Boolean AudioSource.isVirtual	get	
--True if all sounds played by the AudioSource (main sound started by Play() or playOnAwake as well as one-shots) are culled by the audio system.
isVirtual = nil 
--*
--[Comment]
-- property: Boolean AudioSource.loop	get	set	
--Is the audio clip looping?
loop = nil 
--*
--[Comment]
-- property: Boolean AudioSource.ignoreListenerVolume	get	set	
--This makes the audio source not take into account the volume of the audio listener.
ignoreListenerVolume = nil 
--*
--[Comment]
-- property: Boolean AudioSource.playOnAwake	get	set	
--If set to true, the audio source will automatically start playing on awake.
playOnAwake = nil 
--*
--[Comment]
-- property: Boolean AudioSource.ignoreListenerPause	get	set	
--Allows AudioSource to play even though AudioListener.pause is set to true. This is useful for the menu element sounds or background music in pause menus.
ignoreListenerPause = nil 
--*
--[Comment]
-- property: AudioVelocityUpdateMode AudioSource.velocityUpdateMode	get	set	
--Whether the Audio Source should be updated in the fixed or dynamic update.
velocityUpdateMode = nil 
--*
--[Comment]
-- property: Single AudioSource.panStereo	get	set	
--Pans a playing sound in a stereo way (left or right). This only applies to sounds that are Mono or Stereo.
panStereo = nil 
--*
--[Comment]
-- property: Single AudioSource.spatialBlend	get	set	
--Sets how much this AudioSource is affected by 3D spatialisation calculations (attenuation, doppler etc). 0.0 makes the sound full 2D, 1.0 makes it full 3D.
spatialBlend = nil 
--*
--[Comment]
-- property: Boolean AudioSource.spatialize	get	set	
--Enables or disables spatialization.
spatialize = nil 
--*
--[Comment]
-- property: Single AudioSource.reverbZoneMix	get	set	
--The amount by which the signal from the AudioSource will be mixed into the global reverb associated with the Reverb Zones.
reverbZoneMix = nil 
--*
--[Comment]
-- property: Boolean AudioSource.bypassEffects	get	set	
--Bypass effects (Applied from filter components or global listener filters).
bypassEffects = nil 
--*
--[Comment]
-- property: Boolean AudioSource.bypassListenerEffects	get	set	
--When set global effects on the AudioListener will not be applied to the audio signal generated by the AudioSource. Does not apply if the AudioSource is playing into a mixer group.
bypassListenerEffects = nil 
--*
--[Comment]
-- property: Boolean AudioSource.bypassReverbZones	get	set	
--When set doesn't route the signal from an AudioSource into the global reverb associated with reverb zones.
bypassReverbZones = nil 
--*
--[Comment]
-- property: Single AudioSource.dopplerLevel	get	set	
--Sets the Doppler scale for this AudioSource.
dopplerLevel = nil 
--*
--[Comment]
-- property: Single AudioSource.spread	get	set	
--Sets the spread angle (in degrees) of a 3d stereo or multichannel sound in speaker space.
spread = nil 
--*
--[Comment]
-- property: Int32 AudioSource.priority	get	set	
--Sets the priority of the AudioSource.
priority = nil 
--*
--[Comment]
-- property: Boolean AudioSource.mute	get	set	
--Un- / Mutes the AudioSource. Mute sets the volume=0, Un-Mute restore the original volume.
mute = nil 
--*
--[Comment]
-- property: Single AudioSource.minDistance	get	set	
--Within the Min distance the AudioSource will cease to grow louder in volume.
minDistance = nil 
--*
--[Comment]
-- property: Single AudioSource.maxDistance	get	set	
--(Logarithmic rolloff) MaxDistance is the distance a sound stops attenuating at.
maxDistance = nil 
--*
--[Comment]
-- property: AudioRolloffMode AudioSource.rolloffMode	get	set	
--Sets/Gets how the AudioSource attenuates over distance.
rolloffMode = nil 
--*
--[Comment]
-- property: Boolean AudioSource.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean AudioSource.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform AudioSource.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject AudioSource.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String AudioSource.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String AudioSource.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags AudioSource.hideFlags	get	set	
hideFlags = nil 
--*
----Void AudioSource:Play(UInt64 delay)
--Void AudioSource:Play()
function Play() end 

----Void AudioSource:PlayDelayed(Single delay)
function PlayDelayed() end 

----Void AudioSource:PlayScheduled(Double time)
function PlayScheduled() end 

----Void AudioSource:SetScheduledStartTime(Double time)
function SetScheduledStartTime() end 

----Void AudioSource:SetScheduledEndTime(Double time)
function SetScheduledEndTime() end 

----Void AudioSource:Stop()
function Stop() end 

----Void AudioSource:Pause()
function Pause() end 

----Void AudioSource:UnPause()
function UnPause() end 

----Void AudioSource:PlayOneShot(AudioClip clip,Single volumeScale)
--Void AudioSource:PlayOneShot(AudioClip clip)
function PlayOneShot() end 

----Void AudioSource.PlayClipAtPoint(AudioClip clip,Vector3 position)
--Void AudioSource.PlayClipAtPoint(AudioClip clip,Vector3 position,Single volume)
function AudioSource.PlayClipAtPoint() end 

----Void AudioSource:SetCustomCurve(AudioSourceCurveType type,AnimationCurve curve)
function SetCustomCurve() end 

----AnimationCurve AudioSource:GetCustomCurve(AudioSourceCurveType type)
function GetCustomCurve() end 

----Void AudioSource:GetOutputData(Single[] samples,Int32 channel)
function GetOutputData() end 

----Void AudioSource:GetSpectrumData(Single[] samples,Int32 channel,FFTWindow window)
function GetSpectrumData() end 

----Boolean AudioSource:SetSpatializerFloat(Int32 index,Single value)
function SetSpatializerFloat() end 

----Boolean AudioSource:GetSpatializerFloat(Int32 index,Single& value)
function GetSpatializerFloat() end 

Debug = {} 
--*
--[Comment]
--consturctor for Debug overrides:
--*
--Debug.New()
--*

function Debug.New() end
--*
--[Comment]
-- property: ILogger Debug.logger	get	
--Get default debug logger.
logger = nil 
--*
--[Comment]
-- property: Boolean Debug.developerConsoleVisible	get	set	
--Reports whether the development console is visible. The development console cannot be made to appear using:
developerConsoleVisible = nil 
--*
--[Comment]
-- property: Boolean Debug.isDebugBuild	get	
--In the Build Settings dialog there is a check box called "Development Build".
isDebugBuild = nil 
--*
----Void Debug.DrawLine(Vector3 start,Vector3 end,Color color,Single duration,Boolean depthTest)
--Void Debug.DrawLine(Vector3 start,Vector3 end,Color color,Single duration)
--Void Debug.DrawLine(Vector3 start,Vector3 end,Color color)
--Void Debug.DrawLine(Vector3 start,Vector3 end)
function Debug.DrawLine() end 

----Void Debug.DrawRay(Vector3 start,Vector3 dir,Color color,Single duration)
--Void Debug.DrawRay(Vector3 start,Vector3 dir,Color color)
--Void Debug.DrawRay(Vector3 start,Vector3 dir)
--Void Debug.DrawRay(Vector3 start,Vector3 dir,Color color,Single duration,Boolean depthTest)
function Debug.DrawRay() end 

----Void Debug.Break()
function Debug.Break() end 

----Void Debug.DebugBreak()
function Debug.DebugBreak() end 

----Void Debug.Log(Object message)
--Void Debug.Log(Object message,Object context)
function Debug.Log() end 

----Void Debug.LogFormat(String format,Object[] args)
--Void Debug.LogFormat(Object context,String format,Object[] args)
function Debug.LogFormat() end 

----Void Debug.LogError(Object message)
--Void Debug.LogError(Object message,Object context)
function Debug.LogError() end 

----Void Debug.LogErrorFormat(String format,Object[] args)
--Void Debug.LogErrorFormat(Object context,String format,Object[] args)
function Debug.LogErrorFormat() end 

----Void Debug.ClearDeveloperConsole()
function Debug.ClearDeveloperConsole() end 

----Void Debug.LogException(Exception exception)
--Void Debug.LogException(Exception exception,Object context)
function Debug.LogException() end 

----Void Debug.LogWarning(Object message)
--Void Debug.LogWarning(Object message,Object context)
function Debug.LogWarning() end 

----Void Debug.LogWarningFormat(String format,Object[] args)
--Void Debug.LogWarningFormat(Object context,String format,Object[] args)
function Debug.LogWarningFormat() end 

----Void Debug.Assert(Boolean condition)
--Void Debug.Assert(Boolean condition,Object context)
--Void Debug.Assert(Boolean condition,Object message)
--Void Debug.Assert(Boolean condition,String message)
--Void Debug.Assert(Boolean condition,Object message,Object context)
--Void Debug.Assert(Boolean condition,String message,Object context)
function Debug.Assert() end 

----Void Debug.AssertFormat(Boolean condition,String format,Object[] args)
--Void Debug.AssertFormat(Boolean condition,Object context,String format,Object[] args)
function Debug.AssertFormat() end 

----Void Debug.LogAssertion(Object message)
--Void Debug.LogAssertion(Object message,Object context)
function Debug.LogAssertion() end 

----Void Debug.LogAssertionFormat(String format,Object[] args)
--Void Debug.LogAssertionFormat(Object context,String format,Object[] args)
function Debug.LogAssertionFormat() end 

Behaviour = {} 
--*
--[Comment]
--consturctor for Behaviour overrides:
--*
--Behaviour.New()
--*

function Behaviour.New() end
--*
--[Comment]
-- property: Boolean Behaviour.enabled	get	set	
--Enabled Behaviours are Updated, disabled Behaviours are not.
enabled = nil 
--*
--[Comment]
-- property: Boolean Behaviour.isActiveAndEnabled	get	
--Has the Behaviour had enabled called.
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Behaviour.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Behaviour.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Behaviour.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Behaviour.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Behaviour.hideFlags	get	set	
hideFlags = nil 
--*
MonoBehaviour = {} 
--*
--[Comment]
--consturctor for MonoBehaviour overrides:
--*
--MonoBehaviour.New()
--*

function MonoBehaviour.New() end
--*
--[Comment]
-- property: Boolean MonoBehaviour.useGUILayout	get	set	
--Disabling this lets you skip the GUI layout phase.
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean MonoBehaviour.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean MonoBehaviour.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform MonoBehaviour.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject MonoBehaviour.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String MonoBehaviour.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String MonoBehaviour.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags MonoBehaviour.hideFlags	get	set	
hideFlags = nil 
--*
----Void MonoBehaviour:Invoke(String methodName,Single time)
function Invoke() end 

----Void MonoBehaviour:InvokeRepeating(String methodName,Single time,Single repeatRate)
function InvokeRepeating() end 

----Void MonoBehaviour:CancelInvoke()
--Void MonoBehaviour:CancelInvoke(String methodName)
function CancelInvoke() end 

----Boolean MonoBehaviour:IsInvoking(String methodName)
--Boolean MonoBehaviour:IsInvoking()
function IsInvoking() end 

----Coroutine MonoBehaviour:StartCoroutine(IEnumerator routine)
--Coroutine MonoBehaviour:StartCoroutine(String methodName,Object value)
--Coroutine MonoBehaviour:StartCoroutine(String methodName)
function StartCoroutine() end 

----Coroutine MonoBehaviour:StartCoroutine_Auto(IEnumerator routine)
function StartCoroutine_Auto() end 

----Void MonoBehaviour:StopCoroutine(String methodName)
--Void MonoBehaviour:StopCoroutine(IEnumerator routine)
--Void MonoBehaviour:StopCoroutine(Coroutine routine)
function StopCoroutine() end 

----Void MonoBehaviour:StopAllCoroutines()
function StopAllCoroutines() end 

----Void MonoBehaviour.print(Object message)
function MonoBehaviour.print() end 

GameObject = {} 
--*
--[Comment]
--consturctor for GameObject overrides:
--*
--GameObject.New(String name)
--Creates a new game object, named name.
--*

--GameObject.New()
--Creates a new game object.
--*

--GameObject.New(String name,Type[] components)
--Creates a game object and attaches the specified components.
--*

function GameObject.New() end
--*
--[Comment]
-- property: Transform GameObject.transform	get	
--The Transform attached to this GameObject. (null if there is none attached).
transform = nil 
--*
--[Comment]
-- property: Int32 GameObject.layer	get	set	
--The layer the game object is in. A layer is in the range [0...31].
layer = nil 
--*
--[Comment]
-- property: Boolean GameObject.activeSelf	get	
--The local active state of this GameObject. (Read Only)
activeSelf = nil 
--*
--[Comment]
-- property: Boolean GameObject.activeInHierarchy	get	
--Is the GameObject active in the scene?
activeInHierarchy = nil 
--*
--[Comment]
-- property: Boolean GameObject.isStatic	get	set	
--Editor only API that specifies if a game object is static.
isStatic = nil 
--*
--[Comment]
-- property: String GameObject.tag	get	set	
--The tag of this game object.
tag = nil 
--*
--[Comment]
-- property: Scene GameObject.scene	get	
--Scene that the GameObject is part of.
scene = nil 
--*
--[Comment]
-- property: GameObject GameObject.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String GameObject.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags GameObject.hideFlags	get	set	
hideFlags = nil 
--*
----GameObject GameObject.CreatePrimitive(PrimitiveType type)
function GameObject.CreatePrimitive() end 

----Component GameObject:GetComponent(Type type)
--Component GameObject:GetComponent(String type)
function GetComponent() end 

----Component GameObject:GetComponentInChildren(Type type,Boolean includeInactive)
--Component GameObject:GetComponentInChildren(Type type)
function GetComponentInChildren() end 

----Component GameObject:GetComponentInParent(Type type)
function GetComponentInParent() end 

----Component[] GameObject:GetComponents(Type type)
--Void GameObject:GetComponents(Type type,List`1 results)
function GetComponents() end 

----Component[] GameObject:GetComponentsInChildren(Type type)
--Component[] GameObject:GetComponentsInChildren(Type type,Boolean includeInactive)
function GetComponentsInChildren() end 

----Component[] GameObject:GetComponentsInParent(Type type)
--Component[] GameObject:GetComponentsInParent(Type type,Boolean includeInactive)
function GetComponentsInParent() end 

----Void GameObject:SetActive(Boolean value)
function SetActive() end 

----Boolean GameObject:CompareTag(String tag)
function CompareTag() end 

----GameObject GameObject.FindGameObjectWithTag(String tag)
function GameObject.FindGameObjectWithTag() end 

----GameObject GameObject.FindWithTag(String tag)
function GameObject.FindWithTag() end 

----GameObject[] GameObject.FindGameObjectsWithTag(String tag)
function GameObject.FindGameObjectsWithTag() end 

----Void GameObject:SendMessageUpwards(String methodName,Object value,SendMessageOptions options)
--Void GameObject:SendMessageUpwards(String methodName,Object value)
--Void GameObject:SendMessageUpwards(String methodName)
--Void GameObject:SendMessageUpwards(String methodName,SendMessageOptions options)
function SendMessageUpwards() end 

----Void GameObject:SendMessage(String methodName,Object value,SendMessageOptions options)
--Void GameObject:SendMessage(String methodName,Object value)
--Void GameObject:SendMessage(String methodName)
--Void GameObject:SendMessage(String methodName,SendMessageOptions options)
function SendMessage() end 

----Void GameObject:BroadcastMessage(String methodName,Object parameter,SendMessageOptions options)
--Void GameObject:BroadcastMessage(String methodName,Object parameter)
--Void GameObject:BroadcastMessage(String methodName)
--Void GameObject:BroadcastMessage(String methodName,SendMessageOptions options)
function BroadcastMessage() end 

----Component GameObject:AddComponent(Type componentType)
function AddComponent() end 

----GameObject GameObject.Find(String name)
function GameObject.Find() end 

TrackedReference = {} 
--*
----Boolean TrackedReference:Equals(Object o)
function Equals() end 

----Int32 TrackedReference:GetHashCode()
function GetHashCode() end 

----Boolean TrackedReference.op_Equality(TrackedReference x,TrackedReference y)
function TrackedReference.op_Equality() end 

----Boolean TrackedReference.op_Inequality(TrackedReference x,TrackedReference y)
function TrackedReference.op_Inequality() end 

----Boolean TrackedReference.op_Implicit(TrackedReference exists)
function TrackedReference.op_Implicit() end 

Application = {} 
--*
--[Comment]
--consturctor for Application overrides:
--*
--Application.New()
--*

function Application.New() end
--*
--[Comment]
-- property: Int32 Application.streamedBytes	get	
--How many bytes have we downloaded from the main unity web stream (Read Only).
streamedBytes = nil 
--*
--[Comment]
-- property: Boolean Application.isPlaying	get	
--Returns true when in any kind of player (Read Only).
isPlaying = nil 
--*
--[Comment]
-- property: Boolean Application.isEditor	get	
--Are we running inside the Unity editor? (Read Only)
isEditor = nil 
--*
--[Comment]
-- property: Boolean Application.isWebPlayer	get	
--Are we running inside a web player? (Read Only)
isWebPlayer = nil 
--*
--[Comment]
-- property: RuntimePlatform Application.platform	get	
--Returns the platform the game is running on (Read Only).
platform = nil 
--*
--[Comment]
-- property: Boolean Application.isMobilePlatform	get	
--Is the current Runtime platform a known mobile platform.
isMobilePlatform = nil 
--*
--[Comment]
-- property: Boolean Application.isConsolePlatform	get	
--Is the current Runtime platform a known console platform.
isConsolePlatform = nil 
--*
--[Comment]
-- property: Boolean Application.runInBackground	get	set	
--Should the player be running when the application is in the background?
runInBackground = nil 
--*
--[Comment]
-- property: String Application.dataPath	get	
--Contains the path to the game data folder (Read Only).
dataPath = nil 
--*
--[Comment]
-- property: String Application.streamingAssetsPath	get	
--Contains the path to the StreamingAssets folder (Read Only).
streamingAssetsPath = nil 
--*
--[Comment]
-- property: String Application.persistentDataPath	get	
--Contains the path to a persistent data directory (Read Only).
persistentDataPath = nil 
--*
--[Comment]
-- property: String Application.temporaryCachePath	get	
--Contains the path to a temporary data / cache directory (Read Only).
temporaryCachePath = nil 
--*
--[Comment]
-- property: String Application.srcValue	get	
--The path to the web player data file relative to the html file (Read Only).
srcValue = nil 
--*
--[Comment]
-- property: String Application.absoluteURL	get	
--The absolute path to the web player data file (Read Only).
absoluteURL = nil 
--*
--[Comment]
-- property: String Application.unityVersion	get	
--The version of the Unity runtime used to play the content.
unityVersion = nil 
--*
--[Comment]
-- property: String Application.version	get	
--Returns application version number  (Read Only).
version = nil 
--*
--[Comment]
-- property: String Application.bundleIdentifier	get	
--Returns application bundle identifier at runtime.
bundleIdentifier = nil 
--*
--[Comment]
-- property: ApplicationInstallMode Application.installMode	get	
--Returns application install mode (Read Only).
installMode = nil 
--*
--[Comment]
-- property: ApplicationSandboxType Application.sandboxType	get	
--Returns application running in sandbox (Read Only).
sandboxType = nil 
--*
--[Comment]
-- property: String Application.productName	get	
--Returns application product name (Read Only).
productName = nil 
--*
--[Comment]
-- property: String Application.companyName	get	
--Return application company name (Read Only).
companyName = nil 
--*
--[Comment]
-- property: String Application.cloudProjectId	get	
--A unique cloud project identifier. It is unique for every project (Read Only).
cloudProjectId = nil 
--*
--[Comment]
-- property: Boolean Application.webSecurityEnabled	get	
--Indicates whether Unity's webplayer security model is enabled.
webSecurityEnabled = nil 
--*
--[Comment]
-- property: String Application.webSecurityHostUrl	get	
webSecurityHostUrl = nil 
--*
--[Comment]
-- property: Int32 Application.targetFrameRate	get	set	
--Instructs game to try to render at a specified frame rate.
targetFrameRate = nil 
--*
--[Comment]
-- property: SystemLanguage Application.systemLanguage	get	
--The language the user's operating system is running in.
systemLanguage = nil 
--*
--[Comment]
-- property: ThreadPriority Application.backgroundLoadingPriority	get	set	
--Priority of background loading thread.
backgroundLoadingPriority = nil 
--*
--[Comment]
-- property: NetworkReachability Application.internetReachability	get	
--Returns the type of Internet reachability currently possible on the device.
internetReachability = nil 
--*
--[Comment]
-- property: Boolean Application.genuine	get	
--Returns false if application is altered in any way after it was built.
genuine = nil 
--*
--[Comment]
-- property: Boolean Application.genuineCheckAvailable	get	
--Returns true if application integrity can be confirmed.
genuineCheckAvailable = nil 
--*
--[Comment]
-- property: Boolean Application.isShowingSplashScreen	get	
--Checks whether splash screen is being shown.
isShowingSplashScreen = nil 
--*
----Void Application.add_logMessageReceived(LogCallback value)
function Application.add_logMessageReceived() end 

----Void Application.remove_logMessageReceived(LogCallback value)
function Application.remove_logMessageReceived() end 

----Void Application.add_logMessageReceivedThreaded(LogCallback value)
function Application.add_logMessageReceivedThreaded() end 

----Void Application.remove_logMessageReceivedThreaded(LogCallback value)
function Application.remove_logMessageReceivedThreaded() end 

----Void Application.Quit()
function Application.Quit() end 

----Void Application.CancelQuit()
function Application.CancelQuit() end 

----Single Application.GetStreamProgressForLevel(Int32 levelIndex)
--Single Application.GetStreamProgressForLevel(String levelName)
function Application.GetStreamProgressForLevel() end 

----Boolean Application.CanStreamedLevelBeLoaded(Int32 levelIndex)
--Boolean Application.CanStreamedLevelBeLoaded(String levelName)
function Application.CanStreamedLevelBeLoaded() end 

----Void Application.CaptureScreenshot(String filename,Int32 superSize)
--Void Application.CaptureScreenshot(String filename)
function Application.CaptureScreenshot() end 

----Boolean Application.HasProLicense()
function Application.HasProLicense() end 

----Void Application.ExternalCall(String functionName,Object[] args)
function Application.ExternalCall() end 

----Void Application.ExternalEval(String script)
function Application.ExternalEval() end 

----Boolean Application.RequestAdvertisingIdentifierAsync(AdvertisingIdentifierCallback delegateMethod)
function Application.RequestAdvertisingIdentifierAsync() end 

----Void Application.OpenURL(String url)
function Application.OpenURL() end 

----StackTraceLogType Application.GetStackTraceLogType(LogType logType)
function Application.GetStackTraceLogType() end 

----Void Application.SetStackTraceLogType(LogType logType,StackTraceLogType stackTraceType)
function Application.SetStackTraceLogType() end 

----AsyncOperation Application.RequestUserAuthorization(UserAuthorization mode)
function Application.RequestUserAuthorization() end 

----Boolean Application.HasUserAuthorization(UserAuthorization mode)
function Application.HasUserAuthorization() end 

Physics = {} 
--*
--[Comment]
--consturctor for Physics overrides:
--*
--Physics.New()
--*

function Physics.New() end
--*
--[Comment]
-- property: Vector3 Physics.gravity	get	set	
--The gravity applied to all rigid bodies in the scene.
gravity = nil 
--*
--[Comment]
-- property: Single Physics.defaultContactOffset	get	set	
--The default contact offset of the newly created colliders.
defaultContactOffset = nil 
--*
--[Comment]
-- property: Single Physics.bounceThreshold	get	set	
--Two colliding objects with a relative velocity below this will not bounce (default 2). Must be positive.
bounceThreshold = nil 
--*
--[Comment]
-- property: Int32 Physics.defaultSolverIterations	get	set	
--The defaultSolverIterations determines how accurately Rigidbody joints and collision contacts are resolved. (default 6). Must be positive.
defaultSolverIterations = nil 
--*
--[Comment]
-- property: Int32 Physics.defaultSolverVelocityIterations	get	set	
--The defaultSolverVelocityIterations affects how how accurately Rigidbody joints and collision contacts are resolved. (default 1). Must be positive.
defaultSolverVelocityIterations = nil 
--*
--[Comment]
-- property: Single Physics.sleepThreshold	get	set	
--The mass-normalized energy threshold, below which objects start going to sleep.
sleepThreshold = nil 
--*
--[Comment]
-- property: Boolean Physics.queriesHitTriggers	get	set	
--Specifies whether queries (raycasts, spherecasts, overlap tests, etc.) hit Triggers by default.
queriesHitTriggers = nil 
--*
----Boolean Physics.Raycast(Vector3 origin,Vector3 direction,Single maxDistance,Int32 layerMask)
--Boolean Physics.Raycast(Vector3 origin,Vector3 direction,Single maxDistance)
--Boolean Physics.Raycast(Vector3 origin,Vector3 direction)
--Boolean Physics.Raycast(Vector3 origin,Vector3 direction,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.Raycast(Vector3 origin,Vector3 direction,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask)
--Boolean Physics.Raycast(Vector3 origin,Vector3 direction,RaycastHit& hitInfo,Single maxDistance)
--Boolean Physics.Raycast(Vector3 origin,Vector3 direction,RaycastHit& hitInfo)
--Boolean Physics.Raycast(Vector3 origin,Vector3 direction,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.Raycast(Ray ray,Single maxDistance,Int32 layerMask)
--Boolean Physics.Raycast(Ray ray,Single maxDistance)
--Boolean Physics.Raycast(Ray ray)
--Boolean Physics.Raycast(Ray ray,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.Raycast(Ray ray,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask)
--Boolean Physics.Raycast(Ray ray,RaycastHit& hitInfo,Single maxDistance)
--Boolean Physics.Raycast(Ray ray,RaycastHit& hitInfo)
--Boolean Physics.Raycast(Ray ray,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
function Physics.Raycast() end 

----RaycastHit[] Physics.RaycastAll(Ray ray,Single maxDistance,Int32 layerMask)
--RaycastHit[] Physics.RaycastAll(Ray ray,Single maxDistance)
--RaycastHit[] Physics.RaycastAll(Ray ray)
--RaycastHit[] Physics.RaycastAll(Ray ray,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--RaycastHit[] Physics.RaycastAll(Vector3 origin,Vector3 direction,Single maxDistance,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--RaycastHit[] Physics.RaycastAll(Vector3 origin,Vector3 direction,Single maxDistance,Int32 layermask)
--RaycastHit[] Physics.RaycastAll(Vector3 origin,Vector3 direction,Single maxDistance)
--RaycastHit[] Physics.RaycastAll(Vector3 origin,Vector3 direction)
function Physics.RaycastAll() end 

----Int32 Physics.RaycastNonAlloc(Ray ray,RaycastHit[] results,Single maxDistance,Int32 layerMask)
--Int32 Physics.RaycastNonAlloc(Ray ray,RaycastHit[] results,Single maxDistance)
--Int32 Physics.RaycastNonAlloc(Ray ray,RaycastHit[] results)
--Int32 Physics.RaycastNonAlloc(Ray ray,RaycastHit[] results,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.RaycastNonAlloc(Vector3 origin,Vector3 direction,RaycastHit[] results,Single maxDistance,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.RaycastNonAlloc(Vector3 origin,Vector3 direction,RaycastHit[] results,Single maxDistance,Int32 layermask)
--Int32 Physics.RaycastNonAlloc(Vector3 origin,Vector3 direction,RaycastHit[] results,Single maxDistance)
--Int32 Physics.RaycastNonAlloc(Vector3 origin,Vector3 direction,RaycastHit[] results)
function Physics.RaycastNonAlloc() end 

----Boolean Physics.Linecast(Vector3 start,Vector3 end,Int32 layerMask)
--Boolean Physics.Linecast(Vector3 start,Vector3 end)
--Boolean Physics.Linecast(Vector3 start,Vector3 end,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.Linecast(Vector3 start,Vector3 end,RaycastHit& hitInfo,Int32 layerMask)
--Boolean Physics.Linecast(Vector3 start,Vector3 end,RaycastHit& hitInfo)
--Boolean Physics.Linecast(Vector3 start,Vector3 end,RaycastHit& hitInfo,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
function Physics.Linecast() end 

----Collider[] Physics.OverlapSphere(Vector3 position,Single radius,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Collider[] Physics.OverlapSphere(Vector3 position,Single radius,Int32 layerMask)
--Collider[] Physics.OverlapSphere(Vector3 position,Single radius)
function Physics.OverlapSphere() end 

----Int32 Physics.OverlapSphereNonAlloc(Vector3 position,Single radius,Collider[] results,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.OverlapSphereNonAlloc(Vector3 position,Single radius,Collider[] results,Int32 layerMask)
--Int32 Physics.OverlapSphereNonAlloc(Vector3 position,Single radius,Collider[] results)
function Physics.OverlapSphereNonAlloc() end 

----Collider[] Physics.OverlapCapsule(Vector3 point0,Vector3 point1,Single radius,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Collider[] Physics.OverlapCapsule(Vector3 point0,Vector3 point1,Single radius,Int32 layerMask)
--Collider[] Physics.OverlapCapsule(Vector3 point0,Vector3 point1,Single radius)
function Physics.OverlapCapsule() end 

----Int32 Physics.OverlapCapsuleNonAlloc(Vector3 point0,Vector3 point1,Single radius,Collider[] results,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.OverlapCapsuleNonAlloc(Vector3 point0,Vector3 point1,Single radius,Collider[] results,Int32 layerMask)
--Int32 Physics.OverlapCapsuleNonAlloc(Vector3 point0,Vector3 point1,Single radius,Collider[] results)
function Physics.OverlapCapsuleNonAlloc() end 

----Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,Single maxDistance,Int32 layerMask)
--Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,Single maxDistance)
--Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction)
--Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask)
--Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit& hitInfo,Single maxDistance)
--Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit& hitInfo)
--Boolean Physics.CapsuleCast(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
function Physics.CapsuleCast() end 

----Boolean Physics.SphereCast(Vector3 origin,Single radius,Vector3 direction,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask)
--Boolean Physics.SphereCast(Vector3 origin,Single radius,Vector3 direction,RaycastHit& hitInfo,Single maxDistance)
--Boolean Physics.SphereCast(Vector3 origin,Single radius,Vector3 direction,RaycastHit& hitInfo)
--Boolean Physics.SphereCast(Vector3 origin,Single radius,Vector3 direction,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.SphereCast(Ray ray,Single radius,Single maxDistance,Int32 layerMask)
--Boolean Physics.SphereCast(Ray ray,Single radius,Single maxDistance)
--Boolean Physics.SphereCast(Ray ray,Single radius)
--Boolean Physics.SphereCast(Ray ray,Single radius,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.SphereCast(Ray ray,Single radius,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask)
--Boolean Physics.SphereCast(Ray ray,Single radius,RaycastHit& hitInfo,Single maxDistance)
--Boolean Physics.SphereCast(Ray ray,Single radius,RaycastHit& hitInfo)
--Boolean Physics.SphereCast(Ray ray,Single radius,RaycastHit& hitInfo,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
function Physics.SphereCast() end 

----RaycastHit[] Physics.CapsuleCastAll(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,Single maxDistance,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--RaycastHit[] Physics.CapsuleCastAll(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,Single maxDistance,Int32 layermask)
--RaycastHit[] Physics.CapsuleCastAll(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,Single maxDistance)
--RaycastHit[] Physics.CapsuleCastAll(Vector3 point1,Vector3 point2,Single radius,Vector3 direction)
function Physics.CapsuleCastAll() end 

----Int32 Physics.CapsuleCastNonAlloc(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit[] results,Single maxDistance,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.CapsuleCastNonAlloc(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit[] results,Single maxDistance,Int32 layermask)
--Int32 Physics.CapsuleCastNonAlloc(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit[] results,Single maxDistance)
--Int32 Physics.CapsuleCastNonAlloc(Vector3 point1,Vector3 point2,Single radius,Vector3 direction,RaycastHit[] results)
function Physics.CapsuleCastNonAlloc() end 

----RaycastHit[] Physics.SphereCastAll(Vector3 origin,Single radius,Vector3 direction,Single maxDistance,Int32 layerMask)
--RaycastHit[] Physics.SphereCastAll(Vector3 origin,Single radius,Vector3 direction,Single maxDistance)
--RaycastHit[] Physics.SphereCastAll(Vector3 origin,Single radius,Vector3 direction)
--RaycastHit[] Physics.SphereCastAll(Vector3 origin,Single radius,Vector3 direction,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--RaycastHit[] Physics.SphereCastAll(Ray ray,Single radius,Single maxDistance,Int32 layerMask)
--RaycastHit[] Physics.SphereCastAll(Ray ray,Single radius,Single maxDistance)
--RaycastHit[] Physics.SphereCastAll(Ray ray,Single radius)
--RaycastHit[] Physics.SphereCastAll(Ray ray,Single radius,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
function Physics.SphereCastAll() end 

----Int32 Physics.SphereCastNonAlloc(Vector3 origin,Single radius,Vector3 direction,RaycastHit[] results,Single maxDistance,Int32 layerMask)
--Int32 Physics.SphereCastNonAlloc(Vector3 origin,Single radius,Vector3 direction,RaycastHit[] results,Single maxDistance)
--Int32 Physics.SphereCastNonAlloc(Vector3 origin,Single radius,Vector3 direction,RaycastHit[] results)
--Int32 Physics.SphereCastNonAlloc(Vector3 origin,Single radius,Vector3 direction,RaycastHit[] results,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.SphereCastNonAlloc(Ray ray,Single radius,RaycastHit[] results,Single maxDistance,Int32 layerMask)
--Int32 Physics.SphereCastNonAlloc(Ray ray,Single radius,RaycastHit[] results,Single maxDistance)
--Int32 Physics.SphereCastNonAlloc(Ray ray,Single radius,RaycastHit[] results)
--Int32 Physics.SphereCastNonAlloc(Ray ray,Single radius,RaycastHit[] results,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
function Physics.SphereCastNonAlloc() end 

----Boolean Physics.CheckSphere(Vector3 position,Single radius,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.CheckSphere(Vector3 position,Single radius,Int32 layerMask)
--Boolean Physics.CheckSphere(Vector3 position,Single radius)
function Physics.CheckSphere() end 

----Boolean Physics.CheckCapsule(Vector3 start,Vector3 end,Single radius,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.CheckCapsule(Vector3 start,Vector3 end,Single radius,Int32 layermask)
--Boolean Physics.CheckCapsule(Vector3 start,Vector3 end,Single radius)
function Physics.CheckCapsule() end 

----Boolean Physics.CheckBox(Vector3 center,Vector3 halfExtents,Quaternion orientation,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.CheckBox(Vector3 center,Vector3 halfExtents,Quaternion orientation,Int32 layermask)
--Boolean Physics.CheckBox(Vector3 center,Vector3 halfExtents,Quaternion orientation)
--Boolean Physics.CheckBox(Vector3 center,Vector3 halfExtents)
function Physics.CheckBox() end 

----Collider[] Physics.OverlapBox(Vector3 center,Vector3 halfExtents,Quaternion orientation,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Collider[] Physics.OverlapBox(Vector3 center,Vector3 halfExtents,Quaternion orientation,Int32 layerMask)
--Collider[] Physics.OverlapBox(Vector3 center,Vector3 halfExtents,Quaternion orientation)
--Collider[] Physics.OverlapBox(Vector3 center,Vector3 halfExtents)
function Physics.OverlapBox() end 

----Int32 Physics.OverlapBoxNonAlloc(Vector3 center,Vector3 halfExtents,Collider[] results,Quaternion orientation,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.OverlapBoxNonAlloc(Vector3 center,Vector3 halfExtents,Collider[] results,Quaternion orientation,Int32 layerMask)
--Int32 Physics.OverlapBoxNonAlloc(Vector3 center,Vector3 halfExtents,Collider[] results,Quaternion orientation)
--Int32 Physics.OverlapBoxNonAlloc(Vector3 center,Vector3 halfExtents,Collider[] results)
function Physics.OverlapBoxNonAlloc() end 

----RaycastHit[] Physics.BoxCastAll(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation,Single maxDistance,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--RaycastHit[] Physics.BoxCastAll(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation,Single maxDistance,Int32 layermask)
--RaycastHit[] Physics.BoxCastAll(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation,Single maxDistance)
--RaycastHit[] Physics.BoxCastAll(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation)
--RaycastHit[] Physics.BoxCastAll(Vector3 center,Vector3 halfExtents,Vector3 direction)
function Physics.BoxCastAll() end 

----Int32 Physics.BoxCastNonAlloc(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit[] results,Quaternion orientation,Single maxDistance,Int32 layermask,QueryTriggerInteraction queryTriggerInteraction)
--Int32 Physics.BoxCastNonAlloc(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit[] results,Quaternion orientation,Single maxDistance,Int32 layermask)
--Int32 Physics.BoxCastNonAlloc(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit[] results,Quaternion orientation,Single maxDistance)
--Int32 Physics.BoxCastNonAlloc(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit[] results,Quaternion orientation)
--Int32 Physics.BoxCastNonAlloc(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit[] results)
function Physics.BoxCastNonAlloc() end 

----Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation,Single maxDistance,Int32 layerMask)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation,Single maxDistance)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,Quaternion orientation,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit& hitInfo,Quaternion orientation,Single maxDistance,Int32 layerMask)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit& hitInfo,Quaternion orientation,Single maxDistance)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit& hitInfo,Quaternion orientation)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit& hitInfo)
--Boolean Physics.BoxCast(Vector3 center,Vector3 halfExtents,Vector3 direction,RaycastHit& hitInfo,Quaternion orientation,Single maxDistance,Int32 layerMask,QueryTriggerInteraction queryTriggerInteraction)
function Physics.BoxCast() end 

----Void Physics.IgnoreCollision(Collider collider1,Collider collider2,Boolean ignore)
--Void Physics.IgnoreCollision(Collider collider1,Collider collider2)
function Physics.IgnoreCollision() end 

----Void Physics.IgnoreLayerCollision(Int32 layer1,Int32 layer2,Boolean ignore)
--Void Physics.IgnoreLayerCollision(Int32 layer1,Int32 layer2)
function Physics.IgnoreLayerCollision() end 

----Boolean Physics.GetIgnoreLayerCollision(Int32 layer1,Int32 layer2)
function Physics.GetIgnoreLayerCollision() end 

Collider = {} 
--*
--[Comment]
--consturctor for Collider overrides:
--*
--Collider.New()
--*

function Collider.New() end
--*
--[Comment]
-- property: Boolean Collider.enabled	get	set	
--Enabled Colliders will collide with other colliders, disabled Colliders won't.
enabled = nil 
--*
--[Comment]
-- property: Rigidbody Collider.attachedRigidbody	get	
--The rigidbody the collider is attached to.
attachedRigidbody = nil 
--*
--[Comment]
-- property: Boolean Collider.isTrigger	get	set	
--Is the collider a trigger?
isTrigger = nil 
--*
--[Comment]
-- property: Single Collider.contactOffset	get	set	
--Contact offset value of this collider.
contactOffset = nil 
--*
--[Comment]
-- property: PhysicMaterial Collider.material	get	set	
--The material used by the collider.
material = nil 
--*
--[Comment]
-- property: PhysicMaterial Collider.sharedMaterial	get	set	
--The shared physic material of this collider.
sharedMaterial = nil 
--*
--[Comment]
-- property: Bounds Collider.bounds	get	
--The world space bounding volume of the collider.
bounds = nil 
--*
--[Comment]
-- property: Transform Collider.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Collider.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Collider.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Collider.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Collider.hideFlags	get	set	
hideFlags = nil 
--*
----Vector3 Collider:ClosestPointOnBounds(Vector3 position)
function ClosestPointOnBounds() end 

----Boolean Collider:Raycast(Ray ray,RaycastHit& hitInfo,Single maxDistance)
function Raycast() end 

Time = {} 
--*
--[Comment]
--consturctor for Time overrides:
--*
--Time.New()
--*

function Time.New() end
--*
--[Comment]
-- property: Single Time.time	get	
--The time at the beginning of this frame (Read Only). This is the time in seconds since the start of the game.
time = nil 
--*
--[Comment]
-- property: Single Time.timeSinceLevelLoad	get	
--The time this frame has started (Read Only). This is the time in seconds since the last level has been loaded.
timeSinceLevelLoad = nil 
--*
--[Comment]
-- property: Single Time.deltaTime	get	
--The time in seconds it took to complete the last frame (Read Only).
deltaTime = nil 
--*
--[Comment]
-- property: Single Time.fixedTime	get	
--The time the latest MonoBehaviour.FixedUpdate has started (Read Only). This is the time in seconds since the start of the game.
fixedTime = nil 
--*
--[Comment]
-- property: Single Time.unscaledTime	get	
--The timeScale-independant time at the beginning of this frame (Read Only). This is the time in seconds since the start of the game.
unscaledTime = nil 
--*
--[Comment]
-- property: Single Time.unscaledDeltaTime	get	
--The timeScale-independent time in seconds it took to complete the last frame (Read Only).
unscaledDeltaTime = nil 
--*
--[Comment]
-- property: Single Time.fixedDeltaTime	get	set	
--The interval in seconds at which physics and other fixed frame rate updates (like MonoBehaviour's MonoBehaviour.FixedUpdate) are performed.
fixedDeltaTime = nil 
--*
--[Comment]
-- property: Single Time.maximumDeltaTime	get	set	
--The maximum time a frame can take. Physics and other fixed frame rate updates (like MonoBehaviour's MonoBehaviour.FixedUpdate).
maximumDeltaTime = nil 
--*
--[Comment]
-- property: Single Time.smoothDeltaTime	get	
--A smoothed out Time.deltaTime (Read Only).
smoothDeltaTime = nil 
--*
--[Comment]
-- property: Single Time.timeScale	get	set	
--The scale at which the time is passing. This can be used for slow motion effects.
timeScale = nil 
--*
--[Comment]
-- property: Int32 Time.frameCount	get	
--The total number of frames that have passed (Read Only).
frameCount = nil 
--*
--[Comment]
-- property: Int32 Time.renderedFrameCount	get	
renderedFrameCount = nil 
--*
--[Comment]
-- property: Single Time.realtimeSinceStartup	get	
--The real time in seconds since the game started (Read Only).
realtimeSinceStartup = nil 
--*
--[Comment]
-- property: Int32 Time.captureFramerate	get	set	
--Slows game playback time to allow screenshots to be saved between frames.
captureFramerate = nil 
--*
Texture = {} 
--*
--[Comment]
--consturctor for Texture overrides:
--*
--Texture.New()
--*

function Texture.New() end
--*
--[Comment]
-- property: Int32 Texture.masterTextureLimit	get	set	
masterTextureLimit = nil 
--*
--[Comment]
-- property: AnisotropicFiltering Texture.anisotropicFiltering	get	set	
anisotropicFiltering = nil 
--*
--[Comment]
-- property: Int32 Texture.width	get	set	
--Width of the texture in pixels. (Read Only)
width = nil 
--*
--[Comment]
-- property: Int32 Texture.height	get	set	
--Height of the texture in pixels. (Read Only)
height = nil 
--*
--[Comment]
-- property: TextureDimension Texture.dimension	get	set	
--Dimensionality (type) of the texture (Read Only).
dimension = nil 
--*
--[Comment]
-- property: FilterMode Texture.filterMode	get	set	
--Filtering mode of the texture.
filterMode = nil 
--*
--[Comment]
-- property: Int32 Texture.anisoLevel	get	set	
--Anisotropic filtering level of the texture.
anisoLevel = nil 
--*
--[Comment]
-- property: TextureWrapMode Texture.wrapMode	get	set	
--Wrap mode (Repeat or Clamp) of the texture.
wrapMode = nil 
--*
--[Comment]
-- property: Single Texture.mipMapBias	get	set	
--Mip map bias of the texture.
mipMapBias = nil 
--*
--[Comment]
-- property: Vector2 Texture.texelSize	get	
texelSize = nil 
--*
--[Comment]
-- property: String Texture.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Texture.hideFlags	get	set	
hideFlags = nil 
--*
----Void Texture.SetGlobalAnisotropicFilteringLimits(Int32 forcedMin,Int32 globalMax)
function Texture.SetGlobalAnisotropicFilteringLimits() end 

----IntPtr Texture:GetNativeTexturePtr()
function GetNativeTexturePtr() end 

Texture2D = {} 
--*
--[Comment]
--consturctor for Texture2D overrides:
--*
--Texture2D.New(Int32 width,Int32 height)
--Create a new empty texture.
--*

--Texture2D.New(Int32 width,Int32 height,TextureFormat format,Boolean mipmap)
--Create a new empty texture.
--*

--Texture2D.New(Int32 width,Int32 height,TextureFormat format,Boolean mipmap,Boolean linear)
--See Also: SetPixel, SetPixels, Apply functions.
--*

function Texture2D.New() end
--*
--[Comment]
-- property: Int32 Texture2D.mipmapCount	get	
--How many mipmap levels are in this texture (Read Only).
mipmapCount = nil 
--*
--[Comment]
-- property: TextureFormat Texture2D.format	get	
--The format of the pixel data in the texture (Read Only).
format = nil 
--*
--[Comment]
-- property: Texture2D Texture2D.whiteTexture	get	
--Get a small texture with all white pixels.
whiteTexture = nil 
--*
--[Comment]
-- property: Texture2D Texture2D.blackTexture	get	
--Get a small texture with all black pixels.
blackTexture = nil 
--*
--[Comment]
-- property: Boolean Texture2D.alphaIsTransparency	get	set	
alphaIsTransparency = nil 
--*
--[Comment]
-- property: Int32 Texture2D.width	get	set	
width = nil 
--*
--[Comment]
-- property: Int32 Texture2D.height	get	set	
height = nil 
--*
--[Comment]
-- property: TextureDimension Texture2D.dimension	get	set	
dimension = nil 
--*
--[Comment]
-- property: FilterMode Texture2D.filterMode	get	set	
filterMode = nil 
--*
--[Comment]
-- property: Int32 Texture2D.anisoLevel	get	set	
anisoLevel = nil 
--*
--[Comment]
-- property: TextureWrapMode Texture2D.wrapMode	get	set	
wrapMode = nil 
--*
--[Comment]
-- property: Single Texture2D.mipMapBias	get	set	
mipMapBias = nil 
--*
--[Comment]
-- property: Vector2 Texture2D.texelSize	get	
texelSize = nil 
--*
--[Comment]
-- property: String Texture2D.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Texture2D.hideFlags	get	set	
hideFlags = nil 
--*
----Texture2D Texture2D.CreateExternalTexture(Int32 width,Int32 height,TextureFormat format,Boolean mipmap,Boolean linear,IntPtr nativeTex)
function Texture2D.CreateExternalTexture() end 

----Void Texture2D:UpdateExternalTexture(IntPtr nativeTex)
function UpdateExternalTexture() end 

----Void Texture2D:SetPixel(Int32 x,Int32 y,Color color)
function SetPixel() end 

----Color Texture2D:GetPixel(Int32 x,Int32 y)
function GetPixel() end 

----Color Texture2D:GetPixelBilinear(Single u,Single v)
function GetPixelBilinear() end 

----Void Texture2D:SetPixels(Color[] colors)
--Void Texture2D:SetPixels(Color[] colors,Int32 miplevel)
--Void Texture2D:SetPixels(Int32 x,Int32 y,Int32 blockWidth,Int32 blockHeight,Color[] colors,Int32 miplevel)
--Void Texture2D:SetPixels(Int32 x,Int32 y,Int32 blockWidth,Int32 blockHeight,Color[] colors)
function SetPixels() end 

----Void Texture2D:SetPixels32(Color32[] colors)
--Void Texture2D:SetPixels32(Color32[] colors,Int32 miplevel)
--Void Texture2D:SetPixels32(Int32 x,Int32 y,Int32 blockWidth,Int32 blockHeight,Color32[] colors)
--Void Texture2D:SetPixels32(Int32 x,Int32 y,Int32 blockWidth,Int32 blockHeight,Color32[] colors,Int32 miplevel)
function SetPixels32() end 

----Boolean Texture2D:LoadImage(Byte[] data,Boolean markNonReadable)
--Boolean Texture2D:LoadImage(Byte[] data)
function LoadImage() end 

----Void Texture2D:LoadRawTextureData(Byte[] data)
--Void Texture2D:LoadRawTextureData(IntPtr data,Int32 size)
function LoadRawTextureData() end 

----Byte[] Texture2D:GetRawTextureData()
function GetRawTextureData() end 

----Color[] Texture2D:GetPixels()
--Color[] Texture2D:GetPixels(Int32 miplevel)
--Color[] Texture2D:GetPixels(Int32 x,Int32 y,Int32 blockWidth,Int32 blockHeight,Int32 miplevel)
--Color[] Texture2D:GetPixels(Int32 x,Int32 y,Int32 blockWidth,Int32 blockHeight)
function GetPixels() end 

----Color32[] Texture2D:GetPixels32(Int32 miplevel)
--Color32[] Texture2D:GetPixels32()
function GetPixels32() end 

----Void Texture2D:Apply(Boolean updateMipmaps,Boolean makeNoLongerReadable)
--Void Texture2D:Apply(Boolean updateMipmaps)
--Void Texture2D:Apply()
function Apply() end 

----Boolean Texture2D:Resize(Int32 width,Int32 height,TextureFormat format,Boolean hasMipMap)
--Boolean Texture2D:Resize(Int32 width,Int32 height)
function Resize() end 

----Void Texture2D:Compress(Boolean highQuality)
function Compress() end 

----Rect[] Texture2D:PackTextures(Texture2D[] textures,Int32 padding,Int32 maximumAtlasSize,Boolean makeNoLongerReadable)
--Rect[] Texture2D:PackTextures(Texture2D[] textures,Int32 padding,Int32 maximumAtlasSize)
--Rect[] Texture2D:PackTextures(Texture2D[] textures,Int32 padding)
function PackTextures() end 

----Void Texture2D:ReadPixels(Rect source,Int32 destX,Int32 destY,Boolean recalculateMipMaps)
--Void Texture2D:ReadPixels(Rect source,Int32 destX,Int32 destY)
function ReadPixels() end 

----Byte[] Texture2D:EncodeToPNG()
function EncodeToPNG() end 

----Byte[] Texture2D:EncodeToJPG(Int32 quality)
--Byte[] Texture2D:EncodeToJPG()
function EncodeToJPG() end 

Shader = {} 
--*
--[Comment]
--consturctor for Shader overrides:
--*
--Shader.New()
--*

function Shader.New() end
--*
--[Comment]
-- property: Boolean Shader.isSupported	get	
--Can this shader run on the end-users graphics card? (Read Only)
isSupported = nil 
--*
--[Comment]
-- property: ShaderHardwareTier Shader.globalShaderHardwareTier	get	set	
--Shader hardware tier classification for current device.
globalShaderHardwareTier = nil 
--*
--[Comment]
-- property: Int32 Shader.maximumLOD	get	set	
--Shader LOD level for this shader.
maximumLOD = nil 
--*
--[Comment]
-- property: Int32 Shader.globalMaximumLOD	get	set	
--Shader LOD level for all shaders.
globalMaximumLOD = nil 
--*
--[Comment]
-- property: Int32 Shader.renderQueue	get	
--Render queue of this shader. (Read Only)
renderQueue = nil 
--*
--[Comment]
-- property: String Shader.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Shader.hideFlags	get	set	
hideFlags = nil 
--*
----Shader Shader.Find(String name)
function Shader.Find() end 

----Void Shader.EnableKeyword(String keyword)
function Shader.EnableKeyword() end 

----Void Shader.DisableKeyword(String keyword)
function Shader.DisableKeyword() end 

----Boolean Shader.IsKeywordEnabled(String keyword)
function Shader.IsKeywordEnabled() end 

----Void Shader.SetGlobalColor(String propertyName,Color color)
--Void Shader.SetGlobalColor(Int32 nameID,Color color)
function Shader.SetGlobalColor() end 

----Void Shader.SetGlobalVector(String propertyName,Vector4 vec)
--Void Shader.SetGlobalVector(Int32 nameID,Vector4 vec)
function Shader.SetGlobalVector() end 

----Void Shader.SetGlobalFloat(String propertyName,Single value)
--Void Shader.SetGlobalFloat(Int32 nameID,Single value)
function Shader.SetGlobalFloat() end 

----Void Shader.SetGlobalInt(String propertyName,Int32 value)
--Void Shader.SetGlobalInt(Int32 nameID,Int32 value)
function Shader.SetGlobalInt() end 

----Void Shader.SetGlobalTexture(String propertyName,Texture tex)
--Void Shader.SetGlobalTexture(Int32 nameID,Texture tex)
function Shader.SetGlobalTexture() end 

----Void Shader.SetGlobalMatrix(String propertyName,Matrix4x4 mat)
--Void Shader.SetGlobalMatrix(Int32 nameID,Matrix4x4 mat)
function Shader.SetGlobalMatrix() end 

----Void Shader.SetGlobalFloatArray(String propertyName,Single[] values)
--Void Shader.SetGlobalFloatArray(Int32 nameID,Single[] values)
function Shader.SetGlobalFloatArray() end 

----Void Shader.SetGlobalVectorArray(String propertyName,Vector4[] values)
--Void Shader.SetGlobalVectorArray(Int32 nameID,Vector4[] values)
function Shader.SetGlobalVectorArray() end 

----Void Shader.SetGlobalMatrixArray(String propertyName,Matrix4x4[] values)
--Void Shader.SetGlobalMatrixArray(Int32 nameID,Matrix4x4[] values)
function Shader.SetGlobalMatrixArray() end 

----Void Shader.SetGlobalBuffer(String propertyName,ComputeBuffer buffer)
function Shader.SetGlobalBuffer() end 

----Int32 Shader.PropertyToID(String name)
function Shader.PropertyToID() end 

----Void Shader.WarmupAllShaders()
function Shader.WarmupAllShaders() end 

Renderer = {} 
--*
--[Comment]
--consturctor for Renderer overrides:
--*
--Renderer.New()
--*

function Renderer.New() end
--*
--[Comment]
-- property: Boolean Renderer.isPartOfStaticBatch	get	
--Has this renderer been statically batched with any other renderers?
isPartOfStaticBatch = nil 
--*
--[Comment]
-- property: Matrix4x4 Renderer.worldToLocalMatrix	get	
--Matrix that transforms a point from world space into local space (Read Only).
worldToLocalMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 Renderer.localToWorldMatrix	get	
--Matrix that transforms a point from local space into world space (Read Only).
localToWorldMatrix = nil 
--*
--[Comment]
-- property: Boolean Renderer.enabled	get	set	
--Makes the rendered 3D object visible if enabled.
enabled = nil 
--*
--[Comment]
-- property: ShadowCastingMode Renderer.shadowCastingMode	get	set	
--Does this object cast shadows?
shadowCastingMode = nil 
--*
--[Comment]
-- property: Boolean Renderer.receiveShadows	get	set	
--Does this object receive shadows?
receiveShadows = nil 
--*
--[Comment]
-- property: Material Renderer.material	get	set	
--Returns the first instantiated Material assigned to the renderer.
material = nil 
--*
--[Comment]
-- property: Material Renderer.sharedMaterial	get	set	
--The shared material of this object.
sharedMaterial = nil 
--*
--[Comment]
-- property: Material[] Renderer.materials	get	set	
--Returns all the instantiated materials of this object.
materials = nil 
--*
--[Comment]
-- property: Material[] Renderer.sharedMaterials	get	set	
--All the shared materials of this object.
sharedMaterials = nil 
--*
--[Comment]
-- property: Bounds Renderer.bounds	get	
--The bounding volume of the renderer (Read Only).
bounds = nil 
--*
--[Comment]
-- property: Int32 Renderer.lightmapIndex	get	set	
--The index of the baked lightmap applied to this renderer.
lightmapIndex = nil 
--*
--[Comment]
-- property: Int32 Renderer.realtimeLightmapIndex	get	set	
--The index of the realtime lightmap applied to this renderer.
realtimeLightmapIndex = nil 
--*
--[Comment]
-- property: Vector4 Renderer.lightmapScaleOffset	get	set	
--The UV scale & offset used for a lightmap.
lightmapScaleOffset = nil 
--*
--[Comment]
-- property: Boolean Renderer.motionVectors	get	set	
--Specifies whether this renderer has a per-object motion vector pass.
motionVectors = nil 
--*
--[Comment]
-- property: Vector4 Renderer.realtimeLightmapScaleOffset	get	set	
--The UV scale & offset used for a realtime lightmap.
realtimeLightmapScaleOffset = nil 
--*
--[Comment]
-- property: Boolean Renderer.isVisible	get	
--Is this renderer visible in any camera? (Read Only)
isVisible = nil 
--*
--[Comment]
-- property: LightProbeUsage Renderer.lightProbeUsage	get	set	
--The light probe interpolation type.
lightProbeUsage = nil 
--*
--[Comment]
-- property: GameObject Renderer.lightProbeProxyVolumeOverride	get	set	
--If set, the Renderer will use the Light Probe Proxy Volume component attached to the source game object.
lightProbeProxyVolumeOverride = nil 
--*
--[Comment]
-- property: Transform Renderer.probeAnchor	get	set	
--If set, Renderer will use this Transform's position to find the light or reflection probe.
probeAnchor = nil 
--*
--[Comment]
-- property: ReflectionProbeUsage Renderer.reflectionProbeUsage	get	set	
--Should reflection probes be used for this Renderer?
reflectionProbeUsage = nil 
--*
--[Comment]
-- property: String Renderer.sortingLayerName	get	set	
--Name of the Renderer's sorting layer.
sortingLayerName = nil 
--*
--[Comment]
-- property: Int32 Renderer.sortingLayerID	get	set	
--Unique ID of the Renderer's sorting layer.
sortingLayerID = nil 
--*
--[Comment]
-- property: Int32 Renderer.sortingOrder	get	set	
--Renderer's order within a sorting layer.
sortingOrder = nil 
--*
--[Comment]
-- property: Transform Renderer.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Renderer.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Renderer.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Renderer.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Renderer.hideFlags	get	set	
hideFlags = nil 
--*
----Void Renderer:SetPropertyBlock(MaterialPropertyBlock properties)
function SetPropertyBlock() end 

----Void Renderer:GetPropertyBlock(MaterialPropertyBlock dest)
function GetPropertyBlock() end 

----Void Renderer:GetClosestReflectionProbes(List`1 result)
function GetClosestReflectionProbes() end 

WWW = {} 
--*
--[Comment]
--consturctor for WWW overrides:
--*
--WWW.New(String url)
--Creates a WWW request with the given URL.
--params:
--url:    The url to download. Must be '%' escaped.

--*

--WWW.New(String url,WWWForm form)
--Creates a WWW request with the given URL.
--params:
--url:    The url to download. Must be '%' escaped.
--form:    A WWWForm instance containing the form data to post.

--*

--WWW.New(String url,Byte[] postData)
--Creates a WWW request with the given URL.
--params:
--url:    The url to download. Must be '%' escaped.
--postData:    A byte array of data to be posted to the url.

--*

--WWW.New(String url,Byte[] postData,Dictionary`2 headers)
--*

function WWW.New() end
--*
--[Comment]
-- property: Dictionary`2 WWW.responseHeaders	get	
--Dictionary of headers returned by the request.
responseHeaders = nil 
--*
--[Comment]
-- property: String WWW.text	get	
--Returns the contents of the fetched web page as a string (Read Only).
text = nil 
--*
--[Comment]
-- property: Byte[] WWW.bytes	get	
--Returns the contents of the fetched web page as a byte array (Read Only).
bytes = nil 
--*
--[Comment]
-- property: Int32 WWW.size	get	
size = nil 
--*
--[Comment]
-- property: String WWW.error	get	
--Returns an error message if there was an error during the download (Read Only).
error = nil 
--*
--[Comment]
-- property: Texture2D WWW.texture	get	
--Returns a Texture2D generated from the downloaded data (Read Only).
texture = nil 
--*
--[Comment]
-- property: Texture2D WWW.textureNonReadable	get	
--Returns a non-readable Texture2D generated from the downloaded data (Read Only).
textureNonReadable = nil 
--*
--[Comment]
-- property: AudioClip WWW.audioClip	get	
--Returns a AudioClip generated from the downloaded data (Read Only).
audioClip = nil 
--*
--[Comment]
-- property: MovieTexture WWW.movie	get	
--Returns a MovieTexture generated from the downloaded data (Read Only).
movie = nil 
--*
--[Comment]
-- property: Boolean WWW.isDone	get	
--Is the download already finished? (Read Only)
isDone = nil 
--*
--[Comment]
-- property: Single WWW.progress	get	
--How far has the download progressed (Read Only).
progress = nil 
--*
--[Comment]
-- property: Single WWW.uploadProgress	get	
--How far has the upload progressed (Read Only).
uploadProgress = nil 
--*
--[Comment]
-- property: Int32 WWW.bytesDownloaded	get	
--The number of bytes downloaded by this WWW query (read only).
bytesDownloaded = nil 
--*
--[Comment]
-- property: String WWW.url	get	
--The URL of this WWW request (Read Only).
url = nil 
--*
--[Comment]
-- property: AssetBundle WWW.assetBundle	get	
--Streams an AssetBundle that can contain any kind of asset from the project folder.
assetBundle = nil 
--*
--[Comment]
-- property: ThreadPriority WWW.threadPriority	get	set	
--Priority of AssetBundle decompression thread.
threadPriority = nil 
--*
----Void WWW:Dispose()
function Dispose() end 

----Void WWW:InitWWW(String url,Byte[] postData,String[] iHeaders)
function InitWWW() end 

----String WWW.EscapeURL(String s)
--String WWW.EscapeURL(String s,Encoding e)
function WWW.EscapeURL() end 

----String WWW.UnEscapeURL(String s)
--String WWW.UnEscapeURL(String s,Encoding e)
function WWW.UnEscapeURL() end 

----AudioClip WWW:GetAudioClip(Boolean threeD)
--AudioClip WWW:GetAudioClip(Boolean threeD,Boolean stream)
--AudioClip WWW:GetAudioClip(Boolean threeD,Boolean stream,AudioType audioType)
function GetAudioClip() end 

----AudioClip WWW:GetAudioClipCompressed()
--AudioClip WWW:GetAudioClipCompressed(Boolean threeD)
--AudioClip WWW:GetAudioClipCompressed(Boolean threeD,AudioType audioType)
function GetAudioClipCompressed() end 

----Void WWW:LoadImageIntoTexture(Texture2D tex)
function LoadImageIntoTexture() end 

----WWW WWW.LoadFromCacheOrDownload(String url,Int32 version)
--WWW WWW.LoadFromCacheOrDownload(String url,Int32 version,UInt32 crc)
--WWW WWW.LoadFromCacheOrDownload(String url,Hash128 hash)
--WWW WWW.LoadFromCacheOrDownload(String url,Hash128 hash,UInt32 crc)
function WWW.LoadFromCacheOrDownload() end 

Screen = {} 
--*
--[Comment]
--consturctor for Screen overrides:
--*
--Screen.New()
--*

function Screen.New() end
--*
--[Comment]
-- property: Resolution[] Screen.resolutions	get	
--All fullscreen resolutions supported by the monitor (Read Only).
resolutions = nil 
--*
--[Comment]
-- property: Resolution Screen.currentResolution	get	
--The current screen resolution (Read Only).
currentResolution = nil 
--*
--[Comment]
-- property: Int32 Screen.width	get	
--The current width of the screen window in pixels (Read Only).
width = nil 
--*
--[Comment]
-- property: Int32 Screen.height	get	
--The current height of the screen window in pixels (Read Only).
height = nil 
--*
--[Comment]
-- property: Single Screen.dpi	get	
--The current DPI of the screen / device (Read Only).
dpi = nil 
--*
--[Comment]
-- property: Boolean Screen.fullScreen	get	set	
--Is the game running fullscreen?
fullScreen = nil 
--*
--[Comment]
-- property: Boolean Screen.autorotateToPortrait	get	set	
--Allow auto-rotation to portrait?
autorotateToPortrait = nil 
--*
--[Comment]
-- property: Boolean Screen.autorotateToPortraitUpsideDown	get	set	
--Allow auto-rotation to portrait, upside down?
autorotateToPortraitUpsideDown = nil 
--*
--[Comment]
-- property: Boolean Screen.autorotateToLandscapeLeft	get	set	
--Allow auto-rotation to landscape left?
autorotateToLandscapeLeft = nil 
--*
--[Comment]
-- property: Boolean Screen.autorotateToLandscapeRight	get	set	
--Allow auto-rotation to landscape right?
autorotateToLandscapeRight = nil 
--*
--[Comment]
-- property: ScreenOrientation Screen.orientation	get	set	
--Specifies logical orientation of the screen.
orientation = nil 
--*
--[Comment]
-- property: Int32 Screen.sleepTimeout	get	set	
--A power saving setting, allowing the screen to dim some time after the last active user interaction.
sleepTimeout = nil 
--*
----Void Screen.SetResolution(Int32 width,Int32 height,Boolean fullscreen,Int32 preferredRefreshRate)
--Void Screen.SetResolution(Int32 width,Int32 height,Boolean fullscreen)
function Screen.SetResolution() end 

CameraClearFlags = {} 

Skybox = nil;

Color = nil;

SolidColor = nil;

Depth = nil;

Nothing = nil;

AudioClip = {} 
--*
--[Comment]
--consturctor for AudioClip overrides:
--*
--AudioClip.New()
--*

function AudioClip.New() end
--*
--[Comment]
-- property: Single AudioClip.length	get	
--The length of the audio clip in seconds. (Read Only)
length = nil 
--*
--[Comment]
-- property: Int32 AudioClip.samples	get	
--The length of the audio clip in samples. (Read Only)
samples = nil 
--*
--[Comment]
-- property: Int32 AudioClip.channels	get	
--The number of channels in the audio clip. (Read Only)
channels = nil 
--*
--[Comment]
-- property: Int32 AudioClip.frequency	get	
--The sample frequency of the clip in Hertz. (Read Only)
frequency = nil 
--*
--[Comment]
-- property: AudioClipLoadType AudioClip.loadType	get	
--The load type of the clip (read-only).
loadType = nil 
--*
--[Comment]
-- property: Boolean AudioClip.preloadAudioData	get	
--Preloads audio data of the clip when the clip asset is loaded. When this flag is off, scripts have to call AudioClip.LoadAudioData() to load the data before the clip can be played. Properties like length, channels and format are available before the audio data has been loaded.
preloadAudioData = nil 
--*
--[Comment]
-- property: AudioDataLoadState AudioClip.loadState	get	
--Returns the current load state of the audio data associated with an AudioClip.
loadState = nil 
--*
--[Comment]
-- property: Boolean AudioClip.loadInBackground	get	
--Corresponding to the "Load In Background" flag in the inspector, when this flag is set, the loading will happen delayed without blocking the main thread.
loadInBackground = nil 
--*
--[Comment]
-- property: String AudioClip.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags AudioClip.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean AudioClip:LoadAudioData()
function LoadAudioData() end 

----Boolean AudioClip:UnloadAudioData()
function UnloadAudioData() end 

----Boolean AudioClip:GetData(Single[] data,Int32 offsetSamples)
function GetData() end 

----Boolean AudioClip:SetData(Single[] data,Int32 offsetSamples)
function SetData() end 

----AudioClip AudioClip.Create(String name,Int32 lengthSamples,Int32 channels,Int32 frequency,Boolean stream)
--AudioClip AudioClip.Create(String name,Int32 lengthSamples,Int32 channels,Int32 frequency,Boolean stream,PCMReaderCallback pcmreadercallback)
--AudioClip AudioClip.Create(String name,Int32 lengthSamples,Int32 channels,Int32 frequency,Boolean stream,PCMReaderCallback pcmreadercallback,PCMSetPositionCallback pcmsetpositioncallback)
function AudioClip.Create() end 

AssetBundle = {} 
--*
--[Comment]
--consturctor for AssetBundle overrides:
--*
--AssetBundle.New()
--*

function AssetBundle.New() end
--*
--[Comment]
-- property: Object AssetBundle.mainAsset	get	
--Main asset that was supplied when building the asset bundle (Read Only).
mainAsset = nil 
--*
--[Comment]
-- property: Boolean AssetBundle.isStreamedSceneAssetBundle	get	
--Return true if the AssetBundle is a streamed scene AssetBundle.
isStreamedSceneAssetBundle = nil 
--*
--[Comment]
-- property: String AssetBundle.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags AssetBundle.hideFlags	get	set	
hideFlags = nil 
--*
----AssetBundleCreateRequest AssetBundle.LoadFromFileAsync(String path,UInt32 crc,UInt64 offset)
--AssetBundleCreateRequest AssetBundle.LoadFromFileAsync(String path,UInt32 crc)
--AssetBundleCreateRequest AssetBundle.LoadFromFileAsync(String path)
function AssetBundle.LoadFromFileAsync() end 

----AssetBundle AssetBundle.LoadFromFile(String path,UInt32 crc,UInt64 offset)
--AssetBundle AssetBundle.LoadFromFile(String path,UInt32 crc)
--AssetBundle AssetBundle.LoadFromFile(String path)
function AssetBundle.LoadFromFile() end 

----AssetBundleCreateRequest AssetBundle.LoadFromMemoryAsync(Byte[] binary,UInt32 crc)
--AssetBundleCreateRequest AssetBundle.LoadFromMemoryAsync(Byte[] binary)
function AssetBundle.LoadFromMemoryAsync() end 

----AssetBundle AssetBundle.LoadFromMemory(Byte[] binary,UInt32 crc)
--AssetBundle AssetBundle.LoadFromMemory(Byte[] binary)
function AssetBundle.LoadFromMemory() end 

----Boolean AssetBundle:Contains(String name)
function Contains() end 

----Object AssetBundle:LoadAsset(String name)
--Object AssetBundle:LoadAsset(String name,Type type)
function LoadAsset() end 

----AssetBundleRequest AssetBundle:LoadAssetAsync(String name)
--AssetBundleRequest AssetBundle:LoadAssetAsync(String name,Type type)
function LoadAssetAsync() end 

----Object[] AssetBundle:LoadAssetWithSubAssets(String name)
--Object[] AssetBundle:LoadAssetWithSubAssets(String name,Type type)
function LoadAssetWithSubAssets() end 

----AssetBundleRequest AssetBundle:LoadAssetWithSubAssetsAsync(String name)
--AssetBundleRequest AssetBundle:LoadAssetWithSubAssetsAsync(String name,Type type)
function LoadAssetWithSubAssetsAsync() end 

----Object[] AssetBundle:LoadAllAssets()
--Object[] AssetBundle:LoadAllAssets(Type type)
function LoadAllAssets() end 

----AssetBundleRequest AssetBundle:LoadAllAssetsAsync()
--AssetBundleRequest AssetBundle:LoadAllAssetsAsync(Type type)
function LoadAllAssetsAsync() end 

----Void AssetBundle:Unload(Boolean unloadAllLoadedObjects)
function Unload() end 

----String[] AssetBundle:GetAllAssetNames()
function GetAllAssetNames() end 

----String[] AssetBundle:GetAllScenePaths()
function GetAllScenePaths() end 

ParticleSystem = {} 
--*
--[Comment]
--consturctor for ParticleSystem overrides:
--*
--ParticleSystem.New()
--*

function ParticleSystem.New() end
--*
--[Comment]
-- property: Single ParticleSystem.startDelay	get	set	
--Start delay in seconds.
startDelay = nil 
--*
--[Comment]
-- property: Boolean ParticleSystem.isPlaying	get	
--Is the particle system playing right now ?
isPlaying = nil 
--*
--[Comment]
-- property: Boolean ParticleSystem.isStopped	get	
--Is the particle system stopped right now ?
isStopped = nil 
--*
--[Comment]
-- property: Boolean ParticleSystem.isPaused	get	
--Is the particle system paused right now ?
isPaused = nil 
--*
--[Comment]
-- property: Boolean ParticleSystem.loop	get	set	
--Is the particle system looping?
loop = nil 
--*
--[Comment]
-- property: Boolean ParticleSystem.playOnAwake	get	set	
--If set to true, the particle system will automatically start playing on startup.
playOnAwake = nil 
--*
--[Comment]
-- property: Single ParticleSystem.time	get	set	
--Playback position in seconds.
time = nil 
--*
--[Comment]
-- property: Single ParticleSystem.duration	get	
--The duration of the particle system in seconds (Read Only).
duration = nil 
--*
--[Comment]
-- property: Single ParticleSystem.playbackSpeed	get	set	
--The playback speed of the particle system. 1 is normal playback speed.
playbackSpeed = nil 
--*
--[Comment]
-- property: Int32 ParticleSystem.particleCount	get	
--The current number of particles (Read Only).
particleCount = nil 
--*
--[Comment]
-- property: Single ParticleSystem.startSpeed	get	set	
--The initial speed of particles when emitted. When using curves, this values acts as a scale on the curve.
startSpeed = nil 
--*
--[Comment]
-- property: Single ParticleSystem.startSize	get	set	
--The initial size of particles when emitted. When using curves, this values acts as a scale on the curve.
startSize = nil 
--*
--[Comment]
-- property: Color ParticleSystem.startColor	get	set	
--The initial color of particles when emitted.
startColor = nil 
--*
--[Comment]
-- property: Single ParticleSystem.startRotation	get	set	
--The initial rotation of particles when emitted. When using curves, this values acts as a scale on the curve.
startRotation = nil 
--*
--[Comment]
-- property: Vector3 ParticleSystem.startRotation3D	get	set	
--The initial 3D rotation of particles when emitted. When using curves, this values acts as a scale on the curves.
startRotation3D = nil 
--*
--[Comment]
-- property: Single ParticleSystem.startLifetime	get	set	
--The total lifetime in seconds that particles will have when emitted. When using curves, this values acts as a scale on the curve. This value is set in the particle when it is create by the particle system.
startLifetime = nil 
--*
--[Comment]
-- property: Single ParticleSystem.gravityModifier	get	set	
--Scale being applied to the gravity defined by Physics.gravity.
gravityModifier = nil 
--*
--[Comment]
-- property: Int32 ParticleSystem.maxParticles	get	set	
--The maximum number of particles to emit.
maxParticles = nil 
--*
--[Comment]
-- property: ParticleSystemSimulationSpace ParticleSystem.simulationSpace	get	set	
--This selects the space in which to simulate particles. It can be either world or local space.
simulationSpace = nil 
--*
--[Comment]
-- property: ParticleSystemScalingMode ParticleSystem.scalingMode	get	set	
--The scaling mode applied to particle sizes and positions.
scalingMode = nil 
--*
--[Comment]
-- property: UInt32 ParticleSystem.randomSeed	get	set	
--Override the random seed used for the particle system emission.
randomSeed = nil 
--*
--[Comment]
-- property: Boolean ParticleSystem.useAutoRandomSeed	get	set	
--Set to false to support providing your own random seed for the Particle System.
useAutoRandomSeed = nil 
--*
--[Comment]
-- property: EmissionModule ParticleSystem.emission	get	
--Access the particle system emission module.
emission = nil 
--*
--[Comment]
-- property: ShapeModule ParticleSystem.shape	get	
--Access the particle system shape module.
shape = nil 
--*
--[Comment]
-- property: VelocityOverLifetimeModule ParticleSystem.velocityOverLifetime	get	
--Access the particle system velocity over lifetime module.
velocityOverLifetime = nil 
--*
--[Comment]
-- property: LimitVelocityOverLifetimeModule ParticleSystem.limitVelocityOverLifetime	get	
--Access the particle system limit velocity over lifetime module.
limitVelocityOverLifetime = nil 
--*
--[Comment]
-- property: InheritVelocityModule ParticleSystem.inheritVelocity	get	
--Access the particle system velocity inheritance module.
inheritVelocity = nil 
--*
--[Comment]
-- property: ForceOverLifetimeModule ParticleSystem.forceOverLifetime	get	
--Access the particle system force over lifetime module.
forceOverLifetime = nil 
--*
--[Comment]
-- property: ColorOverLifetimeModule ParticleSystem.colorOverLifetime	get	
--Access the particle system color over lifetime module.
colorOverLifetime = nil 
--*
--[Comment]
-- property: ColorBySpeedModule ParticleSystem.colorBySpeed	get	
--Access the particle system color by lifetime module.
colorBySpeed = nil 
--*
--[Comment]
-- property: SizeOverLifetimeModule ParticleSystem.sizeOverLifetime	get	
--Access the particle system size over lifetime module.
sizeOverLifetime = nil 
--*
--[Comment]
-- property: SizeBySpeedModule ParticleSystem.sizeBySpeed	get	
--Access the particle system size by speed module.
sizeBySpeed = nil 
--*
--[Comment]
-- property: RotationOverLifetimeModule ParticleSystem.rotationOverLifetime	get	
--Access the particle system rotation over lifetime module.
rotationOverLifetime = nil 
--*
--[Comment]
-- property: RotationBySpeedModule ParticleSystem.rotationBySpeed	get	
--Access the particle system rotation by speed  module.
rotationBySpeed = nil 
--*
--[Comment]
-- property: ExternalForcesModule ParticleSystem.externalForces	get	
--Access the particle system external forces module.
externalForces = nil 
--*
--[Comment]
-- property: CollisionModule ParticleSystem.collision	get	
--Access the particle system collision module.
collision = nil 
--*
--[Comment]
-- property: TriggerModule ParticleSystem.trigger	get	
--Access the particle system trigger module.
trigger = nil 
--*
--[Comment]
-- property: SubEmittersModule ParticleSystem.subEmitters	get	
--Access the particle system sub emitters module.
subEmitters = nil 
--*
--[Comment]
-- property: TextureSheetAnimationModule ParticleSystem.textureSheetAnimation	get	
--Access the particle system texture sheet animation module.
textureSheetAnimation = nil 
--*
--[Comment]
-- property: Transform ParticleSystem.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject ParticleSystem.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String ParticleSystem.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String ParticleSystem.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags ParticleSystem.hideFlags	get	set	
hideFlags = nil 
--*
----Void ParticleSystem:SetParticles(Particle[] particles,Int32 size)
function SetParticles() end 

----Int32 ParticleSystem:GetParticles(Particle[] particles)
function GetParticles() end 

----Void ParticleSystem:Simulate(Single t,Boolean withChildren,Boolean restart)
--Void ParticleSystem:Simulate(Single t,Boolean withChildren)
--Void ParticleSystem:Simulate(Single t)
--Void ParticleSystem:Simulate(Single t,Boolean withChildren,Boolean restart,Boolean fixedTimeStep)
function Simulate() end 

----Void ParticleSystem:Play()
--Void ParticleSystem:Play(Boolean withChildren)
function Play() end 

----Void ParticleSystem:Stop()
--Void ParticleSystem:Stop(Boolean withChildren)
function Stop() end 

----Void ParticleSystem:Pause()
--Void ParticleSystem:Pause(Boolean withChildren)
function Pause() end 

----Void ParticleSystem:Clear()
--Void ParticleSystem:Clear(Boolean withChildren)
function Clear() end 

----Boolean ParticleSystem:IsAlive()
--Boolean ParticleSystem:IsAlive(Boolean withChildren)
function IsAlive() end 

----Void ParticleSystem:Emit(Int32 count)
--Void ParticleSystem:Emit(EmitParams emitParams,Int32 count)
function Emit() end 

AsyncOperation = {} 
--*
--[Comment]
--consturctor for AsyncOperation overrides:
--*
--AsyncOperation.New()
--*

function AsyncOperation.New() end
--*
--[Comment]
-- property: Boolean AsyncOperation.isDone	get	
--Has the operation finished? (Read Only)
isDone = nil 
--*
--[Comment]
-- property: Single AsyncOperation.progress	get	
--What's the operation's progress. (Read Only)
progress = nil 
--*
--[Comment]
-- property: Int32 AsyncOperation.priority	get	set	
--Priority lets you tweak in which order async operation calls will be performed.
priority = nil 
--*
--[Comment]
-- property: Boolean AsyncOperation.allowSceneActivation	get	set	
--Allow scenes to be activated as soon as it is ready.
allowSceneActivation = nil 
--*
LightType = {} 

Spot = nil;

Directional = nil;

Point = nil;

Area = nil;

SleepTimeout = {} 
--*
--[Comment]
--consturctor for SleepTimeout overrides:
--*
--SleepTimeout.New()
--*

function SleepTimeout.New() end
--*
Color = {} 
--*
--[Comment]
--consturctor for Color overrides:
--*
--Color.New(Single r,Single g,Single b,Single a)
--Constructs a new Color with given r,g,b,a components.
--params:
--r:    Red component.
--g:    Green component.
--b:    Blue component.
--a:    Alpha component.

--*

--Color.New(Single r,Single g,Single b)
--Constructs a new Color with given r,g,b components and sets a to 1.
--params:
--r:    Red component.
--g:    Green component.
--b:    Blue component.

--*

function Color.New() end
--*
--[Comment]
-- property: Color Color.red	get	
--Solid red. RGBA is (1, 0, 0, 1).
red = nil 
--*
--[Comment]
-- property: Color Color.green	get	
--Solid green. RGBA is (0, 1, 0, 1).
green = nil 
--*
--[Comment]
-- property: Color Color.blue	get	
--Solid blue. RGBA is (0, 0, 1, 1).
blue = nil 
--*
--[Comment]
-- property: Color Color.white	get	
--Solid white. RGBA is (1, 1, 1, 1).
white = nil 
--*
--[Comment]
-- property: Color Color.black	get	
--Solid black. RGBA is (0, 0, 0, 1).
black = nil 
--*
--[Comment]
-- property: Color Color.yellow	get	
--Yellow. RGBA is (1, 0.92, 0.016, 1), but the color is nice to look at!
yellow = nil 
--*
--[Comment]
-- property: Color Color.cyan	get	
--Cyan. RGBA is (0, 1, 1, 1).
cyan = nil 
--*
--[Comment]
-- property: Color Color.magenta	get	
--Magenta. RGBA is (1, 0, 1, 1).
magenta = nil 
--*
--[Comment]
-- property: Color Color.gray	get	
--Gray. RGBA is (0.5, 0.5, 0.5, 1).
gray = nil 
--*
--[Comment]
-- property: Color Color.grey	get	
--English spelling for gray. RGBA is the same (0.5, 0.5, 0.5, 1).
grey = nil 
--*
--[Comment]
-- property: Color Color.clear	get	
--Completely transparent. RGBA is (0, 0, 0, 0).
clear = nil 
--*
--[Comment]
-- property: Single Color.grayscale	get	
--The grayscale value of the color. (Read Only)
grayscale = nil 
--*
--[Comment]
-- property: Color Color.linear	get	
--A linear value of an sRGB color.
linear = nil 
--*
--[Comment]
-- property: Color Color.gamma	get	
--A version of the color that has had the gamma curve applied.
gamma = nil 
--*
--[Comment]
-- property: Single Color.maxColorComponent	get	
--Returns the maximum color component value: Max(r,g,b).
maxColorComponent = nil 
--*
--[Comment]
-- property: Single Color.Item	get	set	
Item = nil 
--*
----String Color:ToString()
--String Color:ToString(String format)
function ToString() end 

----Int32 Color:GetHashCode()
function GetHashCode() end 

----Boolean Color:Equals(Object other)
function Equals() end 

----Color Color.Lerp(Color a,Color b,Single t)
function Color.Lerp() end 

----Color Color.LerpUnclamped(Color a,Color b,Single t)
function Color.LerpUnclamped() end 

----Single Color:get_Item(Int32 index)
function get_Item() end 

----Void Color:set_Item(Int32 index,Single value)
function set_Item() end 

----Void Color.RGBToHSV(Color rgbColor,Single& H,Single& S,Single& V)
function Color.RGBToHSV() end 

----Color Color.HSVToRGB(Single H,Single S,Single V)
--Color Color.HSVToRGB(Single H,Single S,Single V,Boolean hdr)
function Color.HSVToRGB() end 

----Color Color.op_Addition(Color a,Color b)
function Color.op_Addition() end 

----Color Color.op_Subtraction(Color a,Color b)
function Color.op_Subtraction() end 

----Color Color.op_Multiply(Color a,Color b)
--Color Color.op_Multiply(Color a,Single b)
--Color Color.op_Multiply(Single b,Color a)
function Color.op_Multiply() end 

----Color Color.op_Division(Color a,Single b)
function Color.op_Division() end 

----Boolean Color.op_Equality(Color lhs,Color rhs)
function Color.op_Equality() end 

----Boolean Color.op_Inequality(Color lhs,Color rhs)
function Color.op_Inequality() end 

----Vector4 Color.op_Implicit(Color c)
--Color Color.op_Implicit(Vector4 v)
function Color.op_Implicit() end 

DirectorPlayer = {} 
--*
--[Comment]
--consturctor for DirectorPlayer overrides:
--*
--DirectorPlayer.New()
--*

function DirectorPlayer.New() end
--*
--[Comment]
-- property: Boolean DirectorPlayer.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean DirectorPlayer.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform DirectorPlayer.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject DirectorPlayer.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String DirectorPlayer.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String DirectorPlayer.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags DirectorPlayer.hideFlags	get	set	
hideFlags = nil 
--*
----Void DirectorPlayer:Play(Playable pStruct)
function Play() end 

----Void DirectorPlayer:Stop()
function Stop() end 

----Void DirectorPlayer:SetTime(Double time)
function SetTime() end 

----Double DirectorPlayer:GetTime()
function GetTime() end 

----Void DirectorPlayer:SetTimeUpdateMode(DirectorUpdateMode mode)
function SetTimeUpdateMode() end 

----DirectorUpdateMode DirectorPlayer:GetTimeUpdateMode()
function GetTimeUpdateMode() end 

Animator = {} 
--*
--[Comment]
--consturctor for Animator overrides:
--*
--Animator.New()
--*

function Animator.New() end
--*
--[Comment]
-- property: Boolean Animator.isOptimizable	get	
--Returns true if the current rig is optimizable with AnimatorUtility.OptimizeTransformHierarchy.
isOptimizable = nil 
--*
--[Comment]
-- property: Boolean Animator.isHuman	get	
--Returns true if the current rig is humanoid, false if it is generic.
isHuman = nil 
--*
--[Comment]
-- property: Boolean Animator.hasRootMotion	get	
--Returns true if the current rig has root motion.
hasRootMotion = nil 
--*
--[Comment]
-- property: Single Animator.humanScale	get	
--Returns the scale of the current Avatar for a humanoid rig, (1 by default if the rig is generic).
humanScale = nil 
--*
--[Comment]
-- property: Boolean Animator.isInitialized	get	
--Returns whether the animator is initialized successfully.
isInitialized = nil 
--*
--[Comment]
-- property: Vector3 Animator.deltaPosition	get	
--Gets the avatar delta position for the last evaluated frame.
deltaPosition = nil 
--*
--[Comment]
-- property: Quaternion Animator.deltaRotation	get	
--Gets the avatar delta rotation for the last evaluated frame.
deltaRotation = nil 
--*
--[Comment]
-- property: Vector3 Animator.velocity	get	
--Gets the avatar velocity  for the last evaluated frame.
velocity = nil 
--*
--[Comment]
-- property: Vector3 Animator.angularVelocity	get	
--Gets the avatar angular velocity for the last evaluated frame.
angularVelocity = nil 
--*
--[Comment]
-- property: Vector3 Animator.rootPosition	get	set	
--The root position, the position of the game object.
rootPosition = nil 
--*
--[Comment]
-- property: Quaternion Animator.rootRotation	get	set	
--The root rotation, the rotation of the game object.
rootRotation = nil 
--*
--[Comment]
-- property: Boolean Animator.applyRootMotion	get	set	
--Should root motion be applied?
applyRootMotion = nil 
--*
--[Comment]
-- property: Boolean Animator.linearVelocityBlending	get	set	
--When linearVelocityBlending is set to true, the root motion velocity and angular velocity will be blended linearly.
linearVelocityBlending = nil 
--*
--[Comment]
-- property: AnimatorUpdateMode Animator.updateMode	get	set	
--Specifies the update mode of the Animator.
updateMode = nil 
--*
--[Comment]
-- property: Boolean Animator.hasTransformHierarchy	get	
--Returns true if the object has a transform hierarchy.
hasTransformHierarchy = nil 
--*
--[Comment]
-- property: Single Animator.gravityWeight	get	
--The current gravity weight based on current animations that are played.
gravityWeight = nil 
--*
--[Comment]
-- property: Vector3 Animator.bodyPosition	get	set	
--The position of the body center of mass.
bodyPosition = nil 
--*
--[Comment]
-- property: Quaternion Animator.bodyRotation	get	set	
--The rotation of the body center of mass.
bodyRotation = nil 
--*
--[Comment]
-- property: Boolean Animator.stabilizeFeet	get	set	
--Automatic stabilization of feet during transition and blending.
stabilizeFeet = nil 
--*
--[Comment]
-- property: Int32 Animator.layerCount	get	
--See IAnimatorControllerPlayable.layerCount.
layerCount = nil 
--*
--[Comment]
-- property: AnimatorControllerParameter[] Animator.parameters	get	
--Read only acces to the AnimatorControllerParameters used by the animator.
parameters = nil 
--*
--[Comment]
-- property: Int32 Animator.parameterCount	get	
--See IAnimatorControllerPlayable.parameterCount.
parameterCount = nil 
--*
--[Comment]
-- property: Single Animator.feetPivotActive	get	set	
--Blends pivot point between body center of mass and feet pivot. At 0%, the blending point is body center of mass. At 100%, the blending point is feet pivot.
feetPivotActive = nil 
--*
--[Comment]
-- property: Single Animator.pivotWeight	get	
--Gets the pivot weight.
pivotWeight = nil 
--*
--[Comment]
-- property: Vector3 Animator.pivotPosition	get	
--Get the current position of the pivot.
pivotPosition = nil 
--*
--[Comment]
-- property: Boolean Animator.isMatchingTarget	get	
--If automatic matching is active.
isMatchingTarget = nil 
--*
--[Comment]
-- property: Single Animator.speed	get	set	
--The playback speed of the Animator. 1 is normal playback speed.
speed = nil 
--*
--[Comment]
-- property: Vector3 Animator.targetPosition	get	
--Returns the position of the target specified by SetTarget(AvatarTarget targetIndex, float targetNormalizedTime)).
targetPosition = nil 
--*
--[Comment]
-- property: Quaternion Animator.targetRotation	get	
--Returns the rotation of the target specified by SetTarget(AvatarTarget targetIndex, float targetNormalizedTime)).
targetRotation = nil 
--*
--[Comment]
-- property: AnimatorCullingMode Animator.cullingMode	get	set	
--Controls culling of this Animator component.
cullingMode = nil 
--*
--[Comment]
-- property: Single Animator.playbackTime	get	set	
--Sets the playback position in the recording buffer.
playbackTime = nil 
--*
--[Comment]
-- property: Single Animator.recorderStartTime	get	set	
--Start time of the first frame of the buffer relative to the frame at which StartRecording was called.
recorderStartTime = nil 
--*
--[Comment]
-- property: Single Animator.recorderStopTime	get	set	
--End time of the recorded clip relative to when StartRecording was called.
recorderStopTime = nil 
--*
--[Comment]
-- property: AnimatorRecorderMode Animator.recorderMode	get	
--Gets the mode of the Animator recorder.
recorderMode = nil 
--*
--[Comment]
-- property: RuntimeAnimatorController Animator.runtimeAnimatorController	get	set	
--The runtime representation of AnimatorController that controls the Animator.
runtimeAnimatorController = nil 
--*
--[Comment]
-- property: Avatar Animator.avatar	get	set	
--Gets/Sets the current Avatar.
avatar = nil 
--*
--[Comment]
-- property: Boolean Animator.layersAffectMassCenter	get	set	
--Additional layers affects the center of mass.
layersAffectMassCenter = nil 
--*
--[Comment]
-- property: Single Animator.leftFeetBottomHeight	get	
--Get left foot bottom height.
leftFeetBottomHeight = nil 
--*
--[Comment]
-- property: Single Animator.rightFeetBottomHeight	get	
--Get right foot bottom height.
rightFeetBottomHeight = nil 
--*
--[Comment]
-- property: Boolean Animator.logWarnings	get	set	
logWarnings = nil 
--*
--[Comment]
-- property: Boolean Animator.fireEvents	get	set	
fireEvents = nil 
--*
--[Comment]
-- property: Boolean Animator.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Animator.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Animator.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Animator.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Animator.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Animator.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Animator.hideFlags	get	set	
hideFlags = nil 
--*
----Single Animator:GetFloat(String name)
--Single Animator:GetFloat(Int32 id)
function GetFloat() end 

----Void Animator:SetFloat(String name,Single value)
--Void Animator:SetFloat(String name,Single value,Single dampTime,Single deltaTime)
--Void Animator:SetFloat(Int32 id,Single value)
--Void Animator:SetFloat(Int32 id,Single value,Single dampTime,Single deltaTime)
function SetFloat() end 

----Boolean Animator:GetBool(String name)
--Boolean Animator:GetBool(Int32 id)
function GetBool() end 

----Void Animator:SetBool(String name,Boolean value)
--Void Animator:SetBool(Int32 id,Boolean value)
function SetBool() end 

----Int32 Animator:GetInteger(String name)
--Int32 Animator:GetInteger(Int32 id)
function GetInteger() end 

----Void Animator:SetInteger(String name,Int32 value)
--Void Animator:SetInteger(Int32 id,Int32 value)
function SetInteger() end 

----Void Animator:SetTrigger(String name)
--Void Animator:SetTrigger(Int32 id)
function SetTrigger() end 

----Void Animator:ResetTrigger(String name)
--Void Animator:ResetTrigger(Int32 id)
function ResetTrigger() end 

----Boolean Animator:IsParameterControlledByCurve(String name)
--Boolean Animator:IsParameterControlledByCurve(Int32 id)
function IsParameterControlledByCurve() end 

----Vector3 Animator:GetIKPosition(AvatarIKGoal goal)
function GetIKPosition() end 

----Void Animator:SetIKPosition(AvatarIKGoal goal,Vector3 goalPosition)
function SetIKPosition() end 

----Quaternion Animator:GetIKRotation(AvatarIKGoal goal)
function GetIKRotation() end 

----Void Animator:SetIKRotation(AvatarIKGoal goal,Quaternion goalRotation)
function SetIKRotation() end 

----Single Animator:GetIKPositionWeight(AvatarIKGoal goal)
function GetIKPositionWeight() end 

----Void Animator:SetIKPositionWeight(AvatarIKGoal goal,Single value)
function SetIKPositionWeight() end 

----Single Animator:GetIKRotationWeight(AvatarIKGoal goal)
function GetIKRotationWeight() end 

----Void Animator:SetIKRotationWeight(AvatarIKGoal goal,Single value)
function SetIKRotationWeight() end 

----Vector3 Animator:GetIKHintPosition(AvatarIKHint hint)
function GetIKHintPosition() end 

----Void Animator:SetIKHintPosition(AvatarIKHint hint,Vector3 hintPosition)
function SetIKHintPosition() end 

----Single Animator:GetIKHintPositionWeight(AvatarIKHint hint)
function GetIKHintPositionWeight() end 

----Void Animator:SetIKHintPositionWeight(AvatarIKHint hint,Single value)
function SetIKHintPositionWeight() end 

----Void Animator:SetLookAtPosition(Vector3 lookAtPosition)
function SetLookAtPosition() end 

----Void Animator:SetLookAtWeight(Single weight,Single bodyWeight,Single headWeight,Single eyesWeight)
--Void Animator:SetLookAtWeight(Single weight,Single bodyWeight,Single headWeight)
--Void Animator:SetLookAtWeight(Single weight,Single bodyWeight)
--Void Animator:SetLookAtWeight(Single weight)
--Void Animator:SetLookAtWeight(Single weight,Single bodyWeight,Single headWeight,Single eyesWeight,Single clampWeight)
function SetLookAtWeight() end 

----Void Animator:SetBoneLocalRotation(HumanBodyBones humanBoneId,Quaternion rotation)
function SetBoneLocalRotation() end 

----String Animator:GetLayerName(Int32 layerIndex)
function GetLayerName() end 

----Int32 Animator:GetLayerIndex(String layerName)
function GetLayerIndex() end 

----Single Animator:GetLayerWeight(Int32 layerIndex)
function GetLayerWeight() end 

----Void Animator:SetLayerWeight(Int32 layerIndex,Single weight)
function SetLayerWeight() end 

----AnimatorStateInfo Animator:GetCurrentAnimatorStateInfo(Int32 layerIndex)
function GetCurrentAnimatorStateInfo() end 

----AnimatorStateInfo Animator:GetNextAnimatorStateInfo(Int32 layerIndex)
function GetNextAnimatorStateInfo() end 

----AnimatorTransitionInfo Animator:GetAnimatorTransitionInfo(Int32 layerIndex)
function GetAnimatorTransitionInfo() end 

----AnimatorClipInfo[] Animator:GetCurrentAnimatorClipInfo(Int32 layerIndex)
function GetCurrentAnimatorClipInfo() end 

----AnimatorClipInfo[] Animator:GetNextAnimatorClipInfo(Int32 layerIndex)
function GetNextAnimatorClipInfo() end 

----Boolean Animator:IsInTransition(Int32 layerIndex)
function IsInTransition() end 

----AnimatorControllerParameter Animator:GetParameter(Int32 index)
function GetParameter() end 

----Void Animator:MatchTarget(Vector3 matchPosition,Quaternion matchRotation,AvatarTarget targetBodyPart,MatchTargetWeightMask weightMask,Single startNormalizedTime,Single targetNormalizedTime)
--Void Animator:MatchTarget(Vector3 matchPosition,Quaternion matchRotation,AvatarTarget targetBodyPart,MatchTargetWeightMask weightMask,Single startNormalizedTime)
function MatchTarget() end 

----Void Animator:InterruptMatchTarget(Boolean completeMatch)
--Void Animator:InterruptMatchTarget()
function InterruptMatchTarget() end 

----Void Animator:CrossFadeInFixedTime(String stateName,Single transitionDuration,Int32 layer)
--Void Animator:CrossFadeInFixedTime(String stateName,Single transitionDuration)
--Void Animator:CrossFadeInFixedTime(String stateName,Single transitionDuration,Int32 layer,Single fixedTime)
--Void Animator:CrossFadeInFixedTime(Int32 stateNameHash,Single transitionDuration,Int32 layer,Single fixedTime)
--Void Animator:CrossFadeInFixedTime(Int32 stateNameHash,Single transitionDuration,Int32 layer)
--Void Animator:CrossFadeInFixedTime(Int32 stateNameHash,Single transitionDuration)
function CrossFadeInFixedTime() end 

----Void Animator:CrossFade(String stateName,Single transitionDuration,Int32 layer)
--Void Animator:CrossFade(String stateName,Single transitionDuration)
--Void Animator:CrossFade(String stateName,Single transitionDuration,Int32 layer,Single normalizedTime)
--Void Animator:CrossFade(Int32 stateNameHash,Single transitionDuration,Int32 layer,Single normalizedTime)
--Void Animator:CrossFade(Int32 stateNameHash,Single transitionDuration,Int32 layer)
--Void Animator:CrossFade(Int32 stateNameHash,Single transitionDuration)
function CrossFade() end 

----Void Animator:PlayInFixedTime(String stateName,Int32 layer)
--Void Animator:PlayInFixedTime(String stateName)
--Void Animator:PlayInFixedTime(String stateName,Int32 layer,Single fixedTime)
--Void Animator:PlayInFixedTime(Int32 stateNameHash,Int32 layer,Single fixedTime)
--Void Animator:PlayInFixedTime(Int32 stateNameHash,Int32 layer)
--Void Animator:PlayInFixedTime(Int32 stateNameHash)
function PlayInFixedTime() end 

----Void Animator:Play(String stateName,Int32 layer)
--Void Animator:Play(String stateName)
--Void Animator:Play(String stateName,Int32 layer,Single normalizedTime)
--Void Animator:Play(Int32 stateNameHash,Int32 layer,Single normalizedTime)
--Void Animator:Play(Int32 stateNameHash,Int32 layer)
--Void Animator:Play(Int32 stateNameHash)
function Play() end 

----Void Animator:SetTarget(AvatarTarget targetIndex,Single targetNormalizedTime)
function SetTarget() end 

----Transform Animator:GetBoneTransform(HumanBodyBones humanBoneId)
function GetBoneTransform() end 

----Void Animator:StartPlayback()
function StartPlayback() end 

----Void Animator:StopPlayback()
function StopPlayback() end 

----Void Animator:StartRecording(Int32 frameCount)
function StartRecording() end 

----Void Animator:StopRecording()
function StopRecording() end 

----Boolean Animator:HasState(Int32 layerIndex,Int32 stateID)
function HasState() end 

----Int32 Animator.StringToHash(String name)
function Animator.StringToHash() end 

----Void Animator:Update(Single deltaTime)
function Update() end 

----Void Animator:Rebind()
function Rebind() end 

----Void Animator:ApplyBuiltinRootMotion()
function ApplyBuiltinRootMotion() end 

Input = {} 
--*
--[Comment]
--consturctor for Input overrides:
--*
--Input.New()
--*

function Input.New() end
--*
--[Comment]
-- property: Boolean Input.compensateSensors	get	set	
--This property controls if input sensors should be compensated for screen orientation.
compensateSensors = nil 
--*
--[Comment]
-- property: Gyroscope Input.gyro	get	
--Returns default gyroscope.
gyro = nil 
--*
--[Comment]
-- property: Vector3 Input.mousePosition	get	
--The current mouse position in pixel coordinates. (Read Only)
mousePosition = nil 
--*
--[Comment]
-- property: Vector2 Input.mouseScrollDelta	get	
--The current mouse scroll delta. (Read Only)
mouseScrollDelta = nil 
--*
--[Comment]
-- property: Boolean Input.mousePresent	get	
--Indicates if a mouse device is detected.
mousePresent = nil 
--*
--[Comment]
-- property: Boolean Input.simulateMouseWithTouches	get	set	
--Enables/Disables mouse simulation with touches. By default this option is enabled.
simulateMouseWithTouches = nil 
--*
--[Comment]
-- property: Boolean Input.anyKey	get	
--Is any key or mouse button currently held down? (Read Only)
anyKey = nil 
--*
--[Comment]
-- property: Boolean Input.anyKeyDown	get	
--Returns true the first frame the user hits any key or mouse button. (Read Only)
anyKeyDown = nil 
--*
--[Comment]
-- property: String Input.inputString	get	
--Returns the keyboard input entered this frame. (Read Only)
inputString = nil 
--*
--[Comment]
-- property: Vector3 Input.acceleration	get	
--Last measured linear acceleration of a device in three-dimensional space. (Read Only)
acceleration = nil 
--*
--[Comment]
-- property: AccelerationEvent[] Input.accelerationEvents	get	
--Returns list of acceleration measurements which occurred during the last frame. (Read Only) (Allocates temporary variables).
accelerationEvents = nil 
--*
--[Comment]
-- property: Int32 Input.accelerationEventCount	get	
--Number of acceleration measurements which occurred during last frame.
accelerationEventCount = nil 
--*
--[Comment]
-- property: Touch[] Input.touches	get	
--Returns list of objects representing status of all touches during last frame. (Read Only) (Allocates temporary variables).
touches = nil 
--*
--[Comment]
-- property: Int32 Input.touchCount	get	
--Number of touches. Guaranteed not to change throughout the frame. (Read Only)
touchCount = nil 
--*
--[Comment]
-- property: Boolean Input.touchPressureSupported	get	
--Bool value which let's users check if touch pressure is supported.
touchPressureSupported = nil 
--*
--[Comment]
-- property: Boolean Input.stylusTouchSupported	get	
--Returns true when Stylus Touch is supported by a device or platform.
stylusTouchSupported = nil 
--*
--[Comment]
-- property: Boolean Input.touchSupported	get	
--Returns whether the device on which application is currently running supports touch input.
touchSupported = nil 
--*
--[Comment]
-- property: Boolean Input.multiTouchEnabled	get	set	
--Property indicating whether the system handles multiple touches.
multiTouchEnabled = nil 
--*
--[Comment]
-- property: LocationService Input.location	get	
--Property for accessing device location (handheld devices only). (Read Only)
location = nil 
--*
--[Comment]
-- property: Compass Input.compass	get	
--Property for accessing compass (handheld devices only). (Read Only)
compass = nil 
--*
--[Comment]
-- property: DeviceOrientation Input.deviceOrientation	get	
--Device physical orientation as reported by OS. (Read Only)
deviceOrientation = nil 
--*
--[Comment]
-- property: IMECompositionMode Input.imeCompositionMode	get	set	
--Controls enabling and disabling of IME input composition.
imeCompositionMode = nil 
--*
--[Comment]
-- property: String Input.compositionString	get	
--The current IME composition string being typed by the user.
compositionString = nil 
--*
--[Comment]
-- property: Boolean Input.imeIsSelected	get	
--Does the user have an IME keyboard input source selected?
imeIsSelected = nil 
--*
--[Comment]
-- property: Vector2 Input.compositionCursorPos	get	set	
--The current text input position used by IMEs to open windows.
compositionCursorPos = nil 
--*
--[Comment]
-- property: Boolean Input.backButtonLeavesApp	get	set	
--Should  Back button quit the application?  Only usable on Android, Windows Phone or Windows Tablets.
backButtonLeavesApp = nil 
--*
----Single Input.GetAxis(String axisName)
function Input.GetAxis() end 

----Single Input.GetAxisRaw(String axisName)
function Input.GetAxisRaw() end 

----Boolean Input.GetButton(String buttonName)
function Input.GetButton() end 

----Boolean Input.GetButtonDown(String buttonName)
function Input.GetButtonDown() end 

----Boolean Input.GetButtonUp(String buttonName)
function Input.GetButtonUp() end 

----Boolean Input.GetKey(String name)
--Boolean Input.GetKey(KeyCode key)
function Input.GetKey() end 

----Boolean Input.GetKeyDown(String name)
--Boolean Input.GetKeyDown(KeyCode key)
function Input.GetKeyDown() end 

----Boolean Input.GetKeyUp(String name)
--Boolean Input.GetKeyUp(KeyCode key)
function Input.GetKeyUp() end 

----String[] Input.GetJoystickNames()
function Input.GetJoystickNames() end 

----Boolean Input.IsJoystickPreconfigured(String joystickName)
function Input.IsJoystickPreconfigured() end 

----Boolean Input.GetMouseButton(Int32 button)
function Input.GetMouseButton() end 

----Boolean Input.GetMouseButtonDown(Int32 button)
function Input.GetMouseButtonDown() end 

----Boolean Input.GetMouseButtonUp(Int32 button)
function Input.GetMouseButtonUp() end 

----Void Input.ResetInputAxes()
function Input.ResetInputAxes() end 

----AccelerationEvent Input.GetAccelerationEvent(Int32 index)
function Input.GetAccelerationEvent() end 

----Touch Input.GetTouch(Int32 index)
function Input.GetTouch() end 

KeyCode = {} 

None = nil;

Backspace = nil;

Delete = nil;

Tab = nil;

Clear = nil;

Return = nil;

Pause = nil;

Escape = nil;

Space = nil;

Keypad0 = nil;

Keypad1 = nil;

Keypad2 = nil;

Keypad3 = nil;

Keypad4 = nil;

Keypad5 = nil;

Keypad6 = nil;

Keypad7 = nil;

Keypad8 = nil;

Keypad9 = nil;

KeypadPeriod = nil;

KeypadDivide = nil;

KeypadMultiply = nil;

KeypadMinus = nil;

KeypadPlus = nil;

KeypadEnter = nil;

KeypadEquals = nil;

UpArrow = nil;

DownArrow = nil;

RightArrow = nil;

LeftArrow = nil;

Insert = nil;

Home = nil;

End = nil;

PageUp = nil;

PageDown = nil;

F1 = nil;

F2 = nil;

F3 = nil;

F4 = nil;

F5 = nil;

F6 = nil;

F7 = nil;

F8 = nil;

F9 = nil;

F10 = nil;

F11 = nil;

F12 = nil;

F13 = nil;

F14 = nil;

F15 = nil;

Alpha0 = nil;

Alpha1 = nil;

Alpha2 = nil;

Alpha3 = nil;

Alpha4 = nil;

Alpha5 = nil;

Alpha6 = nil;

Alpha7 = nil;

Alpha8 = nil;

Alpha9 = nil;

Exclaim = nil;

DoubleQuote = nil;

Hash = nil;

Dollar = nil;

Ampersand = nil;

Quote = nil;

LeftParen = nil;

RightParen = nil;

Asterisk = nil;

Plus = nil;

Comma = nil;

Minus = nil;

Period = nil;

Slash = nil;

Colon = nil;

Semicolon = nil;

Less = nil;

Equals = nil;

Greater = nil;

Question = nil;

At = nil;

LeftBracket = nil;

Backslash = nil;

RightBracket = nil;

Caret = nil;

Underscore = nil;

BackQuote = nil;

A = nil;

B = nil;

C = nil;

D = nil;

E = nil;

F = nil;

G = nil;

H = nil;

I = nil;

J = nil;

K = nil;

L = nil;

M = nil;

N = nil;

O = nil;

P = nil;

Q = nil;

R = nil;

S = nil;

T = nil;

U = nil;

V = nil;

W = nil;

X = nil;

Y = nil;

Z = nil;

Numlock = nil;

CapsLock = nil;

ScrollLock = nil;

RightShift = nil;

LeftShift = nil;

RightControl = nil;

LeftControl = nil;

RightAlt = nil;

LeftAlt = nil;

LeftCommand = nil;

LeftApple = nil;

LeftWindows = nil;

RightCommand = nil;

RightApple = nil;

RightWindows = nil;

AltGr = nil;

Help = nil;

Print = nil;

SysReq = nil;

Break = nil;

Menu = nil;

Mouse0 = nil;

Mouse1 = nil;

Mouse2 = nil;

Mouse3 = nil;

Mouse4 = nil;

Mouse5 = nil;

Mouse6 = nil;

JoystickButton0 = nil;

JoystickButton1 = nil;

JoystickButton2 = nil;

JoystickButton3 = nil;

JoystickButton4 = nil;

JoystickButton5 = nil;

JoystickButton6 = nil;

JoystickButton7 = nil;

JoystickButton8 = nil;

JoystickButton9 = nil;

JoystickButton10 = nil;

JoystickButton11 = nil;

JoystickButton12 = nil;

JoystickButton13 = nil;

JoystickButton14 = nil;

JoystickButton15 = nil;

JoystickButton16 = nil;

JoystickButton17 = nil;

JoystickButton18 = nil;

JoystickButton19 = nil;

Joystick1Button0 = nil;

Joystick1Button1 = nil;

Joystick1Button2 = nil;

Joystick1Button3 = nil;

Joystick1Button4 = nil;

Joystick1Button5 = nil;

Joystick1Button6 = nil;

Joystick1Button7 = nil;

Joystick1Button8 = nil;

Joystick1Button9 = nil;

Joystick1Button10 = nil;

Joystick1Button11 = nil;

Joystick1Button12 = nil;

Joystick1Button13 = nil;

Joystick1Button14 = nil;

Joystick1Button15 = nil;

Joystick1Button16 = nil;

Joystick1Button17 = nil;

Joystick1Button18 = nil;

Joystick1Button19 = nil;

Joystick2Button0 = nil;

Joystick2Button1 = nil;

Joystick2Button2 = nil;

Joystick2Button3 = nil;

Joystick2Button4 = nil;

Joystick2Button5 = nil;

Joystick2Button6 = nil;

Joystick2Button7 = nil;

Joystick2Button8 = nil;

Joystick2Button9 = nil;

Joystick2Button10 = nil;

Joystick2Button11 = nil;

Joystick2Button12 = nil;

Joystick2Button13 = nil;

Joystick2Button14 = nil;

Joystick2Button15 = nil;

Joystick2Button16 = nil;

Joystick2Button17 = nil;

Joystick2Button18 = nil;

Joystick2Button19 = nil;

Joystick3Button0 = nil;

Joystick3Button1 = nil;

Joystick3Button2 = nil;

Joystick3Button3 = nil;

Joystick3Button4 = nil;

Joystick3Button5 = nil;

Joystick3Button6 = nil;

Joystick3Button7 = nil;

Joystick3Button8 = nil;

Joystick3Button9 = nil;

Joystick3Button10 = nil;

Joystick3Button11 = nil;

Joystick3Button12 = nil;

Joystick3Button13 = nil;

Joystick3Button14 = nil;

Joystick3Button15 = nil;

Joystick3Button16 = nil;

Joystick3Button17 = nil;

Joystick3Button18 = nil;

Joystick3Button19 = nil;

Joystick4Button0 = nil;

Joystick4Button1 = nil;

Joystick4Button2 = nil;

Joystick4Button3 = nil;

Joystick4Button4 = nil;

Joystick4Button5 = nil;

Joystick4Button6 = nil;

Joystick4Button7 = nil;

Joystick4Button8 = nil;

Joystick4Button9 = nil;

Joystick4Button10 = nil;

Joystick4Button11 = nil;

Joystick4Button12 = nil;

Joystick4Button13 = nil;

Joystick4Button14 = nil;

Joystick4Button15 = nil;

Joystick4Button16 = nil;

Joystick4Button17 = nil;

Joystick4Button18 = nil;

Joystick4Button19 = nil;

Joystick5Button0 = nil;

Joystick5Button1 = nil;

Joystick5Button2 = nil;

Joystick5Button3 = nil;

Joystick5Button4 = nil;

Joystick5Button5 = nil;

Joystick5Button6 = nil;

Joystick5Button7 = nil;

Joystick5Button8 = nil;

Joystick5Button9 = nil;

Joystick5Button10 = nil;

Joystick5Button11 = nil;

Joystick5Button12 = nil;

Joystick5Button13 = nil;

Joystick5Button14 = nil;

Joystick5Button15 = nil;

Joystick5Button16 = nil;

Joystick5Button17 = nil;

Joystick5Button18 = nil;

Joystick5Button19 = nil;

Joystick6Button0 = nil;

Joystick6Button1 = nil;

Joystick6Button2 = nil;

Joystick6Button3 = nil;

Joystick6Button4 = nil;

Joystick6Button5 = nil;

Joystick6Button6 = nil;

Joystick6Button7 = nil;

Joystick6Button8 = nil;

Joystick6Button9 = nil;

Joystick6Button10 = nil;

Joystick6Button11 = nil;

Joystick6Button12 = nil;

Joystick6Button13 = nil;

Joystick6Button14 = nil;

Joystick6Button15 = nil;

Joystick6Button16 = nil;

Joystick6Button17 = nil;

Joystick6Button18 = nil;

Joystick6Button19 = nil;

Joystick7Button0 = nil;

Joystick7Button1 = nil;

Joystick7Button2 = nil;

Joystick7Button3 = nil;

Joystick7Button4 = nil;

Joystick7Button5 = nil;

Joystick7Button6 = nil;

Joystick7Button7 = nil;

Joystick7Button8 = nil;

Joystick7Button9 = nil;

Joystick7Button10 = nil;

Joystick7Button11 = nil;

Joystick7Button12 = nil;

Joystick7Button13 = nil;

Joystick7Button14 = nil;

Joystick7Button15 = nil;

Joystick7Button16 = nil;

Joystick7Button17 = nil;

Joystick7Button18 = nil;

Joystick7Button19 = nil;

Joystick8Button0 = nil;

Joystick8Button1 = nil;

Joystick8Button2 = nil;

Joystick8Button3 = nil;

Joystick8Button4 = nil;

Joystick8Button5 = nil;

Joystick8Button6 = nil;

Joystick8Button7 = nil;

Joystick8Button8 = nil;

Joystick8Button9 = nil;

Joystick8Button10 = nil;

Joystick8Button11 = nil;

Joystick8Button12 = nil;

Joystick8Button13 = nil;

Joystick8Button14 = nil;

Joystick8Button15 = nil;

Joystick8Button16 = nil;

Joystick8Button17 = nil;

Joystick8Button18 = nil;

Joystick8Button19 = nil;

SkinnedMeshRenderer = {} 
--*
--[Comment]
--consturctor for SkinnedMeshRenderer overrides:
--*
--SkinnedMeshRenderer.New()
--*

function SkinnedMeshRenderer.New() end
--*
--[Comment]
-- property: Transform[] SkinnedMeshRenderer.bones	get	set	
--The bones used to skin the mesh.
bones = nil 
--*
--[Comment]
-- property: Transform SkinnedMeshRenderer.rootBone	get	set	
rootBone = nil 
--*
--[Comment]
-- property: SkinQuality SkinnedMeshRenderer.quality	get	set	
--The maximum number of bones affecting a single vertex.
quality = nil 
--*
--[Comment]
-- property: Mesh SkinnedMeshRenderer.sharedMesh	get	set	
--The mesh used for skinning.
sharedMesh = nil 
--*
--[Comment]
-- property: Boolean SkinnedMeshRenderer.updateWhenOffscreen	get	set	
--If enabled, the Skinned Mesh will be updated when offscreen. If disabled, this also disables updating animations.
updateWhenOffscreen = nil 
--*
--[Comment]
-- property: Boolean SkinnedMeshRenderer.skinnedMotionVectors	get	set	
--Specifies whether skinned motion vectors should be used for this renderer.
skinnedMotionVectors = nil 
--*
--[Comment]
-- property: Bounds SkinnedMeshRenderer.localBounds	get	set	
--AABB of this Skinned Mesh in its local space.
localBounds = nil 
--*
--[Comment]
-- property: Boolean SkinnedMeshRenderer.isPartOfStaticBatch	get	
isPartOfStaticBatch = nil 
--*
--[Comment]
-- property: Matrix4x4 SkinnedMeshRenderer.worldToLocalMatrix	get	
worldToLocalMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 SkinnedMeshRenderer.localToWorldMatrix	get	
localToWorldMatrix = nil 
--*
--[Comment]
-- property: Boolean SkinnedMeshRenderer.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: ShadowCastingMode SkinnedMeshRenderer.shadowCastingMode	get	set	
shadowCastingMode = nil 
--*
--[Comment]
-- property: Boolean SkinnedMeshRenderer.receiveShadows	get	set	
receiveShadows = nil 
--*
--[Comment]
-- property: Material SkinnedMeshRenderer.material	get	set	
material = nil 
--*
--[Comment]
-- property: Material SkinnedMeshRenderer.sharedMaterial	get	set	
sharedMaterial = nil 
--*
--[Comment]
-- property: Material[] SkinnedMeshRenderer.materials	get	set	
materials = nil 
--*
--[Comment]
-- property: Material[] SkinnedMeshRenderer.sharedMaterials	get	set	
sharedMaterials = nil 
--*
--[Comment]
-- property: Bounds SkinnedMeshRenderer.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Int32 SkinnedMeshRenderer.lightmapIndex	get	set	
lightmapIndex = nil 
--*
--[Comment]
-- property: Int32 SkinnedMeshRenderer.realtimeLightmapIndex	get	set	
realtimeLightmapIndex = nil 
--*
--[Comment]
-- property: Vector4 SkinnedMeshRenderer.lightmapScaleOffset	get	set	
lightmapScaleOffset = nil 
--*
--[Comment]
-- property: Boolean SkinnedMeshRenderer.motionVectors	get	set	
motionVectors = nil 
--*
--[Comment]
-- property: Vector4 SkinnedMeshRenderer.realtimeLightmapScaleOffset	get	set	
realtimeLightmapScaleOffset = nil 
--*
--[Comment]
-- property: Boolean SkinnedMeshRenderer.isVisible	get	
isVisible = nil 
--*
--[Comment]
-- property: LightProbeUsage SkinnedMeshRenderer.lightProbeUsage	get	set	
lightProbeUsage = nil 
--*
--[Comment]
-- property: GameObject SkinnedMeshRenderer.lightProbeProxyVolumeOverride	get	set	
lightProbeProxyVolumeOverride = nil 
--*
--[Comment]
-- property: Transform SkinnedMeshRenderer.probeAnchor	get	set	
probeAnchor = nil 
--*
--[Comment]
-- property: ReflectionProbeUsage SkinnedMeshRenderer.reflectionProbeUsage	get	set	
reflectionProbeUsage = nil 
--*
--[Comment]
-- property: String SkinnedMeshRenderer.sortingLayerName	get	set	
sortingLayerName = nil 
--*
--[Comment]
-- property: Int32 SkinnedMeshRenderer.sortingLayerID	get	set	
sortingLayerID = nil 
--*
--[Comment]
-- property: Int32 SkinnedMeshRenderer.sortingOrder	get	set	
sortingOrder = nil 
--*
--[Comment]
-- property: Transform SkinnedMeshRenderer.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject SkinnedMeshRenderer.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String SkinnedMeshRenderer.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String SkinnedMeshRenderer.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags SkinnedMeshRenderer.hideFlags	get	set	
hideFlags = nil 
--*
----Void SkinnedMeshRenderer:BakeMesh(Mesh mesh)
function BakeMesh() end 

----Single SkinnedMeshRenderer:GetBlendShapeWeight(Int32 index)
function GetBlendShapeWeight() end 

----Void SkinnedMeshRenderer:SetBlendShapeWeight(Int32 index,Single value)
function SetBlendShapeWeight() end 

Space = {} 

World = nil;

Self = nil;

MeshRenderer = {} 
--*
--[Comment]
--consturctor for MeshRenderer overrides:
--*
--MeshRenderer.New()
--*

function MeshRenderer.New() end
--*
--[Comment]
-- property: Mesh MeshRenderer.additionalVertexStreams	get	set	
--Vertex attributes in this mesh will override or add attributes of the primary mesh in the MeshRenderer.
additionalVertexStreams = nil 
--*
--[Comment]
-- property: Boolean MeshRenderer.isPartOfStaticBatch	get	
isPartOfStaticBatch = nil 
--*
--[Comment]
-- property: Matrix4x4 MeshRenderer.worldToLocalMatrix	get	
worldToLocalMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 MeshRenderer.localToWorldMatrix	get	
localToWorldMatrix = nil 
--*
--[Comment]
-- property: Boolean MeshRenderer.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: ShadowCastingMode MeshRenderer.shadowCastingMode	get	set	
shadowCastingMode = nil 
--*
--[Comment]
-- property: Boolean MeshRenderer.receiveShadows	get	set	
receiveShadows = nil 
--*
--[Comment]
-- property: Material MeshRenderer.material	get	set	
material = nil 
--*
--[Comment]
-- property: Material MeshRenderer.sharedMaterial	get	set	
sharedMaterial = nil 
--*
--[Comment]
-- property: Material[] MeshRenderer.materials	get	set	
materials = nil 
--*
--[Comment]
-- property: Material[] MeshRenderer.sharedMaterials	get	set	
sharedMaterials = nil 
--*
--[Comment]
-- property: Bounds MeshRenderer.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Int32 MeshRenderer.lightmapIndex	get	set	
lightmapIndex = nil 
--*
--[Comment]
-- property: Int32 MeshRenderer.realtimeLightmapIndex	get	set	
realtimeLightmapIndex = nil 
--*
--[Comment]
-- property: Vector4 MeshRenderer.lightmapScaleOffset	get	set	
lightmapScaleOffset = nil 
--*
--[Comment]
-- property: Boolean MeshRenderer.motionVectors	get	set	
motionVectors = nil 
--*
--[Comment]
-- property: Vector4 MeshRenderer.realtimeLightmapScaleOffset	get	set	
realtimeLightmapScaleOffset = nil 
--*
--[Comment]
-- property: Boolean MeshRenderer.isVisible	get	
isVisible = nil 
--*
--[Comment]
-- property: LightProbeUsage MeshRenderer.lightProbeUsage	get	set	
lightProbeUsage = nil 
--*
--[Comment]
-- property: GameObject MeshRenderer.lightProbeProxyVolumeOverride	get	set	
lightProbeProxyVolumeOverride = nil 
--*
--[Comment]
-- property: Transform MeshRenderer.probeAnchor	get	set	
probeAnchor = nil 
--*
--[Comment]
-- property: ReflectionProbeUsage MeshRenderer.reflectionProbeUsage	get	set	
reflectionProbeUsage = nil 
--*
--[Comment]
-- property: String MeshRenderer.sortingLayerName	get	set	
sortingLayerName = nil 
--*
--[Comment]
-- property: Int32 MeshRenderer.sortingLayerID	get	set	
sortingLayerID = nil 
--*
--[Comment]
-- property: Int32 MeshRenderer.sortingOrder	get	set	
sortingOrder = nil 
--*
--[Comment]
-- property: Transform MeshRenderer.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject MeshRenderer.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String MeshRenderer.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String MeshRenderer.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags MeshRenderer.hideFlags	get	set	
hideFlags = nil 
--*
BoxCollider = {} 
--*
--[Comment]
--consturctor for BoxCollider overrides:
--*
--BoxCollider.New()
--*

function BoxCollider.New() end
--*
--[Comment]
-- property: Vector3 BoxCollider.center	get	set	
--The center of the box, measured in the object's local space.
center = nil 
--*
--[Comment]
-- property: Vector3 BoxCollider.size	get	set	
--The size of the box, measured in the object's local space.
size = nil 
--*
--[Comment]
-- property: Boolean BoxCollider.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Rigidbody BoxCollider.attachedRigidbody	get	
attachedRigidbody = nil 
--*
--[Comment]
-- property: Boolean BoxCollider.isTrigger	get	set	
isTrigger = nil 
--*
--[Comment]
-- property: Single BoxCollider.contactOffset	get	set	
contactOffset = nil 
--*
--[Comment]
-- property: PhysicMaterial BoxCollider.material	get	set	
material = nil 
--*
--[Comment]
-- property: PhysicMaterial BoxCollider.sharedMaterial	get	set	
sharedMaterial = nil 
--*
--[Comment]
-- property: Bounds BoxCollider.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Transform BoxCollider.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject BoxCollider.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String BoxCollider.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String BoxCollider.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags BoxCollider.hideFlags	get	set	
hideFlags = nil 
--*
MeshCollider = {} 
--*
--[Comment]
--consturctor for MeshCollider overrides:
--*
--MeshCollider.New()
--*

function MeshCollider.New() end
--*
--[Comment]
-- property: Mesh MeshCollider.sharedMesh	get	set	
--The mesh object used for collision detection.
sharedMesh = nil 
--*
--[Comment]
-- property: Boolean MeshCollider.convex	get	set	
--Use a convex collider from the mesh.
convex = nil 
--*
--[Comment]
-- property: Boolean MeshCollider.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Rigidbody MeshCollider.attachedRigidbody	get	
attachedRigidbody = nil 
--*
--[Comment]
-- property: Boolean MeshCollider.isTrigger	get	set	
isTrigger = nil 
--*
--[Comment]
-- property: Single MeshCollider.contactOffset	get	set	
contactOffset = nil 
--*
--[Comment]
-- property: PhysicMaterial MeshCollider.material	get	set	
material = nil 
--*
--[Comment]
-- property: PhysicMaterial MeshCollider.sharedMaterial	get	set	
sharedMaterial = nil 
--*
--[Comment]
-- property: Bounds MeshCollider.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Transform MeshCollider.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject MeshCollider.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String MeshCollider.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String MeshCollider.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags MeshCollider.hideFlags	get	set	
hideFlags = nil 
--*
SphereCollider = {} 
--*
--[Comment]
--consturctor for SphereCollider overrides:
--*
--SphereCollider.New()
--*

function SphereCollider.New() end
--*
--[Comment]
-- property: Vector3 SphereCollider.center	get	set	
--The center of the sphere in the object's local space.
center = nil 
--*
--[Comment]
-- property: Single SphereCollider.radius	get	set	
--The radius of the sphere measured in the object's local space.
radius = nil 
--*
--[Comment]
-- property: Boolean SphereCollider.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Rigidbody SphereCollider.attachedRigidbody	get	
attachedRigidbody = nil 
--*
--[Comment]
-- property: Boolean SphereCollider.isTrigger	get	set	
isTrigger = nil 
--*
--[Comment]
-- property: Single SphereCollider.contactOffset	get	set	
contactOffset = nil 
--*
--[Comment]
-- property: PhysicMaterial SphereCollider.material	get	set	
material = nil 
--*
--[Comment]
-- property: PhysicMaterial SphereCollider.sharedMaterial	get	set	
sharedMaterial = nil 
--*
--[Comment]
-- property: Bounds SphereCollider.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Transform SphereCollider.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject SphereCollider.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String SphereCollider.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String SphereCollider.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags SphereCollider.hideFlags	get	set	
hideFlags = nil 
--*
CharacterController = {} 
--*
--[Comment]
--consturctor for CharacterController overrides:
--*
--CharacterController.New()
--*

function CharacterController.New() end
--*
--[Comment]
-- property: Boolean CharacterController.isGrounded	get	
--Was the CharacterController touching the ground during the last move?
isGrounded = nil 
--*
--[Comment]
-- property: Vector3 CharacterController.velocity	get	
--The current relative velocity of the Character (see notes).
velocity = nil 
--*
--[Comment]
-- property: CollisionFlags CharacterController.collisionFlags	get	
--What part of the capsule collided with the environment during the last CharacterController.Move call.
collisionFlags = nil 
--*
--[Comment]
-- property: Single CharacterController.radius	get	set	
--The radius of the character's capsule.
radius = nil 
--*
--[Comment]
-- property: Single CharacterController.height	get	set	
--The height of the character's capsule.
height = nil 
--*
--[Comment]
-- property: Vector3 CharacterController.center	get	set	
--The center of the character's capsule relative to the transform's position.
center = nil 
--*
--[Comment]
-- property: Single CharacterController.slopeLimit	get	set	
--The character controllers slope limit in degrees.
slopeLimit = nil 
--*
--[Comment]
-- property: Single CharacterController.stepOffset	get	set	
--The character controllers step offset in meters.
stepOffset = nil 
--*
--[Comment]
-- property: Single CharacterController.skinWidth	get	set	
--The character's collision skin width.
skinWidth = nil 
--*
--[Comment]
-- property: Boolean CharacterController.detectCollisions	get	set	
--Determines whether other rigidbodies or character controllers collide with this character controller (by default this is always enabled).
detectCollisions = nil 
--*
--[Comment]
-- property: Boolean CharacterController.enableOverlapRecovery	get	set	
--Enables or disables overlap recovery.  Enables or disables overlap recovery. Used to depenetrate character controllers from static objects when an overlap is detected.
enableOverlapRecovery = nil 
--*
--[Comment]
-- property: Boolean CharacterController.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Rigidbody CharacterController.attachedRigidbody	get	
attachedRigidbody = nil 
--*
--[Comment]
-- property: Boolean CharacterController.isTrigger	get	set	
isTrigger = nil 
--*
--[Comment]
-- property: Single CharacterController.contactOffset	get	set	
contactOffset = nil 
--*
--[Comment]
-- property: PhysicMaterial CharacterController.material	get	set	
material = nil 
--*
--[Comment]
-- property: PhysicMaterial CharacterController.sharedMaterial	get	set	
sharedMaterial = nil 
--*
--[Comment]
-- property: Bounds CharacterController.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Transform CharacterController.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject CharacterController.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String CharacterController.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String CharacterController.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags CharacterController.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean CharacterController:SimpleMove(Vector3 speed)
function SimpleMove() end 

----CollisionFlags CharacterController:Move(Vector3 motion)
function Move() end 

CapsuleCollider = {} 
--*
--[Comment]
--consturctor for CapsuleCollider overrides:
--*
--CapsuleCollider.New()
--*

function CapsuleCollider.New() end
--*
--[Comment]
-- property: Vector3 CapsuleCollider.center	get	set	
--The center of the capsule, measured in the object's local space.
center = nil 
--*
--[Comment]
-- property: Single CapsuleCollider.radius	get	set	
--The radius of the sphere, measured in the object's local space.
radius = nil 
--*
--[Comment]
-- property: Single CapsuleCollider.height	get	set	
--The height of the capsule meased in the object's local space.
height = nil 
--*
--[Comment]
-- property: Int32 CapsuleCollider.direction	get	set	
--The direction of the capsule.
direction = nil 
--*
--[Comment]
-- property: Boolean CapsuleCollider.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Rigidbody CapsuleCollider.attachedRigidbody	get	
attachedRigidbody = nil 
--*
--[Comment]
-- property: Boolean CapsuleCollider.isTrigger	get	set	
isTrigger = nil 
--*
--[Comment]
-- property: Single CapsuleCollider.contactOffset	get	set	
contactOffset = nil 
--*
--[Comment]
-- property: PhysicMaterial CapsuleCollider.material	get	set	
material = nil 
--*
--[Comment]
-- property: PhysicMaterial CapsuleCollider.sharedMaterial	get	set	
sharedMaterial = nil 
--*
--[Comment]
-- property: Bounds CapsuleCollider.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Transform CapsuleCollider.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject CapsuleCollider.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String CapsuleCollider.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String CapsuleCollider.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags CapsuleCollider.hideFlags	get	set	
hideFlags = nil 
--*
Animation = {} 
--*
--[Comment]
--consturctor for Animation overrides:
--*
--Animation.New()
--*

function Animation.New() end
--*
--[Comment]
-- property: AnimationClip Animation.clip	get	set	
--The default animation.
clip = nil 
--*
--[Comment]
-- property: Boolean Animation.playAutomatically	get	set	
--Should the default animation clip (the Animation.clip property) automatically start playing on startup?
playAutomatically = nil 
--*
--[Comment]
-- property: WrapMode Animation.wrapMode	get	set	
--How should time beyond the playback range of the clip be treated?
wrapMode = nil 
--*
--[Comment]
-- property: Boolean Animation.isPlaying	get	
--Are we playing any animations?
isPlaying = nil 
--*
--[Comment]
-- property: AnimationState Animation.Item	get	
Item = nil 
--*
--[Comment]
-- property: Boolean Animation.animatePhysics	get	set	
--When turned on, animations will be executed in the physics loop. This is only useful in conjunction with kinematic rigidbodies.
animatePhysics = nil 
--*
--[Comment]
-- property: AnimationCullingType Animation.cullingType	get	set	
--Controls culling of this Animation component.
cullingType = nil 
--*
--[Comment]
-- property: Bounds Animation.localBounds	get	set	
--AABB of this Animation animation component in local space.
localBounds = nil 
--*
--[Comment]
-- property: Boolean Animation.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Animation.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Animation.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Animation.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Animation.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Animation.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Animation.hideFlags	get	set	
hideFlags = nil 
--*
----Void Animation:Stop()
--Void Animation:Stop(String name)
function Stop() end 

----Void Animation:Rewind(String name)
--Void Animation:Rewind()
function Rewind() end 

----Void Animation:Sample()
function Sample() end 

----Boolean Animation:IsPlaying(String name)
function IsPlaying() end 

----AnimationState Animation:get_Item(String name)
function get_Item() end 

----Boolean Animation:Play()
--Boolean Animation:Play(PlayMode mode)
--Boolean Animation:Play(String animation,PlayMode mode)
--Boolean Animation:Play(String animation)
function Play() end 

----Void Animation:CrossFade(String animation,Single fadeLength,PlayMode mode)
--Void Animation:CrossFade(String animation,Single fadeLength)
--Void Animation:CrossFade(String animation)
function CrossFade() end 

----Void Animation:Blend(String animation,Single targetWeight,Single fadeLength)
--Void Animation:Blend(String animation,Single targetWeight)
--Void Animation:Blend(String animation)
function Blend() end 

----AnimationState Animation:CrossFadeQueued(String animation,Single fadeLength,QueueMode queue,PlayMode mode)
--AnimationState Animation:CrossFadeQueued(String animation,Single fadeLength,QueueMode queue)
--AnimationState Animation:CrossFadeQueued(String animation,Single fadeLength)
--AnimationState Animation:CrossFadeQueued(String animation)
function CrossFadeQueued() end 

----AnimationState Animation:PlayQueued(String animation,QueueMode queue,PlayMode mode)
--AnimationState Animation:PlayQueued(String animation,QueueMode queue)
--AnimationState Animation:PlayQueued(String animation)
function PlayQueued() end 

----Void Animation:AddClip(AnimationClip clip,String newName)
--Void Animation:AddClip(AnimationClip clip,String newName,Int32 firstFrame,Int32 lastFrame,Boolean addLoopFrame)
--Void Animation:AddClip(AnimationClip clip,String newName,Int32 firstFrame,Int32 lastFrame)
function AddClip() end 

----Void Animation:RemoveClip(AnimationClip clip)
--Void Animation:RemoveClip(String clipName)
function RemoveClip() end 

----Int32 Animation:GetClipCount()
function GetClipCount() end 

----Void Animation:SyncLayer(Int32 layer)
function SyncLayer() end 

----IEnumerator Animation:GetEnumerator()
function GetEnumerator() end 

----AnimationClip Animation:GetClip(String name)
function GetClip() end 

AnimationClip = {} 
--*
--[Comment]
--consturctor for AnimationClip overrides:
--*
--AnimationClip.New()
--Creates a new animation clip.
--*

function AnimationClip.New() end
--*
--[Comment]
-- property: Single AnimationClip.length	get	
--Animation length in seconds. (Read Only)
length = nil 
--*
--[Comment]
-- property: Single AnimationClip.frameRate	get	set	
--Frame rate at which keyframes are sampled. (Read Only)
frameRate = nil 
--*
--[Comment]
-- property: WrapMode AnimationClip.wrapMode	get	set	
--Sets the default wrap mode used in the animation state.
wrapMode = nil 
--*
--[Comment]
-- property: Bounds AnimationClip.localBounds	get	set	
--AABB of this Animation Clip in local space of Animation component that it is attached too.
localBounds = nil 
--*
--[Comment]
-- property: Boolean AnimationClip.legacy	get	set	
--Set to true if the AnimationClip will be used with the Legacy Animation component ( instead of the Animator ).
legacy = nil 
--*
--[Comment]
-- property: Boolean AnimationClip.humanMotion	get	
--Returns true if the animation contains curve that drives a humanoid rig.
humanMotion = nil 
--*
--[Comment]
-- property: AnimationEvent[] AnimationClip.events	get	set	
--Animation Events for this animation clip.
events = nil 
--*
--[Comment]
-- property: Single AnimationClip.averageDuration	get	
averageDuration = nil 
--*
--[Comment]
-- property: Single AnimationClip.averageAngularSpeed	get	
averageAngularSpeed = nil 
--*
--[Comment]
-- property: Vector3 AnimationClip.averageSpeed	get	
averageSpeed = nil 
--*
--[Comment]
-- property: Single AnimationClip.apparentSpeed	get	
apparentSpeed = nil 
--*
--[Comment]
-- property: Boolean AnimationClip.isLooping	get	
isLooping = nil 
--*
--[Comment]
-- property: Boolean AnimationClip.isHumanMotion	get	
isHumanMotion = nil 
--*
--[Comment]
-- property: String AnimationClip.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags AnimationClip.hideFlags	get	set	
hideFlags = nil 
--*
----Void AnimationClip:SampleAnimation(GameObject go,Single time)
function SampleAnimation() end 

----Void AnimationClip:SetCurve(String relativePath,Type type,String propertyName,AnimationCurve curve)
function SetCurve() end 

----Void AnimationClip:EnsureQuaternionContinuity()
function EnsureQuaternionContinuity() end 

----Void AnimationClip:ClearCurves()
function ClearCurves() end 

----Void AnimationClip:AddEvent(AnimationEvent evt)
function AddEvent() end 

AnimationState = {} 
--*
--[Comment]
--consturctor for AnimationState overrides:
--*
--AnimationState.New()
--*

function AnimationState.New() end
--*
--[Comment]
-- property: Boolean AnimationState.enabled	get	set	
--Enables / disables the animation.
enabled = nil 
--*
--[Comment]
-- property: Single AnimationState.weight	get	set	
--The weight of animation.
weight = nil 
--*
--[Comment]
-- property: WrapMode AnimationState.wrapMode	get	set	
--Wrapping mode of the animation.
wrapMode = nil 
--*
--[Comment]
-- property: Single AnimationState.time	get	set	
--The current time of the animation.
time = nil 
--*
--[Comment]
-- property: Single AnimationState.normalizedTime	get	set	
--The normalized time of the animation.
normalizedTime = nil 
--*
--[Comment]
-- property: Single AnimationState.speed	get	set	
--The playback speed of the animation. 1 is normal playback speed.
speed = nil 
--*
--[Comment]
-- property: Single AnimationState.normalizedSpeed	get	set	
--The normalized playback speed.
normalizedSpeed = nil 
--*
--[Comment]
-- property: Single AnimationState.length	get	
--The length of the animation clip in seconds.
length = nil 
--*
--[Comment]
-- property: Int32 AnimationState.layer	get	set	
layer = nil 
--*
--[Comment]
-- property: AnimationClip AnimationState.clip	get	
--The clip that is being played by this animation state.
clip = nil 
--*
--[Comment]
-- property: String AnimationState.name	get	set	
--The name of the animation.
name = nil 
--*
--[Comment]
-- property: AnimationBlendMode AnimationState.blendMode	get	set	
--Which blend mode should be used?
blendMode = nil 
--*
----Void AnimationState:AddMixingTransform(Transform mix,Boolean recursive)
--Void AnimationState:AddMixingTransform(Transform mix)
function AddMixingTransform() end 

----Void AnimationState:RemoveMixingTransform(Transform mix)
function RemoveMixingTransform() end 

AnimationBlendMode = {} 

Blend = nil;

Additive = nil;

QueueMode = {} 

CompleteOthers = nil;

PlayNow = nil;

PlayMode = {} 

StopSameLayer = nil;

StopAll = nil;

WrapMode = {} 

Once = nil;

Loop = nil;

PingPong = nil;

Default = nil;

ClampForever = nil;

Clamp = nil;

QualitySettings = {} 
--*
--[Comment]
--consturctor for QualitySettings overrides:
--*
--QualitySettings.New()
--*

function QualitySettings.New() end
--*
--[Comment]
-- property: String[] QualitySettings.names	get	
--The indexed list of available Quality Settings.
names = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.pixelLightCount	get	set	
--The maximum number of pixel lights that should affect any object.
pixelLightCount = nil 
--*
--[Comment]
-- property: ShadowProjection QualitySettings.shadowProjection	get	set	
--Directional light shadow projection.
shadowProjection = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.shadowCascades	get	set	
--Number of cascades to use for directional light shadows.
shadowCascades = nil 
--*
--[Comment]
-- property: Single QualitySettings.shadowDistance	get	set	
--Shadow drawing distance.
shadowDistance = nil 
--*
--[Comment]
-- property: ShadowResolution QualitySettings.shadowResolution	get	set	
--The default resolution of the shadow maps.
shadowResolution = nil 
--*
--[Comment]
-- property: Single QualitySettings.shadowNearPlaneOffset	get	set	
--Offset shadow frustum near plane.
shadowNearPlaneOffset = nil 
--*
--[Comment]
-- property: Single QualitySettings.shadowCascade2Split	get	set	
--The normalized cascade distribution for a 2 cascade setup. The value defines the position of the cascade with respect to Zero.
shadowCascade2Split = nil 
--*
--[Comment]
-- property: Vector3 QualitySettings.shadowCascade4Split	get	set	
--The normalized cascade start position for a 4 cascade setup. Each member of the vector defines the normalized position of the coresponding cascade with respect to Zero.
shadowCascade4Split = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.masterTextureLimit	get	set	
--A texture size limit applied to all textures.
masterTextureLimit = nil 
--*
--[Comment]
-- property: AnisotropicFiltering QualitySettings.anisotropicFiltering	get	set	
--Global anisotropic filtering mode.
anisotropicFiltering = nil 
--*
--[Comment]
-- property: Single QualitySettings.lodBias	get	set	
--Global multiplier for the LOD's switching distance.
lodBias = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.maximumLODLevel	get	set	
--A maximum LOD level. All LOD groups.
maximumLODLevel = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.particleRaycastBudget	get	set	
--Budget for how many ray casts can be performed per frame for approximate collision testing.
particleRaycastBudget = nil 
--*
--[Comment]
-- property: Boolean QualitySettings.softVegetation	get	set	
--Use a two-pass shader for the vegetation in the terrain engine.
softVegetation = nil 
--*
--[Comment]
-- property: Boolean QualitySettings.realtimeReflectionProbes	get	set	
--Enables realtime reflection probes.
realtimeReflectionProbes = nil 
--*
--[Comment]
-- property: Boolean QualitySettings.billboardsFaceCameraPosition	get	set	
--If enabled, billboards will face towards camera position rather than camera orientation.
billboardsFaceCameraPosition = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.maxQueuedFrames	get	set	
--Maximum number of frames queued up by graphics driver.
maxQueuedFrames = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.vSyncCount	get	set	
--The VSync Count.
vSyncCount = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.antiAliasing	get	set	
--Set The AA Filtering option.
antiAliasing = nil 
--*
--[Comment]
-- property: ColorSpace QualitySettings.desiredColorSpace	get	
--Desired color space (Read Only).
desiredColorSpace = nil 
--*
--[Comment]
-- property: ColorSpace QualitySettings.activeColorSpace	get	
--Active color space (Read Only).
activeColorSpace = nil 
--*
--[Comment]
-- property: BlendWeights QualitySettings.blendWeights	get	set	
--Blend weights.
blendWeights = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.asyncUploadTimeSlice	get	set	
--Async texture upload provides timesliced async texture upload on the render thread with tight control over memory and timeslicing. There are no allocations except for the ones which driver has to do. To read data and upload texture data a ringbuffer whose size can be controlled is re-used.  Use asyncUploadTimeSlice to set the time-slice in milliseconds for asynchronous texture uploads per  frame. Minimum value is 1 and maximum is 33.
asyncUploadTimeSlice = nil 
--*
--[Comment]
-- property: Int32 QualitySettings.asyncUploadBufferSize	get	set	
--Async texture upload provides timesliced async texture upload on the render thread with tight control over memory and timeslicing. There are no allocations except for the ones which driver has to do. To read data and upload texture data a ringbuffer whose size can be controlled is re-used.  Use asyncUploadBufferSize to set the buffer size for asynchronous texture uploads. The size is in megabytes. Minimum value is 2 and maximum is 512. Although the buffer will resize automatically to fit the largest texture currently loading, it is recommended to set the value approximately to the size of biggest texture used in the scene to avoid re-sizing of the buffer which can incur performance cost.
asyncUploadBufferSize = nil 
--*
--[Comment]
-- property: String QualitySettings.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags QualitySettings.hideFlags	get	set	
hideFlags = nil 
--*
----Int32 QualitySettings.GetQualityLevel()
function QualitySettings.GetQualityLevel() end 

----Void QualitySettings.SetQualityLevel(Int32 index,Boolean applyExpensiveChanges)
--Void QualitySettings.SetQualityLevel(Int32 index)
function QualitySettings.SetQualityLevel() end 

----Void QualitySettings.IncreaseLevel(Boolean applyExpensiveChanges)
--Void QualitySettings.IncreaseLevel()
function QualitySettings.IncreaseLevel() end 

----Void QualitySettings.DecreaseLevel(Boolean applyExpensiveChanges)
--Void QualitySettings.DecreaseLevel()
function QualitySettings.DecreaseLevel() end 

RenderSettings = {} 
--*
--[Comment]
--consturctor for RenderSettings overrides:
--*
--RenderSettings.New()
--*

function RenderSettings.New() end
--*
--[Comment]
-- property: Boolean RenderSettings.fog	get	set	
--Is fog enabled?
fog = nil 
--*
--[Comment]
-- property: FogMode RenderSettings.fogMode	get	set	
--Fog mode to use.
fogMode = nil 
--*
--[Comment]
-- property: Color RenderSettings.fogColor	get	set	
--The color of the fog.
fogColor = nil 
--*
--[Comment]
-- property: Single RenderSettings.fogDensity	get	set	
--The density of the exponential fog.
fogDensity = nil 
--*
--[Comment]
-- property: Single RenderSettings.fogStartDistance	get	set	
--The starting distance of linear fog.
fogStartDistance = nil 
--*
--[Comment]
-- property: Single RenderSettings.fogEndDistance	get	set	
--The ending distance of linear fog.
fogEndDistance = nil 
--*
--[Comment]
-- property: AmbientMode RenderSettings.ambientMode	get	set	
--Ambient lighting mode.
ambientMode = nil 
--*
--[Comment]
-- property: Color RenderSettings.ambientSkyColor	get	set	
--Ambient lighting coming from above.
ambientSkyColor = nil 
--*
--[Comment]
-- property: Color RenderSettings.ambientEquatorColor	get	set	
--Ambient lighting coming from the sides.
ambientEquatorColor = nil 
--*
--[Comment]
-- property: Color RenderSettings.ambientGroundColor	get	set	
--Ambient lighting coming from below.
ambientGroundColor = nil 
--*
--[Comment]
-- property: Color RenderSettings.ambientLight	get	set	
--Flat ambient lighting color.
ambientLight = nil 
--*
--[Comment]
-- property: Single RenderSettings.ambientIntensity	get	set	
--How much the light from the Ambient Source affects the scene.
ambientIntensity = nil 
--*
--[Comment]
-- property: SphericalHarmonicsL2 RenderSettings.ambientProbe	get	set	
--Custom or skybox ambient lighting data.
ambientProbe = nil 
--*
--[Comment]
-- property: Single RenderSettings.reflectionIntensity	get	set	
--How much the skybox / custom cubemap reflection affects the scene.
reflectionIntensity = nil 
--*
--[Comment]
-- property: Int32 RenderSettings.reflectionBounces	get	set	
--The number of times a reflection includes other reflections.
reflectionBounces = nil 
--*
--[Comment]
-- property: Single RenderSettings.haloStrength	get	set	
--Size of the Light halos.
haloStrength = nil 
--*
--[Comment]
-- property: Single RenderSettings.flareStrength	get	set	
--The intensity of all flares in the scene.
flareStrength = nil 
--*
--[Comment]
-- property: Single RenderSettings.flareFadeSpeed	get	set	
--The fade speed of all flares in the scene.
flareFadeSpeed = nil 
--*
--[Comment]
-- property: Material RenderSettings.skybox	get	set	
--The global skybox to use.
skybox = nil 
--*
--[Comment]
-- property: DefaultReflectionMode RenderSettings.defaultReflectionMode	get	set	
--Default reflection mode.
defaultReflectionMode = nil 
--*
--[Comment]
-- property: Int32 RenderSettings.defaultReflectionResolution	get	set	
--Cubemap resolution for default reflection.
defaultReflectionResolution = nil 
--*
--[Comment]
-- property: Cubemap RenderSettings.customReflection	get	set	
--Custom specular reflection cubemap.
customReflection = nil 
--*
--[Comment]
-- property: String RenderSettings.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags RenderSettings.hideFlags	get	set	
hideFlags = nil 
--*
BlendWeights = {} 

OneBone = nil;

TwoBones = nil;

FourBones = nil;

RenderTexture = {} 
--*
--[Comment]
--consturctor for RenderTexture overrides:
--*
--RenderTexture.New(Int32 width,Int32 height,Int32 depth,RenderTextureFormat format,RenderTextureReadWrite readWrite)
--Creates a new RenderTexture object.
--params:
--width:    Texture width in pixels.
--height:    Texture height in pixels.
--depth:    Number of bits in depth buffer (0, 16 or 24). Note that only 24 bit depth has stencil buffer.
--format:    Texture color format.
--readWrite:    How or if color space conversions should be done on texture read/write.

--*

--RenderTexture.New(Int32 width,Int32 height,Int32 depth,RenderTextureFormat format)
--Creates a new RenderTexture object.
--params:
--width:    Texture width in pixels.
--height:    Texture height in pixels.
--depth:    Number of bits in depth buffer (0, 16 or 24). Note that only 24 bit depth has stencil buffer.
--format:    Texture color format.
--readWrite:    How or if color space conversions should be done on texture read/write.

--*

--RenderTexture.New(Int32 width,Int32 height,Int32 depth)
--Creates a new RenderTexture object.
--params:
--width:    Texture width in pixels.
--height:    Texture height in pixels.
--depth:    Number of bits in depth buffer (0, 16 or 24). Note that only 24 bit depth has stencil buffer.
--format:    Texture color format.
--readWrite:    How or if color space conversions should be done on texture read/write.

--*

function RenderTexture.New() end
--*
--[Comment]
-- property: Int32 RenderTexture.width	get	set	
--The width of the render texture in pixels.
width = nil 
--*
--[Comment]
-- property: Int32 RenderTexture.height	get	set	
--The height of the render texture in pixels.
height = nil 
--*
--[Comment]
-- property: Int32 RenderTexture.depth	get	set	
--The precision of the render texture's depth buffer in bits (0, 16, 24 are supported).
depth = nil 
--*
--[Comment]
-- property: Boolean RenderTexture.isPowerOfTwo	get	set	
isPowerOfTwo = nil 
--*
--[Comment]
-- property: Boolean RenderTexture.sRGB	get	
--Does this render texture use sRGB read/write conversions (Read Only).
sRGB = nil 
--*
--[Comment]
-- property: RenderTextureFormat RenderTexture.format	get	set	
--The color format of the render texture.
format = nil 
--*
--[Comment]
-- property: Boolean RenderTexture.useMipMap	get	set	
--Use mipmaps on a render texture?
useMipMap = nil 
--*
--[Comment]
-- property: Boolean RenderTexture.generateMips	get	set	
--Should mipmap levels be generated automatically?
generateMips = nil 
--*
--[Comment]
-- property: TextureDimension RenderTexture.dimension	get	set	
--Dimensionality (type) of the render texture.
dimension = nil 
--*
--[Comment]
-- property: Int32 RenderTexture.volumeDepth	get	set	
--Volume extent of a 3D render texture.
volumeDepth = nil 
--*
--[Comment]
-- property: Int32 RenderTexture.antiAliasing	get	set	
--The antialiasing level for the RenderTexture.
antiAliasing = nil 
--*
--[Comment]
-- property: Boolean RenderTexture.enableRandomWrite	get	set	
--Enable random access write into this render texture on Shader Model 5.0 level shaders.
enableRandomWrite = nil 
--*
--[Comment]
-- property: RenderBuffer RenderTexture.colorBuffer	get	
--Color buffer of the render texture (Read Only).
colorBuffer = nil 
--*
--[Comment]
-- property: RenderBuffer RenderTexture.depthBuffer	get	
--Depth/stencil buffer of the render texture (Read Only).
depthBuffer = nil 
--*
--[Comment]
-- property: RenderTexture RenderTexture.active	get	set	
--Currently active render texture.
active = nil 
--*
--[Comment]
-- property: FilterMode RenderTexture.filterMode	get	set	
filterMode = nil 
--*
--[Comment]
-- property: Int32 RenderTexture.anisoLevel	get	set	
anisoLevel = nil 
--*
--[Comment]
-- property: TextureWrapMode RenderTexture.wrapMode	get	set	
wrapMode = nil 
--*
--[Comment]
-- property: Single RenderTexture.mipMapBias	get	set	
mipMapBias = nil 
--*
--[Comment]
-- property: Vector2 RenderTexture.texelSize	get	
texelSize = nil 
--*
--[Comment]
-- property: String RenderTexture.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags RenderTexture.hideFlags	get	set	
hideFlags = nil 
--*
----RenderTexture RenderTexture.GetTemporary(Int32 width,Int32 height,Int32 depthBuffer,RenderTextureFormat format,RenderTextureReadWrite readWrite,Int32 antiAliasing)
--RenderTexture RenderTexture.GetTemporary(Int32 width,Int32 height,Int32 depthBuffer,RenderTextureFormat format,RenderTextureReadWrite readWrite)
--RenderTexture RenderTexture.GetTemporary(Int32 width,Int32 height,Int32 depthBuffer,RenderTextureFormat format)
--RenderTexture RenderTexture.GetTemporary(Int32 width,Int32 height,Int32 depthBuffer)
--RenderTexture RenderTexture.GetTemporary(Int32 width,Int32 height)
function RenderTexture.GetTemporary() end 

----Void RenderTexture.ReleaseTemporary(RenderTexture temp)
function RenderTexture.ReleaseTemporary() end 

----Boolean RenderTexture:Create()
function Create() end 

----Void RenderTexture:Release()
function Release() end 

----Boolean RenderTexture:IsCreated()
function IsCreated() end 

----Void RenderTexture:DiscardContents()
--Void RenderTexture:DiscardContents(Boolean discardColor,Boolean discardDepth)
function DiscardContents() end 

----Void RenderTexture:MarkRestoreExpected()
function MarkRestoreExpected() end 

----IntPtr RenderTexture:GetNativeDepthBufferPtr()
function GetNativeDepthBufferPtr() end 

----Void RenderTexture:SetGlobalShaderProperty(String propertyName)
function SetGlobalShaderProperty() end 

----Vector2 RenderTexture:GetTexelOffset()
function GetTexelOffset() end 

----Boolean RenderTexture.SupportsStencil(RenderTexture rt)
function RenderTexture.SupportsStencil() end 

Graphic = {} 
--*
--[Comment]
-- property: Material Graphic.defaultGraphicMaterial	get	
--Default material used to draw UI elements if no explicit material was specified.
defaultGraphicMaterial = nil 
--*
--[Comment]
-- property: Color Graphic.color	get	set	
--Base color of the Graphic.
color = nil 
--*
--[Comment]
-- property: Boolean Graphic.raycastTarget	get	set	
--Should this graphic be considered a target for raycasting?
raycastTarget = nil 
--*
--[Comment]
-- property: Int32 Graphic.depth	get	
--Absolute depth of the graphic in the hierarchy, used by rendering and events.
depth = nil 
--*
--[Comment]
-- property: RectTransform Graphic.rectTransform	get	
--The RectTransform component used by the Graphic.
rectTransform = nil 
--*
--[Comment]
-- property: Canvas Graphic.canvas	get	
--A reference to the Canvas this Graphic is rendering to.
canvas = nil 
--*
--[Comment]
-- property: CanvasRenderer Graphic.canvasRenderer	get	
--The CanvasRenderer used by this Graphic.
canvasRenderer = nil 
--*
--[Comment]
-- property: Material Graphic.defaultMaterial	get	
--Returns the default material for the graphic.
defaultMaterial = nil 
--*
--[Comment]
-- property: Material Graphic.material	get	set	
--The Material set by the user.
material = nil 
--*
--[Comment]
-- property: Material Graphic.materialForRendering	get	
--The material that will be sent for Rendering (Read only).
materialForRendering = nil 
--*
--[Comment]
-- property: Texture Graphic.mainTexture	get	
--The graphic's texture. (Read Only).
mainTexture = nil 
--*
--[Comment]
-- property: Boolean Graphic.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Graphic.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Graphic.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Graphic.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Graphic.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Graphic.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Graphic.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Graphic.hideFlags	get	set	
hideFlags = nil 
--*
----Void Graphic:SetAllDirty()
function SetAllDirty() end 

----Void Graphic:SetLayoutDirty()
function SetLayoutDirty() end 

----Void Graphic:SetVerticesDirty()
function SetVerticesDirty() end 

----Void Graphic:SetMaterialDirty()
function SetMaterialDirty() end 

----Void Graphic:Rebuild(CanvasUpdate update)
function Rebuild() end 

----Void Graphic:LayoutComplete()
function LayoutComplete() end 

----Void Graphic:GraphicUpdateComplete()
function GraphicUpdateComplete() end 

----Void Graphic:OnRebuildRequested()
function OnRebuildRequested() end 

----Void Graphic:SetNativeSize()
function SetNativeSize() end 

----Boolean Graphic:Raycast(Vector2 sp,Camera eventCamera)
function Raycast() end 

----Vector2 Graphic:PixelAdjustPoint(Vector2 point)
function PixelAdjustPoint() end 

----Rect Graphic:GetPixelAdjustedRect()
function GetPixelAdjustedRect() end 

----Void Graphic:CrossFadeColor(Color targetColor,Single duration,Boolean ignoreTimeScale,Boolean useAlpha)
--Void Graphic:CrossFadeColor(Color targetColor,Single duration,Boolean ignoreTimeScale,Boolean useAlpha,Boolean useRGB)
function CrossFadeColor() end 

----Void Graphic:CrossFadeAlpha(Single alpha,Single duration,Boolean ignoreTimeScale)
function CrossFadeAlpha() end 

----Void Graphic:RegisterDirtyLayoutCallback(UnityAction action)
function RegisterDirtyLayoutCallback() end 

----Void Graphic:UnregisterDirtyLayoutCallback(UnityAction action)
function UnregisterDirtyLayoutCallback() end 

----Void Graphic:RegisterDirtyVerticesCallback(UnityAction action)
function RegisterDirtyVerticesCallback() end 

----Void Graphic:UnregisterDirtyVerticesCallback(UnityAction action)
function UnregisterDirtyVerticesCallback() end 

----Void Graphic:RegisterDirtyMaterialCallback(UnityAction action)
function RegisterDirtyMaterialCallback() end 

----Void Graphic:UnregisterDirtyMaterialCallback(UnityAction action)
function UnregisterDirtyMaterialCallback() end 

MaskableGraphic = {} 
--*
--[Comment]
-- property: CullStateChangedEvent MaskableGraphic.onCullStateChanged	get	set	
--Callback issued when culling changes.
onCullStateChanged = nil 
--*
--[Comment]
-- property: Boolean MaskableGraphic.maskable	get	set	
--Does this graphic allow masking.
maskable = nil 
--*
--[Comment]
-- property: Color MaskableGraphic.color	get	set	
color = nil 
--*
--[Comment]
-- property: Boolean MaskableGraphic.raycastTarget	get	set	
raycastTarget = nil 
--*
--[Comment]
-- property: Int32 MaskableGraphic.depth	get	
depth = nil 
--*
--[Comment]
-- property: RectTransform MaskableGraphic.rectTransform	get	
rectTransform = nil 
--*
--[Comment]
-- property: Canvas MaskableGraphic.canvas	get	
canvas = nil 
--*
--[Comment]
-- property: CanvasRenderer MaskableGraphic.canvasRenderer	get	
canvasRenderer = nil 
--*
--[Comment]
-- property: Material MaskableGraphic.defaultMaterial	get	
defaultMaterial = nil 
--*
--[Comment]
-- property: Material MaskableGraphic.material	get	set	
material = nil 
--*
--[Comment]
-- property: Material MaskableGraphic.materialForRendering	get	
materialForRendering = nil 
--*
--[Comment]
-- property: Texture MaskableGraphic.mainTexture	get	
mainTexture = nil 
--*
--[Comment]
-- property: Boolean MaskableGraphic.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean MaskableGraphic.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean MaskableGraphic.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform MaskableGraphic.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject MaskableGraphic.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String MaskableGraphic.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String MaskableGraphic.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags MaskableGraphic.hideFlags	get	set	
hideFlags = nil 
--*
----Material MaskableGraphic:GetModifiedMaterial(Material baseMaterial)
function GetModifiedMaterial() end 

----Void MaskableGraphic:Cull(Rect clipRect,Boolean validRect)
function Cull() end 

----Void MaskableGraphic:SetClipRect(Rect clipRect,Boolean validRect)
function SetClipRect() end 

----Void MaskableGraphic:RecalculateClipping()
function RecalculateClipping() end 

----Void MaskableGraphic:RecalculateMasking()
function RecalculateMasking() end 

Image = {} 
--*
--[Comment]
-- property: Sprite Image.sprite	get	set	
--The sprite that is used to render this image.
sprite = nil 
--*
--[Comment]
-- property: Sprite Image.overrideSprite	get	set	
--Set an override sprite to be used for rendering.
overrideSprite = nil 
--*
--[Comment]
-- property: Type Image.type	get	set	
--How to display the image.
type = nil 
--*
--[Comment]
-- property: Boolean Image.preserveAspect	get	set	
--Whether this image should preserve its Sprite aspect ratio.
preserveAspect = nil 
--*
--[Comment]
-- property: Boolean Image.fillCenter	get	set	
--Whether or not to render the center of a Tiled or Sliced image.
fillCenter = nil 
--*
--[Comment]
-- property: FillMethod Image.fillMethod	get	set	
--What type of fill method to use.
fillMethod = nil 
--*
--[Comment]
-- property: Single Image.fillAmount	get	set	
--Amount of the Image shown when the Image.type is set to Image.Type.Filled.
fillAmount = nil 
--*
--[Comment]
-- property: Boolean Image.fillClockwise	get	set	
--Whether the Image should be filled clockwise (true) or counter-clockwise (false).
fillClockwise = nil 
--*
--[Comment]
-- property: Int32 Image.fillOrigin	get	set	
--Controls the origin point of the Fill process. Value means different things with each fill method.
fillOrigin = nil 
--*
--[Comment]
-- property: Single Image.alphaHitTestMinimumThreshold	get	set	
--The alpha threshold specifies the minimum alpha a pixel must have for the event to considered a "hit" on the Image.
alphaHitTestMinimumThreshold = nil 
--*
--[Comment]
-- property: Material Image.defaultETC1GraphicMaterial	get	
--Cache of the default Cavas ETC1 + alpha material.
defaultETC1GraphicMaterial = nil 
--*
--[Comment]
-- property: Texture Image.mainTexture	get	
--The image's texture. (ReadOnly).
mainTexture = nil 
--*
--[Comment]
-- property: Boolean Image.hasBorder	get	
--True if the sprite used has borders.
hasBorder = nil 
--*
--[Comment]
-- property: Single Image.pixelsPerUnit	get	
pixelsPerUnit = nil 
--*
--[Comment]
-- property: Material Image.material	get	set	
--The material used by this Image. If a material is specified it is used, otherwise the default material is used.
material = nil 
--*
--[Comment]
-- property: Single Image.minWidth	get	
--See ILayoutElement.minWidth.
minWidth = nil 
--*
--[Comment]
-- property: Single Image.preferredWidth	get	
--See ILayoutElement.preferredWidth.
preferredWidth = nil 
--*
--[Comment]
-- property: Single Image.flexibleWidth	get	
--See ILayoutElement.flexibleWidth.
flexibleWidth = nil 
--*
--[Comment]
-- property: Single Image.minHeight	get	
--See ILayoutElement.minHeight.
minHeight = nil 
--*
--[Comment]
-- property: Single Image.preferredHeight	get	
--See ILayoutElement.preferredHeight.
preferredHeight = nil 
--*
--[Comment]
-- property: Single Image.flexibleHeight	get	
--See ILayoutElement.flexibleHeight.
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 Image.layoutPriority	get	
--See ILayoutElement.layoutPriority.
layoutPriority = nil 
--*
--[Comment]
-- property: CullStateChangedEvent Image.onCullStateChanged	get	set	
onCullStateChanged = nil 
--*
--[Comment]
-- property: Boolean Image.maskable	get	set	
maskable = nil 
--*
--[Comment]
-- property: Color Image.color	get	set	
color = nil 
--*
--[Comment]
-- property: Boolean Image.raycastTarget	get	set	
raycastTarget = nil 
--*
--[Comment]
-- property: Int32 Image.depth	get	
depth = nil 
--*
--[Comment]
-- property: RectTransform Image.rectTransform	get	
rectTransform = nil 
--*
--[Comment]
-- property: Canvas Image.canvas	get	
canvas = nil 
--*
--[Comment]
-- property: CanvasRenderer Image.canvasRenderer	get	
canvasRenderer = nil 
--*
--[Comment]
-- property: Material Image.defaultMaterial	get	
defaultMaterial = nil 
--*
--[Comment]
-- property: Material Image.materialForRendering	get	
materialForRendering = nil 
--*
--[Comment]
-- property: Boolean Image.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Image.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Image.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Image.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Image.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Image.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Image.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Image.hideFlags	get	set	
hideFlags = nil 
--*
----Void Image:OnBeforeSerialize()
function OnBeforeSerialize() end 

----Void Image:OnAfterDeserialize()
function OnAfterDeserialize() end 

----Void Image:SetNativeSize()
function SetNativeSize() end 

----Void Image:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void Image:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

----Boolean Image:IsRaycastLocationValid(Vector2 screenPoint,Camera eventCamera)
function IsRaycastLocationValid() end 

Text = {} 
--*
--[Comment]
-- property: TextGenerator Text.cachedTextGenerator	get	
--The cached TextGenerator used when generating visible Text.
cachedTextGenerator = nil 
--*
--[Comment]
-- property: TextGenerator Text.cachedTextGeneratorForLayout	get	
--The cached TextGenerator used when determine Layout.
cachedTextGeneratorForLayout = nil 
--*
--[Comment]
-- property: Texture Text.mainTexture	get	
--The Texture that comes from the Font.
mainTexture = nil 
--*
--[Comment]
-- property: Font Text.font	get	set	
--The Font used by the text.
font = nil 
--*
--[Comment]
-- property: String Text.text	get	set	
--The string value this text will display.
text = nil 
--*
--[Comment]
-- property: Boolean Text.supportRichText	get	set	
--Whether this Text will support rich text.
supportRichText = nil 
--*
--[Comment]
-- property: Boolean Text.resizeTextForBestFit	get	set	
--Should the text be allowed to auto resized.
resizeTextForBestFit = nil 
--*
--[Comment]
-- property: Int32 Text.resizeTextMinSize	get	set	
--The minimum size the text is allowed to be.
resizeTextMinSize = nil 
--*
--[Comment]
-- property: Int32 Text.resizeTextMaxSize	get	set	
--The maximum size the text is allowed to be. 1 = infinitly large.
resizeTextMaxSize = nil 
--*
--[Comment]
-- property: TextAnchor Text.alignment	get	set	
--The positioning of the text reliative to its RectTransform.
alignment = nil 
--*
--[Comment]
-- property: Boolean Text.alignByGeometry	get	set	
--Use the extents of glyph geometry to perform horizontal alignment rather than glyph metrics.
alignByGeometry = nil 
--*
--[Comment]
-- property: Int32 Text.fontSize	get	set	
--The size that the Font should render at.
fontSize = nil 
--*
--[Comment]
-- property: HorizontalWrapMode Text.horizontalOverflow	get	set	
--Horizontal overflow mode.
horizontalOverflow = nil 
--*
--[Comment]
-- property: VerticalWrapMode Text.verticalOverflow	get	set	
--Vertical overflow mode.
verticalOverflow = nil 
--*
--[Comment]
-- property: Single Text.lineSpacing	get	set	
--Line spacing, specified as a factor of font line height. A value of 1 will produce normal line spacing.
lineSpacing = nil 
--*
--[Comment]
-- property: FontStyle Text.fontStyle	get	set	
--FontStyle used by the text.
fontStyle = nil 
--*
--[Comment]
-- property: Single Text.pixelsPerUnit	get	
--(Read Only) Provides information about how fonts are scale to the screen.
pixelsPerUnit = nil 
--*
--[Comment]
-- property: Single Text.minWidth	get	
--Called by the layout system.
minWidth = nil 
--*
--[Comment]
-- property: Single Text.preferredWidth	get	
--Called by the layout system.
preferredWidth = nil 
--*
--[Comment]
-- property: Single Text.flexibleWidth	get	
--Called by the layout system.
flexibleWidth = nil 
--*
--[Comment]
-- property: Single Text.minHeight	get	
--Called by the layout system.
minHeight = nil 
--*
--[Comment]
-- property: Single Text.preferredHeight	get	
--Called by the layout system.
preferredHeight = nil 
--*
--[Comment]
-- property: Single Text.flexibleHeight	get	
--Called by the layout system.
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 Text.layoutPriority	get	
--Called by the layout system.
layoutPriority = nil 
--*
--[Comment]
-- property: CullStateChangedEvent Text.onCullStateChanged	get	set	
onCullStateChanged = nil 
--*
--[Comment]
-- property: Boolean Text.maskable	get	set	
maskable = nil 
--*
--[Comment]
-- property: Color Text.color	get	set	
color = nil 
--*
--[Comment]
-- property: Boolean Text.raycastTarget	get	set	
raycastTarget = nil 
--*
--[Comment]
-- property: Int32 Text.depth	get	
depth = nil 
--*
--[Comment]
-- property: RectTransform Text.rectTransform	get	
rectTransform = nil 
--*
--[Comment]
-- property: Canvas Text.canvas	get	
canvas = nil 
--*
--[Comment]
-- property: CanvasRenderer Text.canvasRenderer	get	
canvasRenderer = nil 
--*
--[Comment]
-- property: Material Text.defaultMaterial	get	
defaultMaterial = nil 
--*
--[Comment]
-- property: Material Text.material	get	set	
material = nil 
--*
--[Comment]
-- property: Material Text.materialForRendering	get	
materialForRendering = nil 
--*
--[Comment]
-- property: Boolean Text.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Text.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Text.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Text.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Text.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Text.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Text.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Text.hideFlags	get	set	
hideFlags = nil 
--*
----Void Text:FontTextureChanged()
function FontTextureChanged() end 

----TextGenerationSettings Text:GetGenerationSettings(Vector2 extents)
function GetGenerationSettings() end 

----Vector2 Text.GetTextAnchorPivot(TextAnchor anchor)
function Text.GetTextAnchorPivot() end 

----Void Text:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void Text:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

----Void Text:OnRebuildRequested()
function OnRebuildRequested() end 

Sprite = {} 
--*
--[Comment]
--consturctor for Sprite overrides:
--*
--Sprite.New()
--*

function Sprite.New() end
--*
--[Comment]
-- property: Bounds Sprite.bounds	get	
--Bounds of the Sprite, specified by its center and extents in world space units.
bounds = nil 
--*
--[Comment]
-- property: Rect Sprite.rect	get	
--Location of the Sprite on the original Texture, specified in pixels.
rect = nil 
--*
--[Comment]
-- property: Single Sprite.pixelsPerUnit	get	
--The number of pixels in the sprite that correspond to one unit in world space. (Read Only)
pixelsPerUnit = nil 
--*
--[Comment]
-- property: Texture2D Sprite.texture	get	
--Get the reference to the used texture. If packed this will point to the atlas, if not packed will point to the source sprite.
texture = nil 
--*
--[Comment]
-- property: Texture2D Sprite.associatedAlphaSplitTexture	get	
--Returns the texture that contains the alpha channel from the source texture. Unity generates this texture under the hood for sprites that have alpha in the source, and need to be compressed using techniques like ETC1.  Returns NULL if there is no associated alpha texture for the source sprite. This is the case if the sprite has not been setup to use ETC1 compression.
associatedAlphaSplitTexture = nil 
--*
--[Comment]
-- property: Rect Sprite.textureRect	get	
--Get the rectangle this sprite uses on its texture. Raises an exception if this sprite is tightly packed in an atlas.
textureRect = nil 
--*
--[Comment]
-- property: Vector2 Sprite.textureRectOffset	get	
--Gets the offset of the rectangle this sprite uses on its texture to the original sprite bounds. If sprite mesh type is FullRect, offset is zero.
textureRectOffset = nil 
--*
--[Comment]
-- property: Boolean Sprite.packed	get	
--Returns true if this Sprite is packed in an atlas.
packed = nil 
--*
--[Comment]
-- property: SpritePackingMode Sprite.packingMode	get	
--If Sprite is packed (see Sprite.packed), returns its SpritePackingMode.
packingMode = nil 
--*
--[Comment]
-- property: SpritePackingRotation Sprite.packingRotation	get	
--If Sprite is packed (see Sprite.packed), returns its SpritePackingRotation.
packingRotation = nil 
--*
--[Comment]
-- property: Vector2 Sprite.pivot	get	
--Location of the Sprite's center point in the Rect on the original Texture, specified in pixels.
pivot = nil 
--*
--[Comment]
-- property: Vector4 Sprite.border	get	
--Returns the border sizes of the sprite.
border = nil 
--*
--[Comment]
-- property: Vector2[] Sprite.vertices	get	
--Returns a copy of the array containing sprite mesh vertex positions.
vertices = nil 
--*
--[Comment]
-- property: UInt16[] Sprite.triangles	get	
--Returns a copy of the array containing sprite mesh triangles.
triangles = nil 
--*
--[Comment]
-- property: Vector2[] Sprite.uv	get	
--The base texture coordinates of the sprite mesh.
uv = nil 
--*
--[Comment]
-- property: String Sprite.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Sprite.hideFlags	get	set	
hideFlags = nil 
--*
----Sprite Sprite.Create(Texture2D texture,Rect rect,Vector2 pivot,Single pixelsPerUnit,UInt32 extrude,SpriteMeshType meshType,Vector4 border)
--Sprite Sprite.Create(Texture2D texture,Rect rect,Vector2 pivot,Single pixelsPerUnit,UInt32 extrude,SpriteMeshType meshType)
--Sprite Sprite.Create(Texture2D texture,Rect rect,Vector2 pivot,Single pixelsPerUnit,UInt32 extrude)
--Sprite Sprite.Create(Texture2D texture,Rect rect,Vector2 pivot,Single pixelsPerUnit)
--Sprite Sprite.Create(Texture2D texture,Rect rect,Vector2 pivot)
function Sprite.Create() end 

----Void Sprite:OverrideGeometry(Vector2[] vertices,UInt16[] triangles)
function OverrideGeometry() end 

Toggle = {} 
--*
--[Comment]
-- property: ToggleGroup Toggle.group	get	set	
--Group the toggle belongs to.
group = nil 
--*
--[Comment]
-- property: Boolean Toggle.isOn	get	set	
--Is the toggle on.
isOn = nil 
--*
--[Comment]
-- property: Navigation Toggle.navigation	get	set	
navigation = nil 
--*
--[Comment]
-- property: Transition Toggle.transition	get	set	
transition = nil 
--*
--[Comment]
-- property: ColorBlock Toggle.colors	get	set	
colors = nil 
--*
--[Comment]
-- property: SpriteState Toggle.spriteState	get	set	
spriteState = nil 
--*
--[Comment]
-- property: AnimationTriggers Toggle.animationTriggers	get	set	
animationTriggers = nil 
--*
--[Comment]
-- property: Graphic Toggle.targetGraphic	get	set	
targetGraphic = nil 
--*
--[Comment]
-- property: Boolean Toggle.interactable	get	set	
interactable = nil 
--*
--[Comment]
-- property: Image Toggle.image	get	set	
image = nil 
--*
--[Comment]
-- property: Animator Toggle.animator	get	
animator = nil 
--*
--[Comment]
-- property: Boolean Toggle.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Toggle.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Toggle.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Toggle.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Toggle.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Toggle.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Toggle.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Toggle.hideFlags	get	set	
hideFlags = nil 
--*
----Void Toggle:Rebuild(CanvasUpdate executing)
function Rebuild() end 

----Void Toggle:LayoutComplete()
function LayoutComplete() end 

----Void Toggle:GraphicUpdateComplete()
function GraphicUpdateComplete() end 

----Void Toggle:OnPointerClick(PointerEventData eventData)
function OnPointerClick() end 

----Void Toggle:OnSubmit(BaseEventData eventData)
function OnSubmit() end 

ToggleGroup = {} 
--*
--[Comment]
-- property: Boolean ToggleGroup.allowSwitchOff	get	set	
--Is it allowed that no toggle is switched on?
allowSwitchOff = nil 
--*
--[Comment]
-- property: Boolean ToggleGroup.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean ToggleGroup.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean ToggleGroup.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform ToggleGroup.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject ToggleGroup.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String ToggleGroup.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String ToggleGroup.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags ToggleGroup.hideFlags	get	set	
hideFlags = nil 
--*
----Void ToggleGroup:NotifyToggleOn(Toggle toggle)
function NotifyToggleOn() end 

----Void ToggleGroup:UnregisterToggle(Toggle toggle)
function UnregisterToggle() end 

----Void ToggleGroup:RegisterToggle(Toggle toggle)
function RegisterToggle() end 

----Boolean ToggleGroup:AnyTogglesOn()
function AnyTogglesOn() end 

----IEnumerable`1 ToggleGroup:ActiveToggles()
function ActiveToggles() end 

----Void ToggleGroup:SetAllTogglesOff()
function SetAllTogglesOff() end 

InputField = {} 
--*
--[Comment]
-- property: Boolean InputField.shouldHideMobileInput	get	set	
--Should the mobile keyboard input be hidden.
shouldHideMobileInput = nil 
--*
--[Comment]
-- property: String InputField.text	get	set	
--The current value of the input field.
text = nil 
--*
--[Comment]
-- property: Boolean InputField.isFocused	get	
--Does the InputField currently have focus and is able to process events.
isFocused = nil 
--*
--[Comment]
-- property: Single InputField.caretBlinkRate	get	set	
--The blinking rate of the input caret, defined as the number of times the blink cycle occurs per second.
caretBlinkRate = nil 
--*
--[Comment]
-- property: Int32 InputField.caretWidth	get	set	
--The width of the caret in pixels.
caretWidth = nil 
--*
--[Comment]
-- property: Text InputField.textComponent	get	set	
--The Text component that is going to be used to render the text to screen.
textComponent = nil 
--*
--[Comment]
-- property: Graphic InputField.placeholder	get	set	
--This is an optional ‘empty’ graphic to show that InputField text field is empty. Note that this ‘empty' graphic still displays even when the InputField is selected (that is; when there is focus on it).  A placeholder graphic can be used to show subtle hints or make it more obvious that the control is an InputField.
placeholder = nil 
--*
--[Comment]
-- property: Color InputField.caretColor	get	set	
--The custom caret color used if customCaretColor is set.
caretColor = nil 
--*
--[Comment]
-- property: Boolean InputField.customCaretColor	get	set	
--Should a custom caret color be used or should the textComponent.color be used.
customCaretColor = nil 
--*
--[Comment]
-- property: Color InputField.selectionColor	get	set	
--The color of the highlight to show which characters are selected.
selectionColor = nil 
--*
--[Comment]
-- property: SubmitEvent InputField.onEndEdit	get	set	
--The Unity Event to call when editing has ended.
onEndEdit = nil 
--*
--[Comment]
-- property: OnChangeEvent InputField.onValueChanged	get	set	
--Accessor to the OnChangeEvent.
onValueChanged = nil 
--*
--[Comment]
-- property: OnValidateInput InputField.onValidateInput	get	set	
--The function to call to validate the input characters.
onValidateInput = nil 
--*
--[Comment]
-- property: Int32 InputField.characterLimit	get	set	
--How many characters the input field is limited to. 0 = infinite.
characterLimit = nil 
--*
--[Comment]
-- property: ContentType InputField.contentType	get	set	
--Specifies the type of the input text content.
contentType = nil 
--*
--[Comment]
-- property: LineType InputField.lineType	get	set	
--The LineType used by the InputField.
lineType = nil 
--*
--[Comment]
-- property: InputType InputField.inputType	get	set	
--The type of input expected. See InputField.InputType.
inputType = nil 
--*
--[Comment]
-- property: TouchScreenKeyboardType InputField.keyboardType	get	set	
--They type of mobile keyboard that will be used.
keyboardType = nil 
--*
--[Comment]
-- property: CharacterValidation InputField.characterValidation	get	set	
--The type of validation to perform on a character.
characterValidation = nil 
--*
--[Comment]
-- property: Boolean InputField.readOnly	get	set	
--Set the InputField to be read only.
readOnly = nil 
--*
--[Comment]
-- property: Boolean InputField.multiLine	get	
--If the input field supports multiple lines.
multiLine = nil 
--*
--[Comment]
-- property: Char InputField.asteriskChar	get	set	
--The character used for password fields.
asteriskChar = nil 
--*
--[Comment]
-- property: Boolean InputField.wasCanceled	get	
--If the UI.InputField was canceled and will revert back to the original text upon DeactivateInputField.
wasCanceled = nil 
--*
--[Comment]
-- property: Int32 InputField.caretPosition	get	set	
--Current InputField caret position (also selection tail).
caretPosition = nil 
--*
--[Comment]
-- property: Int32 InputField.selectionAnchorPosition	get	set	
--The beginning point of the selection.
selectionAnchorPosition = nil 
--*
--[Comment]
-- property: Int32 InputField.selectionFocusPosition	get	set	
--The the end point of the selection.
selectionFocusPosition = nil 
--*
--[Comment]
-- property: Navigation InputField.navigation	get	set	
navigation = nil 
--*
--[Comment]
-- property: Transition InputField.transition	get	set	
transition = nil 
--*
--[Comment]
-- property: ColorBlock InputField.colors	get	set	
colors = nil 
--*
--[Comment]
-- property: SpriteState InputField.spriteState	get	set	
spriteState = nil 
--*
--[Comment]
-- property: AnimationTriggers InputField.animationTriggers	get	set	
animationTriggers = nil 
--*
--[Comment]
-- property: Graphic InputField.targetGraphic	get	set	
targetGraphic = nil 
--*
--[Comment]
-- property: Boolean InputField.interactable	get	set	
interactable = nil 
--*
--[Comment]
-- property: Image InputField.image	get	set	
image = nil 
--*
--[Comment]
-- property: Animator InputField.animator	get	
animator = nil 
--*
--[Comment]
-- property: Boolean InputField.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean InputField.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean InputField.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform InputField.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject InputField.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String InputField.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String InputField.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags InputField.hideFlags	get	set	
hideFlags = nil 
--*
----Void InputField:MoveTextEnd(Boolean shift)
function MoveTextEnd() end 

----Void InputField:MoveTextStart(Boolean shift)
function MoveTextStart() end 

----Void InputField:OnBeginDrag(PointerEventData eventData)
function OnBeginDrag() end 

----Void InputField:OnDrag(PointerEventData eventData)
function OnDrag() end 

----Void InputField:OnEndDrag(PointerEventData eventData)
function OnEndDrag() end 

----Void InputField:OnPointerDown(PointerEventData eventData)
function OnPointerDown() end 

----Void InputField:ProcessEvent(Event e)
function ProcessEvent() end 

----Void InputField:OnUpdateSelected(BaseEventData eventData)
function OnUpdateSelected() end 

----Void InputField:ForceLabelUpdate()
function ForceLabelUpdate() end 

----Void InputField:Rebuild(CanvasUpdate update)
function Rebuild() end 

----Void InputField:LayoutComplete()
function LayoutComplete() end 

----Void InputField:GraphicUpdateComplete()
function GraphicUpdateComplete() end 

----Void InputField:ActivateInputField()
function ActivateInputField() end 

----Void InputField:OnSelect(BaseEventData eventData)
function OnSelect() end 

----Void InputField:OnPointerClick(PointerEventData eventData)
function OnPointerClick() end 

----Void InputField:DeactivateInputField()
function DeactivateInputField() end 

----Void InputField:OnDeselect(BaseEventData eventData)
function OnDeselect() end 

----Void InputField:OnSubmit(BaseEventData eventData)
function OnSubmit() end 

Rect = {} 
--*
--[Comment]
--consturctor for Rect overrides:
--*
--Rect.New(Single x,Single y,Single width,Single height)
--Creates a new rectangle.
--params:
--x:    The X value the rect is measured from.
--y:    The Y value the rect is measured from.
--width:    The width of the rectangle.
--height:    The height of the rectangle.

--*

--Rect.New(Vector2 position,Vector2 size)
--Creates a rectangle given a size and position.
--params:
--position:    The position of the minimum corner of the rect.
--size:    The width and height of the rect.

--*

--Rect.New(Rect source)
--*

function Rect.New() end
--*
--[Comment]
-- property: Single Rect.x	get	set	
--The X coordinate of the rectangle.
x = nil 
--*
--[Comment]
-- property: Single Rect.y	get	set	
--The Y coordinate of the rectangle.
y = nil 
--*
--[Comment]
-- property: Vector2 Rect.position	get	set	
--The X and Y position of the rectangle.
position = nil 
--*
--[Comment]
-- property: Vector2 Rect.center	get	set	
--The position of the center of the rectangle.
center = nil 
--*
--[Comment]
-- property: Vector2 Rect.min	get	set	
--The position of the minimum corner of the rectangle.
min = nil 
--*
--[Comment]
-- property: Vector2 Rect.max	get	set	
--The position of the maximum corner of the rectangle.
max = nil 
--*
--[Comment]
-- property: Single Rect.width	get	set	
--The width of the rectangle, measured from the X position.
width = nil 
--*
--[Comment]
-- property: Single Rect.height	get	set	
--The height of the rectangle, measured from the Y position.
height = nil 
--*
--[Comment]
-- property: Vector2 Rect.size	get	set	
--The width and height of the rectangle.
size = nil 
--*
--[Comment]
-- property: Single Rect.xMin	get	set	
--The minimum X coordinate of the rectangle.
xMin = nil 
--*
--[Comment]
-- property: Single Rect.yMin	get	set	
--The minimum Y coordinate of the rectangle.
yMin = nil 
--*
--[Comment]
-- property: Single Rect.xMax	get	set	
--The maximum X coordinate of the rectangle.
xMax = nil 
--*
--[Comment]
-- property: Single Rect.yMax	get	set	
--The maximum Y coordinate of the rectangle.
yMax = nil 
--*
----Rect Rect.MinMaxRect(Single xmin,Single ymin,Single xmax,Single ymax)
function Rect.MinMaxRect() end 

----Void Rect:Set(Single x,Single y,Single width,Single height)
function Set() end 

----String Rect:ToString()
--String Rect:ToString(String format)
function ToString() end 

----Boolean Rect:Contains(Vector2 point)
--Boolean Rect:Contains(Vector3 point)
--Boolean Rect:Contains(Vector3 point,Boolean allowInverse)
function Contains() end 

----Boolean Rect:Overlaps(Rect other)
--Boolean Rect:Overlaps(Rect other,Boolean allowInverse)
function Overlaps() end 

----Vector2 Rect.NormalizedToPoint(Rect rectangle,Vector2 normalizedRectCoordinates)
function Rect.NormalizedToPoint() end 

----Vector2 Rect.PointToNormalized(Rect rectangle,Vector2 point)
function Rect.PointToNormalized() end 

----Int32 Rect:GetHashCode()
function GetHashCode() end 

----Boolean Rect:Equals(Object other)
function Equals() end 

----Boolean Rect.op_Inequality(Rect lhs,Rect rhs)
function Rect.op_Inequality() end 

----Boolean Rect.op_Equality(Rect lhs,Rect rhs)
function Rect.op_Equality() end 

LayoutGroup = {} 
--*
--[Comment]
-- property: RectOffset LayoutGroup.padding	get	set	
--The padding to add around the child layout elements.
padding = nil 
--*
--[Comment]
-- property: TextAnchor LayoutGroup.childAlignment	get	set	
--The alignment to use for the child layout elements in the layout group.
childAlignment = nil 
--*
--[Comment]
-- property: Single LayoutGroup.minWidth	get	
--Called by the layout system.
minWidth = nil 
--*
--[Comment]
-- property: Single LayoutGroup.preferredWidth	get	
--Called by the layout system.
preferredWidth = nil 
--*
--[Comment]
-- property: Single LayoutGroup.flexibleWidth	get	
--Called by the layout system.
flexibleWidth = nil 
--*
--[Comment]
-- property: Single LayoutGroup.minHeight	get	
--Called by the layout system.
minHeight = nil 
--*
--[Comment]
-- property: Single LayoutGroup.preferredHeight	get	
--Called by the layout system.
preferredHeight = nil 
--*
--[Comment]
-- property: Single LayoutGroup.flexibleHeight	get	
--Called by the layout system.
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 LayoutGroup.layoutPriority	get	
--Called by the layout system.
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean LayoutGroup.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean LayoutGroup.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean LayoutGroup.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform LayoutGroup.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject LayoutGroup.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String LayoutGroup.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String LayoutGroup.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags LayoutGroup.hideFlags	get	set	
hideFlags = nil 
--*
----Void LayoutGroup:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void LayoutGroup:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

----Void LayoutGroup:SetLayoutHorizontal()
function SetLayoutHorizontal() end 

----Void LayoutGroup:SetLayoutVertical()
function SetLayoutVertical() end 

HorizontalOrVerticalLayoutGroup = {} 
--*
--[Comment]
-- property: Single HorizontalOrVerticalLayoutGroup.spacing	get	set	
--The spacing to use between layout elements in the layout group.
spacing = nil 
--*
--[Comment]
-- property: Boolean HorizontalOrVerticalLayoutGroup.childForceExpandWidth	get	set	
--Whether to force the children to expand to fill additional available horizontal space.
childForceExpandWidth = nil 
--*
--[Comment]
-- property: Boolean HorizontalOrVerticalLayoutGroup.childForceExpandHeight	get	set	
--Whether to force the children to expand to fill additional available vertical space.
childForceExpandHeight = nil 
--*
--[Comment]
-- property: RectOffset HorizontalOrVerticalLayoutGroup.padding	get	set	
padding = nil 
--*
--[Comment]
-- property: TextAnchor HorizontalOrVerticalLayoutGroup.childAlignment	get	set	
childAlignment = nil 
--*
--[Comment]
-- property: Single HorizontalOrVerticalLayoutGroup.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Single HorizontalOrVerticalLayoutGroup.preferredWidth	get	
preferredWidth = nil 
--*
--[Comment]
-- property: Single HorizontalOrVerticalLayoutGroup.flexibleWidth	get	
flexibleWidth = nil 
--*
--[Comment]
-- property: Single HorizontalOrVerticalLayoutGroup.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Single HorizontalOrVerticalLayoutGroup.preferredHeight	get	
preferredHeight = nil 
--*
--[Comment]
-- property: Single HorizontalOrVerticalLayoutGroup.flexibleHeight	get	
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 HorizontalOrVerticalLayoutGroup.layoutPriority	get	
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean HorizontalOrVerticalLayoutGroup.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean HorizontalOrVerticalLayoutGroup.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean HorizontalOrVerticalLayoutGroup.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform HorizontalOrVerticalLayoutGroup.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject HorizontalOrVerticalLayoutGroup.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String HorizontalOrVerticalLayoutGroup.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String HorizontalOrVerticalLayoutGroup.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags HorizontalOrVerticalLayoutGroup.hideFlags	get	set	
hideFlags = nil 
--*
VerticalLayoutGroup = {} 
--*
--[Comment]
-- property: Single VerticalLayoutGroup.spacing	get	set	
spacing = nil 
--*
--[Comment]
-- property: Boolean VerticalLayoutGroup.childForceExpandWidth	get	set	
childForceExpandWidth = nil 
--*
--[Comment]
-- property: Boolean VerticalLayoutGroup.childForceExpandHeight	get	set	
childForceExpandHeight = nil 
--*
--[Comment]
-- property: RectOffset VerticalLayoutGroup.padding	get	set	
padding = nil 
--*
--[Comment]
-- property: TextAnchor VerticalLayoutGroup.childAlignment	get	set	
childAlignment = nil 
--*
--[Comment]
-- property: Single VerticalLayoutGroup.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Single VerticalLayoutGroup.preferredWidth	get	
preferredWidth = nil 
--*
--[Comment]
-- property: Single VerticalLayoutGroup.flexibleWidth	get	
flexibleWidth = nil 
--*
--[Comment]
-- property: Single VerticalLayoutGroup.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Single VerticalLayoutGroup.preferredHeight	get	
preferredHeight = nil 
--*
--[Comment]
-- property: Single VerticalLayoutGroup.flexibleHeight	get	
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 VerticalLayoutGroup.layoutPriority	get	
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean VerticalLayoutGroup.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean VerticalLayoutGroup.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean VerticalLayoutGroup.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform VerticalLayoutGroup.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject VerticalLayoutGroup.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String VerticalLayoutGroup.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String VerticalLayoutGroup.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags VerticalLayoutGroup.hideFlags	get	set	
hideFlags = nil 
--*
----Void VerticalLayoutGroup:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void VerticalLayoutGroup:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

----Void VerticalLayoutGroup:SetLayoutHorizontal()
function SetLayoutHorizontal() end 

----Void VerticalLayoutGroup:SetLayoutVertical()
function SetLayoutVertical() end 

HorizontalLayoutGroup = {} 
--*
--[Comment]
-- property: Single HorizontalLayoutGroup.spacing	get	set	
spacing = nil 
--*
--[Comment]
-- property: Boolean HorizontalLayoutGroup.childForceExpandWidth	get	set	
childForceExpandWidth = nil 
--*
--[Comment]
-- property: Boolean HorizontalLayoutGroup.childForceExpandHeight	get	set	
childForceExpandHeight = nil 
--*
--[Comment]
-- property: RectOffset HorizontalLayoutGroup.padding	get	set	
padding = nil 
--*
--[Comment]
-- property: TextAnchor HorizontalLayoutGroup.childAlignment	get	set	
childAlignment = nil 
--*
--[Comment]
-- property: Single HorizontalLayoutGroup.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Single HorizontalLayoutGroup.preferredWidth	get	
preferredWidth = nil 
--*
--[Comment]
-- property: Single HorizontalLayoutGroup.flexibleWidth	get	
flexibleWidth = nil 
--*
--[Comment]
-- property: Single HorizontalLayoutGroup.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Single HorizontalLayoutGroup.preferredHeight	get	
preferredHeight = nil 
--*
--[Comment]
-- property: Single HorizontalLayoutGroup.flexibleHeight	get	
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 HorizontalLayoutGroup.layoutPriority	get	
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean HorizontalLayoutGroup.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean HorizontalLayoutGroup.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean HorizontalLayoutGroup.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform HorizontalLayoutGroup.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject HorizontalLayoutGroup.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String HorizontalLayoutGroup.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String HorizontalLayoutGroup.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags HorizontalLayoutGroup.hideFlags	get	set	
hideFlags = nil 
--*
----Void HorizontalLayoutGroup:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void HorizontalLayoutGroup:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

----Void HorizontalLayoutGroup:SetLayoutHorizontal()
function SetLayoutHorizontal() end 

----Void HorizontalLayoutGroup:SetLayoutVertical()
function SetLayoutVertical() end 

ContentSizeFitter = {} 
--*
--[Comment]
-- property: FitMode ContentSizeFitter.horizontalFit	get	set	
--The fit mode to use to determine the width.
horizontalFit = nil 
--*
--[Comment]
-- property: FitMode ContentSizeFitter.verticalFit	get	set	
--The fit mode to use to determine the height.
verticalFit = nil 
--*
--[Comment]
-- property: Boolean ContentSizeFitter.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean ContentSizeFitter.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean ContentSizeFitter.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform ContentSizeFitter.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject ContentSizeFitter.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String ContentSizeFitter.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String ContentSizeFitter.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags ContentSizeFitter.hideFlags	get	set	
hideFlags = nil 
--*
----Void ContentSizeFitter:SetLayoutHorizontal()
function SetLayoutHorizontal() end 

----Void ContentSizeFitter:SetLayoutVertical()
function SetLayoutVertical() end 

Dropdown = {} 
--*
--[Comment]
-- property: RectTransform Dropdown.template	get	set	
--The Rect Transform of the template for the dropdown list.
template = nil 
--*
--[Comment]
-- property: Text Dropdown.captionText	get	set	
--The Text component to hold the text of the currently selected option.
captionText = nil 
--*
--[Comment]
-- property: Image Dropdown.captionImage	get	set	
--The Image component to hold the image of the currently selected option.
captionImage = nil 
--*
--[Comment]
-- property: Text Dropdown.itemText	get	set	
--The Text component to hold the text of the item.
itemText = nil 
--*
--[Comment]
-- property: Image Dropdown.itemImage	get	set	
--The Image component to hold the image of the item.
itemImage = nil 
--*
--[Comment]
-- property: List`1 Dropdown.options	get	set	
--The list of possible options. A text string and an image can be specified for each option.
options = nil 
--*
--[Comment]
-- property: DropdownEvent Dropdown.onValueChanged	get	set	
--A UnityEvent that is invoked when when a user has clicked one of the options in the dropdown list.
onValueChanged = nil 
--*
--[Comment]
-- property: Int32 Dropdown.value	get	set	
--The index of the currently selected option. 0 is the first option, 1 is the second, and so on.
value = nil 
--*
--[Comment]
-- property: Navigation Dropdown.navigation	get	set	
navigation = nil 
--*
--[Comment]
-- property: Transition Dropdown.transition	get	set	
transition = nil 
--*
--[Comment]
-- property: ColorBlock Dropdown.colors	get	set	
colors = nil 
--*
--[Comment]
-- property: SpriteState Dropdown.spriteState	get	set	
spriteState = nil 
--*
--[Comment]
-- property: AnimationTriggers Dropdown.animationTriggers	get	set	
animationTriggers = nil 
--*
--[Comment]
-- property: Graphic Dropdown.targetGraphic	get	set	
targetGraphic = nil 
--*
--[Comment]
-- property: Boolean Dropdown.interactable	get	set	
interactable = nil 
--*
--[Comment]
-- property: Image Dropdown.image	get	set	
image = nil 
--*
--[Comment]
-- property: Animator Dropdown.animator	get	
animator = nil 
--*
--[Comment]
-- property: Boolean Dropdown.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Dropdown.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Dropdown.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Dropdown.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Dropdown.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Dropdown.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Dropdown.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Dropdown.hideFlags	get	set	
hideFlags = nil 
--*
----Void Dropdown:RefreshShownValue()
function RefreshShownValue() end 

----Void Dropdown:AddOptions(List`1 options)
--Void Dropdown:AddOptions(List`1 options)
--Void Dropdown:AddOptions(List`1 options)
function AddOptions() end 

----Void Dropdown:ClearOptions()
function ClearOptions() end 

----Void Dropdown:OnPointerClick(PointerEventData eventData)
function OnPointerClick() end 

----Void Dropdown:OnSubmit(BaseEventData eventData)
function OnSubmit() end 

----Void Dropdown:OnCancel(BaseEventData eventData)
function OnCancel() end 

----Void Dropdown:Show()
function Show() end 

----Void Dropdown:Hide()
function Hide() end 

Mask = {} 
--*
--[Comment]
-- property: RectTransform Mask.rectTransform	get	
--Cached RectTransform.
rectTransform = nil 
--*
--[Comment]
-- property: Boolean Mask.showMaskGraphic	get	set	
--Show the graphic that is associated with the Mask render area.
showMaskGraphic = nil 
--*
--[Comment]
-- property: Graphic Mask.graphic	get	
--The graphic associated with the Mask.
graphic = nil 
--*
--[Comment]
-- property: Boolean Mask.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Mask.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Mask.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Mask.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Mask.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Mask.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Mask.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Mask.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean Mask:MaskEnabled()
function MaskEnabled() end 

----Boolean Mask:IsRaycastLocationValid(Vector2 sp,Camera eventCamera)
function IsRaycastLocationValid() end 

----Material Mask:GetModifiedMaterial(Material baseMaterial)
function GetModifiedMaterial() end 

RectMask2D = {} 
--*
--[Comment]
-- property: Rect RectMask2D.canvasRect	get	
--Get the Rect for the mask in canvas space.
canvasRect = nil 
--*
--[Comment]
-- property: RectTransform RectMask2D.rectTransform	get	
--Get the RectTransform for the mask.
rectTransform = nil 
--*
--[Comment]
-- property: Boolean RectMask2D.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean RectMask2D.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean RectMask2D.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform RectMask2D.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject RectMask2D.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String RectMask2D.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String RectMask2D.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags RectMask2D.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean RectMask2D:IsRaycastLocationValid(Vector2 sp,Camera eventCamera)
function IsRaycastLocationValid() end 

----Void RectMask2D:PerformClipping()
function PerformClipping() end 

----Void RectMask2D:AddClippable(IClippable clippable)
function AddClippable() end 

----Void RectMask2D:RemoveClippable(IClippable clippable)
function RemoveClippable() end 

LayoutElement = {} 
--*
--[Comment]
-- property: Boolean LayoutElement.ignoreLayout	get	set	
--Should this RectTransform be ignored by the layout system?
ignoreLayout = nil 
--*
--[Comment]
-- property: Single LayoutElement.minWidth	get	set	
--The minimum width this layout element may be allocated.
minWidth = nil 
--*
--[Comment]
-- property: Single LayoutElement.minHeight	get	set	
--The minimum height this layout element may be allocated.
minHeight = nil 
--*
--[Comment]
-- property: Single LayoutElement.preferredWidth	get	set	
--The preferred width this layout element should be allocated if there is sufficient space.
preferredWidth = nil 
--*
--[Comment]
-- property: Single LayoutElement.preferredHeight	get	set	
--The preferred height this layout element should be allocated if there is sufficient space.
preferredHeight = nil 
--*
--[Comment]
-- property: Single LayoutElement.flexibleWidth	get	set	
--The extra relative width this layout element should be allocated if there is additional available space.
flexibleWidth = nil 
--*
--[Comment]
-- property: Single LayoutElement.flexibleHeight	get	set	
--The extra relative height this layout element should be allocated if there is additional available space.
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 LayoutElement.layoutPriority	get	
--Called by the layout system.
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean LayoutElement.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean LayoutElement.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean LayoutElement.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform LayoutElement.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject LayoutElement.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String LayoutElement.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String LayoutElement.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags LayoutElement.hideFlags	get	set	
hideFlags = nil 
--*
----Void LayoutElement:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void LayoutElement:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

Slider = {} 
--*
--[Comment]
-- property: RectTransform Slider.fillRect	get	set	
--Optional RectTransform to use as fill for the slider.
fillRect = nil 
--*
--[Comment]
-- property: RectTransform Slider.handleRect	get	set	
--Optional RectTransform to use as a handle for the slider.
handleRect = nil 
--*
--[Comment]
-- property: Direction Slider.direction	get	set	
--The direction of the slider, from minimum to maximum value.
direction = nil 
--*
--[Comment]
-- property: Single Slider.minValue	get	set	
--The minimum allowed value of the slider.
minValue = nil 
--*
--[Comment]
-- property: Single Slider.maxValue	get	set	
--The maximum allowed value of the slider.
maxValue = nil 
--*
--[Comment]
-- property: Boolean Slider.wholeNumbers	get	set	
--Should the value only be allowed to be whole numbers?
wholeNumbers = nil 
--*
--[Comment]
-- property: Single Slider.value	get	set	
--The current value of the slider.
value = nil 
--*
--[Comment]
-- property: Single Slider.normalizedValue	get	set	
--The current value of the slider normalized into a value between 0 and 1.
normalizedValue = nil 
--*
--[Comment]
-- property: SliderEvent Slider.onValueChanged	get	set	
--Callback executed when the value of the slider is changed.
onValueChanged = nil 
--*
--[Comment]
-- property: Navigation Slider.navigation	get	set	
navigation = nil 
--*
--[Comment]
-- property: Transition Slider.transition	get	set	
transition = nil 
--*
--[Comment]
-- property: ColorBlock Slider.colors	get	set	
colors = nil 
--*
--[Comment]
-- property: SpriteState Slider.spriteState	get	set	
spriteState = nil 
--*
--[Comment]
-- property: AnimationTriggers Slider.animationTriggers	get	set	
animationTriggers = nil 
--*
--[Comment]
-- property: Graphic Slider.targetGraphic	get	set	
targetGraphic = nil 
--*
--[Comment]
-- property: Boolean Slider.interactable	get	set	
interactable = nil 
--*
--[Comment]
-- property: Image Slider.image	get	set	
image = nil 
--*
--[Comment]
-- property: Animator Slider.animator	get	
animator = nil 
--*
--[Comment]
-- property: Boolean Slider.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Slider.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Slider.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Slider.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Slider.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Slider.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Slider.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Slider.hideFlags	get	set	
hideFlags = nil 
--*
----Void Slider:Rebuild(CanvasUpdate executing)
function Rebuild() end 

----Void Slider:LayoutComplete()
function LayoutComplete() end 

----Void Slider:GraphicUpdateComplete()
function GraphicUpdateComplete() end 

----Void Slider:OnPointerDown(PointerEventData eventData)
function OnPointerDown() end 

----Void Slider:OnDrag(PointerEventData eventData)
function OnDrag() end 

----Void Slider:OnMove(AxisEventData eventData)
function OnMove() end 

----Selectable Slider:FindSelectableOnLeft()
function FindSelectableOnLeft() end 

----Selectable Slider:FindSelectableOnRight()
function FindSelectableOnRight() end 

----Selectable Slider:FindSelectableOnUp()
function FindSelectableOnUp() end 

----Selectable Slider:FindSelectableOnDown()
function FindSelectableOnDown() end 

----Void Slider:OnInitializePotentialDrag(PointerEventData eventData)
function OnInitializePotentialDrag() end 

----Void Slider:SetDirection(Direction direction,Boolean includeRectLayouts)
function SetDirection() end 

Scrollbar = {} 
--*
--[Comment]
-- property: RectTransform Scrollbar.handleRect	get	set	
--The RectTransform to use for the handle.
handleRect = nil 
--*
--[Comment]
-- property: Direction Scrollbar.direction	get	set	
--The direction of the scrollbar from minimum to maximum value.
direction = nil 
--*
--[Comment]
-- property: Single Scrollbar.value	get	set	
--The current value of the scrollbar, between 0 and 1.
value = nil 
--*
--[Comment]
-- property: Single Scrollbar.size	get	set	
--The size of the scrollbar handle where 1 means it fills the entire scrollbar.
size = nil 
--*
--[Comment]
-- property: Int32 Scrollbar.numberOfSteps	get	set	
--The number of steps to use for the value. A value of 0 disables use of steps.
numberOfSteps = nil 
--*
--[Comment]
-- property: ScrollEvent Scrollbar.onValueChanged	get	set	
--Handling for when the scrollbar value is changed.
onValueChanged = nil 
--*
--[Comment]
-- property: Navigation Scrollbar.navigation	get	set	
navigation = nil 
--*
--[Comment]
-- property: Transition Scrollbar.transition	get	set	
transition = nil 
--*
--[Comment]
-- property: ColorBlock Scrollbar.colors	get	set	
colors = nil 
--*
--[Comment]
-- property: SpriteState Scrollbar.spriteState	get	set	
spriteState = nil 
--*
--[Comment]
-- property: AnimationTriggers Scrollbar.animationTriggers	get	set	
animationTriggers = nil 
--*
--[Comment]
-- property: Graphic Scrollbar.targetGraphic	get	set	
targetGraphic = nil 
--*
--[Comment]
-- property: Boolean Scrollbar.interactable	get	set	
interactable = nil 
--*
--[Comment]
-- property: Image Scrollbar.image	get	set	
image = nil 
--*
--[Comment]
-- property: Animator Scrollbar.animator	get	
animator = nil 
--*
--[Comment]
-- property: Boolean Scrollbar.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Scrollbar.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Scrollbar.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Scrollbar.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Scrollbar.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Scrollbar.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Scrollbar.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Scrollbar.hideFlags	get	set	
hideFlags = nil 
--*
----Void Scrollbar:Rebuild(CanvasUpdate executing)
function Rebuild() end 

----Void Scrollbar:LayoutComplete()
function LayoutComplete() end 

----Void Scrollbar:GraphicUpdateComplete()
function GraphicUpdateComplete() end 

----Void Scrollbar:OnBeginDrag(PointerEventData eventData)
function OnBeginDrag() end 

----Void Scrollbar:OnDrag(PointerEventData eventData)
function OnDrag() end 

----Void Scrollbar:OnPointerDown(PointerEventData eventData)
function OnPointerDown() end 

----Void Scrollbar:OnPointerUp(PointerEventData eventData)
function OnPointerUp() end 

----Void Scrollbar:OnMove(AxisEventData eventData)
function OnMove() end 

----Selectable Scrollbar:FindSelectableOnLeft()
function FindSelectableOnLeft() end 

----Selectable Scrollbar:FindSelectableOnRight()
function FindSelectableOnRight() end 

----Selectable Scrollbar:FindSelectableOnUp()
function FindSelectableOnUp() end 

----Selectable Scrollbar:FindSelectableOnDown()
function FindSelectableOnDown() end 

----Void Scrollbar:OnInitializePotentialDrag(PointerEventData eventData)
function OnInitializePotentialDrag() end 

----Void Scrollbar:SetDirection(Direction direction,Boolean includeRectLayouts)
function SetDirection() end 

RectTransform = {} 
--*
--[Comment]
--consturctor for RectTransform overrides:
--*
--RectTransform.New()
--*

function RectTransform.New() end
--*
--[Comment]
-- property: Rect RectTransform.rect	get	
--The calculated rectangle in the local space of the Transform.
rect = nil 
--*
--[Comment]
-- property: Vector2 RectTransform.anchorMin	get	set	
--The normalized position in the parent RectTransform that the lower left corner is anchored to.
anchorMin = nil 
--*
--[Comment]
-- property: Vector2 RectTransform.anchorMax	get	set	
--The normalized position in the parent RectTransform that the upper right corner is anchored to.
anchorMax = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.anchoredPosition3D	get	set	
--The 3D position of the pivot of this RectTransform relative to the anchor reference point.
anchoredPosition3D = nil 
--*
--[Comment]
-- property: Vector2 RectTransform.anchoredPosition	get	set	
--The position of the pivot of this RectTransform relative to the anchor reference point.
anchoredPosition = nil 
--*
--[Comment]
-- property: Vector2 RectTransform.sizeDelta	get	set	
--The size of this RectTransform relative to the distances between the anchors.
sizeDelta = nil 
--*
--[Comment]
-- property: Vector2 RectTransform.pivot	get	set	
--The normalized position in this RectTransform that it rotates around.
pivot = nil 
--*
--[Comment]
-- property: Vector2 RectTransform.offsetMin	get	set	
--The offset of the lower left corner of the rectangle relative to the lower left anchor.
offsetMin = nil 
--*
--[Comment]
-- property: Vector2 RectTransform.offsetMax	get	set	
--The offset of the upper right corner of the rectangle relative to the upper right anchor.
offsetMax = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.position	get	set	
position = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.localPosition	get	set	
localPosition = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.eulerAngles	get	set	
eulerAngles = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.localEulerAngles	get	set	
localEulerAngles = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.right	get	set	
right = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.up	get	set	
up = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.forward	get	set	
forward = nil 
--*
--[Comment]
-- property: Quaternion RectTransform.rotation	get	set	
rotation = nil 
--*
--[Comment]
-- property: Quaternion RectTransform.localRotation	get	set	
localRotation = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.localScale	get	set	
localScale = nil 
--*
--[Comment]
-- property: Transform RectTransform.parent	get	set	
parent = nil 
--*
--[Comment]
-- property: Matrix4x4 RectTransform.worldToLocalMatrix	get	
worldToLocalMatrix = nil 
--*
--[Comment]
-- property: Matrix4x4 RectTransform.localToWorldMatrix	get	
localToWorldMatrix = nil 
--*
--[Comment]
-- property: Transform RectTransform.root	get	
root = nil 
--*
--[Comment]
-- property: Int32 RectTransform.childCount	get	
childCount = nil 
--*
--[Comment]
-- property: Vector3 RectTransform.lossyScale	get	
lossyScale = nil 
--*
--[Comment]
-- property: Boolean RectTransform.hasChanged	get	set	
hasChanged = nil 
--*
--[Comment]
-- property: Int32 RectTransform.hierarchyCapacity	get	set	
hierarchyCapacity = nil 
--*
--[Comment]
-- property: Int32 RectTransform.hierarchyCount	get	
hierarchyCount = nil 
--*
--[Comment]
-- property: Transform RectTransform.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject RectTransform.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String RectTransform.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String RectTransform.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags RectTransform.hideFlags	get	set	
hideFlags = nil 
--*
----Void RectTransform.add_reapplyDrivenProperties(ReapplyDrivenProperties value)
function RectTransform.add_reapplyDrivenProperties() end 

----Void RectTransform.remove_reapplyDrivenProperties(ReapplyDrivenProperties value)
function RectTransform.remove_reapplyDrivenProperties() end 

----Void RectTransform:GetLocalCorners(Vector3[] fourCornersArray)
function GetLocalCorners() end 

----Void RectTransform:GetWorldCorners(Vector3[] fourCornersArray)
function GetWorldCorners() end 

----Void RectTransform:SetInsetAndSizeFromParentEdge(Edge edge,Single inset,Single size)
function SetInsetAndSizeFromParentEdge() end 

----Void RectTransform:SetSizeWithCurrentAnchors(Axis axis,Single size)
function SetSizeWithCurrentAnchors() end 

RectTransformUtility = {} 
--*
----Boolean RectTransformUtility.RectangleContainsScreenPoint(RectTransform rect,Vector2 screenPoint)
--Boolean RectTransformUtility.RectangleContainsScreenPoint(RectTransform rect,Vector2 screenPoint,Camera cam)
function RectTransformUtility.RectangleContainsScreenPoint() end 

----Vector2 RectTransformUtility.PixelAdjustPoint(Vector2 point,Transform elementTransform,Canvas canvas)
function RectTransformUtility.PixelAdjustPoint() end 

----Rect RectTransformUtility.PixelAdjustRect(RectTransform rectTransform,Canvas canvas)
function RectTransformUtility.PixelAdjustRect() end 

----Boolean RectTransformUtility.ScreenPointToWorldPointInRectangle(RectTransform rect,Vector2 screenPoint,Camera cam,Vector3& worldPoint)
function RectTransformUtility.ScreenPointToWorldPointInRectangle() end 

----Boolean RectTransformUtility.ScreenPointToLocalPointInRectangle(RectTransform rect,Vector2 screenPoint,Camera cam,Vector2& localPoint)
function RectTransformUtility.ScreenPointToLocalPointInRectangle() end 

----Ray RectTransformUtility.ScreenPointToRay(Camera cam,Vector2 screenPos)
function RectTransformUtility.ScreenPointToRay() end 

----Vector2 RectTransformUtility.WorldToScreenPoint(Camera cam,Vector3 worldPoint)
function RectTransformUtility.WorldToScreenPoint() end 

----Bounds RectTransformUtility.CalculateRelativeRectTransformBounds(Transform root,Transform child)
--Bounds RectTransformUtility.CalculateRelativeRectTransformBounds(Transform trans)
function RectTransformUtility.CalculateRelativeRectTransformBounds() end 

----Void RectTransformUtility.FlipLayoutOnAxis(RectTransform rect,Int32 axis,Boolean keepPositioning,Boolean recursive)
function RectTransformUtility.FlipLayoutOnAxis() end 

----Void RectTransformUtility.FlipLayoutAxes(RectTransform rect,Boolean keepPositioning,Boolean recursive)
function RectTransformUtility.FlipLayoutAxes() end 

UIBehaviour = {} 
--*
--[Comment]
-- property: Boolean UIBehaviour.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIBehaviour.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIBehaviour.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIBehaviour.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIBehaviour.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIBehaviour.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIBehaviour.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIBehaviour.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean UIBehaviour:IsActive()
function IsActive() end 

----Boolean UIBehaviour:IsDestroyed()
function IsDestroyed() end 

Selectable = {} 
--*
--[Comment]
-- property: List`1 Selectable.allSelectables	get	
--List of all the selectable objects currently active in the scene.
allSelectables = nil 
--*
--[Comment]
-- property: Navigation Selectable.navigation	get	set	
--The Navigation setting for this selectable object.
navigation = nil 
--*
--[Comment]
-- property: Transition Selectable.transition	get	set	
--The type of transition that will be applied to the targetGraphic when the state changes.
transition = nil 
--*
--[Comment]
-- property: ColorBlock Selectable.colors	get	set	
--The ColorBlock for this selectable object.
colors = nil 
--*
--[Comment]
-- property: SpriteState Selectable.spriteState	get	set	
--The SpriteState for this selectable object.
spriteState = nil 
--*
--[Comment]
-- property: AnimationTriggers Selectable.animationTriggers	get	set	
--The AnimationTriggers for this selectable object.
animationTriggers = nil 
--*
--[Comment]
-- property: Graphic Selectable.targetGraphic	get	set	
--Graphic that will be transitioned upon.
targetGraphic = nil 
--*
--[Comment]
-- property: Boolean Selectable.interactable	get	set	
--UI.Selectable.interactable.
interactable = nil 
--*
--[Comment]
-- property: Image Selectable.image	get	set	
--Convenience function that converts the referenced Graphic to a Image, if possible.
image = nil 
--*
--[Comment]
-- property: Animator Selectable.animator	get	
--Convenience function to get the Animator component on the GameObject.
animator = nil 
--*
--[Comment]
-- property: Boolean Selectable.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Selectable.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Selectable.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Selectable.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Selectable.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Selectable.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Selectable.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Selectable.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean Selectable:IsInteractable()
function IsInteractable() end 

----Selectable Selectable:FindSelectable(Vector3 dir)
function FindSelectable() end 

----Selectable Selectable:FindSelectableOnLeft()
function FindSelectableOnLeft() end 

----Selectable Selectable:FindSelectableOnRight()
function FindSelectableOnRight() end 

----Selectable Selectable:FindSelectableOnUp()
function FindSelectableOnUp() end 

----Selectable Selectable:FindSelectableOnDown()
function FindSelectableOnDown() end 

----Void Selectable:OnMove(AxisEventData eventData)
function OnMove() end 

----Void Selectable:OnPointerDown(PointerEventData eventData)
function OnPointerDown() end 

----Void Selectable:OnPointerUp(PointerEventData eventData)
function OnPointerUp() end 

----Void Selectable:OnPointerEnter(PointerEventData eventData)
function OnPointerEnter() end 

----Void Selectable:OnPointerExit(PointerEventData eventData)
function OnPointerExit() end 

----Void Selectable:OnSelect(BaseEventData eventData)
function OnSelect() end 

----Void Selectable:OnDeselect(BaseEventData eventData)
function OnDeselect() end 

----Void Selectable:Select()
function Select() end 

Button = {} 
--*
--[Comment]
-- property: ButtonClickedEvent Button.onClick	get	set	
--UnityEvent to be fired when the buttons is pressed.
onClick = nil 
--*
--[Comment]
-- property: Navigation Button.navigation	get	set	
navigation = nil 
--*
--[Comment]
-- property: Transition Button.transition	get	set	
transition = nil 
--*
--[Comment]
-- property: ColorBlock Button.colors	get	set	
colors = nil 
--*
--[Comment]
-- property: SpriteState Button.spriteState	get	set	
spriteState = nil 
--*
--[Comment]
-- property: AnimationTriggers Button.animationTriggers	get	set	
animationTriggers = nil 
--*
--[Comment]
-- property: Graphic Button.targetGraphic	get	set	
targetGraphic = nil 
--*
--[Comment]
-- property: Boolean Button.interactable	get	set	
interactable = nil 
--*
--[Comment]
-- property: Image Button.image	get	set	
image = nil 
--*
--[Comment]
-- property: Animator Button.animator	get	
animator = nil 
--*
--[Comment]
-- property: Boolean Button.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Button.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Button.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Button.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Button.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Button.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Button.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Button.hideFlags	get	set	
hideFlags = nil 
--*
----Void Button:OnPointerClick(PointerEventData eventData)
function OnPointerClick() end 

----Void Button:OnSubmit(BaseEventData eventData)
function OnSubmit() end 

Canvas = {} 
--*
--[Comment]
--consturctor for Canvas overrides:
--*
--Canvas.New()
--*

function Canvas.New() end
--*
--[Comment]
-- property: RenderMode Canvas.renderMode	get	set	
--Is the Canvas in World or Overlay mode?
renderMode = nil 
--*
--[Comment]
-- property: Boolean Canvas.isRootCanvas	get	
--Is this the root Canvas?
isRootCanvas = nil 
--*
--[Comment]
-- property: Camera Canvas.worldCamera	get	set	
--Camera used for sizing the Canvas when in Screen Space - Camera. Also used as the Camera that events will be sent through for a World Space {{Canvas].
worldCamera = nil 
--*
--[Comment]
-- property: Rect Canvas.pixelRect	get	
--Get the render rect for the Canvas.
pixelRect = nil 
--*
--[Comment]
-- property: Single Canvas.scaleFactor	get	set	
--Used to scale the entire canvas, while still making it fit the screen. Only applies with renderMode is Screen Space.
scaleFactor = nil 
--*
--[Comment]
-- property: Single Canvas.referencePixelsPerUnit	get	set	
--The number of pixels per unit that is considered the default.
referencePixelsPerUnit = nil 
--*
--[Comment]
-- property: Boolean Canvas.overridePixelPerfect	get	set	
--Allows for nested canvases to override pixelPerfect settings inherited from parent canvases.
overridePixelPerfect = nil 
--*
--[Comment]
-- property: Boolean Canvas.pixelPerfect	get	set	
--Force elements in the canvas to be aligned with pixels. Only applies with renderMode is Screen Space.
pixelPerfect = nil 
--*
--[Comment]
-- property: Single Canvas.planeDistance	get	set	
--How far away from the camera is the Canvas generated.
planeDistance = nil 
--*
--[Comment]
-- property: Int32 Canvas.renderOrder	get	
--The render order in which the canvas is being emitted to the scene.
renderOrder = nil 
--*
--[Comment]
-- property: Boolean Canvas.overrideSorting	get	set	
--Override the sorting of canvas.
overrideSorting = nil 
--*
--[Comment]
-- property: Int32 Canvas.sortingOrder	get	set	
--Canvas' order within a sorting layer.
sortingOrder = nil 
--*
--[Comment]
-- property: Int32 Canvas.targetDisplay	get	set	
--For Overlay mode, display index on which the UI canvas will appear.
targetDisplay = nil 
--*
--[Comment]
-- property: Int32 Canvas.sortingGridNormalizedSize	get	set	
--The normalized grid size that the canvas will split the renderable area into.
sortingGridNormalizedSize = nil 
--*
--[Comment]
-- property: Int32 Canvas.sortingLayerID	get	set	
--Unique ID of the Canvas' sorting layer.
sortingLayerID = nil 
--*
--[Comment]
-- property: Int32 Canvas.cachedSortingLayerValue	get	
--Cached calculated value based upon SortingLayerID.
cachedSortingLayerValue = nil 
--*
--[Comment]
-- property: String Canvas.sortingLayerName	get	set	
--Name of the Canvas' sorting layer.
sortingLayerName = nil 
--*
--[Comment]
-- property: Canvas Canvas.rootCanvas	get	
--Returns the Canvas closest to root, by checking through each parent and returning the last canvas found. If no other canvas is found then the canvas will return itself.
rootCanvas = nil 
--*
--[Comment]
-- property: Boolean Canvas.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Canvas.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Canvas.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Canvas.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Canvas.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Canvas.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Canvas.hideFlags	get	set	
hideFlags = nil 
--*
----Void Canvas.add_willRenderCanvases(WillRenderCanvases value)
function Canvas.add_willRenderCanvases() end 

----Void Canvas.remove_willRenderCanvases(WillRenderCanvases value)
function Canvas.remove_willRenderCanvases() end 

----Material Canvas.GetDefaultCanvasMaterial()
function Canvas.GetDefaultCanvasMaterial() end 

----Material Canvas.GetETC1SupportedCanvasMaterial()
function Canvas.GetETC1SupportedCanvasMaterial() end 

----Void Canvas.ForceUpdateCanvases()
function Canvas.ForceUpdateCanvases() end 

BaseRaycaster = {} 
--*
--[Comment]
-- property: Camera BaseRaycaster.eventCamera	get	
--The camera that will generate rays for this raycaster.
eventCamera = nil 
--*
--[Comment]
-- property: Int32 BaseRaycaster.sortOrderPriority	get	
--Priority of the raycaster based upon sort order.
sortOrderPriority = nil 
--*
--[Comment]
-- property: Int32 BaseRaycaster.renderOrderPriority	get	
--Priority of the raycaster based upon render order.
renderOrderPriority = nil 
--*
--[Comment]
-- property: Boolean BaseRaycaster.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean BaseRaycaster.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean BaseRaycaster.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform BaseRaycaster.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject BaseRaycaster.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String BaseRaycaster.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String BaseRaycaster.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags BaseRaycaster.hideFlags	get	set	
hideFlags = nil 
--*
----Void BaseRaycaster:Raycast(PointerEventData eventData,List`1 resultAppendList)
function Raycast() end 

----String BaseRaycaster:ToString()
function ToString() end 

GraphicRaycaster = {} 
--*
--[Comment]
-- property: Int32 GraphicRaycaster.sortOrderPriority	get	
sortOrderPriority = nil 
--*
--[Comment]
-- property: Int32 GraphicRaycaster.renderOrderPriority	get	
renderOrderPriority = nil 
--*
--[Comment]
-- property: Boolean GraphicRaycaster.ignoreReversedGraphics	get	set	
--Should graphics facing away from the raycaster be considered?
ignoreReversedGraphics = nil 
--*
--[Comment]
-- property: BlockingObjects GraphicRaycaster.blockingObjects	get	set	
--Type of objects that will block graphic raycasts.
blockingObjects = nil 
--*
--[Comment]
-- property: Camera GraphicRaycaster.eventCamera	get	
--See: BaseRaycaster.
eventCamera = nil 
--*
--[Comment]
-- property: Boolean GraphicRaycaster.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean GraphicRaycaster.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean GraphicRaycaster.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform GraphicRaycaster.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject GraphicRaycaster.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String GraphicRaycaster.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String GraphicRaycaster.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags GraphicRaycaster.hideFlags	get	set	
hideFlags = nil 
--*
----Void GraphicRaycaster:Raycast(PointerEventData eventData,List`1 resultAppendList)
function Raycast() end 

LuaBehaviour = {} 
--*
--[Comment]
--consturctor for LuaBehaviour overrides:
--*
--LuaBehaviour.New()
--*

function LuaBehaviour.New() end
--*
--[Comment]
-- property: Boolean LuaBehaviour.UsingOnEnable	get	set	
UsingOnEnable = nil 
--*
--[Comment]
-- property: Boolean LuaBehaviour.UsingOnDisable	get	set	
UsingOnDisable = nil 
--*
--[Comment]
-- property: Boolean LuaBehaviour.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean LuaBehaviour.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean LuaBehaviour.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform LuaBehaviour.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject LuaBehaviour.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String LuaBehaviour.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String LuaBehaviour.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags LuaBehaviour.hideFlags	get	set	
hideFlags = nil 
--*
----Void LuaBehaviour:Init(LuaTable tb)
function Init() end 

----Void LuaBehaviour:AddClick(GameObject go,LuaFunction luafunc)
function AddClick() end 

----Void LuaBehaviour:RemoveClick(GameObject go)
function RemoveClick() end 

----Void LuaBehaviour:ClearClick()
function ClearClick() end 

ScrollRect = {} 
--*
--[Comment]
-- property: RectTransform ScrollRect.content	get	set	
--The content that can be scrolled. It should be a child of the GameObject with ScrollRect on it.
content = nil 
--*
--[Comment]
-- property: Boolean ScrollRect.horizontal	get	set	
--Should horizontal scrolling be enabled?
horizontal = nil 
--*
--[Comment]
-- property: Boolean ScrollRect.vertical	get	set	
--Should vertical scrolling be enabled?
vertical = nil 
--*
--[Comment]
-- property: MovementType ScrollRect.movementType	get	set	
--The behavior to use when the content moves beyond the scroll rect.
movementType = nil 
--*
--[Comment]
-- property: Single ScrollRect.elasticity	get	set	
--The amount of elasticity to use when the content moves beyond the scroll rect.
elasticity = nil 
--*
--[Comment]
-- property: Boolean ScrollRect.inertia	get	set	
--Should movement inertia be enabled?
inertia = nil 
--*
--[Comment]
-- property: Single ScrollRect.decelerationRate	get	set	
--The rate at which movement slows down.
decelerationRate = nil 
--*
--[Comment]
-- property: Single ScrollRect.scrollSensitivity	get	set	
--The sensitivity to scroll wheel and track pad scroll events.
scrollSensitivity = nil 
--*
--[Comment]
-- property: RectTransform ScrollRect.viewport	get	set	
--Reference to the viewport RectTransform that is the parent of the content RectTransform.
viewport = nil 
--*
--[Comment]
-- property: Scrollbar ScrollRect.horizontalScrollbar	get	set	
--Optional Scrollbar object linked to the horizontal scrolling of the ScrollRect.
horizontalScrollbar = nil 
--*
--[Comment]
-- property: Scrollbar ScrollRect.verticalScrollbar	get	set	
--Optional Scrollbar object linked to the vertical scrolling of the ScrollRect.
verticalScrollbar = nil 
--*
--[Comment]
-- property: ScrollbarVisibility ScrollRect.horizontalScrollbarVisibility	get	set	
--The mode of visibility for the horizontal scrollbar.
horizontalScrollbarVisibility = nil 
--*
--[Comment]
-- property: ScrollbarVisibility ScrollRect.verticalScrollbarVisibility	get	set	
--The mode of visibility for the vertical scrollbar.
verticalScrollbarVisibility = nil 
--*
--[Comment]
-- property: Single ScrollRect.horizontalScrollbarSpacing	get	set	
--The space between the scrollbar and the viewport.
horizontalScrollbarSpacing = nil 
--*
--[Comment]
-- property: Single ScrollRect.verticalScrollbarSpacing	get	set	
--The space between the scrollbar and the viewport.
verticalScrollbarSpacing = nil 
--*
--[Comment]
-- property: ScrollRectEvent ScrollRect.onValueChanged	get	set	
--Callback executed when the scroll position of the slider is changed.
onValueChanged = nil 
--*
--[Comment]
-- property: Vector2 ScrollRect.velocity	get	set	
--The current velocity of the content.
velocity = nil 
--*
--[Comment]
-- property: Vector2 ScrollRect.normalizedPosition	get	set	
--The scroll position as a Vector2 between (0,0) and (1,1) with (0,0) being the lower left corner.
normalizedPosition = nil 
--*
--[Comment]
-- property: Single ScrollRect.horizontalNormalizedPosition	get	set	
--The horizontal scroll position as a value between 0 and 1, with 0 being at the left.
horizontalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single ScrollRect.verticalNormalizedPosition	get	set	
--The vertical scroll position as a value between 0 and 1, with 0 being at the bottom.
verticalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single ScrollRect.minWidth	get	
--Called by the layout system.
minWidth = nil 
--*
--[Comment]
-- property: Single ScrollRect.preferredWidth	get	
--Called by the layout system.
preferredWidth = nil 
--*
--[Comment]
-- property: Single ScrollRect.flexibleWidth	get	
--Called by the layout system.
flexibleWidth = nil 
--*
--[Comment]
-- property: Single ScrollRect.minHeight	get	
--Called by the layout system.
minHeight = nil 
--*
--[Comment]
-- property: Single ScrollRect.preferredHeight	get	
--Called by the layout system.
preferredHeight = nil 
--*
--[Comment]
-- property: Single ScrollRect.flexibleHeight	get	
--Called by the layout system.
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 ScrollRect.layoutPriority	get	
--Called by the layout system.
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean ScrollRect.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean ScrollRect.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean ScrollRect.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform ScrollRect.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject ScrollRect.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String ScrollRect.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String ScrollRect.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags ScrollRect.hideFlags	get	set	
hideFlags = nil 
--*
----Void ScrollRect:Rebuild(CanvasUpdate executing)
function Rebuild() end 

----Void ScrollRect:LayoutComplete()
function LayoutComplete() end 

----Void ScrollRect:GraphicUpdateComplete()
function GraphicUpdateComplete() end 

----Boolean ScrollRect:IsActive()
function IsActive() end 

----Void ScrollRect:StopMovement()
function StopMovement() end 

----Void ScrollRect:OnScroll(PointerEventData data)
function OnScroll() end 

----Void ScrollRect:OnInitializePotentialDrag(PointerEventData eventData)
function OnInitializePotentialDrag() end 

----Void ScrollRect:OnBeginDrag(PointerEventData eventData)
function OnBeginDrag() end 

----Void ScrollRect:OnEndDrag(PointerEventData eventData)
function OnEndDrag() end 

----Void ScrollRect:OnDrag(PointerEventData eventData)
function OnDrag() end 

----Void ScrollRect:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void ScrollRect:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

----Void ScrollRect:SetLayoutHorizontal()
function SetLayoutHorizontal() end 

----Void ScrollRect:SetLayoutVertical()
function SetLayoutVertical() end 

LoopScrollRect = {} 
--*
--[Comment]
-- property: String LoopScrollRect.CellPrefabName	get	set	
CellPrefabName = nil 
--*
--[Comment]
-- property: Int32 LoopScrollRect.TotalCount	get	set	
TotalCount = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.InitInStart	get	set	
InitInStart = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.Threshold	get	set	
Threshold = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.ReverseDirection	get	set	
ReverseDirection = nil 
--*
--[Comment]
-- property: RectTransform LoopScrollRect.content	get	set	
content = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.horizontal	get	set	
horizontal = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.vertical	get	set	
vertical = nil 
--*
--[Comment]
-- property: MovementType LoopScrollRect.movementType	get	set	
movementType = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.elasticity	get	set	
elasticity = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.inertia	get	set	
inertia = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.decelerationRate	get	set	
decelerationRate = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.scrollSensitivity	get	set	
scrollSensitivity = nil 
--*
--[Comment]
-- property: RectTransform LoopScrollRect.viewport	get	set	
viewport = nil 
--*
--[Comment]
-- property: Scrollbar LoopScrollRect.horizontalScrollbar	get	set	
horizontalScrollbar = nil 
--*
--[Comment]
-- property: Scrollbar LoopScrollRect.verticalScrollbar	get	set	
verticalScrollbar = nil 
--*
--[Comment]
-- property: ScrollbarVisibility LoopScrollRect.horizontalScrollbarVisibility	get	set	
horizontalScrollbarVisibility = nil 
--*
--[Comment]
-- property: ScrollbarVisibility LoopScrollRect.verticalScrollbarVisibility	get	set	
verticalScrollbarVisibility = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.horizontalScrollbarSpacing	get	set	
horizontalScrollbarSpacing = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.verticalScrollbarSpacing	get	set	
verticalScrollbarSpacing = nil 
--*
--[Comment]
-- property: ScrollRectEvent LoopScrollRect.onValueChanged	get	set	
onValueChanged = nil 
--*
--[Comment]
-- property: Vector2 LoopScrollRect.velocity	get	set	
velocity = nil 
--*
--[Comment]
-- property: Vector2 LoopScrollRect.normalizedPosition	get	set	
normalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.horizontalNormalizedPosition	get	set	
horizontalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.verticalNormalizedPosition	get	set	
verticalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.preferredWidth	get	
preferredWidth = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.flexibleWidth	get	set	
flexibleWidth = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.preferredHeight	get	
preferredHeight = nil 
--*
--[Comment]
-- property: Single LoopScrollRect.flexibleHeight	get	
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 LoopScrollRect.layoutPriority	get	
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean LoopScrollRect.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform LoopScrollRect.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject LoopScrollRect.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String LoopScrollRect.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String LoopScrollRect.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags LoopScrollRect.hideFlags	get	set	
hideFlags = nil 
--*
----Void LoopScrollRect:Init(GameObject cellGo)
function Init() end 

----Void LoopScrollRect:ClearCells()
function ClearCells() end 

----Void LoopScrollRect:RefillCells(Int32 startIdx)
function RefillCells() end 

----Void LoopScrollRect:Rebuild(CanvasUpdate executing)
function Rebuild() end 

----Void LoopScrollRect:LayoutComplete()
function LayoutComplete() end 

----Void LoopScrollRect:GraphicUpdateComplete()
function GraphicUpdateComplete() end 

----Boolean LoopScrollRect:IsActive()
function IsActive() end 

----Void LoopScrollRect:StopMovement()
function StopMovement() end 

----Void LoopScrollRect:OnScroll(PointerEventData data)
function OnScroll() end 

----Void LoopScrollRect:OnInitializePotentialDrag(PointerEventData eventData)
function OnInitializePotentialDrag() end 

----Void LoopScrollRect:OnBeginDrag(PointerEventData eventData)
function OnBeginDrag() end 

----Void LoopScrollRect:OnEndDrag(PointerEventData eventData)
function OnEndDrag() end 

----Void LoopScrollRect:OnDrag(PointerEventData eventData)
function OnDrag() end 

----Void LoopScrollRect:CalculateLayoutInputHorizontal()
function CalculateLayoutInputHorizontal() end 

----Void LoopScrollRect:CalculateLayoutInputVertical()
function CalculateLayoutInputVertical() end 

----Void LoopScrollRect:SetLayoutHorizontal()
function SetLayoutHorizontal() end 

----Void LoopScrollRect:SetLayoutVertical()
function SetLayoutVertical() end 

LoopVerticalScrollRect = {} 
--*
--[Comment]
--consturctor for LoopVerticalScrollRect overrides:
--*
--LoopVerticalScrollRect.New()
--*

function LoopVerticalScrollRect.New() end
--*
--[Comment]
-- property: String LoopVerticalScrollRect.CellPrefabName	get	set	
CellPrefabName = nil 
--*
--[Comment]
-- property: Int32 LoopVerticalScrollRect.TotalCount	get	set	
TotalCount = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.InitInStart	get	set	
InitInStart = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.Threshold	get	set	
Threshold = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.ReverseDirection	get	set	
ReverseDirection = nil 
--*
--[Comment]
-- property: RectTransform LoopVerticalScrollRect.content	get	set	
content = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.horizontal	get	set	
horizontal = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.vertical	get	set	
vertical = nil 
--*
--[Comment]
-- property: MovementType LoopVerticalScrollRect.movementType	get	set	
movementType = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.elasticity	get	set	
elasticity = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.inertia	get	set	
inertia = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.decelerationRate	get	set	
decelerationRate = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.scrollSensitivity	get	set	
scrollSensitivity = nil 
--*
--[Comment]
-- property: RectTransform LoopVerticalScrollRect.viewport	get	set	
viewport = nil 
--*
--[Comment]
-- property: Scrollbar LoopVerticalScrollRect.horizontalScrollbar	get	set	
horizontalScrollbar = nil 
--*
--[Comment]
-- property: Scrollbar LoopVerticalScrollRect.verticalScrollbar	get	set	
verticalScrollbar = nil 
--*
--[Comment]
-- property: ScrollbarVisibility LoopVerticalScrollRect.horizontalScrollbarVisibility	get	set	
horizontalScrollbarVisibility = nil 
--*
--[Comment]
-- property: ScrollbarVisibility LoopVerticalScrollRect.verticalScrollbarVisibility	get	set	
verticalScrollbarVisibility = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.horizontalScrollbarSpacing	get	set	
horizontalScrollbarSpacing = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.verticalScrollbarSpacing	get	set	
verticalScrollbarSpacing = nil 
--*
--[Comment]
-- property: ScrollRectEvent LoopVerticalScrollRect.onValueChanged	get	set	
onValueChanged = nil 
--*
--[Comment]
-- property: Vector2 LoopVerticalScrollRect.velocity	get	set	
velocity = nil 
--*
--[Comment]
-- property: Vector2 LoopVerticalScrollRect.normalizedPosition	get	set	
normalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.horizontalNormalizedPosition	get	set	
horizontalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.verticalNormalizedPosition	get	set	
verticalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.preferredWidth	get	
preferredWidth = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.flexibleWidth	get	set	
flexibleWidth = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.preferredHeight	get	
preferredHeight = nil 
--*
--[Comment]
-- property: Single LoopVerticalScrollRect.flexibleHeight	get	
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 LoopVerticalScrollRect.layoutPriority	get	
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean LoopVerticalScrollRect.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform LoopVerticalScrollRect.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject LoopVerticalScrollRect.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String LoopVerticalScrollRect.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String LoopVerticalScrollRect.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags LoopVerticalScrollRect.hideFlags	get	set	
hideFlags = nil 
--*
LoopHorizontalScrollRect = {} 
--*
--[Comment]
--consturctor for LoopHorizontalScrollRect overrides:
--*
--LoopHorizontalScrollRect.New()
--*

function LoopHorizontalScrollRect.New() end
--*
--[Comment]
-- property: String LoopHorizontalScrollRect.CellPrefabName	get	set	
CellPrefabName = nil 
--*
--[Comment]
-- property: Int32 LoopHorizontalScrollRect.TotalCount	get	set	
TotalCount = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.InitInStart	get	set	
InitInStart = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.Threshold	get	set	
Threshold = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.ReverseDirection	get	set	
ReverseDirection = nil 
--*
--[Comment]
-- property: RectTransform LoopHorizontalScrollRect.content	get	set	
content = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.horizontal	get	set	
horizontal = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.vertical	get	set	
vertical = nil 
--*
--[Comment]
-- property: MovementType LoopHorizontalScrollRect.movementType	get	set	
movementType = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.elasticity	get	set	
elasticity = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.inertia	get	set	
inertia = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.decelerationRate	get	set	
decelerationRate = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.scrollSensitivity	get	set	
scrollSensitivity = nil 
--*
--[Comment]
-- property: RectTransform LoopHorizontalScrollRect.viewport	get	set	
viewport = nil 
--*
--[Comment]
-- property: Scrollbar LoopHorizontalScrollRect.horizontalScrollbar	get	set	
horizontalScrollbar = nil 
--*
--[Comment]
-- property: Scrollbar LoopHorizontalScrollRect.verticalScrollbar	get	set	
verticalScrollbar = nil 
--*
--[Comment]
-- property: ScrollbarVisibility LoopHorizontalScrollRect.horizontalScrollbarVisibility	get	set	
horizontalScrollbarVisibility = nil 
--*
--[Comment]
-- property: ScrollbarVisibility LoopHorizontalScrollRect.verticalScrollbarVisibility	get	set	
verticalScrollbarVisibility = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.horizontalScrollbarSpacing	get	set	
horizontalScrollbarSpacing = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.verticalScrollbarSpacing	get	set	
verticalScrollbarSpacing = nil 
--*
--[Comment]
-- property: ScrollRectEvent LoopHorizontalScrollRect.onValueChanged	get	set	
onValueChanged = nil 
--*
--[Comment]
-- property: Vector2 LoopHorizontalScrollRect.velocity	get	set	
velocity = nil 
--*
--[Comment]
-- property: Vector2 LoopHorizontalScrollRect.normalizedPosition	get	set	
normalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.horizontalNormalizedPosition	get	set	
horizontalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.verticalNormalizedPosition	get	set	
verticalNormalizedPosition = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.preferredWidth	get	
preferredWidth = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.flexibleWidth	get	set	
flexibleWidth = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.preferredHeight	get	
preferredHeight = nil 
--*
--[Comment]
-- property: Single LoopHorizontalScrollRect.flexibleHeight	get	
flexibleHeight = nil 
--*
--[Comment]
-- property: Int32 LoopHorizontalScrollRect.layoutPriority	get	
layoutPriority = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean LoopHorizontalScrollRect.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform LoopHorizontalScrollRect.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject LoopHorizontalScrollRect.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String LoopHorizontalScrollRect.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String LoopHorizontalScrollRect.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags LoopHorizontalScrollRect.hideFlags	get	set	
hideFlags = nil 
--*
Base = {} 
--*
--[Comment]
--consturctor for Base overrides:
--*
--Base.New()
--*

function Base.New() end
--*
--[Comment]
-- property: Boolean Base.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Base.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Base.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Base.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Base.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Base.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Base.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Base.hideFlags	get	set	
hideFlags = nil 
--*
Manager = {} 
--*
--[Comment]
--consturctor for Manager overrides:
--*
--Manager.New()
--*

function Manager.New() end
--*
--[Comment]
-- property: Boolean Manager.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean Manager.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean Manager.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform Manager.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject Manager.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String Manager.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String Manager.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags Manager.hideFlags	get	set	
hideFlags = nil 
--*
ByteBuffer = {} 
--*
--[Comment]
--consturctor for ByteBuffer overrides:
--*
--ByteBuffer.New()
--*

--ByteBuffer.New(Byte[] data)
--*

function ByteBuffer.New() end
--*
----Void ByteBuffer:Close()
function Close() end 

----Void ByteBuffer:WriteByte(Byte v)
function WriteByte() end 

----Void ByteBuffer:WriteInt(Int32 v)
function WriteInt() end 

----Void ByteBuffer:WriteShort(UInt16 v)
function WriteShort() end 

----Void ByteBuffer:WriteLong(Int64 v)
function WriteLong() end 

----Void ByteBuffer:WriteFloat(Single v)
function WriteFloat() end 

----Void ByteBuffer:WriteDouble(Double v)
function WriteDouble() end 

----Void ByteBuffer:WriteString(String v)
function WriteString() end 

----Void ByteBuffer:WriteBytes(Byte[] v)
function WriteBytes() end 

----Void ByteBuffer:WriteBuffer(LuaByteBuffer strBuffer)
function WriteBuffer() end 

----Byte ByteBuffer:ReadByte()
function ReadByte() end 

----Int32 ByteBuffer:ReadInt()
function ReadInt() end 

----UInt16 ByteBuffer:ReadShort()
function ReadShort() end 

----Int64 ByteBuffer:ReadLong()
function ReadLong() end 

----Single ByteBuffer:ReadFloat()
function ReadFloat() end 

----Double ByteBuffer:ReadDouble()
function ReadDouble() end 

----String ByteBuffer:ReadString()
function ReadString() end 

----Byte[] ByteBuffer:ReadBytes()
function ReadBytes() end 

----LuaByteBuffer ByteBuffer:ReadBuffer()
function ReadBuffer() end 

----Byte[] ByteBuffer:ToBytes()
function ToBytes() end 

----Void ByteBuffer:Flush()
function Flush() end 

NetworkManager = {} 
--*
--[Comment]
--consturctor for NetworkManager overrides:
--*
--NetworkManager.New()
--*

function NetworkManager.New() end
--*
--[Comment]
-- property: Boolean NetworkManager.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean NetworkManager.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean NetworkManager.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform NetworkManager.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject NetworkManager.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String NetworkManager.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String NetworkManager.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags NetworkManager.hideFlags	get	set	
hideFlags = nil 
--*
----Void NetworkManager:SetLuaTable(LuaTable tb)
function SetLuaTable() end 

----Void NetworkManager:OnSocketData(Int32 key,Byte[] value)
function OnSocketData() end 

----Void NetworkManager:SendConnect()
function SendConnect() end 

----Void NetworkManager:SendMessage(ByteBuffer buffer)
function SendMessage() end 

----Socket NetworkManager:getYsocket()
function getYsocket() end 

----Void NetworkManager:SendMessageByUDP(Byte[] msg)
function SendMessageByUDP() end 

----Boolean NetworkManager:ConnectUDP()
function ConnectUDP() end 

----Void NetworkManager.AddEvent(Int32 _event,Byte[] data)
function NetworkManager.AddEvent() end 

----Void NetworkManager:OnInit()
function OnInit() end 

----Void NetworkManager:OnUnLoad()
function OnUnLoad() end 

LuaHelper = {} 
--*
----Type LuaHelper.GetType(String classname)
function LuaHelper.GetType() end 

----NetworkManager LuaHelper.GetNetManager()
function LuaHelper.GetNetManager() end 

----Action LuaHelper.Action(LuaFunction func)
function LuaHelper.Action() end 

----Void LuaHelper.OnCallLuaFunc(LuaByteBuffer data,LuaFunction func)
function LuaHelper.OnCallLuaFunc() end 

----Void LuaHelper.OnJsonCallFunc(String data,LuaFunction func)
function LuaHelper.OnJsonCallFunc() end 

NGUITools = {} 
--*
--[Comment]
-- property: Single NGUITools.soundVolume	get	set	
soundVolume = nil 
--*
--[Comment]
-- property: Boolean NGUITools.fileAccess	get	
fileAccess = nil 
--*
--[Comment]
-- property: String NGUITools.clipboard	get	set	
clipboard = nil 
--*
--[Comment]
-- property: Vector2 NGUITools.screenSize	get	
screenSize = nil 
--*
----AudioSource NGUITools.PlaySound(AudioClip clip)
--AudioSource NGUITools.PlaySound(AudioClip clip,Single volume)
--AudioSource NGUITools.PlaySound(AudioClip clip,Single volume,Single pitch)
function NGUITools.PlaySound() end 

----Int32 NGUITools.RandomRange(Int32 min,Int32 max)
function NGUITools.RandomRange() end 

----String NGUITools.GetHierarchy(GameObject obj)
function NGUITools.GetHierarchy() end 

----Camera NGUITools.FindCameraForLayer(Int32 layer)
function NGUITools.FindCameraForLayer() end 

----Void NGUITools.AddWidgetCollider(GameObject go)
--Void NGUITools.AddWidgetCollider(GameObject go,Boolean considerInactive)
function NGUITools.AddWidgetCollider() end 

----Void NGUITools.UpdateWidgetCollider(GameObject go)
--Void NGUITools.UpdateWidgetCollider(GameObject go,Boolean considerInactive)
--Void NGUITools.UpdateWidgetCollider(BoxCollider box,Boolean considerInactive)
--Void NGUITools.UpdateWidgetCollider(BoxCollider2D box,Boolean considerInactive)
function NGUITools.UpdateWidgetCollider() end 

----String NGUITools.GetTypeName(Object obj)
function NGUITools.GetTypeName() end 

----Void NGUITools.RegisterUndo(Object obj,String name)
function NGUITools.RegisterUndo() end 

----Void NGUITools.SetDirty(Object obj)
function NGUITools.SetDirty() end 

----GameObject NGUITools.AddChild(GameObject parent)
--GameObject NGUITools.AddChild(GameObject parent,Boolean undo)
--GameObject NGUITools.AddChild(GameObject parent,GameObject prefab)
function NGUITools.AddChild() end 

----Int32 NGUITools.CalculateRaycastDepth(GameObject go)
function NGUITools.CalculateRaycastDepth() end 

----Int32 NGUITools.CalculateNextDepth(GameObject go)
--Int32 NGUITools.CalculateNextDepth(GameObject go,Boolean ignoreChildrenWithColliders)
function NGUITools.CalculateNextDepth() end 

----Int32 NGUITools.AdjustDepth(GameObject go,Int32 adjustment)
function NGUITools.AdjustDepth() end 

----Void NGUITools.BringForward(GameObject go)
function NGUITools.BringForward() end 

----Void NGUITools.PushBack(GameObject go)
function NGUITools.PushBack() end 

----Void NGUITools.NormalizeDepths()
function NGUITools.NormalizeDepths() end 

----Void NGUITools.NormalizeWidgetDepths()
--Void NGUITools.NormalizeWidgetDepths(GameObject go)
--Void NGUITools.NormalizeWidgetDepths(UIWidget[] list)
function NGUITools.NormalizeWidgetDepths() end 

----Void NGUITools.NormalizePanelDepths()
function NGUITools.NormalizePanelDepths() end 

----UIPanel NGUITools.CreateUI(Boolean advanced3D)
--UIPanel NGUITools.CreateUI(Boolean advanced3D,Int32 layer)
--UIPanel NGUITools.CreateUI(Transform trans,Boolean advanced3D,Int32 layer)
function NGUITools.CreateUI() end 

----Void NGUITools.SetChildLayer(Transform t,Int32 layer)
function NGUITools.SetChildLayer() end 

----UISprite NGUITools.AddSprite(GameObject go,UIAtlas atlas,String spriteName,Int32 depth)
function NGUITools.AddSprite() end 

----GameObject NGUITools.GetRoot(GameObject go)
function NGUITools.GetRoot() end 

----Void NGUITools.Destroy(Object obj)
function NGUITools.Destroy() end 

----Void NGUITools.DestroyChildren(Transform t)
function NGUITools.DestroyChildren() end 

----Void NGUITools.DestroyImmediate(Object obj)
function NGUITools.DestroyImmediate() end 

----Void NGUITools.Broadcast(String funcName)
--Void NGUITools.Broadcast(String funcName,Object param)
function NGUITools.Broadcast() end 

----Boolean NGUITools.IsChild(Transform parent,Transform child)
function NGUITools.IsChild() end 

----Void NGUITools.SetActive(GameObject go,Boolean state)
--Void NGUITools.SetActive(GameObject go,Boolean state,Boolean compatibilityMode)
function NGUITools.SetActive() end 

----Void NGUITools.SetActiveChildren(GameObject go,Boolean state)
function NGUITools.SetActiveChildren() end 

----Boolean NGUITools.GetActive(Behaviour mb)
--Boolean NGUITools.GetActive(GameObject go)
function NGUITools.GetActive() end 

----Void NGUITools.SetActiveSelf(GameObject go,Boolean state)
function NGUITools.SetActiveSelf() end 

----Void NGUITools.SetLayer(GameObject go,Int32 layer)
function NGUITools.SetLayer() end 

----Vector3 NGUITools.Round(Vector3 v)
function NGUITools.Round() end 

----Void NGUITools.MakePixelPerfect(Transform t)
function NGUITools.MakePixelPerfect() end 

----Void NGUITools.FitOnScreen(Camera cam,Transform transform,Vector3 pos)
--Void NGUITools.FitOnScreen(Camera cam,Transform transform,Transform content,Vector3 pos)
--Void NGUITools.FitOnScreen(Camera cam,Transform transform,Transform content,Vector3 pos,Bounds& bounds)
function NGUITools.FitOnScreen() end 

----Boolean NGUITools.Save(String fileName,Byte[] bytes)
function NGUITools.Save() end 

----Byte[] NGUITools.Load(String fileName)
function NGUITools.Load() end 

----Color NGUITools.ApplyPMA(Color c)
function NGUITools.ApplyPMA() end 

----Void NGUITools.MarkParentAsChanged(GameObject go)
function NGUITools.MarkParentAsChanged() end 

----Vector3[] NGUITools.GetSides(Camera cam)
--Vector3[] NGUITools.GetSides(Camera cam,Single depth)
--Vector3[] NGUITools.GetSides(Camera cam,Transform relativeTo)
--Vector3[] NGUITools.GetSides(Camera cam,Single depth,Transform relativeTo)
function NGUITools.GetSides() end 

----Vector3[] NGUITools.GetWorldCorners(Camera cam)
--Vector3[] NGUITools.GetWorldCorners(Camera cam,Single depth)
--Vector3[] NGUITools.GetWorldCorners(Camera cam,Transform relativeTo)
--Vector3[] NGUITools.GetWorldCorners(Camera cam,Single depth,Transform relativeTo)
function NGUITools.GetWorldCorners() end 

----String NGUITools.GetFuncName(Object obj,String method)
function NGUITools.GetFuncName() end 

----Void NGUITools.ImmediatelyCreateDrawCalls(GameObject root)
function NGUITools.ImmediatelyCreateDrawCalls() end 

----String NGUITools.KeyToCaption(KeyCode key)
function NGUITools.KeyToCaption() end 

----Color NGUITools.GammaToLinearSpace(Color c)
function NGUITools.GammaToLinearSpace() end 

UIPanel = {} 
--*
--[Comment]
--consturctor for UIPanel overrides:
--*
--UIPanel.New()
--*

function UIPanel.New() end
--*
--[Comment]
-- property: String UIPanel.sortingLayerName	get	set	
sortingLayerName = nil 
--*
--[Comment]
-- property: Int32 UIPanel.nextUnusedDepth	get	
nextUnusedDepth = nil 
--*
--[Comment]
-- property: Boolean UIPanel.canBeAnchored	get	
canBeAnchored = nil 
--*
--[Comment]
-- property: Single UIPanel.alpha	get	set	
alpha = nil 
--*
--[Comment]
-- property: Int32 UIPanel.depth	get	set	
depth = nil 
--*
--[Comment]
-- property: Int32 UIPanel.sortingOrder	get	set	
sortingOrder = nil 
--*
--[Comment]
-- property: Single UIPanel.width	get	
width = nil 
--*
--[Comment]
-- property: Single UIPanel.height	get	
height = nil 
--*
--[Comment]
-- property: Boolean UIPanel.halfPixelOffset	get	
halfPixelOffset = nil 
--*
--[Comment]
-- property: Boolean UIPanel.usedForUI	get	
usedForUI = nil 
--*
--[Comment]
-- property: Vector3 UIPanel.drawCallOffset	get	
drawCallOffset = nil 
--*
--[Comment]
-- property: Clipping UIPanel.clipping	get	set	
clipping = nil 
--*
--[Comment]
-- property: UIPanel UIPanel.parentPanel	get	
parentPanel = nil 
--*
--[Comment]
-- property: Int32 UIPanel.clipCount	get	
clipCount = nil 
--*
--[Comment]
-- property: Boolean UIPanel.hasClipping	get	
hasClipping = nil 
--*
--[Comment]
-- property: Boolean UIPanel.hasCumulativeClipping	get	
hasCumulativeClipping = nil 
--*
--[Comment]
-- property: Vector2 UIPanel.clipOffset	get	set	
clipOffset = nil 
--*
--[Comment]
-- property: Texture2D UIPanel.clipTexture	get	set	
clipTexture = nil 
--*
--[Comment]
-- property: Vector4 UIPanel.baseClipRegion	get	set	
baseClipRegion = nil 
--*
--[Comment]
-- property: Vector4 UIPanel.finalClipRegion	get	
finalClipRegion = nil 
--*
--[Comment]
-- property: Vector2 UIPanel.clipSoftness	get	set	
clipSoftness = nil 
--*
--[Comment]
-- property: Vector3[] UIPanel.localCorners	get	
localCorners = nil 
--*
--[Comment]
-- property: Vector3[] UIPanel.worldCorners	get	
worldCorners = nil 
--*
--[Comment]
-- property: GameObject UIPanel.cachedGameObject	get	
cachedGameObject = nil 
--*
--[Comment]
-- property: Transform UIPanel.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Camera UIPanel.anchorCamera	get	
anchorCamera = nil 
--*
--[Comment]
-- property: Boolean UIPanel.isFullyAnchored	get	
isFullyAnchored = nil 
--*
--[Comment]
-- property: Boolean UIPanel.isAnchoredHorizontally	get	
isAnchoredHorizontally = nil 
--*
--[Comment]
-- property: Boolean UIPanel.isAnchoredVertically	get	
isAnchoredVertically = nil 
--*
--[Comment]
-- property: UIRect UIPanel.parent	get	
parent = nil 
--*
--[Comment]
-- property: UIRoot UIPanel.root	get	
root = nil 
--*
--[Comment]
-- property: Boolean UIPanel.isAnchored	get	
isAnchored = nil 
--*
--[Comment]
-- property: Boolean UIPanel.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIPanel.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIPanel.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIPanel.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIPanel.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIPanel.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIPanel.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIPanel.hideFlags	get	set	
hideFlags = nil 
--*
----Int32 UIPanel.CompareFunc(UIPanel a,UIPanel b)
function UIPanel.CompareFunc() end 

----Vector3[] UIPanel:GetSides(Transform relativeTo)
function GetSides() end 

----Void UIPanel:Invalidate(Boolean includeChildren)
function Invalidate() end 

----Single UIPanel:CalculateFinalAlpha(Int32 frameID)
function CalculateFinalAlpha() end 

----Void UIPanel:SetRect(Single x,Single y,Single width,Single height)
function SetRect() end 

----Boolean UIPanel:IsVisible(Vector3 a,Vector3 b,Vector3 c,Vector3 d)
--Boolean UIPanel:IsVisible(Vector3 worldPos)
--Boolean UIPanel:IsVisible(UIWidget w)
function IsVisible() end 

----Boolean UIPanel:Affects(UIWidget w)
function Affects() end 

----Void UIPanel:RebuildAllDrawCalls()
function RebuildAllDrawCalls() end 

----Void UIPanel:SetDirty()
function SetDirty() end 

----Void UIPanel:ParentHasChanged()
function ParentHasChanged() end 

----Void UIPanel:SortWidgets()
function SortWidgets() end 

----Boolean UIPanel:FillDrawCall(UIDrawCall dc)
function FillDrawCall() end 

----UIDrawCall UIPanel:FindDrawCall(UIWidget w)
function FindDrawCall() end 

----Void UIPanel:AddWidget(UIWidget w)
function AddWidget() end 

----Void UIPanel:RemoveWidget(UIWidget w)
function RemoveWidget() end 

----Void UIPanel:Refresh()
function Refresh() end 

----Vector3 UIPanel:CalculateConstrainOffset(Vector2 min,Vector2 max)
function CalculateConstrainOffset() end 

----Boolean UIPanel:ConstrainTargetToBounds(Transform target,Bounds& targetBounds,Boolean immediate)
--Boolean UIPanel:ConstrainTargetToBounds(Transform target,Boolean immediate)
function ConstrainTargetToBounds() end 

----UIPanel UIPanel.Find(Transform trans)
--UIPanel UIPanel.Find(Transform trans,Boolean createIfMissing)
--UIPanel UIPanel.Find(Transform trans,Boolean createIfMissing,Int32 layer)
function UIPanel.Find() end 

----Vector2 UIPanel:GetWindowSize()
function GetWindowSize() end 

----Vector2 UIPanel:GetViewSize()
function GetViewSize() end 

UIPanelEX = {} 
--*
--[Comment]
--consturctor for UIPanelEX overrides:
--*
--UIPanelEX.New()
--*

function UIPanelEX.New() end
--*
--[Comment]
-- property: String UIPanelEX.sortingLayerName	get	set	
sortingLayerName = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.canBeAnchored	get	
canBeAnchored = nil 
--*
--[Comment]
-- property: Single UIPanelEX.alpha	get	set	
alpha = nil 
--*
--[Comment]
-- property: Int32 UIPanelEX.depth	get	set	
depth = nil 
--*
--[Comment]
-- property: Int32 UIPanelEX.sortingOrder	get	set	
sortingOrder = nil 
--*
--[Comment]
-- property: Single UIPanelEX.width	get	
width = nil 
--*
--[Comment]
-- property: Single UIPanelEX.height	get	
height = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.halfPixelOffset	get	
halfPixelOffset = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.usedForUI	get	
usedForUI = nil 
--*
--[Comment]
-- property: Vector3 UIPanelEX.drawCallOffset	get	
drawCallOffset = nil 
--*
--[Comment]
-- property: Clipping UIPanelEX.clipping	get	set	
clipping = nil 
--*
--[Comment]
-- property: UIPanel UIPanelEX.parentPanel	get	
parentPanel = nil 
--*
--[Comment]
-- property: Int32 UIPanelEX.clipCount	get	
clipCount = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.hasClipping	get	
hasClipping = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.hasCumulativeClipping	get	
hasCumulativeClipping = nil 
--*
--[Comment]
-- property: Vector2 UIPanelEX.clipOffset	get	set	
clipOffset = nil 
--*
--[Comment]
-- property: Texture2D UIPanelEX.clipTexture	get	set	
clipTexture = nil 
--*
--[Comment]
-- property: Vector4 UIPanelEX.baseClipRegion	get	set	
baseClipRegion = nil 
--*
--[Comment]
-- property: Vector4 UIPanelEX.finalClipRegion	get	
finalClipRegion = nil 
--*
--[Comment]
-- property: Vector2 UIPanelEX.clipSoftness	get	set	
clipSoftness = nil 
--*
--[Comment]
-- property: Vector3[] UIPanelEX.localCorners	get	
localCorners = nil 
--*
--[Comment]
-- property: Vector3[] UIPanelEX.worldCorners	get	
worldCorners = nil 
--*
--[Comment]
-- property: GameObject UIPanelEX.cachedGameObject	get	
cachedGameObject = nil 
--*
--[Comment]
-- property: Transform UIPanelEX.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Camera UIPanelEX.anchorCamera	get	
anchorCamera = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.isFullyAnchored	get	
isFullyAnchored = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.isAnchoredHorizontally	get	
isAnchoredHorizontally = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.isAnchoredVertically	get	
isAnchoredVertically = nil 
--*
--[Comment]
-- property: UIRect UIPanelEX.parent	get	
parent = nil 
--*
--[Comment]
-- property: UIRoot UIPanelEX.root	get	
root = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.isAnchored	get	
isAnchored = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIPanelEX.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIPanelEX.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIPanelEX.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIPanelEX.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIPanelEX.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIPanelEX.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIPanelEX:reset()
function reset() end 

----Vector3 UIPanelEX:CalculateConstrainOffset(Vector2 min,Vector2 max)
function CalculateConstrainOffset() end 

UILabel = {} 
--*
--[Comment]
--consturctor for UILabel overrides:
--*
--UILabel.New()
--*

function UILabel.New() end
--*
--[Comment]
-- property: Int32 UILabel.finalFontSize	get	
finalFontSize = nil 
--*
--[Comment]
-- property: Boolean UILabel.isAnchoredHorizontally	get	
isAnchoredHorizontally = nil 
--*
--[Comment]
-- property: Boolean UILabel.isAnchoredVertically	get	
isAnchoredVertically = nil 
--*
--[Comment]
-- property: Material UILabel.material	get	set	
material = nil 
--*
--[Comment]
-- property: UIFont UILabel.bitmapFont	get	set	
bitmapFont = nil 
--*
--[Comment]
-- property: Font UILabel.trueTypeFont	get	set	
trueTypeFont = nil 
--*
--[Comment]
-- property: Object UILabel.ambigiousFont	get	set	
ambigiousFont = nil 
--*
--[Comment]
-- property: String UILabel.text	get	set	
text = nil 
--*
--[Comment]
-- property: Int32 UILabel.defaultFontSize	get	
defaultFontSize = nil 
--*
--[Comment]
-- property: Int32 UILabel.fontSize	get	set	
fontSize = nil 
--*
--[Comment]
-- property: FontStyle UILabel.fontStyle	get	set	
fontStyle = nil 
--*
--[Comment]
-- property: Alignment UILabel.alignment	get	set	
alignment = nil 
--*
--[Comment]
-- property: Boolean UILabel.applyGradient	get	set	
applyGradient = nil 
--*
--[Comment]
-- property: Color UILabel.gradientTop	get	set	
gradientTop = nil 
--*
--[Comment]
-- property: Color UILabel.gradientBottom	get	set	
gradientBottom = nil 
--*
--[Comment]
-- property: Int32 UILabel.spacingX	get	set	
spacingX = nil 
--*
--[Comment]
-- property: Int32 UILabel.spacingY	get	set	
spacingY = nil 
--*
--[Comment]
-- property: Boolean UILabel.useFloatSpacing	get	set	
useFloatSpacing = nil 
--*
--[Comment]
-- property: Single UILabel.floatSpacingX	get	set	
floatSpacingX = nil 
--*
--[Comment]
-- property: Single UILabel.floatSpacingY	get	set	
floatSpacingY = nil 
--*
--[Comment]
-- property: Single UILabel.effectiveSpacingY	get	
effectiveSpacingY = nil 
--*
--[Comment]
-- property: Single UILabel.effectiveSpacingX	get	
effectiveSpacingX = nil 
--*
--[Comment]
-- property: Boolean UILabel.overflowEllipsis	get	set	
overflowEllipsis = nil 
--*
--[Comment]
-- property: Int32 UILabel.overflowWidth	get	set	
overflowWidth = nil 
--*
--[Comment]
-- property: Boolean UILabel.supportEncoding	get	set	
supportEncoding = nil 
--*
--[Comment]
-- property: SymbolStyle UILabel.symbolStyle	get	set	
symbolStyle = nil 
--*
--[Comment]
-- property: Overflow UILabel.overflowMethod	get	set	
overflowMethod = nil 
--*
--[Comment]
-- property: Boolean UILabel.multiLine	get	set	
multiLine = nil 
--*
--[Comment]
-- property: Vector3[] UILabel.localCorners	get	
localCorners = nil 
--*
--[Comment]
-- property: Vector3[] UILabel.worldCorners	get	
worldCorners = nil 
--*
--[Comment]
-- property: Vector4 UILabel.drawingDimensions	get	
drawingDimensions = nil 
--*
--[Comment]
-- property: Int32 UILabel.maxLineCount	get	set	
maxLineCount = nil 
--*
--[Comment]
-- property: Effect UILabel.effectStyle	get	set	
effectStyle = nil 
--*
--[Comment]
-- property: Color UILabel.effectColor	get	set	
effectColor = nil 
--*
--[Comment]
-- property: Vector2 UILabel.effectDistance	get	set	
effectDistance = nil 
--*
--[Comment]
-- property: String UILabel.processedText	get	
processedText = nil 
--*
--[Comment]
-- property: Vector2 UILabel.printedSize	get	
printedSize = nil 
--*
--[Comment]
-- property: Vector2 UILabel.localSize	get	
localSize = nil 
--*
--[Comment]
-- property: Modifier UILabel.modifier	get	set	
modifier = nil 
--*
--[Comment]
-- property: String UILabel.printedText	get	
printedText = nil 
--*
--[Comment]
-- property: OnRenderCallback UILabel.onRender	get	set	
onRender = nil 
--*
--[Comment]
-- property: Vector4 UILabel.drawRegion	get	set	
drawRegion = nil 
--*
--[Comment]
-- property: Vector2 UILabel.pivotOffset	get	
pivotOffset = nil 
--*
--[Comment]
-- property: Int32 UILabel.width	get	set	
width = nil 
--*
--[Comment]
-- property: Int32 UILabel.height	get	set	
height = nil 
--*
--[Comment]
-- property: Color UILabel.color	get	set	
color = nil 
--*
--[Comment]
-- property: Single UILabel.alpha	get	set	
alpha = nil 
--*
--[Comment]
-- property: Boolean UILabel.isVisible	get	
isVisible = nil 
--*
--[Comment]
-- property: Boolean UILabel.hasVertices	get	
hasVertices = nil 
--*
--[Comment]
-- property: Pivot UILabel.rawPivot	get	set	
rawPivot = nil 
--*
--[Comment]
-- property: Pivot UILabel.pivot	get	set	
pivot = nil 
--*
--[Comment]
-- property: Int32 UILabel.depth	get	set	
depth = nil 
--*
--[Comment]
-- property: Int32 UILabel.raycastDepth	get	
raycastDepth = nil 
--*
--[Comment]
-- property: Vector3 UILabel.localCenter	get	
localCenter = nil 
--*
--[Comment]
-- property: Vector3 UILabel.worldCenter	get	
worldCenter = nil 
--*
--[Comment]
-- property: Texture UILabel.mainTexture	get	set	
mainTexture = nil 
--*
--[Comment]
-- property: Shader UILabel.shader	get	set	
shader = nil 
--*
--[Comment]
-- property: Boolean UILabel.hasBoxCollider	get	
hasBoxCollider = nil 
--*
--[Comment]
-- property: Int32 UILabel.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Int32 UILabel.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Vector4 UILabel.border	get	set	
border = nil 
--*
--[Comment]
-- property: GameObject UILabel.cachedGameObject	get	
cachedGameObject = nil 
--*
--[Comment]
-- property: Transform UILabel.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Camera UILabel.anchorCamera	get	
anchorCamera = nil 
--*
--[Comment]
-- property: Boolean UILabel.isFullyAnchored	get	
isFullyAnchored = nil 
--*
--[Comment]
-- property: Boolean UILabel.canBeAnchored	get	
canBeAnchored = nil 
--*
--[Comment]
-- property: UIRect UILabel.parent	get	
parent = nil 
--*
--[Comment]
-- property: UIRoot UILabel.root	get	
root = nil 
--*
--[Comment]
-- property: Boolean UILabel.isAnchored	get	
isAnchored = nil 
--*
--[Comment]
-- property: Boolean UILabel.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UILabel.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UILabel.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UILabel.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UILabel.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UILabel.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UILabel.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UILabel.hideFlags	get	set	
hideFlags = nil 
--*
----Vector3[] UILabel:GetSides(Transform relativeTo)
function GetSides() end 

----Void UILabel:MarkAsChanged()
function MarkAsChanged() end 

----Void UILabel:ProcessText()
function ProcessText() end 

----Void UILabel:MakePixelPerfect()
function MakePixelPerfect() end 

----Void UILabel:AssumeNaturalSize()
function AssumeNaturalSize() end 

----Int32 UILabel:GetCharacterIndexAtPosition(Vector3 worldPos,Boolean precise)
--Int32 UILabel:GetCharacterIndexAtPosition(Vector2 localPos,Boolean precise)
function GetCharacterIndexAtPosition() end 

----String UILabel:GetWordAtPosition(Vector3 worldPos)
--String UILabel:GetWordAtPosition(Vector2 localPos)
function GetWordAtPosition() end 

----String UILabel:GetWordAtCharacterIndex(Int32 characterIndex)
function GetWordAtCharacterIndex() end 

----String UILabel:GetUrlAtPosition(Vector3 worldPos)
--String UILabel:GetUrlAtPosition(Vector2 localPos)
function GetUrlAtPosition() end 

----String UILabel:GetUrlAtCharacterIndex(Int32 characterIndex)
function GetUrlAtCharacterIndex() end 

----Int32 UILabel:GetCharacterIndex(Int32 currentIndex,KeyCode key)
function GetCharacterIndex() end 

----Void UILabel:PrintOverlay(Int32 start,Int32 end,UIGeometry caret,UIGeometry highlight,Color caretColor,Color highlightColor)
function PrintOverlay() end 

----Void UILabel:OnFill(BetterList`1 verts,BetterList`1 uvs,BetterList`1 cols)
function OnFill() end 

----Vector2 UILabel:ApplyOffset(BetterList`1 verts,Int32 start)
function ApplyOffset() end 

----Void UILabel:ApplyShadow(BetterList`1 verts,BetterList`1 uvs,BetterList`1 cols,Int32 start,Int32 end,Single x,Single y)
function ApplyShadow() end 

----Int32 UILabel:CalculateOffsetToFit(String text)
function CalculateOffsetToFit() end 

----Void UILabel:SetCurrentProgress()
function SetCurrentProgress() end 

----Void UILabel:SetCurrentPercent()
function SetCurrentPercent() end 

----Void UILabel:SetCurrentSelection()
function SetCurrentSelection() end 

----Boolean UILabel:Wrap(String text,String& final)
--Boolean UILabel:Wrap(String text,String& final,Int32 height)
function Wrap() end 

----Void UILabel:UpdateNGUIText()
function UpdateNGUIText() end 

UIAtlas = {} 
--*
--[Comment]
--consturctor for UIAtlas overrides:
--*
--UIAtlas.New()
--*

function UIAtlas.New() end
--*
--[Comment]
-- property: Material UIAtlas.spriteMaterial	get	set	
spriteMaterial = nil 
--*
--[Comment]
-- property: Boolean UIAtlas.premultipliedAlpha	get	
premultipliedAlpha = nil 
--*
--[Comment]
-- property: List`1 UIAtlas.spriteList	get	set	
spriteList = nil 
--*
--[Comment]
-- property: Texture UIAtlas.texture	get	
texture = nil 
--*
--[Comment]
-- property: Single UIAtlas.pixelSize	get	set	
pixelSize = nil 
--*
--[Comment]
-- property: UIAtlas UIAtlas.replacement	get	set	
replacement = nil 
--*
--[Comment]
-- property: Boolean UIAtlas.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIAtlas.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIAtlas.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIAtlas.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIAtlas.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIAtlas.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIAtlas.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIAtlas.hideFlags	get	set	
hideFlags = nil 
--*
----UISpriteData UIAtlas:GetSprite(String name)
function GetSprite() end 

----String UIAtlas:GetRandomSprite(String startsWith)
function GetRandomSprite() end 

----Void UIAtlas:MarkSpriteListAsChanged()
function MarkSpriteListAsChanged() end 

----Void UIAtlas:SortAlphabetically()
function SortAlphabetically() end 

----BetterList`1 UIAtlas:GetListOfSprites()
--BetterList`1 UIAtlas:GetListOfSprites(String match)
function GetListOfSprites() end 

----Boolean UIAtlas.CheckIfRelated(UIAtlas a,UIAtlas b)
function UIAtlas.CheckIfRelated() end 

----Void UIAtlas:MarkAsChanged()
function MarkAsChanged() end 

UISprite = {} 
--*
--[Comment]
--consturctor for UISprite overrides:
--*
--UISprite.New()
--*

function UISprite.New() end
--*
--[Comment]
-- property: Material UISprite.material	get	
material = nil 
--*
--[Comment]
-- property: UIAtlas UISprite.atlas	get	set	
atlas = nil 
--*
--[Comment]
-- property: String UISprite.spriteName	get	set	
spriteName = nil 
--*
--[Comment]
-- property: Boolean UISprite.isValid	get	
isValid = nil 
--*
--[Comment]
-- property: Boolean UISprite.applyGradient	get	set	
applyGradient = nil 
--*
--[Comment]
-- property: Color UISprite.gradientTop	get	set	
gradientTop = nil 
--*
--[Comment]
-- property: Color UISprite.gradientBottom	get	set	
gradientBottom = nil 
--*
--[Comment]
-- property: Vector4 UISprite.border	get	
border = nil 
--*
--[Comment]
-- property: Single UISprite.pixelSize	get	
pixelSize = nil 
--*
--[Comment]
-- property: Int32 UISprite.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Int32 UISprite.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Vector4 UISprite.drawingDimensions	get	
drawingDimensions = nil 
--*
--[Comment]
-- property: Boolean UISprite.premultipliedAlpha	get	
premultipliedAlpha = nil 
--*
--[Comment]
-- property: Type UISprite.type	get	set	
type = nil 
--*
--[Comment]
-- property: Flip UISprite.flip	get	set	
flip = nil 
--*
--[Comment]
-- property: FillDirection UISprite.fillDirection	get	set	
fillDirection = nil 
--*
--[Comment]
-- property: Single UISprite.fillAmount	get	set	
fillAmount = nil 
--*
--[Comment]
-- property: Boolean UISprite.invert	get	set	
invert = nil 
--*
--[Comment]
-- property: Boolean UISprite.hasBorder	get	
hasBorder = nil 
--*
--[Comment]
-- property: OnRenderCallback UISprite.onRender	get	set	
onRender = nil 
--*
--[Comment]
-- property: Vector4 UISprite.drawRegion	get	set	
drawRegion = nil 
--*
--[Comment]
-- property: Vector2 UISprite.pivotOffset	get	
pivotOffset = nil 
--*
--[Comment]
-- property: Int32 UISprite.width	get	set	
width = nil 
--*
--[Comment]
-- property: Int32 UISprite.height	get	set	
height = nil 
--*
--[Comment]
-- property: Color UISprite.color	get	set	
color = nil 
--*
--[Comment]
-- property: Single UISprite.alpha	get	set	
alpha = nil 
--*
--[Comment]
-- property: Boolean UISprite.isVisible	get	
isVisible = nil 
--*
--[Comment]
-- property: Boolean UISprite.hasVertices	get	
hasVertices = nil 
--*
--[Comment]
-- property: Pivot UISprite.rawPivot	get	set	
rawPivot = nil 
--*
--[Comment]
-- property: Pivot UISprite.pivot	get	set	
pivot = nil 
--*
--[Comment]
-- property: Int32 UISprite.depth	get	set	
depth = nil 
--*
--[Comment]
-- property: Int32 UISprite.raycastDepth	get	
raycastDepth = nil 
--*
--[Comment]
-- property: Vector3[] UISprite.localCorners	get	
localCorners = nil 
--*
--[Comment]
-- property: Vector2 UISprite.localSize	get	
localSize = nil 
--*
--[Comment]
-- property: Vector3 UISprite.localCenter	get	
localCenter = nil 
--*
--[Comment]
-- property: Vector3[] UISprite.worldCorners	get	
worldCorners = nil 
--*
--[Comment]
-- property: Vector3 UISprite.worldCenter	get	
worldCenter = nil 
--*
--[Comment]
-- property: Texture UISprite.mainTexture	get	set	
mainTexture = nil 
--*
--[Comment]
-- property: Shader UISprite.shader	get	set	
shader = nil 
--*
--[Comment]
-- property: Boolean UISprite.hasBoxCollider	get	
hasBoxCollider = nil 
--*
--[Comment]
-- property: GameObject UISprite.cachedGameObject	get	
cachedGameObject = nil 
--*
--[Comment]
-- property: Transform UISprite.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Camera UISprite.anchorCamera	get	
anchorCamera = nil 
--*
--[Comment]
-- property: Boolean UISprite.isFullyAnchored	get	
isFullyAnchored = nil 
--*
--[Comment]
-- property: Boolean UISprite.isAnchoredHorizontally	get	
isAnchoredHorizontally = nil 
--*
--[Comment]
-- property: Boolean UISprite.isAnchoredVertically	get	
isAnchoredVertically = nil 
--*
--[Comment]
-- property: Boolean UISprite.canBeAnchored	get	
canBeAnchored = nil 
--*
--[Comment]
-- property: UIRect UISprite.parent	get	
parent = nil 
--*
--[Comment]
-- property: UIRoot UISprite.root	get	
root = nil 
--*
--[Comment]
-- property: Boolean UISprite.isAnchored	get	
isAnchored = nil 
--*
--[Comment]
-- property: Boolean UISprite.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UISprite.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UISprite.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UISprite.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UISprite.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UISprite.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UISprite.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UISprite.hideFlags	get	set	
hideFlags = nil 
--*
----UISpriteData UISprite:GetAtlasSprite()
function GetAtlasSprite() end 

----Void UISprite:MakePixelPerfect()
function MakePixelPerfect() end 

----Void UISprite:OnFill(BetterList`1 verts,BetterList`1 uvs,BetterList`1 cols)
function OnFill() end 

UISlider = {} 
--*
--[Comment]
--consturctor for UISlider overrides:
--*
--UISlider.New()
--*

function UISlider.New() end
--*
--[Comment]
-- property: Boolean UISlider.isColliderEnabled	get	
isColliderEnabled = nil 
--*
--[Comment]
-- property: Transform UISlider.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Camera UISlider.cachedCamera	get	
cachedCamera = nil 
--*
--[Comment]
-- property: UIWidget UISlider.foregroundWidget	get	set	
foregroundWidget = nil 
--*
--[Comment]
-- property: UIWidget UISlider.backgroundWidget	get	set	
backgroundWidget = nil 
--*
--[Comment]
-- property: FillDirection UISlider.fillDirection	get	set	
fillDirection = nil 
--*
--[Comment]
-- property: Single UISlider.value	get	set	
value = nil 
--*
--[Comment]
-- property: Single UISlider.alpha	get	set	
alpha = nil 
--*
--[Comment]
-- property: Boolean UISlider.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UISlider.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UISlider.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UISlider.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UISlider.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UISlider.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UISlider.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UISlider.hideFlags	get	set	
hideFlags = nil 
--*
----Void UISlider:OnPan(Vector2 delta)
function OnPan() end 

UIGrid = {} 
--*
--[Comment]
--consturctor for UIGrid overrides:
--*
--UIGrid.New()
--*

function UIGrid.New() end
--*
--[Comment]
-- property: Boolean UIGrid.repositionNow	set	
repositionNow = nil 
--*
--[Comment]
-- property: Boolean UIGrid.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIGrid.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIGrid.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIGrid.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIGrid.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIGrid.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIGrid.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIGrid.hideFlags	get	set	
hideFlags = nil 
--*
----List`1 UIGrid:GetChildList()
function GetChildList() end 

----Transform UIGrid:GetChild(Int32 index)
function GetChild() end 

----Int32 UIGrid:GetIndex(Transform trans)
function GetIndex() end 

----Void UIGrid:AddChild(Transform trans)
--Void UIGrid:AddChild(Transform trans,Boolean sort)
function AddChild() end 

----Boolean UIGrid:RemoveChild(Transform t)
function RemoveChild() end 

----Int32 UIGrid.SortByName(Transform a,Transform b)
function UIGrid.SortByName() end 

----Int32 UIGrid.SortHorizontal(Transform a,Transform b)
function UIGrid.SortHorizontal() end 

----Int32 UIGrid.SortVertical(Transform a,Transform b)
function UIGrid.SortVertical() end 

----Void UIGrid:Reposition()
function Reposition() end 

----Void UIGrid:ConstrainWithinPanel()
function ConstrainWithinPanel() end 

UITable = {} 
--*
--[Comment]
--consturctor for UITable overrides:
--*
--UITable.New()
--*

function UITable.New() end
--*
--[Comment]
-- property: Boolean UITable.repositionNow	set	
repositionNow = nil 
--*
--[Comment]
-- property: Boolean UITable.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UITable.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UITable.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UITable.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UITable.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UITable.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UITable.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UITable.hideFlags	get	set	
hideFlags = nil 
--*
----List`1 UITable:GetChildList()
function GetChildList() end 

----Void UITable:Reposition()
function Reposition() end 

UIInput = {} 
--*
--[Comment]
--consturctor for UIInput overrides:
--*
--UIInput.New()
--*

function UIInput.New() end
--*
--[Comment]
-- property: String UIInput.defaultText	get	set	
defaultText = nil 
--*
--[Comment]
-- property: Color UIInput.defaultColor	get	set	
defaultColor = nil 
--*
--[Comment]
-- property: Boolean UIInput.inputShouldBeHidden	get	
inputShouldBeHidden = nil 
--*
--[Comment]
-- property: String UIInput.value	get	set	
value = nil 
--*
--[Comment]
-- property: Boolean UIInput.isSelected	get	set	
isSelected = nil 
--*
--[Comment]
-- property: Int32 UIInput.cursorPosition	get	set	
cursorPosition = nil 
--*
--[Comment]
-- property: Int32 UIInput.selectionStart	get	set	
selectionStart = nil 
--*
--[Comment]
-- property: Int32 UIInput.selectionEnd	get	set	
selectionEnd = nil 
--*
--[Comment]
-- property: UITexture UIInput.caret	get	
caret = nil 
--*
--[Comment]
-- property: Boolean UIInput.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIInput.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIInput.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIInput.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIInput.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIInput.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIInput.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIInput.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIInput:Set(String value,Boolean notify)
function Set() end 

----String UIInput:Validate(String val)
function Validate() end 

----Void UIInput:Start()
function Start() end 

----Boolean UIInput:ProcessEvent(Event ev)
function ProcessEvent() end 

----Void UIInput:Submit()
function Submit() end 

----Void UIInput:UpdateLabel()
function UpdateLabel() end 

----Void UIInput:RemoveFocus()
function RemoveFocus() end 

----Void UIInput:SaveValue()
function SaveValue() end 

----Void UIInput:LoadValue()
function LoadValue() end 

UIToggle = {} 
--*
--[Comment]
--consturctor for UIToggle overrides:
--*
--UIToggle.New()
--*

function UIToggle.New() end
--*
--[Comment]
-- property: Boolean UIToggle.value	get	set	
value = nil 
--*
--[Comment]
-- property: Boolean UIToggle.isColliderEnabled	get	
isColliderEnabled = nil 
--*
--[Comment]
-- property: Boolean UIToggle.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIToggle.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIToggle.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIToggle.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIToggle.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIToggle.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIToggle.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIToggle.hideFlags	get	set	
hideFlags = nil 
--*
----UIToggle UIToggle.GetActiveToggle(Int32 group)
function UIToggle.GetActiveToggle() end 

----Void UIToggle:Start()
function Start() end 

----Void UIToggle:Set(Boolean state,Boolean notify)
function Set() end 

UITexture = {} 
--*
--[Comment]
--consturctor for UITexture overrides:
--*
--UITexture.New()
--*

function UITexture.New() end
--*
--[Comment]
-- property: Texture UITexture.mainTexture	get	set	
mainTexture = nil 
--*
--[Comment]
-- property: Material UITexture.material	get	set	
material = nil 
--*
--[Comment]
-- property: Shader UITexture.shader	get	set	
shader = nil 
--*
--[Comment]
-- property: Boolean UITexture.premultipliedAlpha	get	
premultipliedAlpha = nil 
--*
--[Comment]
-- property: Vector4 UITexture.border	get	set	
border = nil 
--*
--[Comment]
-- property: Rect UITexture.uvRect	get	set	
uvRect = nil 
--*
--[Comment]
-- property: Vector4 UITexture.drawingDimensions	get	
drawingDimensions = nil 
--*
--[Comment]
-- property: Boolean UITexture.fixedAspect	get	set	
fixedAspect = nil 
--*
--[Comment]
-- property: Type UITexture.type	get	set	
type = nil 
--*
--[Comment]
-- property: Flip UITexture.flip	get	set	
flip = nil 
--*
--[Comment]
-- property: FillDirection UITexture.fillDirection	get	set	
fillDirection = nil 
--*
--[Comment]
-- property: Single UITexture.fillAmount	get	set	
fillAmount = nil 
--*
--[Comment]
-- property: Int32 UITexture.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Int32 UITexture.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Boolean UITexture.invert	get	set	
invert = nil 
--*
--[Comment]
-- property: Boolean UITexture.hasBorder	get	
hasBorder = nil 
--*
--[Comment]
-- property: Single UITexture.pixelSize	get	
pixelSize = nil 
--*
--[Comment]
-- property: OnRenderCallback UITexture.onRender	get	set	
onRender = nil 
--*
--[Comment]
-- property: Vector4 UITexture.drawRegion	get	set	
drawRegion = nil 
--*
--[Comment]
-- property: Vector2 UITexture.pivotOffset	get	
pivotOffset = nil 
--*
--[Comment]
-- property: Int32 UITexture.width	get	set	
width = nil 
--*
--[Comment]
-- property: Int32 UITexture.height	get	set	
height = nil 
--*
--[Comment]
-- property: Color UITexture.color	get	set	
color = nil 
--*
--[Comment]
-- property: Single UITexture.alpha	get	set	
alpha = nil 
--*
--[Comment]
-- property: Boolean UITexture.isVisible	get	
isVisible = nil 
--*
--[Comment]
-- property: Boolean UITexture.hasVertices	get	
hasVertices = nil 
--*
--[Comment]
-- property: Pivot UITexture.rawPivot	get	set	
rawPivot = nil 
--*
--[Comment]
-- property: Pivot UITexture.pivot	get	set	
pivot = nil 
--*
--[Comment]
-- property: Int32 UITexture.depth	get	set	
depth = nil 
--*
--[Comment]
-- property: Int32 UITexture.raycastDepth	get	
raycastDepth = nil 
--*
--[Comment]
-- property: Vector3[] UITexture.localCorners	get	
localCorners = nil 
--*
--[Comment]
-- property: Vector2 UITexture.localSize	get	
localSize = nil 
--*
--[Comment]
-- property: Vector3 UITexture.localCenter	get	
localCenter = nil 
--*
--[Comment]
-- property: Vector3[] UITexture.worldCorners	get	
worldCorners = nil 
--*
--[Comment]
-- property: Vector3 UITexture.worldCenter	get	
worldCenter = nil 
--*
--[Comment]
-- property: Boolean UITexture.hasBoxCollider	get	
hasBoxCollider = nil 
--*
--[Comment]
-- property: GameObject UITexture.cachedGameObject	get	
cachedGameObject = nil 
--*
--[Comment]
-- property: Transform UITexture.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Camera UITexture.anchorCamera	get	
anchorCamera = nil 
--*
--[Comment]
-- property: Boolean UITexture.isFullyAnchored	get	
isFullyAnchored = nil 
--*
--[Comment]
-- property: Boolean UITexture.isAnchoredHorizontally	get	
isAnchoredHorizontally = nil 
--*
--[Comment]
-- property: Boolean UITexture.isAnchoredVertically	get	
isAnchoredVertically = nil 
--*
--[Comment]
-- property: Boolean UITexture.canBeAnchored	get	
canBeAnchored = nil 
--*
--[Comment]
-- property: UIRect UITexture.parent	get	
parent = nil 
--*
--[Comment]
-- property: UIRoot UITexture.root	get	
root = nil 
--*
--[Comment]
-- property: Boolean UITexture.isAnchored	get	
isAnchored = nil 
--*
--[Comment]
-- property: Boolean UITexture.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UITexture.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UITexture.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UITexture.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UITexture.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UITexture.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UITexture.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UITexture.hideFlags	get	set	
hideFlags = nil 
--*
----Void UITexture:MakePixelPerfect()
function MakePixelPerfect() end 

----Void UITexture:OnFill(BetterList`1 verts,BetterList`1 uvs,BetterList`1 cols)
function OnFill() end 

UIScrollView = {} 
--*
--[Comment]
--consturctor for UIScrollView overrides:
--*
--UIScrollView.New()
--*

function UIScrollView.New() end
--*
--[Comment]
-- property: UIPanel UIScrollView.panel	get	
panel = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.isDragging	get	
isDragging = nil 
--*
--[Comment]
-- property: Bounds UIScrollView.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.canMoveHorizontally	get	
canMoveHorizontally = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.canMoveVertically	get	
canMoveVertically = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.shouldMoveHorizontally	get	
shouldMoveHorizontally = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.shouldMoveVertically	get	
shouldMoveVertically = nil 
--*
--[Comment]
-- property: Vector3 UIScrollView.currentMomentum	get	set	
currentMomentum = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIScrollView.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIScrollView.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIScrollView.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIScrollView.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIScrollView.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIScrollView.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean UIScrollView:RestrictWithinBounds(Boolean instant)
--Boolean UIScrollView:RestrictWithinBounds(Boolean instant,Boolean horizontal,Boolean vertical)
function RestrictWithinBounds() end 

----Void UIScrollView:DisableSpring()
function DisableSpring() end 

----Void UIScrollView:UpdateScrollbars()
--Void UIScrollView:UpdateScrollbars(Boolean recalculateBounds)
function UpdateScrollbars() end 

----Void UIScrollView:SetDragAmount(Single x,Single y,Boolean updateScrollbars)
function SetDragAmount() end 

----Void UIScrollView:InvalidateBounds()
function InvalidateBounds() end 

----Void UIScrollView:ResetPosition()
function ResetPosition() end 

----Void UIScrollView:UpdatePosition()
function UpdatePosition() end 

----Void UIScrollView:OnScrollBar()
function OnScrollBar() end 

----Void UIScrollView:MoveRelative(Vector3 relative)
function MoveRelative() end 

----Void UIScrollView:MoveAbsolute(Vector3 absolute)
function MoveAbsolute() end 

----Void UIScrollView:Press(Boolean pressed)
function Press() end 

----Void UIScrollView:Drag()
function Drag() end 

----Void UIScrollView:Scroll(Single delta)
function Scroll() end 

----Void UIScrollView:OnPan(Vector2 delta)
function OnPan() end 

UICamera = {} 
--*
--[Comment]
--consturctor for UICamera overrides:
--*
--UICamera.New()
--*

function UICamera.New() end
--*
--[Comment]
-- property: Boolean UICamera.disableController	get	set	
disableController = nil 
--*
--[Comment]
-- property: Vector2 UICamera.lastEventPosition	get	set	
lastEventPosition = nil 
--*
--[Comment]
-- property: UICamera UICamera.first	get	
first = nil 
--*
--[Comment]
-- property: ControlScheme UICamera.currentScheme	get	set	
currentScheme = nil 
--*
--[Comment]
-- property: KeyCode UICamera.currentKey	get	set	
currentKey = nil 
--*
--[Comment]
-- property: Ray UICamera.currentRay	get	
currentRay = nil 
--*
--[Comment]
-- property: Boolean UICamera.inputHasFocus	get	
inputHasFocus = nil 
--*
--[Comment]
-- property: Camera UICamera.cachedCamera	get	
cachedCamera = nil 
--*
--[Comment]
-- property: GameObject UICamera.tooltipObject	get	
tooltipObject = nil 
--*
--[Comment]
-- property: Boolean UICamera.isOverUI	get	
isOverUI = nil 
--*
--[Comment]
-- property: GameObject UICamera.hoveredObject	get	set	
hoveredObject = nil 
--*
--[Comment]
-- property: GameObject UICamera.controllerNavigationObject	get	set	
controllerNavigationObject = nil 
--*
--[Comment]
-- property: GameObject UICamera.selectedObject	get	set	
selectedObject = nil 
--*
--[Comment]
-- property: Int32 UICamera.dragCount	get	
dragCount = nil 
--*
--[Comment]
-- property: Camera UICamera.mainCamera	get	
mainCamera = nil 
--*
--[Comment]
-- property: UICamera UICamera.eventHandler	get	
eventHandler = nil 
--*
--[Comment]
-- property: Boolean UICamera.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UICamera.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UICamera.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UICamera.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UICamera.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UICamera.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UICamera.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UICamera.hideFlags	get	set	
hideFlags = nil 
--*
----Boolean UICamera.IsPressed(GameObject go)
function UICamera.IsPressed() end 

----Int32 UICamera.CountInputSources()
function UICamera.CountInputSources() end 

----Void UICamera.Raycast(MouseOrTouch touch)
--Boolean UICamera.Raycast(Vector3 inPos)
function UICamera.Raycast() end 

----Boolean UICamera.IsHighlighted(GameObject go)
function UICamera.IsHighlighted() end 

----UICamera UICamera.FindCameraForLayer(Int32 layer)
function UICamera.FindCameraForLayer() end 

----Void UICamera.Notify(GameObject go,String funcName,Object obj)
function UICamera.Notify() end 

----MouseOrTouch UICamera.GetMouse(Int32 button)
function UICamera.GetMouse() end 

----MouseOrTouch UICamera.GetTouch(Int32 id,Boolean createIfMissing)
function UICamera.GetTouch() end 

----Void UICamera.RemoveTouch(Int32 id)
function UICamera.RemoveTouch() end 

----Void UICamera:ProcessMouse()
function ProcessMouse() end 

----Void UICamera:ProcessTouches()
function ProcessTouches() end 

----Void UICamera:ProcessOthers()
function ProcessOthers() end 

----Void UICamera:ProcessTouch(Boolean pressed,Boolean released)
function ProcessTouch() end 

----Void UICamera.CancelNextTooltip()
function UICamera.CancelNextTooltip() end 

----Boolean UICamera.ShowTooltip(GameObject go)
function UICamera.ShowTooltip() end 

----Boolean UICamera.HideTooltip()
function UICamera.HideTooltip() end 

UIWidget = {} 
--*
--[Comment]
--consturctor for UIWidget overrides:
--*
--UIWidget.New()
--*

function UIWidget.New() end
--*
--[Comment]
-- property: OnRenderCallback UIWidget.onRender	get	set	
onRender = nil 
--*
--[Comment]
-- property: Vector4 UIWidget.drawRegion	get	set	
drawRegion = nil 
--*
--[Comment]
-- property: Vector2 UIWidget.pivotOffset	get	
pivotOffset = nil 
--*
--[Comment]
-- property: Int32 UIWidget.width	get	set	
width = nil 
--*
--[Comment]
-- property: Int32 UIWidget.height	get	set	
height = nil 
--*
--[Comment]
-- property: Color UIWidget.color	get	set	
color = nil 
--*
--[Comment]
-- property: Single UIWidget.alpha	get	set	
alpha = nil 
--*
--[Comment]
-- property: Boolean UIWidget.isVisible	get	
isVisible = nil 
--*
--[Comment]
-- property: Boolean UIWidget.hasVertices	get	
hasVertices = nil 
--*
--[Comment]
-- property: Pivot UIWidget.rawPivot	get	set	
rawPivot = nil 
--*
--[Comment]
-- property: Pivot UIWidget.pivot	get	set	
pivot = nil 
--*
--[Comment]
-- property: Int32 UIWidget.depth	get	set	
depth = nil 
--*
--[Comment]
-- property: Int32 UIWidget.raycastDepth	get	
raycastDepth = nil 
--*
--[Comment]
-- property: Vector3[] UIWidget.localCorners	get	
localCorners = nil 
--*
--[Comment]
-- property: Vector2 UIWidget.localSize	get	
localSize = nil 
--*
--[Comment]
-- property: Vector3 UIWidget.localCenter	get	
localCenter = nil 
--*
--[Comment]
-- property: Vector3[] UIWidget.worldCorners	get	
worldCorners = nil 
--*
--[Comment]
-- property: Vector3 UIWidget.worldCenter	get	
worldCenter = nil 
--*
--[Comment]
-- property: Vector4 UIWidget.drawingDimensions	get	
drawingDimensions = nil 
--*
--[Comment]
-- property: Material UIWidget.material	get	set	
material = nil 
--*
--[Comment]
-- property: Texture UIWidget.mainTexture	get	set	
mainTexture = nil 
--*
--[Comment]
-- property: Shader UIWidget.shader	get	set	
shader = nil 
--*
--[Comment]
-- property: Boolean UIWidget.hasBoxCollider	get	
hasBoxCollider = nil 
--*
--[Comment]
-- property: Boolean UIWidget.showHandlesWithMoveTool	get	set	
showHandlesWithMoveTool = nil 
--*
--[Comment]
-- property: Boolean UIWidget.showHandles	get	
showHandles = nil 
--*
--[Comment]
-- property: Int32 UIWidget.minWidth	get	
minWidth = nil 
--*
--[Comment]
-- property: Int32 UIWidget.minHeight	get	
minHeight = nil 
--*
--[Comment]
-- property: Vector4 UIWidget.border	get	set	
border = nil 
--*
--[Comment]
-- property: GameObject UIWidget.cachedGameObject	get	
cachedGameObject = nil 
--*
--[Comment]
-- property: Transform UIWidget.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Camera UIWidget.anchorCamera	get	
anchorCamera = nil 
--*
--[Comment]
-- property: Boolean UIWidget.isFullyAnchored	get	
isFullyAnchored = nil 
--*
--[Comment]
-- property: Boolean UIWidget.isAnchoredHorizontally	get	
isAnchoredHorizontally = nil 
--*
--[Comment]
-- property: Boolean UIWidget.isAnchoredVertically	get	
isAnchoredVertically = nil 
--*
--[Comment]
-- property: Boolean UIWidget.canBeAnchored	get	
canBeAnchored = nil 
--*
--[Comment]
-- property: UIRect UIWidget.parent	get	
parent = nil 
--*
--[Comment]
-- property: UIRoot UIWidget.root	get	
root = nil 
--*
--[Comment]
-- property: Boolean UIWidget.isAnchored	get	
isAnchored = nil 
--*
--[Comment]
-- property: Boolean UIWidget.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIWidget.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIWidget.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIWidget.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIWidget.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIWidget.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIWidget.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIWidget.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIWidget:SetDimensions(Int32 w,Int32 h)
function SetDimensions() end 

----Vector3[] UIWidget:GetSides(Transform relativeTo)
function GetSides() end 

----Single UIWidget:CalculateFinalAlpha(Int32 frameID)
function CalculateFinalAlpha() end 

----Void UIWidget:Invalidate(Boolean includeChildren)
function Invalidate() end 

----Single UIWidget:CalculateCumulativeAlpha(Int32 frameID)
function CalculateCumulativeAlpha() end 

----Void UIWidget:SetRect(Single x,Single y,Single width,Single height)
function SetRect() end 

----Void UIWidget:ResizeCollider()
function ResizeCollider() end 

----Int32 UIWidget.FullCompareFunc(UIWidget left,UIWidget right)
function UIWidget.FullCompareFunc() end 

----Int32 UIWidget.PanelCompareFunc(UIWidget left,UIWidget right)
function UIWidget.PanelCompareFunc() end 

----Bounds UIWidget:CalculateBounds()
--Bounds UIWidget:CalculateBounds(Transform relativeParent)
function CalculateBounds() end 

----Void UIWidget:SetDirty()
function SetDirty() end 

----Void UIWidget:RemoveFromPanel()
function RemoveFromPanel() end 

----Void UIWidget:MarkAsChanged()
function MarkAsChanged() end 

----UIPanel UIWidget:CreatePanel()
function CreatePanel() end 

----Void UIWidget:CheckLayer()
function CheckLayer() end 

----Void UIWidget:ParentHasChanged()
function ParentHasChanged() end 

----Boolean UIWidget:UpdateVisibility(Boolean visibleByAlpha,Boolean visibleByPanel)
function UpdateVisibility() end 

----Boolean UIWidget:UpdateTransform(Int32 frame)
function UpdateTransform() end 

----Boolean UIWidget:UpdateGeometry(Int32 frame)
function UpdateGeometry() end 

----Void UIWidget:WriteToBuffers(BetterList`1 v,BetterList`1 u,BetterList`1 c,BetterList`1 n,BetterList`1 t)
function WriteToBuffers() end 

----Void UIWidget:MakePixelPerfect()
function MakePixelPerfect() end 

----Void UIWidget:OnFill(BetterList`1 verts,BetterList`1 uvs,BetterList`1 cols)
function OnFill() end 

AnchorUpdate = {} 

OnEnable = nil;

OnUpdate = nil;

OnStart = nil;

TweenScale = {} 
--*
--[Comment]
--consturctor for TweenScale overrides:
--*
--TweenScale.New()
--*

function TweenScale.New() end
--*
--[Comment]
-- property: Transform TweenScale.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Vector3 TweenScale.value	get	set	
value = nil 
--*
--[Comment]
-- property: Single TweenScale.amountPerDelta	get	
amountPerDelta = nil 
--*
--[Comment]
-- property: Single TweenScale.tweenFactor	get	set	
tweenFactor = nil 
--*
--[Comment]
-- property: Direction TweenScale.direction	get	
direction = nil 
--*
--[Comment]
-- property: Boolean TweenScale.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean TweenScale.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean TweenScale.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform TweenScale.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject TweenScale.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String TweenScale.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String TweenScale.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags TweenScale.hideFlags	get	set	
hideFlags = nil 
--*
----TweenScale TweenScale.Begin(GameObject go,Single duration,Vector3 scale)
function TweenScale.Begin() end 

----Void TweenScale:SetStartToCurrentValue()
function SetStartToCurrentValue() end 

----Void TweenScale:SetEndToCurrentValue()
function SetEndToCurrentValue() end 

TweenPosition = {} 
--*
--[Comment]
--consturctor for TweenPosition overrides:
--*
--TweenPosition.New()
--*

function TweenPosition.New() end
--*
--[Comment]
-- property: Transform TweenPosition.cachedTransform	get	
cachedTransform = nil 
--*
--[Comment]
-- property: Vector3 TweenPosition.value	get	set	
value = nil 
--*
--[Comment]
-- property: Single TweenPosition.amountPerDelta	get	
amountPerDelta = nil 
--*
--[Comment]
-- property: Single TweenPosition.tweenFactor	get	set	
tweenFactor = nil 
--*
--[Comment]
-- property: Direction TweenPosition.direction	get	
direction = nil 
--*
--[Comment]
-- property: Boolean TweenPosition.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean TweenPosition.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean TweenPosition.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform TweenPosition.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject TweenPosition.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String TweenPosition.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String TweenPosition.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags TweenPosition.hideFlags	get	set	
hideFlags = nil 
--*
----TweenPosition TweenPosition.Begin(GameObject go,Single duration,Vector3 pos)
--TweenPosition TweenPosition.Begin(GameObject go,Single duration,Vector3 pos,Boolean worldSpace)
function TweenPosition.Begin() end 

----Void TweenPosition:SetStartToCurrentValue()
function SetStartToCurrentValue() end 

----Void TweenPosition:SetEndToCurrentValue()
function SetEndToCurrentValue() end 

Types = {} 
--*
----Type Types.GetType(String typeName,String assemblyName)
function Types.GetType() end 

TimeTicker = {} 
--*
--[Comment]
--consturctor for TimeTicker overrides:
--*
--TimeTicker.New()
--*

function TimeTicker.New() end
--*
--[Comment]
-- property: Single TimeTicker.TotalTime	get	set	
TotalTime = nil 
--*
--[Comment]
-- property: Single TimeTicker.NowTime	get	set	
NowTime = nil 
--*
--[Comment]
-- property: Single TimeTicker.OverTime	get	
OverTime = nil 
--*
--[Comment]
-- property: Boolean TimeTicker.IsTicking	get	set	
IsTicking = nil 
--*
--[Comment]
-- property: Boolean TimeTicker.IsReverse	get	set	
IsReverse = nil 
--*
----Void TimeTicker:Start(Single time)
function Start() end 

----Void TimeTicker:StartReverse(Single time)
function StartReverse() end 

----Void TimeTicker:Pause(Boolean pause)
function Pause() end 

----Boolean TimeTicker:IsPause()
function IsPause() end 

----Void TimeTicker:Stop()
function Stop() end 

TimerManager = {} 
--*
--[Comment]
--consturctor for TimerManager overrides:
--*
--TimerManager.New()
--*

function TimerManager.New() end
--*
--[Comment]
-- property: TimerManager TimerManager.Single	get	
Single = nil 
--*
--[Comment]
-- property: Double TimerManager.StartTimerTick	get	
StartTimerTick = nil 
--*
----Void TimerManager:AddTimer(Timer timer)
function AddTimer() end 

----Void TimerManager:RemoveTimer(Timer timer)
function RemoveTimer() end 

----Void TimerManager:Do()
function Do() end 

----Boolean TimerManager:DoOnce(Double time)
function DoOnce() end 

----Boolean TimerManager:IsEnd()
function IsEnd() end 

----Void TimerManager:OnDestroy()
function OnDestroy() end 

Timer = {} 
--*
--[Comment]
--consturctor for Timer overrides:
--*
--Timer.New(Single liveTime,Boolean isLoop)
--*

--Timer.New(Single liveTime,Single outTime)
--*

function Timer.New() end
--*
--[Comment]
-- property: Boolean Timer.IsPause	get	set	
IsPause = nil 
--*
--[Comment]
-- property: Boolean Timer.IsLoop	get	set	
IsLoop = nil 
--*
--[Comment]
-- property: Single Timer.LoopTime	get	set	
LoopTime = nil 
--*
--[Comment]
-- property: Single Timer.OutTime	get	set	
OutTime = nil 
--*
--[Comment]
-- property: Double Timer.StartTime	get	set	
StartTime = nil 
--*
--[Comment]
-- property: Action Timer.TimesUpDo	get	set	
TimesUpDo = nil 
--*
--[Comment]
-- property: Action Timer.KillDo	get	set	
KillDo = nil 
--*
--[Comment]
-- property: Boolean Timer.IsStop	get	set	
IsStop = nil 
--*
--[Comment]
-- property: Double Timer.StopTime	get	
StopTime = nil 
--*
----Timer Timer:Start()
function Start() end 

----Timer Timer:OnCompleteCallback(Action completeCallback)
function OnCompleteCallback() end 

----Timer Timer:OnKill(Action onKill)
function OnKill() end 

----Void Timer:Kill()
function Kill() end 

----Void Timer:NextTick()
function NextTick() end 

----Void Timer:Pause()
function Pause() end 

----Void Timer:GoOn()
function GoOn() end 

UIEventListener = {} 
--*
--[Comment]
--consturctor for UIEventListener overrides:
--*
--UIEventListener.New()
--*

function UIEventListener.New() end
--*
--[Comment]
-- property: Boolean UIEventListener.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIEventListener.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIEventListener.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIEventListener.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIEventListener.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIEventListener.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIEventListener.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIEventListener.hideFlags	get	set	
hideFlags = nil 
--*
----UIEventListener UIEventListener.Get(GameObject go)
function UIEventListener.Get() end 

UIDragObjectEX = {} 
--*
--[Comment]
--consturctor for UIDragObjectEX overrides:
--*
--UIDragObjectEX.New()
--*

function UIDragObjectEX.New() end
--*
--[Comment]
-- property: Vector3 UIDragObjectEX.dragMovement	get	set	
dragMovement = nil 
--*
--[Comment]
-- property: Boolean UIDragObjectEX.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIDragObjectEX.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIDragObjectEX.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIDragObjectEX.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIDragObjectEX.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIDragObjectEX.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIDragObjectEX.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIDragObjectEX.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIDragObjectEX:CancelMovement()
function CancelMovement() end 

----Void UIDragObjectEX:CancelSpring()
function CancelSpring() end 

DP_FightPrefabManage = {} 
--*
--[Comment]
--consturctor for DP_FightPrefabManage overrides:
--*
--DP_FightPrefabManage.New()
--*

function DP_FightPrefabManage.New() end
--*
----Void DP_FightPrefabManage.Init()
function DP_FightPrefabManage.Init() end 

----GameObject DP_FightPrefabManage.InstantiateObject3D(String name)
function DP_FightPrefabManage.InstantiateObject3D() end 

----Void DP_FightPrefabManage.ReLoad3DObjects()
function DP_FightPrefabManage.ReLoad3DObjects() end 

----GameObject DP_FightPrefabManage.InstantiateAvatar(CreateActorParam param)
function DP_FightPrefabManage.InstantiateAvatar() end 

----Material DP_FightPrefabManage.CreateMat(Boolean colorMat)
function DP_FightPrefabManage.CreateMat() end 

RuntimePlatform = {} 

OSXEditor = nil;

OSXPlayer = nil;

WindowsPlayer = nil;

OSXWebPlayer = nil;

OSXDashboardPlayer = nil;

WindowsWebPlayer = nil;

WindowsEditor = nil;

IPhonePlayer = nil;

XBOX360 = nil;

PS3 = nil;

Android = nil;

NaCl = nil;

FlashPlayer = nil;

LinuxPlayer = nil;

WebGLPlayer = nil;

MetroPlayerX86 = nil;

WSAPlayerX86 = nil;

MetroPlayerX64 = nil;

WSAPlayerX64 = nil;

MetroPlayerARM = nil;

WSAPlayerARM = nil;

WP8Player = nil;

BB10Player = nil;

BlackBerryPlayer = nil;

TizenPlayer = nil;

PSP2 = nil;

PS4 = nil;

PSM = nil;

XboxOne = nil;

SamsungTVPlayer = nil;

WiiU = nil;

tvOS = nil;

EasyTouch = {} 
--*
--[Comment]
--consturctor for EasyTouch overrides:
--*
--EasyTouch.New()
--*

function EasyTouch.New() end
--*
--[Comment]
-- property: Boolean EasyTouch.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean EasyTouch.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean EasyTouch.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform EasyTouch.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject EasyTouch.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String EasyTouch.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String EasyTouch.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags EasyTouch.hideFlags	get	set	
hideFlags = nil 
--*
----Void EasyTouch.add_On_Cancel(TouchCancelHandler value)
function EasyTouch.add_On_Cancel() end 

----Void EasyTouch.remove_On_Cancel(TouchCancelHandler value)
function EasyTouch.remove_On_Cancel() end 

----Void EasyTouch.add_On_Cancel2Fingers(Cancel2FingersHandler value)
function EasyTouch.add_On_Cancel2Fingers() end 

----Void EasyTouch.remove_On_Cancel2Fingers(Cancel2FingersHandler value)
function EasyTouch.remove_On_Cancel2Fingers() end 

----Void EasyTouch.add_On_TouchStart(TouchStartHandler value)
function EasyTouch.add_On_TouchStart() end 

----Void EasyTouch.remove_On_TouchStart(TouchStartHandler value)
function EasyTouch.remove_On_TouchStart() end 

----Void EasyTouch.add_On_TouchDown(TouchDownHandler value)
function EasyTouch.add_On_TouchDown() end 

----Void EasyTouch.remove_On_TouchDown(TouchDownHandler value)
function EasyTouch.remove_On_TouchDown() end 

----Void EasyTouch.add_On_TouchUp(TouchUpHandler value)
function EasyTouch.add_On_TouchUp() end 

----Void EasyTouch.remove_On_TouchUp(TouchUpHandler value)
function EasyTouch.remove_On_TouchUp() end 

----Void EasyTouch.add_On_SimpleTap(SimpleTapHandler value)
function EasyTouch.add_On_SimpleTap() end 

----Void EasyTouch.remove_On_SimpleTap(SimpleTapHandler value)
function EasyTouch.remove_On_SimpleTap() end 

----Void EasyTouch.add_On_DoubleTap(DoubleTapHandler value)
function EasyTouch.add_On_DoubleTap() end 

----Void EasyTouch.remove_On_DoubleTap(DoubleTapHandler value)
function EasyTouch.remove_On_DoubleTap() end 

----Void EasyTouch.add_On_LongTapStart(LongTapStartHandler value)
function EasyTouch.add_On_LongTapStart() end 

----Void EasyTouch.remove_On_LongTapStart(LongTapStartHandler value)
function EasyTouch.remove_On_LongTapStart() end 

----Void EasyTouch.add_On_LongTap(LongTapHandler value)
function EasyTouch.add_On_LongTap() end 

----Void EasyTouch.remove_On_LongTap(LongTapHandler value)
function EasyTouch.remove_On_LongTap() end 

----Void EasyTouch.add_On_LongTapEnd(LongTapEndHandler value)
function EasyTouch.add_On_LongTapEnd() end 

----Void EasyTouch.remove_On_LongTapEnd(LongTapEndHandler value)
function EasyTouch.remove_On_LongTapEnd() end 

----Void EasyTouch.add_On_DragStart(DragStartHandler value)
function EasyTouch.add_On_DragStart() end 

----Void EasyTouch.remove_On_DragStart(DragStartHandler value)
function EasyTouch.remove_On_DragStart() end 

----Void EasyTouch.add_On_Drag(DragHandler value)
function EasyTouch.add_On_Drag() end 

----Void EasyTouch.remove_On_Drag(DragHandler value)
function EasyTouch.remove_On_Drag() end 

----Void EasyTouch.add_On_DragEnd(DragEndHandler value)
function EasyTouch.add_On_DragEnd() end 

----Void EasyTouch.remove_On_DragEnd(DragEndHandler value)
function EasyTouch.remove_On_DragEnd() end 

----Void EasyTouch.add_On_SwipeStart(SwipeStartHandler value)
function EasyTouch.add_On_SwipeStart() end 

----Void EasyTouch.remove_On_SwipeStart(SwipeStartHandler value)
function EasyTouch.remove_On_SwipeStart() end 

----Void EasyTouch.add_On_Swipe(SwipeHandler value)
function EasyTouch.add_On_Swipe() end 

----Void EasyTouch.remove_On_Swipe(SwipeHandler value)
function EasyTouch.remove_On_Swipe() end 

----Void EasyTouch.add_On_SwipeEnd(SwipeEndHandler value)
function EasyTouch.add_On_SwipeEnd() end 

----Void EasyTouch.remove_On_SwipeEnd(SwipeEndHandler value)
function EasyTouch.remove_On_SwipeEnd() end 

----Void EasyTouch.add_On_TouchStart2Fingers(TouchStart2FingersHandler value)
function EasyTouch.add_On_TouchStart2Fingers() end 

----Void EasyTouch.remove_On_TouchStart2Fingers(TouchStart2FingersHandler value)
function EasyTouch.remove_On_TouchStart2Fingers() end 

----Void EasyTouch.add_On_TouchDown2Fingers(TouchDown2FingersHandler value)
function EasyTouch.add_On_TouchDown2Fingers() end 

----Void EasyTouch.remove_On_TouchDown2Fingers(TouchDown2FingersHandler value)
function EasyTouch.remove_On_TouchDown2Fingers() end 

----Void EasyTouch.add_On_TouchUp2Fingers(TouchUp2FingersHandler value)
function EasyTouch.add_On_TouchUp2Fingers() end 

----Void EasyTouch.remove_On_TouchUp2Fingers(TouchUp2FingersHandler value)
function EasyTouch.remove_On_TouchUp2Fingers() end 

----Void EasyTouch.add_On_SimpleTap2Fingers(SimpleTap2FingersHandler value)
function EasyTouch.add_On_SimpleTap2Fingers() end 

----Void EasyTouch.remove_On_SimpleTap2Fingers(SimpleTap2FingersHandler value)
function EasyTouch.remove_On_SimpleTap2Fingers() end 

----Void EasyTouch.add_On_DoubleTap2Fingers(DoubleTap2FingersHandler value)
function EasyTouch.add_On_DoubleTap2Fingers() end 

----Void EasyTouch.remove_On_DoubleTap2Fingers(DoubleTap2FingersHandler value)
function EasyTouch.remove_On_DoubleTap2Fingers() end 

----Void EasyTouch.add_On_LongTapStart2Fingers(LongTapStart2FingersHandler value)
function EasyTouch.add_On_LongTapStart2Fingers() end 

----Void EasyTouch.remove_On_LongTapStart2Fingers(LongTapStart2FingersHandler value)
function EasyTouch.remove_On_LongTapStart2Fingers() end 

----Void EasyTouch.add_On_LongTap2Fingers(LongTap2FingersHandler value)
function EasyTouch.add_On_LongTap2Fingers() end 

----Void EasyTouch.remove_On_LongTap2Fingers(LongTap2FingersHandler value)
function EasyTouch.remove_On_LongTap2Fingers() end 

----Void EasyTouch.add_On_LongTapEnd2Fingers(LongTapEnd2FingersHandler value)
function EasyTouch.add_On_LongTapEnd2Fingers() end 

----Void EasyTouch.remove_On_LongTapEnd2Fingers(LongTapEnd2FingersHandler value)
function EasyTouch.remove_On_LongTapEnd2Fingers() end 

----Void EasyTouch.add_On_Twist(TwistHandler value)
function EasyTouch.add_On_Twist() end 

----Void EasyTouch.remove_On_Twist(TwistHandler value)
function EasyTouch.remove_On_Twist() end 

----Void EasyTouch.add_On_TwistEnd(TwistEndHandler value)
function EasyTouch.add_On_TwistEnd() end 

----Void EasyTouch.remove_On_TwistEnd(TwistEndHandler value)
function EasyTouch.remove_On_TwistEnd() end 

----Void EasyTouch.add_On_Pinch(PinchHandler value)
function EasyTouch.add_On_Pinch() end 

----Void EasyTouch.remove_On_Pinch(PinchHandler value)
function EasyTouch.remove_On_Pinch() end 

----Void EasyTouch.add_On_PinchIn(PinchInHandler value)
function EasyTouch.add_On_PinchIn() end 

----Void EasyTouch.remove_On_PinchIn(PinchInHandler value)
function EasyTouch.remove_On_PinchIn() end 

----Void EasyTouch.add_On_PinchOut(PinchOutHandler value)
function EasyTouch.add_On_PinchOut() end 

----Void EasyTouch.remove_On_PinchOut(PinchOutHandler value)
function EasyTouch.remove_On_PinchOut() end 

----Void EasyTouch.add_On_PinchEnd(PinchEndHandler value)
function EasyTouch.add_On_PinchEnd() end 

----Void EasyTouch.remove_On_PinchEnd(PinchEndHandler value)
function EasyTouch.remove_On_PinchEnd() end 

----Void EasyTouch.add_On_DragStart2Fingers(DragStart2FingersHandler value)
function EasyTouch.add_On_DragStart2Fingers() end 

----Void EasyTouch.remove_On_DragStart2Fingers(DragStart2FingersHandler value)
function EasyTouch.remove_On_DragStart2Fingers() end 

----Void EasyTouch.add_On_Drag2Fingers(Drag2FingersHandler value)
function EasyTouch.add_On_Drag2Fingers() end 

----Void EasyTouch.remove_On_Drag2Fingers(Drag2FingersHandler value)
function EasyTouch.remove_On_Drag2Fingers() end 

----Void EasyTouch.add_On_DragEnd2Fingers(DragEnd2FingersHandler value)
function EasyTouch.add_On_DragEnd2Fingers() end 

----Void EasyTouch.remove_On_DragEnd2Fingers(DragEnd2FingersHandler value)
function EasyTouch.remove_On_DragEnd2Fingers() end 

----Void EasyTouch.add_On_SwipeStart2Fingers(SwipeStart2FingersHandler value)
function EasyTouch.add_On_SwipeStart2Fingers() end 

----Void EasyTouch.remove_On_SwipeStart2Fingers(SwipeStart2FingersHandler value)
function EasyTouch.remove_On_SwipeStart2Fingers() end 

----Void EasyTouch.add_On_Swipe2Fingers(Swipe2FingersHandler value)
function EasyTouch.add_On_Swipe2Fingers() end 

----Void EasyTouch.remove_On_Swipe2Fingers(Swipe2FingersHandler value)
function EasyTouch.remove_On_Swipe2Fingers() end 

----Void EasyTouch.add_On_SwipeEnd2Fingers(SwipeEnd2FingersHandler value)
function EasyTouch.add_On_SwipeEnd2Fingers() end 

----Void EasyTouch.remove_On_SwipeEnd2Fingers(SwipeEnd2FingersHandler value)
function EasyTouch.remove_On_SwipeEnd2Fingers() end 

----Void EasyTouch.add_On_EasyTouchIsReady(EasyTouchIsReadyHandler value)
function EasyTouch.add_On_EasyTouchIsReady() end 

----Void EasyTouch.remove_On_EasyTouchIsReady(EasyTouchIsReadyHandler value)
function EasyTouch.remove_On_EasyTouchIsReady() end 

----Void EasyTouch.add_On_OverUIElement(OverUIElementHandler value)
function EasyTouch.add_On_OverUIElement() end 

----Void EasyTouch.remove_On_OverUIElement(OverUIElementHandler value)
function EasyTouch.remove_On_OverUIElement() end 

----Void EasyTouch.add_On_UIElementTouchUp(UIElementTouchUpHandler value)
function EasyTouch.add_On_UIElementTouchUp() end 

----Void EasyTouch.remove_On_UIElementTouchUp(UIElementTouchUpHandler value)
function EasyTouch.remove_On_UIElementTouchUp() end 

----Boolean EasyTouch.IsFingerOverUIElement(Int32 fingerIndex)
function EasyTouch.IsFingerOverUIElement() end 

----GameObject EasyTouch.GetCurrentPickedUIElement(Int32 fingerIndex)
function EasyTouch.GetCurrentPickedUIElement() end 

----GameObject EasyTouch.GetCurrentPickedObject(Int32 fingerIndex)
function EasyTouch.GetCurrentPickedObject() end 

----Int32 EasyTouch.GetTouchCount()
function EasyTouch.GetTouchCount() end 

----Void EasyTouch.ResetTouch(Int32 fingerIndex)
function EasyTouch.ResetTouch() end 

----Void EasyTouch.SetEnabled(Boolean enable)
function EasyTouch.SetEnabled() end 

----Boolean EasyTouch.GetEnabled()
function EasyTouch.GetEnabled() end 

----Void EasyTouch.SetUICompatibily(Boolean value)
function EasyTouch.SetUICompatibily() end 

----Boolean EasyTouch.GetUIComptability()
function EasyTouch.GetUIComptability() end 

----Void EasyTouch.SetAutoUpdateUI(Boolean value)
function EasyTouch.SetAutoUpdateUI() end 

----Boolean EasyTouch.GetAutoUpdateUI()
function EasyTouch.GetAutoUpdateUI() end 

----Void EasyTouch.SetNGUICompatibility(Boolean value)
function EasyTouch.SetNGUICompatibility() end 

----Boolean EasyTouch.GetNGUICompatibility()
function EasyTouch.GetNGUICompatibility() end 

----Void EasyTouch.SetEnableAutoSelect(Boolean value)
function EasyTouch.SetEnableAutoSelect() end 

----Boolean EasyTouch.GetEnableAutoSelect()
function EasyTouch.GetEnableAutoSelect() end 

----Void EasyTouch.SetAutoUpdatePickedObject(Boolean value)
function EasyTouch.SetAutoUpdatePickedObject() end 

----Boolean EasyTouch.GetAutoUpdatePickedObject()
function EasyTouch.GetAutoUpdatePickedObject() end 

----Void EasyTouch.Set3DPickableLayer(LayerMask mask)
function EasyTouch.Set3DPickableLayer() end 

----LayerMask EasyTouch.Get3DPickableLayer()
function EasyTouch.Get3DPickableLayer() end 

----Void EasyTouch.AddCamera(Camera cam,Boolean guiCam)
function EasyTouch.AddCamera() end 

----Void EasyTouch.RemoveCamera(Camera cam)
function EasyTouch.RemoveCamera() end 

----Camera EasyTouch.GetCamera(Int32 index)
function EasyTouch.GetCamera() end 

----Void EasyTouch.SetEnable2DCollider(Boolean value)
function EasyTouch.SetEnable2DCollider() end 

----Boolean EasyTouch.GetEnable2DCollider()
function EasyTouch.GetEnable2DCollider() end 

----Void EasyTouch.Set2DPickableLayer(LayerMask mask)
function EasyTouch.Set2DPickableLayer() end 

----LayerMask EasyTouch.Get2DPickableLayer()
function EasyTouch.Get2DPickableLayer() end 

----Void EasyTouch.SetGesturePriority(GesturePriority value)
function EasyTouch.SetGesturePriority() end 

----GesturePriority EasyTouch.GetGesturePriority()
function EasyTouch.GetGesturePriority() end 

----Void EasyTouch.SetStationaryTolerance(Single tolerance)
function EasyTouch.SetStationaryTolerance() end 

----Single EasyTouch.GetStationaryTolerance()
function EasyTouch.GetStationaryTolerance() end 

----Void EasyTouch.SetLongTapTime(Single time)
function EasyTouch.SetLongTapTime() end 

----Single EasyTouch.GetlongTapTime()
function EasyTouch.GetlongTapTime() end 

----Void EasyTouch.SetDoubleTapTime(Single time)
function EasyTouch.SetDoubleTapTime() end 

----Single EasyTouch.GetDoubleTapTime()
function EasyTouch.GetDoubleTapTime() end 

----Void EasyTouch.SetSwipeTolerance(Single tolerance)
function EasyTouch.SetSwipeTolerance() end 

----Single EasyTouch.GetSwipeTolerance()
function EasyTouch.GetSwipeTolerance() end 

----Void EasyTouch.SetEnable2FingersGesture(Boolean enable)
function EasyTouch.SetEnable2FingersGesture() end 

----Boolean EasyTouch.GetEnable2FingersGesture()
function EasyTouch.GetEnable2FingersGesture() end 

----Void EasyTouch.SetTwoFingerPickMethod(TwoFingerPickMethod pickMethod)
function EasyTouch.SetTwoFingerPickMethod() end 

----TwoFingerPickMethod EasyTouch.GetTwoFingerPickMethod()
function EasyTouch.GetTwoFingerPickMethod() end 

----Void EasyTouch.SetEnablePinch(Boolean enable)
function EasyTouch.SetEnablePinch() end 

----Boolean EasyTouch.GetEnablePinch()
function EasyTouch.GetEnablePinch() end 

----Void EasyTouch.SetMinPinchLength(Single length)
function EasyTouch.SetMinPinchLength() end 

----Single EasyTouch.GetMinPinchLength()
function EasyTouch.GetMinPinchLength() end 

----Void EasyTouch.SetEnableTwist(Boolean enable)
function EasyTouch.SetEnableTwist() end 

----Boolean EasyTouch.GetEnableTwist()
function EasyTouch.GetEnableTwist() end 

----Void EasyTouch.SetMinTwistAngle(Single angle)
function EasyTouch.SetMinTwistAngle() end 

----Single EasyTouch.GetMinTwistAngle()
function EasyTouch.GetMinTwistAngle() end 

----Boolean EasyTouch.GetSecondeFingerSimulation()
function EasyTouch.GetSecondeFingerSimulation() end 

----Void EasyTouch.SetSecondFingerSimulation(Boolean value)
function EasyTouch.SetSecondFingerSimulation() end 

BaseFinger = {} 
--*
--[Comment]
--consturctor for BaseFinger overrides:
--*
--BaseFinger.New()
--*

function BaseFinger.New() end
--*
----Gesture BaseFinger:GetGesture()
function GetGesture() end 

Flip = {} 

Nothing = nil;

Horizontally = nil;

Vertically = nil;

Both = nil;

MFAModelRender = {} 
--*
--[Comment]
--consturctor for MFAModelRender overrides:
--*
--MFAModelRender.New()
--*

function MFAModelRender.New() end
--*
--[Comment]
-- property: Int32 MFAModelRender.LodCount	get	
LodCount = nil 
--*
--[Comment]
-- property: Boolean MFAModelRender.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean MFAModelRender.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean MFAModelRender.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform MFAModelRender.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject MFAModelRender.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String MFAModelRender.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String MFAModelRender.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags MFAModelRender.hideFlags	get	set	
hideFlags = nil 
--*
----Void MFAModelRender:SetClip(Int32 hashClipName)
function SetClip() end 

----Void MFAModelRender:SetLostTime(Single time)
function SetLostTime() end 

----Void MFAModelRender:SetDir(Boolean isRight)
function SetDir() end 

----Void MFAModelRender:SetAlpha(Single v)
function SetAlpha() end 

----Void MFAModelRender:SetMat(Material mat)
function SetMat() end 

----Void MFAModelRender:SetShaderParam(String propertyName,Single v)
function SetShaderParam() end 

----Void MFAModelRender:SetTexture(Int32 lodLevel,String textureName)
function SetTexture() end 

----Void MFAModelRender:SetLodMesh(Int32 lodLevel,String MeshName)
function SetLodMesh() end 

----String MFAModelRender:GetLodMesh(Int32 lodLevel)
function GetLodMesh() end 

BoxScrollObject = {} 
--*
--[Comment]
--consturctor for BoxScrollObject overrides:
--*
--BoxScrollObject.New()
--*

function BoxScrollObject.New() end
--*
--[Comment]
-- property: Bounds BoxScrollObject.bounds	get	
bounds = nil 
--*
--[Comment]
-- property: Vector3 BoxScrollObject.ScrollViewPosition	get	
ScrollViewPosition = nil 
--*
--[Comment]
-- property: Vector3 BoxScrollObject.ScrollLogicPosition	get	
ScrollLogicPosition = nil 
--*
--[Comment]
-- property: Boolean BoxScrollObject.showHandles	get	
showHandles = nil 
--*
--[Comment]
-- property: Boolean BoxScrollObject.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean BoxScrollObject.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean BoxScrollObject.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform BoxScrollObject.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject BoxScrollObject.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String BoxScrollObject.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String BoxScrollObject.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags BoxScrollObject.hideFlags	get	set	
hideFlags = nil 
--*
WndManage = {} 
--*
--[Comment]
-- property: WndManage WndManage.Single	get	
Single = nil 
--*
----Void WndManage:DestroyHideWnds()
function DestroyHideWnds() end 

----Void WndManage:DestroyWnd(Wnd wnd)
--Void WndManage:DestroyWnd(String wndName,Single duration)
function DestroyWnd() end 

----Void WndManage:RegWnd(String wndName,String dependPackets,Int32 cacheTime,WndFadeMode fade,WndAnimationMode animaMode)
function RegWnd() end 

----Void WndManage:RegWnd1(String wndName,String dependPackets,Int32 cacheTime,Int32 fade,Int32 animaMode)
function RegWnd1() end 

----HashSet`1 WndManage:GetDependPackets(List`1 wndNames)
function GetDependPackets() end 

----Void WndManage:ShowWnd(String wndName,Single duration,Boolean isWithBg)
function ShowWnd() end 

----Void WndManage:HideWnd(String wndName,Single duration)
function HideWnd() end 

----Void WndManage:PreLoadDepend(String wndName)
function PreLoadDepend() end 

----Wnd WndManage:_GetWnd(String wndName)
function _GetWnd() end 

----Void WndManage:_OnWndHide(String wndName)
function _OnWndHide() end 

----Void WndManage:LogicInit_Go()
function LogicInit_Go() end 

----Single WndManage:LogicInit_GetInitProgress()
function LogicInit_GetInitProgress() end 

Wnd = {} 
--*
--[Comment]
--consturctor for Wnd overrides:
--*
--Wnd.New(GameObject panelObj,GameObject baffleObj,wndInfo wInfo)
--*

function Wnd.New() end
--*
--[Comment]
-- property: String Wnd.Name	get	
Name = nil 
--*
--[Comment]
-- property: Boolean Wnd.IsVisible	get	
IsVisible = nil 
--*
----Void Wnd:_Hide(Single duration,WShowType wt,Int32 depth)
function _Hide() end 

----Void Wnd:_Show(Single duration)
function _Show() end 

----GameObject Wnd:FindWidget(String objName)
function FindWidget() end 

----GameObject Wnd:GetGameObject()
function GetGameObject() end 

----Void Wnd:Dispose()
function Dispose() end 

RanderControl = {} 
--*
--[Comment]
--consturctor for RanderControl overrides:
--*
--RanderControl.New()
--*

function RanderControl.New() end
--*
--[Comment]
-- property: Boolean RanderControl.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean RanderControl.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean RanderControl.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform RanderControl.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject RanderControl.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String RanderControl.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String RanderControl.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags RanderControl.hideFlags	get	set	
hideFlags = nil 
--*
----Void RanderControl:SyncData()
function SyncData() end 

----Void RanderControl:Begin()
function Begin() end 

----Void RanderControl:OnEnable()
function OnEnable() end 

----Void RanderControl:PlayAni(String aniName,WrapMode mode)
function PlayAni() end 

----Void RanderControl:DestoryFSM()
function DestoryFSM() end 

----Void RanderControl:SetBloodBarValue()
function SetBloodBarValue() end 

----Void RanderControl:CleanTarget()
function CleanTarget() end 

wndShowHideInfo = {} 
--*
--[Comment]
--consturctor for wndShowHideInfo overrides:
--*
--wndShowHideInfo.New()
--*

function wndShowHideInfo.New() end
--*
Utils = {} 
--*
--[Comment]
--consturctor for Utils overrides:
--*
--Utils.New()
--*

function Utils.New() end
--*
--[Comment]
-- property: Utils Utils.Single	get	
Single = nil 
--*
----Int32[] Utils.PositionToNum(Vector3 planePosOffset,Vector3 position,Single unitWidth,Single mapWidth,Single mapHight)
function Utils.PositionToNum() end 

----Vector3 Utils.NumToPosition(Vector3 planePosOffset,Vector2 num,Single unitWidth,Single mapWidth,Single mapHight)
function Utils.NumToPosition() end 

----List`1 Utils.NumToPostionByList(Vector3 planePosOffset,IList`1 nodeList,Single unitWidth,Single mapWidth,Single mapHight)
function Utils.NumToPostionByList() end 

----Boolean Utils.IsCoverage(Single rectX1,Single rectY1,Single rectX2,Single rectY2,Single pointX,Single pointY)
function Utils.IsCoverage() end 

----Void Utils.DrawGraphics(ICollisionGraphics graphics,Color color)
function Utils.DrawGraphics() end 

----Void Utils.DrawRect(Vector3 position,Single width,Single height,Single rotation,Color color)
function Utils.DrawRect() end 

----Void Utils.DrawSector(Vector3 position,Single radius,Single rotation,Single openAngle,Color color)
function Utils.DrawSector() end 

----Void Utils.DrawTriangle(Vector3 point1,Vector3 point2,Vector3 point3,Color color)
function Utils.DrawTriangle() end 

----Void Utils.DrawCircle(Vector3 position,Single radius,Color color)
function Utils.DrawCircle() end 

----Int64 Utils.GetKey(Int64 x,Int64 y)
function Utils.GetKey() end 

----Vector2 Utils.GetHorizonalTestLine(Single rotation)
function Utils.GetHorizonalTestLine() end 

----Vector2 Utils.GetVerticalTestLine(Single rotation,Single radius)
function Utils.GetVerticalTestLine() end 

----Single Utils.GetDistancePointToLine(Vector2 lineP1,Vector2 lineP2,Vector2 point)
function Utils.GetDistancePointToLine() end 

----Single Utils.GetDistancePointToPoint(Vector2 point1,Vector2 point2)
function Utils.GetDistancePointToPoint() end 

----Void Utils.CreateOrOpenFile(String path,String fileName,String info)
function Utils.CreateOrOpenFile() end 

----String Utils.LoadFileInfo(String path)
--String Utils.LoadFileInfo(FileInfo fi)
function Utils.LoadFileInfo() end 

----String Utils.LoadFileRotate(String path)
function Utils.LoadFileRotate() end 

----String Utils.CombineFile(List`1 pathList)
function Utils.CombineFile() end 

----Dictionary`2 Utils.DepartFileData(String data)
function Utils.DepartFileData() end 

----String Utils.GetMapDataByFileName(String fileName)
function Utils.GetMapDataByFileName() end 

----Single Utils.GetTheta(Vector3 targetPos,Vector3 startPos,Single speed,Single gravity)
function Utils.GetTheta() end 

----Vector3 Utils.WithOutY(Vector3 vec3)
function Utils.WithOutY() end 

----Vector2 Utils.V3ToV2WithouY(Vector3 vec3)
function Utils.V3ToV2WithouY() end 

----Single Utils.GetRange(Single min,Single max,Single val)
function Utils.GetRange() end 

----Single Utils.GetTwoPointDistance2D(Single x1,Single y1,Single x2,Single y2)
function Utils.GetTwoPointDistance2D() end 

----Void Utils.CopyArray(Int32[][] from,Int32[][]& to,Int32 rowCount,Int32 colCount)
function Utils.CopyArray() end 

----String Utils.GetMapFileNameById(Int32 mapId,Int32 mapLevel)
--String Utils.GetMapFileNameById(String mapId,Int32 mapLevel)
function Utils.GetMapFileNameById() end 

----Void Utils:MoveAndRotateObj(IList`1 paramList,GameObject obj,Int32 frameRate,Action completeCallback)
function MoveAndRotateObj() end 

----Void Utils:StopMove()
function StopMove() end 

UITweener = {} 
--*
--[Comment]
-- property: Single UITweener.amountPerDelta	get	
amountPerDelta = nil 
--*
--[Comment]
-- property: Single UITweener.tweenFactor	get	set	
tweenFactor = nil 
--*
--[Comment]
-- property: Direction UITweener.direction	get	
direction = nil 
--*
--[Comment]
-- property: Boolean UITweener.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UITweener.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UITweener.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UITweener.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UITweener.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UITweener.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UITweener.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UITweener.hideFlags	get	set	
hideFlags = nil 
--*
----Void UITweener:SetOnFinished(Callback del)
--Void UITweener:SetOnFinished(EventDelegate del)
function SetOnFinished() end 

----Void UITweener:AddOnFinished(Callback del)
--Void UITweener:AddOnFinished(EventDelegate del)
function AddOnFinished() end 

----Void UITweener:RemoveOnFinished(EventDelegate del)
function RemoveOnFinished() end 

----Void UITweener:Sample(Single factor,Boolean isFinished)
function Sample() end 

----Void UITweener:PlayForward()
function PlayForward() end 

----Void UITweener:PlayReverse()
function PlayReverse() end 

----Void UITweener:Play(Boolean forward)
function Play() end 

----Void UITweener:ResetToBeginning()
function ResetToBeginning() end 

----Void UITweener:Toggle()
function Toggle() end 

----Void UITweener:SetStartToCurrentValue()
function SetStartToCurrentValue() end 

----Void UITweener:SetEndToCurrentValue()
function SetEndToCurrentValue() end 

AStarPathFinding = {} 
--*
--[Comment]
--consturctor for AStarPathFinding overrides:
--*
--AStarPathFinding.New()
--*

function AStarPathFinding.New() end
--*
----IList`1 AStarPathFinding.SearchRoad(Int32[][] map,Int32 startX,Int32 startY,Int32 endX,Int32 endY,Int32 diameterX,Int32 diameterY,Boolean isJumpPoint,Action completeCallback)
function AStarPathFinding.SearchRoad() end 

----IEnumerator AStarPathFinding.ISearchRoad(Int32[][] map,Int32 startX,Int32 startY,Int32 endX,Int32 endY,Int32 diameterX,Int32 diameterY)
function AStarPathFinding.ISearchRoad() end 

----Int32 AStarPathFinding.NearObstacleCount(Node node,Int32[][] map,Int32 colCount,Int32 rowCount)
function AStarPathFinding.NearObstacleCount() end 

PacketManage = {} 
--*
--[Comment]
--consturctor for PacketManage overrides:
--*
--PacketManage.New()
--*

function PacketManage.New() end
--*
--[Comment]
-- property: PacketManage PacketManage.Single	get	
Single = nil 
--*
--[Comment]
-- property: Boolean PacketManage.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean PacketManage.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean PacketManage.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform PacketManage.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject PacketManage.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String PacketManage.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String PacketManage.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags PacketManage.hideFlags	get	set	
hideFlags = nil 
--*
----Void PacketManage:LoadPacket(PackType pkType,String packName,Action`2 OnPacketLoadDone,Action`2 OnPacketLoadingProgress,Boolean FoceLoadInternalPack)
function LoadPacket() end 

----Void PacketManage:AutoGC(Int64 addsize)
function AutoGC() end 

----Void PacketManage:LoadInternalPack(String url,String packName,Action`2 OnPacketLoadDone,Action`2 OnPacketLoadingProgress)
function LoadInternalPack() end 

----PacketRouting PacketManage:GetPacket(String packName)
function GetPacket() end 

----Void PacketManage:UnLoadPacket(String packName)
function UnLoadPacket() end 

PacketRouting = {} 
--*
--[Comment]
--consturctor for PacketRouting overrides:
--*
--PacketRouting.New()
--*

function PacketRouting.New() end
--*
----Void PacketRouting:Add(IPacket packet)
function Add() end 

----Object PacketRouting:Load(String path,RES_LOCATION resLocation)
function Load() end 

----Byte[] PacketRouting:LoadBytes(String path,RES_LOCATION resLocation)
function LoadBytes() end 

----String PacketRouting:LoadString(String path,RES_LOCATION resLocation)
function LoadString() end 

----Void PacketRouting:UnLoad()
function UnLoad() end 

RES_LOCATION = {} 

auto = nil;

fileSystem = nil;

externalPack = nil;

internalPack = nil;

HUDText = {} 
--*
--[Comment]
--consturctor for HUDText overrides:
--*
--HUDText.New()
--*

function HUDText.New() end
--*
--[Comment]
-- property: Boolean HUDText.isVisible	get	
isVisible = nil 
--*
--[Comment]
-- property: Object HUDText.ambigiousFont	get	set	
ambigiousFont = nil 
--*
--[Comment]
-- property: Boolean HUDText.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean HUDText.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean HUDText.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform HUDText.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject HUDText.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String HUDText.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String HUDText.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags HUDText.hideFlags	get	set	
hideFlags = nil 
--*
----Void HUDText:AddLocalized(String text,Color c,Single stayDuration)
function AddLocalized() end 

----Void HUDText:Add(Object obj,Color c,Single stayDuration)
function Add() end 

AstarFight = {} 
--*
--[Comment]
--consturctor for AstarFight overrides:
--*
--AstarFight.New()
--*

function AstarFight.New() end
--*
--[Comment]
-- property: AstarFight AstarFight.Instance	get	set	
Instance = nil 
--*
--[Comment]
-- property: Boolean AstarFight.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean AstarFight.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean AstarFight.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform AstarFight.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject AstarFight.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String AstarFight.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String AstarFight.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags AstarFight.hideFlags	get	set	
hideFlags = nil 
--*
----Void AstarFight:InitMap(Int32[][] obMapInfo,Int32[][] buildingMapInfo)
function InitMap() end 

----Void AstarFight:Clear()
function Clear() end 

----Void AstarFight:isZhangAi(Vector3 mapPosition,Int32 index)
function isZhangAi() end 

----Void AstarFight:isQianFengZhangAi(Vector3 mapPosition,Int32 index)
function isQianFengZhangAi() end 

----Dictionary`2 AstarFight.setAllZhenxingList(Int32[] cardID,Int32[] level)
function AstarFight.setAllZhenxingList() end 

----Void AstarFight:setZhenxingInfo(Transform go,Int32 cardID,Int32 index)
function setZhenxingInfo() end 

----Void AstarFight:setQianFengInfo(Transform go,Int32 cardID,Int32 index)
function setQianFengInfo() end 

----Vector3 AstarFight:getNum(Vector3 p)
function getNum() end 

----Void AstarFight:setMaxX(Single X)
function setMaxX() end 

----Void AstarFight:OnDestroy()
function OnDestroy() end 

UIFollow = {} 
--*
--[Comment]
--consturctor for UIFollow overrides:
--*
--UIFollow.New()
--*

function UIFollow.New() end
--*
--[Comment]
-- property: Transform UIFollow.Target	get	set	
Target = nil 
--*
--[Comment]
-- property: Boolean UIFollow.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIFollow.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIFollow.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIFollow.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIFollow.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIFollow.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIFollow.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIFollow.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIFollow:ResetPosition()
function ResetPosition() end 

DP_CameraTrackObjectManage = {} 
--*
--[Comment]
--consturctor for DP_CameraTrackObjectManage overrides:
--*
--DP_CameraTrackObjectManage.New()
--*

function DP_CameraTrackObjectManage.New() end
--*
----Void DP_CameraTrackObjectManage:CancelTrackActor(Int32 actorID)
function CancelTrackActor() end 

----Void DP_CameraTrackObjectManage:LookAround(Action complateRecall)
function LookAround() end 

----Void DP_CameraTrackObjectManage:OnInterruptLookAround()
function OnInterruptLookAround() end 

----Void DP_CameraTrackObjectManage:LookFollowAround(Transform targetTrans,Action complateRecall)
function LookFollowAround() end 

----Void DP_CameraTrackObjectManage:UnLockOP()
function UnLockOP() end 

----Void DP_CameraTrackObjectManage:Reset()
function Reset() end 

DP_Battlefield = {} 
--*
--[Comment]
--consturctor for DP_Battlefield overrides:
--*
--DP_Battlefield.New()
--*

function DP_Battlefield.New() end
--*
--[Comment]
-- property: Boolean DP_Battlefield.IsLoading	get	
IsLoading = nil 
--*
----Void DP_Battlefield:SwapScene(Int32 sceneID,List`1 dyDependPacks,Action OnSwapDone)
function SwapScene() end 

----Void DP_Battlefield:LoadBase()
function LoadBase() end 

----Void DP_Battlefield:CameraFocusFID(Boolean isLeft,Int32 fid)
function CameraFocusFID() end 

----Void DP_Battlefield:Reset()
function Reset() end 

ClusterManager = {} 
--*
--[Comment]
--consturctor for ClusterManager overrides:
--*
--ClusterManager.New()
--*

function ClusterManager.New() end
--*
--[Comment]
-- property: ClusterManager ClusterManager.Single	get	
Single = nil 
--*
----Void ClusterManager:Do()
function Do() end 

----Boolean ClusterManager:IsEnd()
function IsEnd() end 

----Void ClusterManager:OnDestroy()
function OnDestroy() end 

----Void ClusterManager:Add(PositionObject member)
function Add() end 

----Void ClusterManager:Remove(PositionObject member)
function Remove() end 

----Void ClusterManager:Init(Single x,Single y,Int32 w,Int32 h,Int32 unitw,Int32[][] map)
function Init() end 

----Void ClusterManager:Pause()
function Pause() end 

----Void ClusterManager:GoOn()
function GoOn() end 

----Void ClusterManager:ClearAll()
function ClearAll() end 

----IList`1 ClusterManager:GetPositionObjectListByGraphics(ICollisionGraphics graphics)
function GetPositionObjectListByGraphics() end 

----IList`1 ClusterManager:CheckRange(Vector2 pos,Single range,Int32 myCamp,Boolean isExceptMyCamp)
--IList`1 ClusterManager:CheckRange(ICollisionGraphics graphics,Int32 myCamp,Boolean isExceptMyCamp)
function CheckRange() end 

PositionTransform = {} 
--*
--[Comment]
--consturctor for PositionTransform overrides:
--*
--PositionTransform.New()
--*

function PositionTransform.New() end
--*
--[Comment]
-- property: Vector3 PositionTransform.Value	get	set	
Value = nil 
--*
--[Comment]
-- property: TransformMixer PositionTransform.OwnerTransformMixer	get	
OwnerTransformMixer = nil 
--*
--[Comment]
-- property: Boolean PositionTransform.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean PositionTransform.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean PositionTransform.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform PositionTransform.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject PositionTransform.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String PositionTransform.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String PositionTransform.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags PositionTransform.hideFlags	get	set	
hideFlags = nil 
--*
----Void PositionTransform:add_OnValueChanged(OnValueChangedDelegate value)
function add_OnValueChanged() end 

----Void PositionTransform:remove_OnValueChanged(OnValueChangedDelegate value)
function remove_OnValueChanged() end 

MoveRecord = {} 
--*
--[Comment]
--consturctor for MoveRecord overrides:
--*
--MoveRecord.New()
--*

function MoveRecord.New() end
--*
--[Comment]
-- property: Vector3 MoveRecord.CurrentPos	get	set	
CurrentPos = nil 
--*
--[Comment]
-- property: Vector3 MoveRecord.TotalOffset	get	
TotalOffset = nil 
--*
----Void MoveRecord:Clear(Vector3 origin)
function Clear() end 

----Void MoveRecord:JumpTo(Vector3 pos)
function JumpTo() end 

----Vector3 MoveRecord:GetInertiaSpeed(Single validTime)
function GetInertiaSpeed() end 

LGYLOG = {} 
--*
--[Comment]
--consturctor for LGYLOG overrides:
--*
--LGYLOG.New()
--*

function LGYLOG.New() end
--*
----Void LGYLOG.Log(String log)
--Void LGYLOG.Log(String log,Int32 level)
function LGYLOG.Log() end 

CreateActorParam = {} 
--*
--[Comment]
--consturctor for CreateActorParam overrides:
--*
--CreateActorParam.New(Int32 cmType,Boolean colorMat,Int32 flagColorIdx,String meshPackName,String texturePackName,Boolean isHero,Int32 soldierID,Int32 cardID)
--*

--CreateActorParam.New(Single x,Single y,Int32 level)
--*

--CreateActorParam.New(Single x,Single y)
--*

function CreateActorParam.New() end
--*
Tools = {} 
--*
--[Comment]
--consturctor for Tools overrides:
--*
--Tools.New()
--*

function Tools.New() end
--*
--[Comment]
-- property: String Tools.DataPath	get	
DataPath = nil 
--*
----Object[] Tools.CallMethod(String module,String func,Object[] args)
function Tools.CallMethod() end 

----String Tools.GetOS()
function Tools.GetOS() end 

----String Tools.AppContentPath()
function Tools.AppContentPath() end 

----String Tools.GetRelativePath()
function Tools.GetRelativePath() end 

----String Tools.md5file(String file)
function Tools.md5file() end 

----ResourceManager Tools.GetResManager()
function Tools.GetResManager() end 

----Void Tools.ChangeChildLayer(Transform t,Int32 layer)
function Tools.ChangeChildLayer() end 

----Void Tools.AddChildToTarget(Transform target,Transform child)
function Tools.AddChildToTarget() end 

----Void Tools.AdjustBaseWindowDepth(GameObject rootGameObject,GameObject go,Int32 platformDepth)
function Tools.AdjustBaseWindowDepth() end 

----Void Tools.SetTargetMinPanelDepth(GameObject obj,Int32 depth)
function Tools.SetTargetMinPanelDepth() end 

----Int32 Tools.GetMaxTargetDepth(GameObject obj,Boolean includeInactive)
function Tools.GetMaxTargetDepth() end 

FightUnitFactory = {} 
--*
--[Comment]
--consturctor for FightUnitFactory overrides:
--*
--FightUnitFactory.New()
--*

function FightUnitFactory.New() end
--*
----DisplayOwner FightUnitFactory.CreateUnit(Int32 unitType,CreateActorParam otherParam)
function FightUnitFactory.CreateUnit() end 

----Void FightUnitFactory.DeleteUnit(VOBase obj)
function FightUnitFactory.DeleteUnit() end 

SDataUtils = {} 
--*
--[Comment]
--consturctor for SDataUtils overrides:
--*
--SDataUtils.New()
--*

function SDataUtils.New() end
--*
----Void SDataUtils.setData(String index,LuaTable table1,LuaTable table2)
function SDataUtils.setData() end 

----Void SDataUtils.dealTable(LuaTable table,Action`2 ac)
function SDataUtils.dealTable() end 

GameObjectExtension = {} 
--*
----Void GameObjectExtension.EnableCollider(GameObject obj,Boolean enable)
function GameObjectExtension.EnableCollider() end 

----Void GameObjectExtension.RemoveComponents(GameObject obj,Type type)
function GameObjectExtension.RemoveComponents() end 

----Transform GameObjectExtension.FindChild(Transform obj,String[] name_path)
--Transform GameObjectExtension.FindChild(Transform obj,String objName)
function GameObjectExtension.FindChild() end 

----GameObject GameObjectExtension.InstantiateFromPreobj(Object preObj,GameObject parent)
function GameObjectExtension.InstantiateFromPreobj() end 

----GameObject GameObjectExtension.InstantiateFromPacket(String packName,String preObjName,GameObject parent)
function GameObjectExtension.InstantiateFromPacket() end 

LayerMask = {} 
--*
--[Comment]
-- property: Int32 LayerMask.value	get	set	
--Converts a layer mask value to an integer value.
value = nil 
--*
----String LayerMask.LayerToName(Int32 layer)
function LayerMask.LayerToName() end 

----Int32 LayerMask.NameToLayer(String layerName)
function LayerMask.NameToLayer() end 

----Int32 LayerMask.GetMask(String[] layerNames)
function LayerMask.GetMask() end 

----Int32 LayerMask.op_Implicit(LayerMask mask)
--LayerMask LayerMask.op_Implicit(Int32 intVal)
function LayerMask.op_Implicit() end 

SpinWithMouse = {} 
--*
--[Comment]
--consturctor for SpinWithMouse overrides:
--*
--SpinWithMouse.New()
--*

function SpinWithMouse.New() end
--*
--[Comment]
-- property: Boolean SpinWithMouse.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean SpinWithMouse.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean SpinWithMouse.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform SpinWithMouse.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject SpinWithMouse.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String SpinWithMouse.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String SpinWithMouse.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags SpinWithMouse.hideFlags	get	set	
hideFlags = nil 
--*
DisplayOwner = {} 
--*
--[Comment]
--consturctor for DisplayOwner overrides:
--*
--DisplayOwner.New(GameObject gameObj,PositionObject clusterData)
--*

--DisplayOwner.New(GameObject gameObj,PositionObject clusterData,MFAModelRender mfa)
--*

--DisplayOwner.New(GameObject gameObj,PositionObject clusterData,MFAModelRender modelRender,RanderControl randerControl)
--*

function DisplayOwner.New() end
--*
--[Comment]
-- property: GameObject DisplayOwner.GameObj	get	set	
GameObj = nil 
--*
--[Comment]
-- property: PositionObject DisplayOwner.ClusterData	get	set	
ClusterData = nil 
--*
--[Comment]
-- property: MFAModelRender DisplayOwner.MFAModelRender	get	set	
MFAModelRender = nil 
--*
--[Comment]
-- property: RanderControl DisplayOwner.RanderControl	get	set	
RanderControl = nil 
--*
----Void DisplayOwner:Destroy()
function Destroy() end 

----Void DisplayOwner:CleanData()
function CleanData() end 

PositionObject = {} 
--*
--[Comment]
-- property: AllData PositionObject.AllData	get	set	
AllData = nil 
--*
--[Comment]
-- property: ICollisionGraphics PositionObject.MyCollisionGraphics	get	set	
MyCollisionGraphics = nil 
--*
--[Comment]
-- property: Int64 PositionObject.Id	get	
Id = nil 
--*
--[Comment]
-- property: Int32 PositionObject.CollisionGroup	get	set	
CollisionGroup = nil 
--*
--[Comment]
-- property: Single PositionObject.Diameter	get	set	
Diameter = nil 
--*
--[Comment]
-- property: Vector3 PositionObject.Position	get	set	
Position = nil 
--*
--[Comment]
-- property: Single PositionObject.X	get	set	
X = nil 
--*
--[Comment]
-- property: Single PositionObject.Y	get	set	
Y = nil 
--*
--[Comment]
-- property: Single PositionObject.Height	get	set	
Height = nil 
--*
--[Comment]
-- property: Vector3 PositionObject.Rotate	set	
Rotate = nil 
--*
--[Comment]
-- property: Vector3 PositionObject.Direction	get	set	
Direction = nil 
--*
--[Comment]
-- property: Vector3 PositionObject.DirectionRight	get	
DirectionRight = nil 
--*
--[Comment]
-- property: GameObject PositionObject.ItemObj	get	
ItemObj = nil 
--*
--[Comment]
-- property: Boolean PositionObject.CouldMove	get	
CouldMove = nil 
--*
--[Comment]
-- property: Boolean PositionObject.IsMoving	get	
IsMoving = nil 
--*
--[Comment]
-- property: Single PositionObject.Quality	get	set	
Quality = nil 
--*
--[Comment]
-- property: Vector3 PositionObject.SpeedDirection	get	set	
SpeedDirection = nil 
--*
--[Comment]
-- property: Single PositionObject.MaxSpeed	get	set	
MaxSpeed = nil 
--*
--[Comment]
-- property: Boolean PositionObject.CouldSelect	get	set	
CouldSelect = nil 
--*
--[Comment]
-- property: Boolean PositionObject.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean PositionObject.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean PositionObject.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform PositionObject.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject PositionObject.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String PositionObject.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String PositionObject.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags PositionObject.hideFlags	get	set	
hideFlags = nil 
--*
----Void PositionObject:Begin()
function Begin() end 

----Void PositionObject:StopMove()
function StopMove() end 

----Void PositionObject:ContinueMove()
function ContinueMove() end 

----Void PositionObject:Clear()
function Clear() end 

VOBase = {} 
--*
--[Comment]
--consturctor for VOBase overrides:
--*
--VOBase.New()
--*

function VOBase.New() end
--*
--[Comment]
-- property: Single VOBase.AntiArmor	get	set	
AntiArmor = nil 
--*
--[Comment]
-- property: String VOBase.ModelPack	get	set	
ModelPack = nil 
--*
--[Comment]
-- property: String VOBase.ModelName	get	set	
ModelName = nil 
--*
--[Comment]
-- property: String VOBase.ModelTexture	get	set	
ModelTexture = nil 
--*
--[Comment]
-- property: Single VOBase.MoveSpeed	get	set	
MoveSpeed = nil 
--*
--[Comment]
-- property: Int32 VOBase.BehaviorType	get	set	
BehaviorType = nil 
--*
--[Comment]
-- property: Single VOBase.AttackRange	get	set	
AttackRange = nil 
--*
--[Comment]
-- property: Single VOBase.SkillRange	get	set	
SkillRange = nil 
--*
--[Comment]
-- property: Single VOBase.Hit	get	set	
Hit = nil 
--*
--[Comment]
-- property: Single VOBase.Dodge	get	set	
Dodge = nil 
--*
--[Comment]
-- property: Single VOBase.Crit	get	set	
Crit = nil 
--*
--[Comment]
-- property: Single VOBase.AntiCrit	get	set	
AntiCrit = nil 
--*
--[Comment]
-- property: Single VOBase.Armor	get	set	
Armor = nil 
--*
--[Comment]
-- property: Int16 VOBase.ArmyType	get	set	
ArmyType = nil 
--*
--[Comment]
-- property: Int32 VOBase.ArmyID	get	set	
ArmyID = nil 
--*
--[Comment]
-- property: ObjectID VOBase.ObjID	get	set	
ObjID = nil 
--*
--[Comment]
-- property: String VOBase.Name	get	set	
Name = nil 
--*
--[Comment]
-- property: String VOBase.ZiYuanBaoMing	get	set	
ZiYuanBaoMing = nil 
--*
--[Comment]
-- property: Int32 VOBase.VOType	get	set	
VOType = nil 
--*
--[Comment]
-- property: Single VOBase.TotalHp	get	set	
TotalHp = nil 
--*
--[Comment]
-- property: Single VOBase.CurrentHP	get	set	
CurrentHP = nil 
--*
--[Comment]
-- property: Int32 VOBase.EntityID	get	set	
EntityID = nil 
--*
--[Comment]
-- property: Int32 VOBase.Camp	get	set	
Camp = nil 
--*
----Void VOBase:SetCurrentHP(Single hp)
function SetCurrentHP() end 

----Void VOBase:SetSoldierData(armybase_cInfo data)
function SetSoldierData() end 

----String VOBase:ToString()
function ToString() end 

AllData = {} 
--*
--[Comment]
--consturctor for AllData overrides:
--*
--AllData.New()
--*

function AllData.New() end
--*
--[Comment]
-- property: VOBase AllData.MemberData	get	set	
MemberData = nil 
--*
--[Comment]
-- property: SelectWeightData AllData.SelectWeightData	get	set	
SelectWeightData = nil 
--*
--[Comment]
-- property: ArmyAOEData AllData.AOEData	get	set	
AOEData = nil 
--*
--[Comment]
-- property: EffectData AllData.EffectData	get	set	
EffectData = nil 
--*
--[Comment]
-- property: ArmyTypeData AllData.ArmyTypeData	get	set	
ArmyTypeData = nil 
--*
--[Comment]
-- property: IList`1 AllData.SkillInfoList	get	set	
SkillInfoList = nil 
--*
ClusterData = {} 
--*
--[Comment]
--consturctor for ClusterData overrides:
--*
--ClusterData.New()
--*

function ClusterData.New() end
--*
--[Comment]
-- property: Single ClusterData.RotateSpeed	get	set	
RotateSpeed = nil 
--*
--[Comment]
-- property: Single ClusterData.RotateWeight	get	set	
RotateWeight = nil 
--*
--[Comment]
-- property: Vector3 ClusterData.TargetPos	get	set	
TargetPos = nil 
--*
--[Comment]
-- property: Action`1 ClusterData.Moveing	get	set	
Moveing = nil 
--*
--[Comment]
-- property: Action`1 ClusterData.Wait	get	set	
Wait = nil 
--*
--[Comment]
-- property: Action`1 ClusterData.Complete	get	set	
Complete = nil 
--*
--[Comment]
-- property: AllData ClusterData.AllData	get	set	
AllData = nil 
--*
--[Comment]
-- property: ICollisionGraphics ClusterData.MyCollisionGraphics	get	set	
MyCollisionGraphics = nil 
--*
--[Comment]
-- property: Int64 ClusterData.Id	get	
Id = nil 
--*
--[Comment]
-- property: Int32 ClusterData.CollisionGroup	get	set	
CollisionGroup = nil 
--*
--[Comment]
-- property: Single ClusterData.Diameter	get	set	
Diameter = nil 
--*
--[Comment]
-- property: Vector3 ClusterData.Position	get	set	
Position = nil 
--*
--[Comment]
-- property: Single ClusterData.X	get	set	
X = nil 
--*
--[Comment]
-- property: Single ClusterData.Y	get	set	
Y = nil 
--*
--[Comment]
-- property: Single ClusterData.Height	get	set	
Height = nil 
--*
--[Comment]
-- property: Vector3 ClusterData.Rotate	set	
Rotate = nil 
--*
--[Comment]
-- property: Vector3 ClusterData.Direction	get	set	
Direction = nil 
--*
--[Comment]
-- property: Vector3 ClusterData.DirectionRight	get	
DirectionRight = nil 
--*
--[Comment]
-- property: GameObject ClusterData.ItemObj	get	
ItemObj = nil 
--*
--[Comment]
-- property: Boolean ClusterData.CouldMove	get	
CouldMove = nil 
--*
--[Comment]
-- property: Boolean ClusterData.IsMoving	get	
IsMoving = nil 
--*
--[Comment]
-- property: Single ClusterData.Quality	get	set	
Quality = nil 
--*
--[Comment]
-- property: Vector3 ClusterData.SpeedDirection	get	set	
SpeedDirection = nil 
--*
--[Comment]
-- property: Single ClusterData.MaxSpeed	get	set	
MaxSpeed = nil 
--*
--[Comment]
-- property: Boolean ClusterData.CouldSelect	get	set	
CouldSelect = nil 
--*
--[Comment]
-- property: Boolean ClusterData.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean ClusterData.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean ClusterData.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform ClusterData.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject ClusterData.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String ClusterData.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String ClusterData.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags ClusterData.hideFlags	get	set	
hideFlags = nil 
--*
----Void ClusterData:SetDataValue(VOBase data)
function SetDataValue() end 

----Void ClusterData:RotateToWithoutYAxis(Vector3 target)
function RotateToWithoutYAxis() end 

----Void ClusterData:PushTarget(Vector3 target)
function PushTarget() end 

----Void ClusterData:PushTargetList(List`1 targetList)
function PushTargetList() end 

----Boolean ClusterData:PopTarget()
function PopTarget() end 

----Void ClusterData:ClearTarget()
function ClearTarget() end 

----Void ClusterData:Destory()
function Destory() end 

UIScrollViewAdapter = {} 
--*
--[Comment]
--consturctor for UIScrollViewAdapter overrides:
--*
--UIScrollViewAdapter.New()
--*

function UIScrollViewAdapter.New() end
--*
--[Comment]
-- property: Boolean UIScrollViewAdapter.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIScrollViewAdapter.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIScrollViewAdapter.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIScrollViewAdapter.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIScrollViewAdapter.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIScrollViewAdapter.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIScrollViewAdapter.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIScrollViewAdapter.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIScrollViewAdapter:ItemLoaded(UIScrollViewItemBase item,Boolean clear)
function ItemLoaded() end 

----Void UIScrollViewAdapter:ItemSelected(UIScrollViewItemBase item,Boolean clear)
function ItemSelected() end 

----Void UIScrollViewAdapter:ListMoved()
function ListMoved() end 

----Void UIScrollViewAdapter:Create(Int32 items,UIScrollViewItemBase listItemPrefab)
function Create() end 

----Void UIScrollViewAdapter:Reload(Int32 items)
function Reload() end 

----Void UIScrollViewAdapter:Clear()
function Clear() end 

UIScrollViewItemBase = {} 
--*
--[Comment]
--consturctor for UIScrollViewItemBase overrides:
--*
--UIScrollViewItemBase.New()
--*

function UIScrollViewItemBase.New() end
--*
--[Comment]
-- property: Int32 UIScrollViewItemBase.Index	get	set	
Index = nil 
--*
--[Comment]
-- property: Vector2 UIScrollViewItemBase.Size	get	set	
Size = nil 
--*
--[Comment]
-- property: Vector2 UIScrollViewItemBase.Position	get	set	
Position = nil 
--*
--[Comment]
-- property: Boolean UIScrollViewItemBase.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIScrollViewItemBase.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIScrollViewItemBase.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIScrollViewItemBase.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIScrollViewItemBase.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIScrollViewItemBase.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIScrollViewItemBase.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIScrollViewItemBase.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIScrollViewItemBase:Selected(Boolean clear)
function Selected() end 

UI_Cangku_Item = {} 
--*
--[Comment]
--consturctor for UI_Cangku_Item overrides:
--*
--UI_Cangku_Item.New()
--*

function UI_Cangku_Item.New() end
--*
--[Comment]
-- property: GameObject UI_Cangku_Item.cItem	get	set	
cItem = nil 
--*
--[Comment]
-- property: GameObject UI_Cangku_Item.cEquipment	get	set	
cEquipment = nil 
--*
--[Comment]
-- property: Int32 UI_Cangku_Item.Index	get	set	
Index = nil 
--*
--[Comment]
-- property: Vector2 UI_Cangku_Item.Size	get	set	
Size = nil 
--*
--[Comment]
-- property: Vector2 UI_Cangku_Item.Position	get	set	
Position = nil 
--*
--[Comment]
-- property: Boolean UI_Cangku_Item.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UI_Cangku_Item.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UI_Cangku_Item.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UI_Cangku_Item.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UI_Cangku_Item.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UI_Cangku_Item.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UI_Cangku_Item.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UI_Cangku_Item.hideFlags	get	set	
hideFlags = nil 
--*
----Void UI_Cangku_Item:setIcon(String spriteName)
--Void UI_Cangku_Item:setIcon(UIAtlas atlas,String spriteName)
function setIcon() end 

----Void UI_Cangku_Item:setIconLayer(String spriteName)
--Void UI_Cangku_Item:setIconLayer(UIAtlas atlas,String spriteName)
function setIconLayer() end 

----Void UI_Cangku_Item:setIconFrame(String spriteName)
--Void UI_Cangku_Item:setIconFrame(UIAtlas atlas,String spriteName)
function setIconFrame() end 

----Void UI_Cangku_Item:setIconSelectFrame(String spriteName)
function setIconSelectFrame() end 

----Void UI_Cangku_Item:setCompositeMark(Boolean show,Boolean KePinHe)
function setCompositeMark() end 

----Void UI_Cangku_Item:setItemSelect(Boolean selected)
function setItemSelect() end 

----Void UI_Cangku_Item:setItemCount(Int32 count)
function setItemCount() end 

----Void UI_Cangku_Item:setItemCountHide(Boolean shouldBeHide)
function setItemCountHide() end 

----Void UI_Cangku_Item:setEquipmentLevel(Int32 level)
function setEquipmentLevel() end 

----Void UI_Cangku_Item:setEquipped(Boolean Equipped)
function setEquipped() end 

----Void UI_Cangku_Item:setEquipmentLock(Boolean Locked)
function setEquipmentLock() end 

UI_Equip_Item = {} 
--*
--[Comment]
--consturctor for UI_Equip_Item overrides:
--*
--UI_Equip_Item.New()
--*

function UI_Equip_Item.New() end
--*
--[Comment]
-- property: GameObject UI_Equip_Item.cEquipment	get	set	
cEquipment = nil 
--*
--[Comment]
-- property: Int32 UI_Equip_Item.Index	get	set	
Index = nil 
--*
--[Comment]
-- property: Vector2 UI_Equip_Item.Size	get	set	
Size = nil 
--*
--[Comment]
-- property: Vector2 UI_Equip_Item.Position	get	set	
Position = nil 
--*
--[Comment]
-- property: Boolean UI_Equip_Item.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UI_Equip_Item.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UI_Equip_Item.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UI_Equip_Item.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UI_Equip_Item.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UI_Equip_Item.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UI_Equip_Item.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UI_Equip_Item.hideFlags	get	set	
hideFlags = nil 
--*
----Void UI_Equip_Item:setIcon(String spriteName)
--Void UI_Equip_Item:setIcon(UIAtlas atlas,String spriteName)
function setIcon() end 

----Void UI_Equip_Item:setIconFrame(String spriteName)
--Void UI_Equip_Item:setIconFrame(UIAtlas atlas,String spriteName)
function setIconFrame() end 

----Void UI_Equip_Item:setIconSelectFrame(String spriteName)
function setIconSelectFrame() end 

----Void UI_Equip_Item:setEquipmentLevel(Int32 level)
function setEquipmentLevel() end 

----Void UI_Equip_Item:setEquipped(Boolean Equipped)
function setEquipped() end 

----Void UI_Equip_Item:setEquipmentLock(Boolean Locked)
function setEquipmentLock() end 

----Void UI_Equip_Item:setEmpty()
function setEmpty() end 

UIDragScrollView = {} 
--*
--[Comment]
--consturctor for UIDragScrollView overrides:
--*
--UIDragScrollView.New()
--*

function UIDragScrollView.New() end
--*
--[Comment]
-- property: Boolean UIDragScrollView.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean UIDragScrollView.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean UIDragScrollView.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform UIDragScrollView.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject UIDragScrollView.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String UIDragScrollView.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String UIDragScrollView.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags UIDragScrollView.hideFlags	get	set	
hideFlags = nil 
--*
----Void UIDragScrollView:OnPan(Vector2 delta)
function OnPan() end 

UIToast = {} 
--*
--[Comment]
--consturctor for UIToast overrides:
--*
--UIToast.New()
--*

function UIToast.New() end
--*
----Void UIToast.ShowWithCallback(String messageToShow,TweenCallback callback,ShowType showType)
function UIToast.ShowWithCallback() end 

----Void UIToast.Show(String messageToShow)
function UIToast.Show() end 

SceneChanger = {} 
--*
----Int32 SceneChanger.LoadFight(Action callback)
function SceneChanger.LoadFight() end 

----Int32 SceneChanger.LoadChooseFight(Action callback)
function SceneChanger.LoadChooseFight() end 

----Int32 SceneChanger.LoadScene(FightParameter param,Action callback)
function SceneChanger.LoadScene() end 

FightManager = {} 
--*
--[Comment]
--consturctor for FightManager overrides:
--*
--FightManager.New()
--*

function FightManager.New() end
--*
--[Comment]
-- property: FightManager FightManager.Single	get	
Single = nil 
--*
----Void FightManager:StartFight(Int32 mapId,MapDataParamsPacker mapDataPacker,Boolean isOnline)
function StartFight() end 

----Void FightManager:EndFight()
function EndFight() end 

----Void FightManager:InitMap()
--Void FightManager:InitMap(Int32[][] obMapInfo,Int32[][] buildingMapInfo)
function InitMap() end 

----Void FightManager:Clear()
function Clear() end 

MapDataParamsPacker = {} 
--*
--[Comment]
--consturctor for MapDataParamsPacker overrides:
--*
--MapDataParamsPacker.New()
--*

function MapDataParamsPacker.New() end
--*
ChatBubbleAni = {} 
--*
--[Comment]
--consturctor for ChatBubbleAni overrides:
--*
--ChatBubbleAni.New()
--*

function ChatBubbleAni.New() end
--*
--[Comment]
-- property: Boolean ChatBubbleAni.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean ChatBubbleAni.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean ChatBubbleAni.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform ChatBubbleAni.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject ChatBubbleAni.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String ChatBubbleAni.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String ChatBubbleAni.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags ChatBubbleAni.hideFlags	get	set	
hideFlags = nil 
--*
----Void ChatBubbleAni.NextMessageAni(Int32 index,GameObject go1,GameObject go2)
function ChatBubbleAni.NextMessageAni() end 

chatItem = {} 
--*
--[Comment]
--consturctor for chatItem overrides:
--*
--chatItem.New()
--*

function chatItem.New() end
--*
--[Comment]
-- property: Boolean chatItem.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean chatItem.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean chatItem.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform chatItem.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject chatItem.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String chatItem.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String chatItem.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags chatItem.hideFlags	get	set	
hideFlags = nil 
--*
----Void chatItem:showItemByType(Int32 type)
function showItemByType() end 

LoopItemScrollView = {} 
--*
--[Comment]
--consturctor for LoopItemScrollView overrides:
--*
--LoopItemScrollView.New()
--*

function LoopItemScrollView.New() end
--*
--[Comment]
-- property: Boolean LoopItemScrollView.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean LoopItemScrollView.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean LoopItemScrollView.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform LoopItemScrollView.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject LoopItemScrollView.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String LoopItemScrollView.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String LoopItemScrollView.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags LoopItemScrollView.hideFlags	get	set	
hideFlags = nil 
--*
----Void LoopItemScrollView:Init(List`1 datas,DelegateHandler onItemInitCallback)
function Init() end 

----Void LoopItemScrollView:InitScrollView()
function InitScrollView() end 

----Void LoopItemScrollView:UpdateInBack(Int32 uid,String username,String content,String time,Int32 type)
function UpdateInBack() end 

----Void LoopItemScrollView:UpdateInFront(Int32 uid,String username,String content,String time,Int32 type)
function UpdateInFront() end 

----Void LoopItemScrollView:InitScollerView()
function InitScollerView() end 

----Boolean LoopItemScrollView:isSendOldData()
function isSendOldData() end 

MailItem = {} 
--*
--[Comment]
--consturctor for MailItem overrides:
--*
--MailItem.New()
--*

function MailItem.New() end
--*
--[Comment]
-- property: Boolean MailItem.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean MailItem.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean MailItem.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform MailItem.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject MailItem.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String MailItem.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String MailItem.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags MailItem.hideFlags	get	set	
hideFlags = nil 
--*
----Void MailItem:ShowItemTypeAndzuoSP(Int32 type,Boolean isHavefujian)
function ShowItemTypeAndzuoSP() end 

----Void MailItem:ShowFujianNum(Int32 fujianNum,Int32 type)
function ShowFujianNum() end 

----String MailItem:DaoqiTime(Int32 time)
function DaoqiTime() end 

MailLoopGrid = {} 
--*
--[Comment]
--consturctor for MailLoopGrid overrides:
--*
--MailLoopGrid.New()
--*

function MailLoopGrid.New() end
--*
--[Comment]
-- property: Boolean MailLoopGrid.useGUILayout	get	set	
useGUILayout = nil 
--*
--[Comment]
-- property: Boolean MailLoopGrid.enabled	get	set	
enabled = nil 
--*
--[Comment]
-- property: Boolean MailLoopGrid.isActiveAndEnabled	get	
isActiveAndEnabled = nil 
--*
--[Comment]
-- property: Transform MailLoopGrid.transform	get	
transform = nil 
--*
--[Comment]
-- property: GameObject MailLoopGrid.gameObject	get	
gameObject = nil 
--*
--[Comment]
-- property: String MailLoopGrid.tag	get	set	
tag = nil 
--*
--[Comment]
-- property: String MailLoopGrid.name	get	set	
name = nil 
--*
--[Comment]
-- property: HideFlags MailLoopGrid.hideFlags	get	set	
hideFlags = nil 
--*
----Void MailLoopGrid:InsertDataBack(LuaTable dataTable)
function InsertDataBack() end 

----Void MailLoopGrid:UpOneData(String mailID,LuaTable dataTable)
function UpOneData() end 

----Void MailLoopGrid:DelYDorYLQ_Mail()
function DelYDorYLQ_Mail() end 

----Void MailLoopGrid:InitWindow()
function InitWindow() end 

----Void MailLoopGrid:OneBtnGet()
function OneBtnGet() end 

WordFilter = {} 
--*
--[Comment]
--consturctor for WordFilter overrides:
--*
--WordFilter.New()
--*

function WordFilter.New() end
--*
----Void WordFilter.AddStirngToFilters(String s)
function WordFilter.AddStirngToFilters() end 

----String WordFilter.filter(String content,String& result_str,Int32 filter_deep,Boolean check_only,Boolean bTrim,String replace_str)
function WordFilter.filter() end 

SceneManager = {} 
--*
--[Comment]
--consturctor for SceneManager overrides:
--*
--SceneManager.New()
--*

function SceneManager.New() end
--*
--[Comment]
-- property: Int32 SceneManager.sceneCount	get	
--The total number of scenes.
sceneCount = nil 
--*
--[Comment]
-- property: Int32 SceneManager.sceneCountInBuildSettings	get	
--Number of scenes in Build Settings.
sceneCountInBuildSettings = nil 
--*
----Void SceneManager.add_sceneLoaded(UnityAction`2 value)
function SceneManager.add_sceneLoaded() end 

----Void SceneManager.remove_sceneLoaded(UnityAction`2 value)
function SceneManager.remove_sceneLoaded() end 

----Void SceneManager.add_sceneUnloaded(UnityAction`1 value)
function SceneManager.add_sceneUnloaded() end 

----Void SceneManager.remove_sceneUnloaded(UnityAction`1 value)
function SceneManager.remove_sceneUnloaded() end 

----Void SceneManager.add_activeSceneChanged(UnityAction`2 value)
function SceneManager.add_activeSceneChanged() end 

----Void SceneManager.remove_activeSceneChanged(UnityAction`2 value)
function SceneManager.remove_activeSceneChanged() end 

----Scene SceneManager.GetActiveScene()
function SceneManager.GetActiveScene() end 

----Boolean SceneManager.SetActiveScene(Scene scene)
function SceneManager.SetActiveScene() end 

----Scene SceneManager.GetSceneByPath(String scenePath)
function SceneManager.GetSceneByPath() end 

----Scene SceneManager.GetSceneByName(String name)
function SceneManager.GetSceneByName() end 

----Scene SceneManager.GetSceneAt(Int32 index)
function SceneManager.GetSceneAt() end 

----Void SceneManager.LoadScene(String sceneName)
--Void SceneManager.LoadScene(String sceneName,LoadSceneMode mode)
--Void SceneManager.LoadScene(Int32 sceneBuildIndex)
--Void SceneManager.LoadScene(Int32 sceneBuildIndex,LoadSceneMode mode)
function SceneManager.LoadScene() end 

----AsyncOperation SceneManager.LoadSceneAsync(String sceneName)
--AsyncOperation SceneManager.LoadSceneAsync(String sceneName,LoadSceneMode mode)
--AsyncOperation SceneManager.LoadSceneAsync(Int32 sceneBuildIndex)
--AsyncOperation SceneManager.LoadSceneAsync(Int32 sceneBuildIndex,LoadSceneMode mode)
function SceneManager.LoadSceneAsync() end 

----Scene SceneManager.CreateScene(String sceneName)
function SceneManager.CreateScene() end 

----Boolean SceneManager.UnloadScene(Int32 sceneBuildIndex)
--Boolean SceneManager.UnloadScene(String sceneName)
--Boolean SceneManager.UnloadScene(Scene scene)
function SceneManager.UnloadScene() end 

----Void SceneManager.MergeScenes(Scene sourceScene,Scene destinationScene)
function SceneManager.MergeScenes() end 

----Void SceneManager.MoveGameObjectToScene(GameObject go,Scene scene)
function SceneManager.MoveGameObjectToScene() end 

LoadSceneMode = {} 

Single = nil;

Additive = nil;


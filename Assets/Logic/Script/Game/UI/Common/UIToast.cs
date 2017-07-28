using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class UIToast {

    public enum ShowType
    {
        Queue,//根据消息顺序依次弹出
        Upwards,//向上堆叠消息
    }
    /// <summary>
    /// 弹出一个Toast或者多个有序Toast
    /// </summary>
    /// <param name="messageToShow">要显示的信息</param>
    /// <param name="callback">当前信息显示完成后的回调</param>
    /// <param name="showType">显示类型</param>
    public static void Show(string messageToShow, TweenCallback callback, ShowType showType)
    {
        if ( ToastManager._ins == null)
        {
            ToastManager.init();
        }
        if (messageToShow == null || messageToShow == string.Empty)
            return;

        switch (showType)
        {
            case ShowType.Queue:
                ToastManager._ins.enqueueToast(messageToShow,callback);
                break;
            case ShowType.Upwards:
                ToastManager._ins.popToast(messageToShow,callback);
                break;
        }
    }
    /// <summary>
    /// 简化的调用方法
    /// </summary>
    /// <param name="messageToShow"></param>
    public static void Show(string messageToShow)
    {
        if (ToastManager._ins == null)
        {
            ToastManager.init();
        }
        if (messageToShow == null || messageToShow == string.Empty)
            return;
        ToastManager._ins.popToast(messageToShow, null);
    }
    class ToastManager : MonoBehaviour
    {
        public static ToastManager _ins;
        public const string TOAST_GROUP = "ToastGroup";
        public const string PARENT = "UIRoot/FlyRoot";
        
        private static Transform root;
        //prefab Toast
        private GameObject pToast;
        
        void Awake()
        {
            _ins = this;
            MessageQueue = new Queue<Tuple<string, int>>();

            //pToast = GameObjectExtension.InstantiateFromPacket("ui_toast", "Toast", root.gameObject);

            //var iToast = Instantiate(pToast, root) as GameObject;
            var iToast = GameObjectExtension.InstantiateFromPacket("ui_toast", "Toast", root.gameObject);
            iToast.transform.localPosition = position;
            iToast.transform.localScale = Vector3.one;
            wToast = iToast.GetComponent<UIWidget>();
            wToast.color = new Color(wToast.color.r, wToast.color.g, wToast.color.b, 0);

            Queue_sq = DOTween.Sequence();
            Queue_sq.SetAutoKill(false).SetRecyclable(true);
            Queue_splashTweener = DOTween.ToAlpha(() => wToast.color, color => wToast.color = color, 1, 0.35f);
            Queue_fadeTweener = DOTween.ToAlpha(() => wToast.color, color => wToast.color = color, 0, 0.35f);
            Queue_splashTweener.SetRecyclable(true);
            Queue_fadeTweener.SetRecyclable(true);

            Queue_sq.Append(Queue_splashTweener);
            Queue_sq.AppendInterval(Queue_TimeInterval);
            Queue_sq.Append(Queue_fadeTweener);
            Queue_sq.AppendCallback(checkQueue);
            Queue_sq.TogglePause();
        }
        /// <summary>
        /// 消息管理器初始化方法
        /// </summary>
        public static void init()
        {
            root = GameObject.Find(PARENT + "/" + TOAST_GROUP) == null ? null : GameObject.Find(PARENT + "/" + TOAST_GROUP).transform;
            if (root == null)
            {
                root = new GameObject(TOAST_GROUP).transform;
                root.SetParent(GameObject.Find(PARENT).transform);
                root.localScale = Vector3.one;
            }
            root.gameObject.AddComponent<ToastManager>();
        }

        #region ShowType.Queue
        public const float Queue_TimeInterval = 0.75f;
        Sequence Queue_sq;
        Tweener Queue_splashTweener;
        Tweener Queue_fadeTweener;
        Vector3 position = new Vector3(0, -200, 0);
        /**
         * Tuple<string, int>
         * @param string messageToShow
         * @param int32 callback index
         */
        Queue<Tuple<string, int>> MessageQueue;
        private UIWidget wToast;
        /**
         * Dictionary<int, TweenCallback>
         * @param int32 callback index
         * @param TweenCallback callback
         */
        Dictionary<int, TweenCallback> CallbackTable = new Dictionary<int, TweenCallback>();
        int CallbackID = 0;
        public void enqueueToast(string messageToShow, TweenCallback callback)
        {
            CallbackTable.Add(CallbackID, callback);
            MessageQueue.Enqueue(Tuple.Create(messageToShow, CallbackID++));
            checkQueue();
        }
        private void dequeueToast()
        {
            var msg = MessageQueue.Dequeue();
            var message = msg.Item1;
            var callbackID = msg.Item2;

            wToast.GetComponentInChildren<UILabel>().text = message;
            wToast.GetComponentInChildren<UILabel>().AssumeNaturalSize();
            wToast.GetComponentInChildren<UISprite>().width = wToast.GetComponentInChildren<UILabel>().width + 80;

            Queue_fadeTweener.OnComplete(getCallbackByID(callbackID));

            Queue_sq.Restart(); 
        }
        private void checkQueue()
        {
            if (Queue_sq == null || Queue_sq.IsPlaying())
                return;
            if (MessageQueue.Count != 0)
                dequeueToast();
            else
            {
                CallbackTable.Clear();
                CallbackID = 0;
            }
        }
        private TweenCallback getCallbackByID(int CallbackID)
        {
            return CallbackTable[CallbackID];
        }
        #endregion

        #region ShowType.Upwards
        //限制最多同时显示的Toast
        public const int LIMIT = 5+(+1);
        public const float Upwards_TimeInterval = 2f;
        /// <summary>
        /// 使用环状缓冲区代替字典数组实现内存优化
        /// head 队头索引
        /// tail 队尾索引
        /// circleTable 环状缓冲区数组
        /// </summary>
        int head = 0;
        int tail = 0;
        Tuple<Sequence, GameObject>[] circleTable = new Tuple<Sequence, GameObject>[LIMIT];

        public void popToast(string messageToShow, TweenCallback callback)
        {
            /**
             * 遍历数组中的旧消息，并使它们都做向上移动的动画
             **/
            int i = tail;
            while (i != head)
            {
                if (circleTable[i].Item1.IsPlaying())
                {
                    var moveY = circleTable[i].Item2.GetComponent<UIWidget>().height;
                    var ToastPosition = circleTable[i].Item2.transform.position;
                    circleTable[i].Item1.Join(circleTable[i].Item2.transform.DOBlendableLocalMoveBy(
                        new Vector3(0, moveY, 0), 0.2f, true));
                }
                i = (i + 1 + LIMIT) % LIMIT;
            }

            //var iToast = Instantiate(pToast, root) as GameObject;
            GameObject iToast = GameObjectExtension.InstantiateFromPacket("ui_toast", "Toast", root.gameObject);
            iToast.name = head.ToString();
            iToast.transform.localPosition = position;
            iToast.transform.localScale = Vector3.one;
            iToast.GetComponentInChildren<UILabel>().text = messageToShow;
            iToast.GetComponentInChildren<UILabel>().AssumeNaturalSize();
            iToast.GetComponentInChildren<UISprite>().width = iToast.GetComponentInChildren<UILabel>().width + 80;
            var iWidget = iToast.GetComponent<UIWidget>();
            iWidget.alpha = 0;

            var sq = DOTween.Sequence();
            var Upwards_splashTweener = DOTween.ToAlpha(() => iWidget.color, color => iWidget.color = color, 1, 0.5f);
            var Upwards_fadeTweener = DOTween.ToAlpha(() => iWidget.color, color => iWidget.color = color, 0, 0.35f);

            sq.Append(Upwards_splashTweener);
            sq.AppendInterval(Upwards_TimeInterval);
            sq.Append(Upwards_fadeTweener);
            //动画完成时，使队尾索引向后移动
            callback += () => { tail = (tail + 1 + LIMIT) % LIMIT; Destroy(iToast); };
            sq.AppendCallback(callback);

            //队头索引向后移动
            circleTable[(head + LIMIT) % LIMIT] = Tuple.Create(sq, iToast);
            head = (head + 1 + LIMIT) % LIMIT;
            //当队头索引将要覆盖队尾时，让队尾元素提前完成逻辑并向前移动
            if ((head + LIMIT) % LIMIT == tail)
            {
                circleTable[tail].Item1.Complete(true);
            }
        }
        #endregion
    }
}


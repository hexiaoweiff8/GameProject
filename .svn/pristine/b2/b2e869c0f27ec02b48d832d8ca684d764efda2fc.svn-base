namespace Assets.scripts.interfaces
{
    /// <summary>
    /// 有生命条的物体 可销毁 可激活 需要更新
    /// </summary>
    public interface ILife
    {
        /// <summary>
        /// 激活
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        ObjectID Activate(ObjectID ID);

        /// <summary>
        /// 销毁
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        bool Distroy(ObjectID ID);

        /// <summary>
        /// 刷新数据
        /// </summary>
        /// <param name="duringTime">单位秒</param>
        /// <returns></returns>
        bool Updata(float duringTime);
    }
}
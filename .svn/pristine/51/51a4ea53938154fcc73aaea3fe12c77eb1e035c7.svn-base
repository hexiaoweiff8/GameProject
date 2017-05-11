using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX;

public class AudioFxInfo
{
    internal static short IID;
    internal static short IVibration;
    internal static short ITexiao1;
    internal static short ITexiao2;
    internal static short ITexiao3;
    internal static short IAudio1;
    internal static short IAudio2;
    //internal static short ITexiaoYanchi;

    internal static void FillFieldIndex(ITabReader reader)
    {
        IID = reader.ColumnName2Index("ID");
        IVibration = reader.ColumnName2Index("Vibration");
        ITexiao1 = reader.ColumnName2Index("Texiao1");
        ITexiao2 = reader.ColumnName2Index("Texiao2");
        ITexiao3 = reader.ColumnName2Index("Texiao3");
        IAudio1 = reader.ColumnName2Index("Audio1");
        IAudio2 = reader.ColumnName2Index("Audio2");
        //ITexiaoYanchi = reader.ColumnName2Index("TexiaoYanchi");

        
    }

    List<int> tmpID = new List<int>();
    public AudioFxInfo(ITabReader reader, int row)
    {
        ID = reader.GetI32(IID, row);
        {
            tmpID.Clear();
            var Vibration = reader.GetS(IVibration, row);
            if (!string.IsNullOrEmpty(Vibration))
            {
                try
                {
                    var idarray = Vibration.Split('|');
                    Array.ForEach(idarray, (v) => { var intv = int.Parse(v); if (intv > 0) tmpID.Add(intv); });
                }
                catch (Exception)
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("AudioFx.Vibration 填写有误 ID:{0}", ID));
                }
            }
            VibrationID = tmpID.ToArray();
        }
        {
            int txid1 = reader.GetI32(ITexiao1, row);
            int txid2 = reader.GetI32(ITexiao2, row);
            string txid3 = reader.GetS(ITexiao3, row);

            tmpID.Clear();
            if (txid1 > 0) tmpID.Add(txid1);
            if (txid2 > 0) tmpID.Add(txid2);
            if (!string.IsNullOrEmpty(txid3))
            {
                try
                {
                    var idarray = txid3.Split('|');
                    Array.ForEach(idarray, (v) => { var intv = int.Parse(v); if (intv > 0) tmpID.Add(intv); });
                }
                catch (Exception)
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("AudioFx.Texiao3 填写有误 ID:{0}", ID));
                }
            }
            TexiaoID = tmpID.ToArray();
        }

        //TexiaoYanchi = (float)reader.GetI16(ITexiaoYanchi, row) / 1000f;

        {
            int audio1 = reader.GetI32(IAudio1, row);
            string audio2 = reader.GetS(IAudio2, row);

            tmpID.Clear();
            if (audio1 > 0) tmpID.Add(audio1);
            if (!string.IsNullOrEmpty(audio2))
            {
                try
                {
                    var idarray = audio2.Split('|');
                    Array.ForEach(idarray, (v) => { var intv = int.Parse(v); if (intv > 0) tmpID.Add(intv); });

                }
                catch (Exception)
                {
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("AudioFx.Audio2 填写有误 ID:{0}", ID));
                }
            }
            AudioID = tmpID.ToArray();
        }
    }

    public void BuildLinks()
    {
        float live = 0;

        {
            Texiaos = new TexiaoInfo[TexiaoID.Length];
            int i = 0; Array.ForEach(TexiaoID, (id) =>
                    {
                        var tmp = Texiaos[i++] = SData_Texiao.Single.Get(id);
                        if (tmp == null) 
                            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("AudioFx 不存在的特效ID:{0}", id));
                         
                        if (tmp.LiveTime > live) live = tmp.LiveTime;
                        if (tmp.AnimMode == TexiaoAnimMode.Loop) live = 99999999;
                    }
                );
        }

        {
            Audios = new AudioInfo[AudioID.Length];
            int i = 0; Array.ForEach(AudioID, (id) =>
            {
                var tmp = Audios[i++] = SData_Audio.Single.Get(id);
                if (tmp == null)
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("AudioFx 不存在的音效ID:{0}", id));
                         

                if (tmp.LiveTime > live) live = tmp.LiveTime;
                if (tmp.AnimMode == AudioAnimMode.Loop) live = 99999999;
            }
            );
        }

        {
            Vibrations = new VibrationInfo[VibrationID.Length];
            int i = 0; Array.ForEach(VibrationID, (id) =>
            {
                var tmp = Vibrations[i++] = SData_Vibration.Single.Get(id);

                if (tmp == null)
                    MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_ERROR, string.Format("AudioFx 不存在的震动ID:{0}", id));

                if (tmp.LiveTime > live) live = tmp.LiveTime;
                if (tmp.AnimMode == VibrationAnimMode.Loop) live = 99999999;
            }
            );
        }

        if (live > 0) LiveTime = live;
    }

    //public readonly float TexiaoYanchi;

    public readonly int ID;
    int[] TexiaoID;
    public TexiaoInfo[] Texiaos;

    readonly int[] AudioID;
    public AudioInfo[] Audios;

    readonly int[] VibrationID;
    public VibrationInfo[] Vibrations;

    public float LiveTime = 99999999;//效果生命
}

public class SData_AudioFx : MonoEX.Singleton<SData_AudioFx>
{
    public SData_AudioFx()
    {
        using (ITabReader reader = TabReaderManage.Single.CreateInstance())
        {
            MonoEX.Debug.Logout(MonoEX.LOG_TYPE.LT_INFO, "开始装载 AudioFx");
            reader.Load("bsv", "AudioFx");
            AudioFxInfo.FillFieldIndex(reader);

            int rowCount = reader.GetRowCount();
            for (int row = 0; row < rowCount; row++)
            {
                AudioFxInfo sa = new AudioFxInfo(reader, row);
                Data.Add(sa.ID, sa);
            }
        }
    }

    public AudioFxInfo Get(int id)
    {
        if (!Data.ContainsKey(id)) return null;
        return Data[id];
    }

    public void BuildLinks()
    {
        foreach (var kv in Data) kv.Value.BuildLinks();
    }
    Dictionary<int, AudioFxInfo> Data = new Dictionary<int, AudioFxInfo>();
}

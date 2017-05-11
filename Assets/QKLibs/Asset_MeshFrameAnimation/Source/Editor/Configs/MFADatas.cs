using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MonoEX;
class MFADatas : SingletonAuto<MFADatas>
{
    public readonly MFAData_AnimationExport AnimationExport = new MFAData_AnimationExport();
    public readonly MFAData_ClipDefine ClipDefine = new MFAData_ClipDefine();
    public readonly MFAData_Frames Frames = new MFAData_Frames();
    public readonly MFAData_ModelClips ModelClips = new MFAData_ModelClips();

    public MFADatas()
    {
    }
    public void AutoReload()
    {
        AnimationExport.AutoReload();
        ClipDefine.AutoReload();
        Frames.AutoReload();
        ModelClips.AutoReload();


        ModelClips.BuildLinks(ClipDefine);

        ClipDefine.BuildLinks(Frames);

    }
}

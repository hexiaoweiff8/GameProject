using UnityEngine;
using System.Collections;

public class DragableCard : UIDragDropItem {

    protected override void OnDragDropRelease(GameObject surface) {
        base.OnDragDropRelease(surface);

        //if ( surface!=null && surface.tag == "FightCard") {
        //    //拖拽到了可发牌区域
        //} else {
        //    //transform.parent.GetComponent<MyCard>().UpdateShow();
        //}
    }
	
}

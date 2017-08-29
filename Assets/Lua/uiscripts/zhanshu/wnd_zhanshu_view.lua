---
--- Created by Administrator.
--- DateTime: 2017/8/16 16:54
---

wnd_zhanshu_view = {}



local this = wnd_zhanshu_view


function wnd_zhanshu_view:initview(root)
    self = root
    this.tags = {}
    this.tags["tag_all"] = self.transform:Find("ui_zs_soldier/tags/tag_all").gameObject
    this.tags["tag_human"] = self.transform:Find("ui_zs_soldier/tags/tag_human").gameObject
    this.tags["tag_beast"] = self.transform:Find("ui_zs_soldier/tags/tag_beast").gameObject
    this.tags["tag_machine"] =self.transform:Find("ui_zs_soldier/tags/tag_machine").gameObject

    this.skills = {}
    for i=1,5 do
        this.skills[i] = self.transform:Find("ui_zs_soldier/info_retire_bg/info_panel/skill_info/card_skill"..tostring(i)).gameObject
    end

    this.tuiyipic_list = {}
    for i=1,12 do
        this.tuiyipic_list[i] = self.transform:Find("ui_zs_soldier/info_retire_bg/retire_panel/tuiyi_pos/tuiyi_pos"..tostring(i)).gameObject
    end
    this.info_panel = self.transform:Find("ui_zs_soldier/info_retire_bg/info_panel").gameObject
    this.intro_label1 = this.info_panel.transform:Find("cardinfo_intro/intro_label1").gameObject
    this.intro_label2 = this.info_panel.transform:Find("cardinfo_intro/intro_label2").gameObject
    this.intro_label3 = this.info_panel.transform:Find("cardinfo_intro/intro_label3").gameObject

    this.carditem = self.transform:Find("ui_zs_soldier/card_bg/card_panel/cardGrid/carditem").gameObject
    this.carditem:SetActive(false)

    this.skill_tips_bg = self.transform:Find("ui_zs_soldier/info_retire_bg/info_panel/skill_tips_bg").gameObject
    this.weijihuo_bg = self.transform:Find("ui_zs_soldier/info_retire_bg/info_panel/weijihuo_bg").gameObject
    this.weijihuo_bg:SetActive(false)


    this.card_bg = self.transform:Find("ui_zs_soldier/card_bg").gameObject
    this.cardpanel = self.transform:Find("ui_zs_soldier/card_bg/card_panel").gameObject

    this.cardGrid = self.transform:Find("ui_zs_soldier/card_bg/card_panel/cardGrid").gameObject
    --this.cardGrid:GetComponent("UIGrid").enabled = true

    this.cardinfo_item = self.transform:Find("ui_zs_soldier/info_retire_bg/info_panel/cardinfo_item").gameObject
    this.cardinfo_characteristic = self.transform:Find("ui_zs_soldier/info_retire_bg/info_panel/cardinfo_characteristic").gameObject
    this.cardinfo_intro = self.transform:Find("ui_zs_soldier/info_retire_bg/info_panel/cardinfo_intro").gameObject
    this.cardinfo_type = this.info_panel.transform:Find("cardinfo_type").gameObject


    this.soldierpanel =self.transform:Find("ui_zs_soldier").gameObject
    this.skillpanel =self.transform:Find("ui_zs_skill").gameObject

    this.btn_change = self.transform:Find("share_item/btn_change").gameObject
    this.btn_change_label = self.transform:Find("share_item/btn_change/btn_change_label").gameObject
    this.btn_back = self.transform:Find("share_item/btn_back").gameObject

    this.btn_biandui = self.transform:Find("share_item/btn_biandui").gameObject

    this.btn_soldierctr = self.transform:Find("ui_zs_soldier/btn_soldierctr").gameObject

    this.info_retire_bg = self.transform:Find("ui_zs_soldier/info_retire_bg").gameObject
    this.info_retire_bg:SetActive(false)
    this.xiangqing_bg = this.info_panel.transform:Find("xiangqing_bg").gameObject

    this.retire_panel = self.transform:Find("ui_zs_soldier/info_retire_bg/retire_panel").gameObject

    this.tuiyi_award_num = this.retire_panel.transform:Find("tuiyi_award/tuiyi_award_num").gameObject
    this.btn_tuiyi = this.retire_panel.transform:Find("btn_tuiyi").gameObject

    this.clone_card_panel = self.transform:Find("clone_card_panel").gameObject
    this.clone_card_panel.transform.localPosition = this.info_retire_bg.transform.localPosition
    this.card_clone = this.clone_card_panel.transform:Find("card_clone").gameObject

    ------淡入淡出部分-------
    this.card_ns_widget = this.carditem.transform:Find("card_jindu_frame/card_ns_widget").gameObject
    this.card_ns_icon = this.card_ns_widget.transform:Find("card_ns_icon").gameObject
    this.card_ns_pic = this.card_ns_widget.transform:Find("card_ns_frame/card_ns_pic").gameObject
    this.card_ns_label = this.card_ns_widget.transform:Find("card_ns_frame/card_ns_label").gameObject

    -------static label----------
    this.tag_all_label = self.transform:Find("ui_zs_soldier/tags/tag_all/all_label").gameObject
    this.tag_human_label = self.transform:Find("ui_zs_soldier/tags/tag_human/human_label").gameObject
    this.tag_beast_label = self.transform:Find("ui_zs_soldier/tags/tag_beast/beast_label").gameObject
    this.tag_machine_label = self.transform:Find("ui_zs_soldier/tags/tag_machine/machine_label").gameObject
    this.weijihuolabel = this.weijihuo_bg.transform:Find("weijihuo_label").gameObject
    this.tuiyi_intro_label = this.retire_panel.transform:Find("tuiyi_intro/tuiyi_intro_label").gameObject
    this.tuiyi_award_label = this.retire_panel.transform:Find("tuiyi_award/tuiyi_award_label").gameObject
    this.btn_tuiyi_label = this.retire_panel.transform:Find("btn_tuiyi/btn_tuiyi_label").gameObject
end



return this
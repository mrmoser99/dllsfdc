/**
 * Created by samuelmeyers on 11/8/18.
 */

public with sharing class FMZ_QuickActionController {
    private static final String BASE_URL = System.Label.FMZ_Dealer_Community_Base_URL;

    private static List<String> appApprovedStrings = new List<String>{
            'CREDIT APPROVED'
    };
    private static List<String> appInProgressStrings = new List<String>{
            'NEW - ENTERED',
            'NEW - CREDIT PULLED',
            'NEW - IN CREDIT CHECK',
            'NEW - IN REVIEW',
            'NEW - PRICING GENERATED',
            'NEW - CHECKLIST GENERATED'
    };
    private static List<String> qqApprovedStrings = new List<String>{
            'CREDIT APPROVED'
    };

    @AuraEnabled
    public static List<Section> getSections(){
        FMZ_CTA_Settings__c setting = FMZ_CTA_Settings__c.getOrgDefaults();
        List<Section> sections = new List<Section>();
        sections.add(new Section(
                'Fund_Applications',
                setting.Fund_Apps_Label__c,
                setting.Fund_Apps_Call_to_Action__c,
                setting.Fund_Apps_Name_Column_Label__c,
                setting.Fund_Apps_Info_Column_Label__c,
                setting.Fund_Apps_Action_Label__c,
                setting.Fund_Apps_Complete_Message__c));
        sections.add(new Section(
                'Complete_Applications',
                setting.Complete_Apps_Label__c,
                setting.Complete_Apps_Call_to_Action__c,
                setting.Complete_Apps_Name_Column_Label__c,
                setting.Complete_Apps_Info_Column_Label__c,
                setting.Complete_Apps_Action_Label__c,
                setting.Complete_Apps_Complete_Message__c));
        sections.add(new Section(
                'Convert_Credit_Checks',
                setting.Convert_CC_Label__c,
                setting.Convert_CC_Call_to_Action__c,
                setting.Convert_CC_Name_Column_Label__c,
                setting.Convert_CC_Info_Column_Label__c,
                setting.Convert_CC_Action_Label__c,
                setting.Convert_CC_Complete_Message__c));

        List<String> appStatus = new List<String>();
        appStatus.addAll(appApprovedStrings);
        appStatus.addAll(appInProgressStrings);

        List<genesis__Applications__c> apps = [
                SELECT Id, Name, genesis__Status__c, genesis__Account__r.Name, Lease_Number__c
                FROM genesis__Applications__c
                WHERE genesis__Status__c IN: appStatus
                ORDER BY LastModifiedDate DESC, genesis__Status__c
        ];

        List<genesis__Quick_Quotes__c> qqs = [
                SELECT Id, Name, genesis__Status__c, genesis__Account__r.Name
                FROM genesis__Quick_Quotes__c
                WHERE genesis__Status__c IN: qqApprovedStrings
                ORDER BY LastModifiedDate DESC, genesis__Status__c
        ];

        List<SectionItem> approvedApps = new List<SectionItem>();
        List<SectionItem> inProgressApps = new List<SectionItem>();

        if(apps.size() > 0){
            for(genesis__Applications__c app : apps){
                if(appApprovedStrings.contains(app.genesis__Status__c) && app.Lease_Number__c == null){
                    approvedApps.add(new SectionItem(app.Id, app.Name, BASE_URL+app.Id, app.genesis__Account__r.Name, null, 'Fund'));
                }else if(appInProgressStrings.contains(app.genesis__Status__c) && app.Lease_Number__c == null){
                    inProgressApps.add(new SectionItem(app.Id, app.Name, BASE_URL+app.Id, app.genesis__Account__r.Name, null, 'View'));
                }
            }
        }

        List<SectionItem> approvedQQs = new List<SectionItem>();
        if(qqs.size() > 0){
            for(genesis__Quick_Quotes__c qq : qqs){
                approvedQQs.add(new SectionItem(qq.Id, qq.Name, BASE_URL+qq.Id, qq.genesis__Account__r.Name, null, 'Convert'));
            }
        }
        
        sections[0].items = approvedApps;
        sections[1].items = inProgressApps;
        sections[2].items = approvedQQs;

        return sections;
    }

    public class Section {
        @AuraEnabled
        public String name;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String title;

        @AuraEnabled
        public String linkColTitle;

        @AuraEnabled
        public String infoColTitle;

        @AuraEnabled
        public String actionLabel;

        @AuraEnabled
        public String emptyListMessage;

        @AuraEnabled
        public List<SectionItem> items;

        public Section(String name, String label, String title, String linkColTitle, String infoColTitle, String globalAction, String emptyListMessage){
            this.name = name;
            this.label = label;
            this.title = title;
            this.linkColTitle = linkColTitle;
            this.infoColTitle = infoColTitle;
            this.actionLabel = globalAction;
            this.emptyListMessage = emptyListMessage;
            this.items = new List<SectionItem>();
        }

    }

    public class SectionItem {
        @AuraEnabled
        public String id;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String link;

        @AuraEnabled
        public String info;

        @AuraEnabled
        public String action;

        @AuraEnabled
        public String actionLabel;

        public SectionItem(String id, String name, String link, String info, String action, String actionLabel){
            this.id = id;
            this.name = name;
            this.link = link;
            this.info = info;
            this.action = action;
            this.actionLabel = actionLabel;
        }
    }
}
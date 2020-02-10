/**
 * Created by samuelmeyers on 11/8/18.
 */

public with sharing class FMZ_QuickActionController_Temp {
    private static final String BASE_URL = System.Label.FMZ_Dealer_Community_Base_URL;

    private static List<String> appApprovedStrings = new List<String>{
            'CAMS APPROVED'
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
        List<Section> sections = new List<Section>();
        sections.add(new Section(
                'https://newcoleasing--dev--c.cs66.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=0680v000000LXkD&operationContext=CHATTER&contentId=05T0v000001Drnf',
                'Fund_Applications',
                'Apps Ready to Fund',
                'Fund These Applications for $$$',
                'Number',
                'Info',
                null,
                'All OFAC Approved Applications have been funded!'));
        sections.add(new Section(
                'https://newcoleasing--dev--c.cs66.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=0680v000000LXk8&operationContext=CHATTER&contentId=05T0v000001DrnV',
                'Complete_Applications',
                'Incomplete Apps',
                'Complete These Applications',
                'Number',
                'Info',
                null,
                'All Applications are Complete!'));
        sections.add(new Section(
                null,
                'Convert_Credit_Checks',
                'Approved Credit Checks',
                'Convert these Credit Checks to Applications',
                'Number',
                'Info',
                null,
                'All Approved Credit Checks have been converted!'));
        sections.add(new Section(
                null,
                'Create_Credit_Checks',
                'New Credit Check',
                'Time to check some credit!',
                null,
                null,
                'c:FMZ_CreditApproval_NewButton',
                'Time to check some credit!'));

        List<String> appStatus = new List<String>();
        appStatus.addAll(appApprovedStrings);
        appStatus.addAll(appInProgressStrings);

        List<genesis__Applications__c> apps = [
                SELECT Id, Name, genesis__Status__c, genesis__Account__r.Name
                FROM genesis__Applications__c
                WHERE genesis__Status__c IN: appStatus
                ORDER BY LastModifiedDate, genesis__Status__c
        ];

        List<genesis__Quick_Quotes__c> qqs = [
                SELECT Id, Name, genesis__Status__c, genesis__Account__r.Name
                FROM genesis__Quick_Quotes__c
                WHERE genesis__Status__c IN: qqApprovedStrings
                ORDER BY LastModifiedDate, genesis__Status__c
        ];

        List<SectionItem> approvedApps = new List<SectionItem>();
        List<SectionItem> inProgressApps = new List<SectionItem>();

        for(genesis__Applications__c app : apps){
            if(appApprovedStrings.contains(app.genesis__Status__c)){
                approvedApps.add(new SectionItem(app.Id, app.Name, BASE_URL+app.Id, app.genesis__Account__r.Name, null));
            }else{
                inProgressApps.add(new SectionItem(app.Id, app.Name, BASE_URL+app.Id, app.genesis__Account__r.Name, null));
            }
        }

        List<SectionItem> approvedQQs = new List<SectionItem>();
        for(genesis__Quick_Quotes__c qq : qqs){
            approvedQQs.add(new SectionItem(qq.Id, qq.Name, BASE_URL+qq.Id, qq.genesis__Account__r.Name, null));
        }

        sections[0].items = approvedApps;
        sections[1].items = inProgressApps;
        sections[2].items = approvedQQs;

        return sections;
    }

    public class Section {
        @AuraEnabled
        public String imageSource;

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
        public String globalAction;

        @AuraEnabled
        public String emptyListMessage;

        @AuraEnabled
        public List<SectionItem> items;

        public Section(String imageSource, String name, String label, String title, String linkColTitle, String infoColTitle, String globalAction, String emptyListMessage){
            this.imageSource = imageSource;
            this.name = name;
            this.label = label;
            this.title = title;
            this.linkColTitle = linkColTitle;
            this.infoColTitle = infoColTitle;
            this.globalAction = globalAction;
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

        public SectionItem(String id, String name, String link, String info, String action ){
            this.id = id;
            this.name = name;
            this.link = link;
            this.info = info;
            this.action = action;
        }
    }
}
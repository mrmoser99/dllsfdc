/**
 * Created by samuelmeyers on 12/11/18.
 */

public without sharing class FMZ_WelcomeMessageController {
    @AuraEnabled
    public static MessageSetting getWelcomeMessage(){
        FMZ_Welcome_Message__c setting = FMZ_Welcome_Message__c.getOrgDefaults();

        PMUtility.getAccessToken();
        
        return new MessageSetting(
                setting.Text_Color_Hex_Code__c,
                setting.Background_Color_Hex_Code__c,
                setting.Title__c.replaceAll('\\{0\\}', UserInfo.getName()).replaceAll('\\{1\\}', UserInfo.getFirstName()),
                setting.Subtitle__c.replaceAll('\\{0\\}', UserInfo.getName()).replaceAll('\\{1\\}', UserInfo.getFirstName())
        );
    }

    public class MessageSetting {
        @AuraEnabled
        public String textColor;

        @AuraEnabled
        public String backgroundColor;

        @AuraEnabled
        public String title;

        @AuraEnabled
        public String subtitle;

        public MessageSetting(String textColor, String backgroundColor, String title, String subtitle){
            this.textColor = textColor;
            this.backgroundColor = backgroundColor;
            this.title = title;
            this.subtitle = subtitle;
        }
    }
}
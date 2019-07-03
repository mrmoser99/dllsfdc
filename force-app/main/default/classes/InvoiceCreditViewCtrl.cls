/**
 * Created by Balaji Rajendran on 5/27/19.
 */

public with sharing class InvoiceCreditViewCtrl {
    public Cllease__Lease_Account__c leaseAccount{ get;set; }
    public Account lessee { get;set; }
    public Cllease__Invoice_Credit__c invoiceCredit { get; set; }
    public String leaseParam { get;set; }

    private ApexPages.StandardController ctrl;
    private String parentUrl;
    string defaultReturnURL;

    public InvoiceCreditViewCtrl(ApexPages.StandardController controller) {
        this.invoiceCredit = (Cllease__Invoice_Credit__c) controller.getRecord();
        system.debug(LoggingLevel.DEBUG, '*** Invoice credit is ' + invoiceCredit);
        leaseParam = ApexPages.currentPage().getParameters().get('leaseId');

        Map<String, String> params = ApexPages.currentPage().getParameters();
        parentUrl = params.get('retURL');

        ctrl = controller;
        if (leaseParam != null) {
            leaseAccount = [SELECT Id, Name, Cllease__Lease_Status__c, Cllease__Account__c
                            FROM Cllease__Lease_Account__c
                            WHERE Id = :leaseParam
                            ];
            if (leaseAccount != null) {
                invoiceCredit.Cllease__Contract__c = leaseAccount.Id;
                invoiceCredit.Cllease__Account__c = leaseAccount.Cllease__Account__c;
            }
        } else {
            if (invoiceCredit.Cllease__Contract__c != null) {
                leaseAccount = [
                        SELECT Id, Name, Cllease__Account__c,
                                Cllease__Lease_Status__c
                        FROM Cllease__Lease_Account__c
                        WHERE Id = :this.invoiceCredit.Cllease__Contract__c
                ];
                invoiceCredit.Cllease__Account__c = leaseAccount.Cllease__Account__c;
            }
        }

        defaultReturnURL = '/' + invoiceCredit.Cllease__Contract__c;

        if (invoiceCredit.Cllease__Account__c != null) {
            lessee = [
                    SELECT Id, Name
                    FROM Account
                    WHERE Id = :invoiceCredit.Cllease__Account__c
            ];

        } else if (invoiceCredit.Cllease__Contract__c != null) {
            lessee = [
                    SELECT Id, Name
                    FROM Account
                    WHERE Id = :leaseAccount.Cllease__Account__c
            ];
        }
    }

    public Boolean validate() {
        return true;
    }

    public PageReference cancel() {
        PageReference ref = new PageReference(defaultReturnURL);
        if (parentUrl != null) {
            ref = new PageReference(parentUrl);
        }
        return ref;
    }

    public PageReference save() {
        try {
            if(validate()) {
                upsert invoiceCredit;
                PageReference ref = new PageReference(defaultReturnURL);
                if (parentUrl != null) {
                    ref = new PageReference(parentUrl);
                }
                return ref;
            }
        } catch(DMLException e) {
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR, e.getDMLmessage(0));
            ApexPages.addMessage(message);
        }catch(Exception e){
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR, e.getMessage());
            ApexPages.addMessage(message);
        }
        return null;
    }

}
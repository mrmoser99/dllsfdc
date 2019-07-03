@istest
public class TestRecon {
    
   static testMethod void Test1()
   {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
        email.subject = 'Create Contact';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'email body';
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        String myBody =' Payment Method,Payment Channel,Processing Date,Capture Date,Biller Account Number,Invoice Number,Name,Invoice Payment,Reversal Amount,Confirmation #,Reversal Reason,Fee,Status\n' +
                     ',,,,,,,,,,\n' +
                     'ACH-CCD,Enrolled,6/01/2018,6/01/2018,0000000420,INV-0000000059,DIVERSIFIED SKILLED STAFFING L,211.00,0.00,3106649839,,0.00,OK\n' +
                     'ACH-CCD,Enrolled,6/13/2018,6/12/2018,0000000420,INV-0000000093,DIVERSIFIED SKILLED STAFFING L,135.93,0.00,3106719860,,0.00\n' +
                     'ACH-CCD,Enrolled,6/13/2018,6/13/2018,0000000418,INV-0000000094,AMERICAN HOME HEALTH SERVICES LLC,786.18,0.00,3106723536,,0.00\n';
        attachment.body = blob.valueOf(myBody);
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     
        Reconciler testInbound=new Reconciler ();

        testInbound.handleInboundEmail(email, env);
   }
}
@isTest
public class VertexHttpResponseGenerator  {

    /**
     * Following method helps in generating the HTTP Response for Charges
     * i. if dueDetailLines.size() <= 2, generate successful response
     * ii.if dueDetailLines.size() >= 3, generate failed resonse to cover failure test cases.
     **/
    public static HTTPResponse vertexBillHTTPResponse(List<cllease__Due_Detail_Lines__c> dueDetailLines) {
        // extracting Names  from Charges
        List<String> dueDetailLineNames = new List<String>();
        for(cllease__Due_Detail_Lines__c dueDetailLine : dueDetailLines) {
            dueDetailLineNames.add(dueDetailLine.Name);
        }
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody((dueDetailLines.size() <= 2 ? generateResponse(dueDetailLineNames) : vertexFailedHTTPResponse()));
        res.setStatusCode((dueDetailLines.size() <= 2 ? 200 : 500));
        return res;
    }

    /**
     * Following method helps in generating the HTTP Response for Charges
     * i. if charges.size() <= 2, generate successful response
     * ii.if charges.size() >= 3, generate failed resonse to cover failure test cases.
     **/
    public static HTTPResponse vertexChargeHTTPResponse(List<cllease__Charge__c> charges) {
        // extracting Names  from Charges
        List<String> chargeNames = new List<String>();
        for(cllease__Charge__c charge : charges) {
            chargeNames.add(charge.Name);
        }
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody((chargeNames.size() <= 2 ? generateResponse(chargeNames) : vertexFailedHTTPResponse()));
        res.setStatusCode((chargeNames.size() <= 2 ? 200 : 500));
        return res;
    }

    /**
     * Following method helps in generating the HTTP Response for Charges
     * i. if charges.size() <= 2, generate successful response
     * ii.if charges.size() >= 3, generate failed resonse to cover failure test cases.
     **/
    public static HTTPResponse vertexUpfrontHTTPResponse(List<genesis__Application_Equipment__c> appEquipmentList) {
        // extracting Names  from Charges
        List<String> appEqpNames = new List<String>();
        for(genesis__Application_Equipment__c appEqp : appEquipmentList) {
            appEqpNames.add(appEqp.Name);
        }

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        // Hard coding response to single Equipment and throw exception for multiple Equipment
        res.setBody(((appEqpNames.size() <= 2 &  appEqpNames.size() > 0 )? generateResponse(appEqpNames) : vertexFailedHTTPResponse()));
        res.setStatusCode((appEqpNames.size() <= 2 ? 200 : 500));
        return res;
    }



    /**
     * Following  helper method generates the failed response for 
     * negative test case generation
     **/
    public static String vertexFailedHTTPResponse() {
        String httpResBody 
            =' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">      '+
            '    <soapenv:Header/>                                                              '+
            '    <soapenv:Body>                                                                 '+
            '       <soapenv:Fault>                                                             '+
            '          <faultcode>soapenv:Client</faultcode>                                    '+
            '          <faultstring xml:lang="en">The LocationRole being added is invalid.      '+
            '        This might be due to an invalid location or an invalid address field.      '+
            '        Make sure that the locationRole is valid, and try again.</faultstring>     '+
            '          <detail>                                                                 '+
            '             <ns2:VertexException xmlns:ns2="urn:vertexinc:oseries:exception:1:0"> '+
            '                <exceptionType>VertexApplicationException</exceptionType>          '+
            '                <rootCause>The LocationRole being added is invalid. This might     '+
            '              be due to an invalid location or an invalid address field.           '+
            '              Make sure that the locationRole is valid, and try again.</rootCause> '+
            '             </ns2:VertexException>                                                '+
            '          </detail>                                                                '+
            '       </soapenv:Fault>                                                            '+
            '    </soapenv:Body>                                                                '+
            ' </soapenv:Envelope>                                                               ';

        return httpResBody;
    }

    /**
     * Following  helper method generates the Successful response for 
     * positive test case generation
     **/
    public static HttpResponse generateQuoteResponse(List<Termination_Equipment_Quote__c> quoteEqpLines) {
        String lineItemStr = '';

        // a. Creating LineItems
        for(Termination_Equipment_Quote__c quoteEqpLine : quoteEqpLines) {
            lineItemStr +=  ' <LineItem lineItemId="'+ quoteEqpLine.Name +'">                                                     '+
                            '   <Customer>                                                                                     '+
                            '       <Destination taxAreaId="444391090">                                                        '+
                            '           <City>Arlington</City>                                                                 '+
                            '           <MainDivision>TX</MainDivision>                                                        '+
                            '       </Destination>                                                                             '+
                            '   </Customer>                                                                                    '+
                            '   <Product>Origination Fees</Product>                                                            '+
                            '   <Quantity>1.0</Quantity>                                                                       '+
                            '   <FairMarketValue>75.0</FairMarketValue>                                                        '+
                            '   <ExtendedPrice>75.0</ExtendedPrice>                                                            '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '       taxStructure="SINGLE_RATE">                                                                '+
                            '       <Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction>        '+
                            '       <CalculatedTax>4.69</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.0625</EffectiveRate>                                                      '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Sales and Use Tax</Imposition>                                '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>18653</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '   taxStructure="SINGLE_RATE">                                                                    '+
                            '       <Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77875">FORT WORTH</Jurisdiction>    '+
                            '       <CalculatedTax>0.75</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.01</EffectiveRate>                                                        '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Local Sales and Use Tax</Imposition>                          '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>26278</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '   taxStructure="SINGLE_RATE">                                                                    '+
                            '       <Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78125">                 '+
                            '       <![CDATA[FORT WORTH METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction>                       '+
                            '       <CalculatedTax>0.37</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.005</EffectiveRate>                                                       '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Local Sales and Use Tax</Imposition>                          '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>26657</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '   taxStructure="SINGLE_RATE">                                                                    '+
                            '       <Jurisdiction jurisdictionLevel="SPECIAL_PURPOSE_DISTRICT" jurisdictionId="78124">         '+
                            '       <![CDATA[FORT WORTH CRIME CONTROL DISTRICT]]></Jurisdiction>                               '+
                            '       <CalculatedTax>0.37</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.005</EffectiveRate>                                                       '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Local Sales and Use Tax</Imposition>                          '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>26653</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <TotalTax>6.18</TotalTax>                                                                      '+
                            '   <FlexibleFields>                                                                               '+
                            '       <FlexibleCodeField fieldId="1">INV</FlexibleCodeField>                                     '+
                            '       <FlexibleCodeField fieldId="2">FMV</FlexibleCodeField>                                     '+
                            '       <FlexibleCodeField fieldId="3">ST</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="4">A</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="5">I</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="6">Stream</FlexibleCodeField>                                  '+
                            '       <FlexibleCodeField fieldId="7">N</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="8">N</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="9">CLS-cllease__Charge__c</FlexibleCodeField>                  '+
                            '       <FlexibleCodeField fieldId="10">VALUE IS BLANK</FlexibleCodeField>                         '+
                            '       <FlexibleCodeField fieldId="11">0</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="12">0</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="13">F</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="14">F</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="15">'+ quoteEqpLine.Termination_Quote_Line__r.cllease__Line_Type__c +'</FlexibleCodeField>    '+
                            '       <FlexibleCodeField fieldId="16">NA</FlexibleCodeField>                                     '+
                            '       <FlexibleCodeField fieldId="17">LES-0000001054</FlexibleCodeField>                         '+
                            '       <FlexibleCodeField fieldId="18">0</FlexibleCodeField>                                      '+
                            '       <FlexibleNumericField fieldId="1">30</FlexibleNumericField>                                '+
                            '       <FlexibleNumericField fieldId="2">0</FlexibleNumericField>                                 '+
                            '       <FlexibleNumericField fieldId="3">0</FlexibleNumericField>                                 '+
                            '       <FlexibleNumericField fieldId="4">0</FlexibleNumericField>                                 '+
                            '       <FlexibleNumericField fieldId="5">0</FlexibleNumericField>                                 '+
                            '       <FlexibleDateField fieldId="1">2018-03-06</FlexibleDateField>                              '+
                            '   </FlexibleFields>                                                                              '+
                            '   <AssistedParameters>                                                                           '+
                            '       <AssistedParameter paramName="FLEX.input.TaxPmtType" phase="PRE"                           '+
                            '       ruleName="FMV Tax Payment Type Assignment" originalValue="ST">ST</AssistedParameter>       '+
                            '       <AssistedParameter paramName="product" phase="PRE"                                         '+
                            '       ruleName="Set Contract Level Fee Type Product Code" originalValue="VALUE IS BLANK">        '+
                            '       Origination Fees</AssistedParameter>                                                       '+
                            '   </AssistedParameters>                                                                          '+
                            ' </LineItem>                                                                                      ';
                
        }

        // b. Creating Full Http Response
        String httpResBody 
            =   ' <?xml version="1.0" encoding="UTF-8"?>                                       '+
                ' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"> '+
                '     <soapenv:Header></soapenv:Header>                                        '+
                '     <soapenv:Body>                                                           '+
                '         <VertexEnvelope xmlns="urn:vertexinc:o-series:tps:8:0"               '+
                '               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">         '+
                '             <Login>                                                          '+
                '                 <UserName>devuser07</UserName>                               '+
                '                 <Password>Dllgroup2018</Password>                            '+
                '             </Login>                                                         '+
                '             <QuotationResponse documentDate="2018-03-06"                     '+
                '                   transactionType="LEASE">                                   '+
                '                 <Seller>                                                     '+
                '                     <Company>DLLOS</Company>                                 '+
                '                     <Division>DLLFS</Division>                               '+
                '                 </Seller>                                                    '+
                '                 <SubTotal>139.12</SubTotal>                                  '+
                '                 <Total>147.51</Total>                                        '+
                '                 <TotalTax>8.39</TotalTax>                                    '+
                lineItemStr +
                '           </QuotationResponse>                                                '+
                '             <ApplicationData>                                                 '+
                '                 <ResponseTimeMS>114.6</ResponseTimeMS>                        '+
                '             </ApplicationData>                                                '+
                '         </VertexEnvelope>                                                     '+
                '     </soapenv:Body>                                                           '+
                ' </soapenv:Envelope>                                                           ';
            
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        // Hard coding response to single Equipment and throw exception for multiple Equipment
        res.setBody(httpResBody);
        res.setStatusCode(200);
        return res;
    }

    /**
     * Following  helper method generates the Successful response for 
     * positive test case generation
     **/
    public static String generateResponse(List<String> names) {
        String lineItemStr = '';

        // a. Creating LineItems
        for(String name : names) {
            lineItemStr +=  ' <LineItem lineItemId="'+ name +'">                                                               '+
                            '   <Customer>                                                                                     '+
                            '       <Destination taxAreaId="444391090">                                                        '+
                            '           <City>Arlington</City>                                                                 '+
                            '           <MainDivision>TX</MainDivision>                                                        '+
                            '       </Destination>                                                                             '+
                            '   </Customer>                                                                                    '+
                            '   <Product>Origination Fees</Product>                                                            '+
                            '   <Quantity>1.0</Quantity>                                                                       '+
                            '   <FairMarketValue>75.0</FairMarketValue>                                                        '+
                            '   <ExtendedPrice>75.0</ExtendedPrice>                                                            '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '       taxStructure="SINGLE_RATE">                                                                '+
                            '       <Jurisdiction jurisdictionLevel="STATE" jurisdictionId="35763">TEXAS</Jurisdiction>        '+
                            '       <CalculatedTax>4.69</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.0625</EffectiveRate>                                                      '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Sales and Use Tax</Imposition>                                '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>18653</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '   taxStructure="SINGLE_RATE">                                                                    '+
                            '       <Jurisdiction jurisdictionLevel="CITY" jurisdictionId="77875">FORT WORTH</Jurisdiction>    '+
                            '       <CalculatedTax>0.75</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.01</EffectiveRate>                                                        '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Local Sales and Use Tax</Imposition>                          '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>26278</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '   taxStructure="SINGLE_RATE">                                                                    '+
                            '       <Jurisdiction jurisdictionLevel="TRANSIT_DISTRICT" jurisdictionId="78125">                 '+
                            '       <![CDATA[FORT WORTH METROPOLITAN TRANSIT AUTHORITY]]></Jurisdiction>                       '+
                            '       <CalculatedTax>0.37</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.005</EffectiveRate>                                                       '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Local Sales and Use Tax</Imposition>                          '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>26657</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <Taxes taxResult="TAXABLE" taxType="SALES" situs="DESTINATION" taxCollectedFromParty="BUYER"   '+
                            '   taxStructure="SINGLE_RATE">                                                                    '+
                            '       <Jurisdiction jurisdictionLevel="SPECIAL_PURPOSE_DISTRICT" jurisdictionId="78124">         '+
                            '       <![CDATA[FORT WORTH CRIME CONTROL DISTRICT]]></Jurisdiction>                               '+
                            '       <CalculatedTax>0.37</CalculatedTax>                                                        '+
                            '       <EffectiveRate>0.005</EffectiveRate>                                                       '+
                            '       <Taxable>75.0</Taxable>                                                                    '+
                            '       <Imposition impositionId="1">Local Sales and Use Tax</Imposition>                          '+
                            '       <ImpositionType impositionTypeId="1">General Sales and Use Tax</ImpositionType>            '+
                            '       <TaxRuleId>26653</TaxRuleId>                                                               '+
                            '   </Taxes>                                                                                       '+
                            '   <TotalTax>6.18</TotalTax>                                                                      '+
                            '   <FlexibleFields>                                                                               '+
                            '       <FlexibleCodeField fieldId="1">INV</FlexibleCodeField>                                     '+
                            '       <FlexibleCodeField fieldId="2">FMV</FlexibleCodeField>                                     '+
                            '       <FlexibleCodeField fieldId="3">ST</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="4">A</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="5">I</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="6">Stream</FlexibleCodeField>                                  '+
                            '       <FlexibleCodeField fieldId="7">N</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="8">N</FlexibleCodeField>                                       '+
                            '       <FlexibleCodeField fieldId="9">CLS-cllease__Charge__c</FlexibleCodeField>                  '+
                            '       <FlexibleCodeField fieldId="10">VALUE IS BLANK</FlexibleCodeField>                         '+
                            '       <FlexibleCodeField fieldId="11">0</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="12">0</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="13">F</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="14">F</FlexibleCodeField>                                      '+
                            '       <FlexibleCodeField fieldId="15">Origination Fees</FlexibleCodeField>                       '+
                            '       <FlexibleCodeField fieldId="16">NA</FlexibleCodeField>                                     '+
                            '       <FlexibleCodeField fieldId="17">LES-0000001054</FlexibleCodeField>                         '+
                            '       <FlexibleCodeField fieldId="18">0</FlexibleCodeField>                                      '+
                            '       <FlexibleNumericField fieldId="1">30</FlexibleNumericField>                                '+
                            '       <FlexibleNumericField fieldId="2">0</FlexibleNumericField>                                 '+
                            '       <FlexibleNumericField fieldId="3">0</FlexibleNumericField>                                 '+
                            '       <FlexibleNumericField fieldId="4">0</FlexibleNumericField>                                 '+
                            '       <FlexibleNumericField fieldId="5">0</FlexibleNumericField>                                 '+
                            '       <FlexibleDateField fieldId="1">2018-03-06</FlexibleDateField>                              '+
                            '   </FlexibleFields>                                                                              '+
                            '   <AssistedParameters>                                                                           '+
                            '       <AssistedParameter paramName="FLEX.input.TaxPmtType" phase="PRE"                           '+
                            '       ruleName="FMV Tax Payment Type Assignment" originalValue="ST">ST</AssistedParameter>       '+
                            '       <AssistedParameter paramName="product" phase="PRE"                                         '+
                            '       ruleName="Set Contract Level Fee Type Product Code" originalValue="VALUE IS BLANK">        '+
                            '       Origination Fees</AssistedParameter>                                                       '+
                            '   </AssistedParameters>                                                                          '+
                            ' </LineItem>                                                                                      ';
                
        }

        // b. Creating Full Http Response
        String httpResBody 
            =   ' <?xml version="1.0" encoding="UTF-8"?>                                       '+
                ' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"> '+
                '     <soapenv:Header></soapenv:Header>                                        '+
                '     <soapenv:Body>                                                           '+
                '         <VertexEnvelope xmlns="urn:vertexinc:o-series:tps:8:0"               '+
                '               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">         '+
                '             <Login>                                                          '+
                '                 <UserName>devuser07</UserName>                               '+
                '                 <Password>Dllgroup2018</Password>                            '+
                '             </Login>                                                         '+
                '             <InvoiceResponse documentDate="2018-03-06"                       '+
                '                   transactionType="LEASE">                                   '+
                '                 <Seller>                                                     '+
                '                     <Company>DLLOS</Company>                                 '+
                '                     <Division>DLLFS</Division>                               '+
                '                 </Seller>                                                    '+
                '                 <SubTotal>139.12</SubTotal>                                  '+
                '                 <Total>147.51</Total>                                        '+
                '                 <TotalTax>8.39</TotalTax>                                    '+
                lineItemStr +
                '           </InvoiceResponse>                                                  '+
                '             <ApplicationData>                                                 '+
                '                 <ResponseTimeMS>114.6</ResponseTimeMS>                        '+
                '             </ApplicationData>                                                '+
                '         </VertexEnvelope>                                                     '+
                '     </soapenv:Body>                                                           '+
                ' </soapenv:Envelope>                                                           ';
            
        return httpResBody;
    }

}
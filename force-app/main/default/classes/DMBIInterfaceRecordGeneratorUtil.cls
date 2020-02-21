Public class DMBIInterfaceRecordGeneratorJob {
    Public static string query = DMBIStaticVariables.Empty_str;
    public static Map<string,string> CodeMap;
    public DMBIInterfaceRecordGeneratorJob(){
        //.CodeMap = getIntMapping();
    }
    Public static Map<string,string> getIntMapping(){
        Map<string,string> MappingMap = new Map<string,string>();
        for (IntObjectMapping__mdt iom : DMBIStaticVariables.getIntObjectMapping()){
            MappingMap.put(iom.MasterLabel,iom.value__c);
        }
        Return MappingMap;
    } 
    //query method
    public static string ConstructQuery(){
        // returning constrcted Dynamic Query on Contract Object 
        return DMBIStaticVariables.NetInvestmentJobBatch_query_str;
        
    }
    /*------------------------------------- AGREEMENT EXPOSURE Records creation start-----------------------------------------------*/
    //@METHOD: To Create Int_Agreement_Exposure__c object
    Public static list<Int_Agreement_Exposure__c> CreateAgreementExposures(list<Int_Agreement__c> AgreementsList,list<cllease__Lease_Account__c> Contracts,map<string,string> intMap){
        list<Int_Agreement_Exposure__c> AgreementExposuresToInsert = new list<Int_Agreement_Exposure__c>();
        map<string,int_agreement__c> AgrMap = new map<string,int_agreement__c>();
        for (Int_Agreement__c agr : AgreementsList){
            AgrMap.put(agr.Agreement_Number__c,new int_agreement__c(id=agr.Id));
        }
        map<string,list<cllease__Rental_Stream__c>> ResMap = GetRentalSteamMap(Contracts);
        for(cllease__Lease_Account__c Contract : Contracts){
            If(!(Contract.cllease__Lease_Status__c == 'ACTIVE - MATURED' || Contract.cllease__Lease_Status__c == 'TERMINATED')) {
                list<cllease__Rental_Stream__c> RSList = new list<cllease__Rental_Stream__c> ();
                if(ResMap.containskey(Contract.Id)){RSList.addAll(ResMap.get(Contract.Id));}
                AgreementExposuresToInsert.add(CreateNewAgreementExposure(Contract,AgrMap,intMap,RSList));
            }
        }
        return AgreementExposuresToInsert;
    }
    //@@SUBMETHOD: constructing a new Int__agreement Exposure object
    Private static Int_Agreement_Exposure__c CreateNewAgreementExposure(cllease__Lease_Account__c cla,map<string,int_agreement__c> agrMap, map<string,string> intmap,list<cllease__Rental_Stream__c> RSList){
        system.debug('**************************************************************');
        system.debug('cla is: ' + cla);
        system.debug('****************************Exposure for:' + cla.name + ' has exposure of:' + cla.exposure__c);
        system.debug('**************************************************************');
        Return new Int_Agreement_Exposure__c(
           
            Agreement_Name__c = AgrMap.get(cla.name).Id,
            Exposure_Type__c = 'DLL',
            Arrears_Amount__c = cla.cllease__Delinquent_Amount__c!=Null?ScaleToTwoDecimal(cla.cllease__Delinquent_Amount__c):0,
            Exposure_Booked__c = cla.Exposure__c!=Null?ScaleToTwoDecimal(cla.Exposure__c):0,
            Agreement_Source_System__c = intmap.get(cla.Source_System__c),
            Agreement_Number__c = cla.name,
            Days_In_Arrears__c = string.valueof(cla.cllease__Days_Past_Due__c)!=Null?string.valueof(cla.cllease__Days_Past_Due__c):'0',
            Net_Principal_Balance_Amount__c = ScaleToTwoDecimal(CalculateNetPrincipalBalanceAmountFromRentalStream(RSList)),
            Accrued_Interest_Amount__c = ScaleToTwoDecimal(CalculateAccruedInterestAmountFromRentalStream(RSList)),
            Other_Arrears_Amount__c = 0,
            Other_Days_in_Arrears__c = '0'
        );
    }
    //@@SUBMETHOD: Summing up Lease_Income of rental stream records to calculate AccruedInterestAmount 
    Private static Decimal CalculateNetPrincipalBalanceAmountFromRentalStream(list<cllease__Rental_Stream__c> RSList){
        Decimal TempNetPrincipalBalanceAmount = 0.00;
        for(cllease__Rental_Stream__c rs: RSList){
            if (!rs.cllease__Accrued_Flag__c){
                TempNetPrincipalBalanceAmount+= rs.cllease__Capital_Recovery__c;    
            }
        }
        return TempNetPrincipalBalanceAmount;
    }    
    /*------------------------------------- AGREEMENT EXPOSURE Records creation ends-----------------------------------------------*/
    /*------------------------------------- Agreement classification Records creation starts-----------------------------------------------*/
    //@METHOD: To Create Int_Agreement_Classification__c object
    Public static list<Int_Agreement_Classification__c> CreateAgreementClassifications(list<Int_Agreement__c> AgreementsList,list<cllease__Lease_Account__c> contracts,map<string,string> codemap){
        list<Int_Agreement_Classification__c> AgreementClassificationToInsert = new list<Int_Agreement_Classification__c>();
        Map<string,Int_Agreement__c> AgrMap = new map<string,Int_Agreement__c>();
        for(Int_Agreement__c agrRec : AgreementsList){//Agreement_Source_System__c
            AgrMap.put(agrRec.Agreement_Number__c,new Int_Agreement__c(id=agrrec.Id));
            //AgreementClassificationToInsert.add(CreateNewAgreementClassification(agrRec));
        }
        for(cllease__Lease_Account__c contract:contracts){
            //AgreementClassificationToInsert.add(CreateNewAgreementClassification(contract,agrMap,codemap));
            AgreementClassificationToInsert.add(CreateNewAgreementClassificationFPT(contract,agrMap,codemap));
            AgreementClassificationToInsert.add(CreateNewAgreementClassificationILC(contract,agrMap,codemap));
        }
        //insert AgreementClassificationToInsert;
        Return AgreementClassificationToInsert;
    }
    
    Private static Int_Agreement_Classification__c CreateNewAgreementClassificationFPT(cllease__Lease_Account__c cla,Map<string,Int_Agreement__c> AgrMap,map<string,string> codeMap){
        Return new Int_Agreement_Classification__c(
            Agreement_Name__c = AgrMap.get(cla.name).Id,
            Agreement_Classification_Type_Code__c= 'FPT',
            Agreement_Classification_Code__c = codeMap.containskey(cla.cllease__Product_Type__c)?codeMap.get(cla.cllease__Product_Type__c):'L',
            Agreement_Source_System__c= codeMap.get(cla.source_system__c),
            Agreement_Number__c=cla.name
        );
    }
    Private static Int_Agreement_Classification__c CreateNewAgreementClassificationILC(cllease__Lease_Account__c cla,Map<string,Int_Agreement__c> AgrMap,map<string,string> codeMap){
        Return new Int_Agreement_Classification__c(
            Agreement_Name__c = AgrMap.get(cla.name).Id,
            Agreement_Classification_Type_Code__c= 'ILC',
            Agreement_Classification_Code__c = (codeMap.containskey(cla.cllease__Product_Sub_Type__c)?codeMap.get(cla.cllease__Product_Sub_Type__c):'MPFL').right(2),
            Agreement_Source_System__c= codeMap.get(cla.source_system__c),
            Agreement_Number__c=cla.name
        );
    }
    /*------------------------------------- Agreement classification Records creation ends-----------------------------------------------*/
    
    /*------------------------------------- Agreement Records creation starts-----------------------------------------------*/
    
    //@METHOD: To Create Agreement records
    Public static list<Int_Agreement__c> CreateAgreements(list<cllease__Lease_Account__c> clleaseContractsList,map<string,string> IntCodeMap){
        list<Int_Agreement__c> AgreementsToInsert = new list<Int_Agreement__c>();
        map<string,list<cllease__Rental_Stream__c>> ResMap = new Map<string,list<cllease__Rental_Stream__c>>();
        map<string,list<cllease__Residual_Stream__c>> RsdMap = new Map<string,list<cllease__Residual_Stream__c>>();
        Map<string,List<cllease__Contract_Equipment__c>> EqmpntMap = new map<string,List<cllease__Contract_Equipment__c>>();
        Map<string,list<cllease__Lease_Payment_Transaction__c>> PmntTransMap = new map<string,List<cllease__Lease_Payment_Transaction__c>>();
        EqmpntMap = GetEquipments(clleaseContractsList);
        //Payment transaction map
        for(cllease__Lease_Payment_Transaction__c cce : DMBIStaticVariables.getPaymentTransactions(clleaseContractsList)){
            if(!PmntTransMap.containskey(cce.cllease__Contract__c)){
                PmntTransMap.put(cce.cllease__Contract__c,new list<cllease__Lease_Payment_Transaction__c>{cce});
            }else{
                list<cllease__Lease_Payment_Transaction__c> TempList = PmntTransMap.get(cce.cllease__Contract__c);
                TempList.add(cce);
                PmntTransMap.put(cce.cllease__Contract__c,TempList);
            }
        }
        //Rental streams map
        ResMap = GetRentalSteamMap(clleaseContractsList);
        //Residual streams map
        RsdMap = getResidualStreamMap(clleaseContractsList);
        //CREATING AGREEMENT RECORDS FROM CONTRACT RECORDS.
        for(cllease__Lease_Account__c la : clleaseContractsList){//Agreement_Source_System__c
            string str = la.cllease__GL_Transaction_Details__r.size()>0?(la.cllease__GL_Transaction_Details__r[0].Movement_Code_DR_Segment__c != Null?la.cllease__GL_Transaction_Details__r[0].Movement_Code_DR_Segment__c:''):'';
            List<cllease__Contract_Equipment__c> cceList = new list<cllease__Contract_Equipment__c>();
            List<cllease__Lease_Payment_Transaction__c> clptList = new list<cllease__Lease_Payment_Transaction__c>();
            List<cllease__Rental_Stream__c> CRSList = new list<cllease__Rental_Stream__c>();
            List<cllease__Residual_Stream__c> ResList = new List<cllease__Residual_Stream__c>();
            if(ResMap.containskey(la.Id)){CRSList.addAll(ResMap.get(la.Id));}
            if(RsdMap.containskey(la.Id)){ResList.AddAll(RsdMap.get(la.Id));}
            if(EqmpntMap.containskey(la.Id)){cceList.addAll(EqmpntMap.get(la.Id));}
            if(PmntTransMap.containskey(la.id)){clptList.addall(PmntTransMap.get(la.Id));}
            AgreementsToInsert.add(CreateNewAgreement(la,IntCodeMap,CRSList,ResList,str,cceList,clptList));
        }
        if(!AgreementsToInsert.isempty()){
            //insert AgreementsToInsert;
            Database.insert(AgreementsToInsert, false);
        }
        Return AgreementsToInsert;
    }
    //@@SUBMETHOD: constructing a new Int__agreement object
    Private static Int_Agreement__c CreateNewAgreement(cllease__Lease_Account__c cla, map<string,string> Codemap,List<cllease__Rental_Stream__c> CRSList,List<cllease__Residual_Stream__c> ResList,string str,List<cllease__Contract_Equipment__c> ceList,list<cllease__Lease_Payment_Transaction__c> PTList){
        //Codemap = getIntMapping();
        String AmortizationTypeCode = cla.cllease__Residual_Amount__c > 0?'OTHER':'FRENCH';
        Return new Int_Agreement__c(
            Funding_Rate__c = cla.Cost_of_Funds__c,
            Costs_Of_Funds_Percentage__c = cla.Cost_of_Funds__c,
            EAD_Ex_Ante__c = 0,
            EAD_Ex_Post__c = 0,
            Risk_Costs__c = 0,
            Securitization_Identifier__c = '',
            Syndication_Percentage__c = Null,
            //GL_Code_Block__c = CalculateGLCodeBlock(cla.cllease__GL_Transaction_Details__r),
            GL_Code_Block__c = str,//cla.cllease__GL_Transaction_Details__r.size()>0?(cla.cllease__GL_Transaction_Details__r[0].Movement_Code_DR_Segment__c != Null?cla.cllease__GL_Transaction_Details__r[0].Movement_Code_DR_Segment__c:''):'',
            Floating_Rate_Cap__c = Null,
            Floating_Rate_Code__c = '',
            Floating_Rate_Currency_Code__c = '',
            Floating_Rate_Floor__c = 0,
            Floating_Rate_Freq_Refresh_Code__c = '',
            Floating_Rate_Frequency__c = '',
            Floating_Rate_Period_End_Date__c = Null,
            Floating_Rate_Spread__c = 0,   
            LGD_Percentage__c = 0,
            //LGD_Lookup_Type_Code__c = Codemap.containsKey(cla.cllease__Contract_Equipments__r[0].Master_Asset_Type__c)?Codemap.get(cla.cllease__Contract_Equipments__r[0].Master_Asset_Type__c):'',
            LGD_Lookup_Type_Code__c = CalculateLGDLookUpTypeCode(ceList,Codemap),
            Current_Interest_Rate_Type_Code__c = 'FIXED',
            Interest_Rate_Type_Code__c = 'FIXED',
            System_Selling_Party_Number__c = cla.cllease__Dealer__r.Account_Number__c,
            Down_Payment_Amount__c = cla.cllease__Down_Payment__c!=Null?ScaleToTwoDecimal(cla.cllease__Down_Payment__c):0,
            Agreement_Source_System__c = Codemap.get(cla.Source_System__c),
            Agreement_Number__c = cla.Name,
            System_Selling_Party_Description__c = cla.cllease__Dealer__r.genesis__Vendor_Type__c,
            Arrears_Amount__c = cla.cllease__Delinquent_Amount__c!=Null?ScaleToTwoDecimal(cla.cllease__Delinquent_Amount__c):0,
            Agreement_Rate__c = cla.cllease__Yield__c!=Null?ScaleToTwoDecimal(cla.cllease__Yield__c):0,
            //Net_Principal_Amount__c = ScaleToTwoDecimal(cla.cllease__Financed_Amount__c),
            //Net_Principal_Amount__c = ScaleToTwoDecimal(CalculateNetPrincipalAmount(cla.cllease__Residual_Amount__c,cla.cllease__Rental_Streams__r,cla.cllease__Residual_Streams__r)),
            //Net_Principal_Amount__c = ScaleToTwoDecimal(cla.cllease__Total_Dealer_Charges__c - (cla.cllease__Subsidy1__c!=Null?cla.cllease__Subsidy1__c:0) - (cla.Interim_Rent__c!=Null?cla.Interim_Rent__c:0)),
            Net_Principal_Amount__c = ScaleToTwoDecimal((cla.Net_Dealer_Funding__c!=Null && cla.Net_Dealer_Funding__c!=0)?cla.Net_Dealer_Funding__c:((cla.Net_Trade_Up_Amount__c==Null || cla.Net_Trade_Up_Amount__c==0) && cla.cllease__Total_Dealer_Charges__c!=Null?cla.cllease__Total_Dealer_Charges__c:0)),
            Maturity_Options_Code__c = 'ETNOFEE',
            Hyperion_Base_Entity__c = 'BEQUS',
            Amortization_Type_Code__c = AmortizationTypeCode,
            Payment_Method_Code__c = CalculatePaymentmethodCode(PTList,Codemap),
            //Payment_Method_Code__c = CalculatePaymentmethodCode1(PaymentTransMap,cla.id,Codemap),
            Agreement_Activation_Date__c = cla.Booking_Date__c!=Null?cla.Booking_Date__c:system.today(),
            Payments_Received__c = Null, //ScaleToTwoDecimal(CalculateclleaseTransactionAmountFrompaymentTransaction(cla.cllease__Contract_Payment_Transactions__r)),
            Day_Count_Convention_Code__c = Codemap.containsKey(cla.cllease__Days_Convention__c)?Codemap.get(cla.cllease__Days_Convention__c):'',
            Agreement_Status__c = Codemap.containsKey(cla.cllease__Lease_Status__c)?Codemap.get(cla.cllease__Lease_Status__c):'' ,
            Deal_Date__c = cla.cllease__Contract_Date__c!=Null?cla.cllease__Contract_Date__c:system.today(),
            Agreement_Maturity_Date__c = cla.cllease__Maturity_Date__c!=Null?cla.cllease__Maturity_Date__c:system.today(),
            Fixed_Rate_Period_End_Date__c = cla.cllease__Maturity_Date__c!=Null?cla.cllease__Maturity_Date__c:system.today(),
            Payment_Frequency_Code__c = Codemap.containskey(cla.cllease__Payment_Frequency__c)?(Codemap.get(cla.cllease__Payment_Frequency__c)!=Null?Codemap.get(cla.cllease__Payment_Frequency__c):'M'):'M',//Codemap.get(cla.cllease__Payment_Frequency__c)!=Null?Codemap.get(cla.cllease__Payment_Frequency__c):'M',
            Payment_Type_Code__c = Codemap.containskey(cla.cllease__Payment_Method__c)?codemap.get(cla.cllease__Payment_Method__c):'NULL',
            Days_In_Arrears__c = String.valueof(cla.cllease__Days_Past_Due__c)!=NULL?String.valueof(cla.cllease__Days_Past_Due__c):'0',
            Agreement_Original_Duration__c= string.valueof(cla.cllease__Term__c),
            Deposit_Payment_Amount__c= ScaleToTwoDecimal(cla.cllease__Security_Deposit_Amount__c),
            Agreement_Start_Date__c= cla.cllease__Amort_Start_Date__c,
            Agreement_Termination_Date__c=cla.Termination_Date__c,
            System_Program_Number__c = cla.Dealer_Program__r.name,
            Brokered_Indicator__c = '0',
            Billing_Collection_Indicator__c = '0',
            Encumbered_Indicator__c = '0',
            Fee_For_Service_Indicator__c = '0',
            On_Balance_Indicator__c = '1',
            Recourse_Indicator__c = '0',
            Renewable_Indicator__c = '0',
            Securitization_Indicator__c = '0',
            Syndication_Indicator__c = '0',
            Payment_Frequency_Principal_Code__c= codemap.containskey(cla.cllease__Payment_Frequency__c)?codemap.get(cla.cllease__Payment_Frequency__c):'',
            Payment_Frequency_Interest_Code__c = codemap.containskey(cla.cllease__Payment_Frequency__c)?codemap.get(cla.cllease__Payment_Frequency__c):'',
            //Net_Principal_Balance_Amount__c = (cla.Unbilled_Receivable__c + cla.cllease__Residual_Amount__c)!=Null?(ScaleToTwoDecimal(cla.Unbilled_Receivable__c + cla.cllease__Residual_Amount__c)):0,
            Net_Principal_Balance_Amount__c = ScaleToTwoDecimal(cla.Unbilled_Receivable__c + cla.cllease__Residual_Amount__c - CalculateUnearnedRentalIncome(CRSList) - CalculateUnearnedResidualIncome(ResList)+ cla.Billed_Not_Paid__c),
            Currency_Code__c = cla.cllease__Currency_Code__c!=Null?cla.cllease__Currency_Code__c:'USD',
            Accrued_Interest_Amount__c = ScaleToTwoDecimal(CalculateAccruedInterestAmountFromRentalStream(CRSList)),
            Residual_Value_Booked__c = ScaleToTwoDecimal(cla.cllease__Residual_Amount__c)
        );
    }
    private static map<string,list<cllease__Residual_Stream__c>> getResidualStreamMap(list<cllease__Lease_Account__c> clleaseContractsList ){
        map<string,list<cllease__Residual_Stream__c>> RsdMap = new map<string,list<cllease__Residual_Stream__c>>();
        for(cllease__Residual_Stream__c rs : DMBIStaticVariables.getResidualStreams(clleaseContractsList)){
            if(!RsdMap.containskey(rs.cllease__Contract__c)){
                RsdMap.put(rs.cllease__Contract__c,new list<cllease__Residual_Stream__c>{rs});
            }else{
                list<cllease__Residual_Stream__c> TempList = RsdMap.get(rs.cllease__Contract__c);
                TempList.add(rs);
                RsdMap.put(rs.cllease__Contract__c,TempList);
            }
        }return RsdMap;
    }
    //@@SUBMETHOD: find master asset type code
    Private static void findMasterAssetTypecode(list<cllease__Contract_Equipment__c> Equipmnetlist){
        
    }
    
    //@@SUBMETHOD: Calculate GL Code Block
    Private Static String CalculateGLCodeBlock(List<cllease__GL_Transaction_Detail__c> GLTList){
        String GLCodeBlock = '';
        for(cllease__GL_Transaction_Detail__c GLT: GLTList) {
            If(GLT.CL_Lease_Transaction_Type__c == 'BOOKING' && GLT.cllease__Debit_GL_Account__r.name == 'Gross Receivables - CLS'){
                GLCodeBlock = GLT.Movement_Code_DR_Segment__c != Null?GLT.Movement_Code_DR_Segment__c:'';
            } 
        }
        Return GLCodeBlock;
    }
    
    //@@SUMMETHOD: find LGD LookUp Type Code
    Private static String CalculateLGDLookUpTypeCode1(string contractID, Map<string,string> Codemap,Map<string,cllease__Contract_Equipment__c> ceMap){
        String LGDLookUpTypeCode = '';
        //String MasterAssetType = CEPList[0].Master_Asset_Type__c;
        string MasterAssetType = ceMap.get(contractID).Master_Asset_Type__c;
        //Decimal TotalDealerCharges = CEPList[0].cllease__Total_Dealer_Charges__c;
        Decimal TotalDealerCharges = ceMap.get(contractID).cllease__Total_Dealer_Charges__c;
        
        for(cllease__Contract_Equipment__c CEP: ceMap.values()){
            If(CEP.cllease__Total_Dealer_Charges__c > TotalDealerCharges){
                TotalDealerCharges = CEP.cllease__Total_Dealer_Charges__c;
                MasterAssetType = CEP.Master_Asset_Type__c;
            }                
        }
        LGDLookUpTypeCode = Codemap.containsKey(MasterAssetType)?Codemap.get(MasterAssetType):'118';
        return LGDLookUpTypeCode;
    }
    //@@SUMMETHOD: find LGD LookUp Type Code
    Private static String CalculateLGDLookUpTypeCode(List<cllease__Contract_Equipment__c> CEPList, Map<string,string> Codemap){
        String LGDLookUpTypeCode = '';
        String MasterAssetType = CEPList[0].Master_Asset_Type__c;
        Decimal TotalDealerCharges = CEPList[0].cllease__Total_Dealer_Charges__c;
        for(cllease__Contract_Equipment__c CEP: CEPList){
            If(CEP.cllease__Total_Dealer_Charges__c > TotalDealerCharges){
                TotalDealerCharges = CEP.cllease__Total_Dealer_Charges__c;
                MasterAssetType = CEP.Master_Asset_Type__c;
            }                
        }
        LGDLookUpTypeCode = Codemap.containsKey(MasterAssetType)?Codemap.get(MasterAssetType):'118';
        return LGDLookUpTypeCode;
    }
    //@@SUBMETHOD: find Net Principal Amount
    Private static Decimal CalculateNetPrincipalAmount(Decimal ResidualAmount,List<cllease__Rental_Stream__c> RntList,List<cllease__Residual_Stream__c> RsdList){
        Decimal NetPrincipalAmount = 0.00;
        NetPrincipalAmount = CalculateGrossReceivable(RntList) + ResidualAmount - CalculateTotalLeaseIncome(RntList) - CalculateTotalResidualIncome(RsdList);
        return NetPrincipalAmount;
    }
    
    //@@SUBMETHOD: Calculate Gross receivable from Income/rental stream
    Private static Decimal CalculateGrossReceivable(List<cllease__Rental_Stream__c> RntList){
        Decimal GrossReceivable = 0.00;
        for(cllease__Rental_Stream__c Rnt: RntList){
            GrossReceivable += Rnt.cllease__Payment_Amount__c;
        }
        Return GrossReceivable;
    }
    
    //@@SUBMETHOD: Calculate Unearned Rental Income from Income/rental stream
    Private static Decimal CalculateUnearnedRentalIncome(List<cllease__Rental_Stream__c> RntList){
        Decimal UnearnedRentalIncome = 0.00;
        for(cllease__Rental_Stream__c Rnt: RntList){
            If(!Rnt.cllease__Accrued_Flag__c){
                UnearnedRentalIncome += Rnt.cllease__Lease_Income__c;
            }    
        }
        Return UnearnedRentalIncome;
    }
    
    //@@SUBMETHOD: Calculate Unearned Residual Income from Residual stream
    Private static Decimal CalculateUnearnedResidualIncome(List<cllease__Residual_Stream__c> RsdList){
        Decimal UnearnedResidualIncome = 0.00;
        for(cllease__Residual_Stream__c Rsd: RsdList){
            If(!Rsd.cllease__Accrued_Flag__c){
                UnearnedResidualIncome += Rsd.cllease__Residual_Income__c;
            }    
        }
        Return UnearnedResidualIncome;
    }
    
    //@@SUBMETHOD: Calculate Total Lease Income from Income/rental stream
    Private static Decimal CalculateTotalLeaseIncome(List<cllease__Rental_Stream__c> RntList){
        Decimal TotalLeaseIncome = 0.00;
        for(cllease__Rental_Stream__c Rnt: RntList){
            TotalLeaseIncome += Rnt.cllease__Lease_Income__c;
        }
        Return TotalLeaseIncome;
    }
    
    //@@SUBMETHOD: Calculate Total Residual Income from residual stream
    Private static Decimal CalculateTotalResidualIncome(List<cllease__Residual_Stream__c> RsdList){
        Decimal TotalResidualIncome = 0.00;
        for(cllease__Residual_Stream__c Rsd: RsdList){
            TotalResidualIncome += Rsd.cllease__Residual_Income__c;
        }
        Return TotalResidualIncome;
    }
    
    //@@SUBMETHOD: Summing up Lease_Income of rental stream records to calculate AccruedInterestAmount 
    Private static Decimal CalculateAccruedInterestAmountFromRentalStream(list<cllease__Rental_Stream__c> RSList){
        Decimal TempAccruedInterestAmount = 0.00;
        for(cllease__Rental_Stream__c rs: RSList){
            if (rs.cllease__Accrued_Flag__c){
                TempAccruedInterestAmount+=rs.cllease__Lease_Income__c;    
            }
        }
        return TempAccruedInterestAmount;
    }
    //@@SUBMETHOD: calculate Payment_Method_Code__c for the agreement record 
    Private static String CalculatePaymentmethodCode(list<cllease__Lease_Payment_Transaction__c> PTList,map<string,string> Codemap){
        String PaymentMethodCode = '';
        If(!PTList.isEmpty()){
            PaymentMethodCode = Codemap.containsKey(PTList[0].cllease__Payment_Mode__r.name)?Codemap.get(PTList[0].cllease__Payment_Mode__r.name):'O';
        }
        Else{
            PaymentMethodCode = 'O';
        }  
        return PaymentMethodCode;
    }
    Private static String CalculatePaymentmethodCode1(map<string,cllease__Lease_Payment_Transaction__c> clptMap,string ContractID,map<string,string> Codemap){
        String PaymentMethodCode = 'O';
        If(!clptMap.containsKey(ContractID)){
            PaymentMethodCode = Codemap.containsKey(clptMap.get(ContractID).cllease__Payment_Mode__r.name)?Codemap.get(clptMap.get(ContractID).cllease__Payment_Mode__r.name):'O';
            //PaymentMethodCode = Codemap.containsKey(PTList[0].cllease__Payment_Mode__r.name)?Codemap.get(PTList[0].cllease__Payment_Mode__r.name):'O';
        }
        return PaymentMethodCode;
    }
    // Added on 6th OCt
    //@@@SUBMETHOD:Summing upcllease__Transaction_Amount__c of Payment Transaction Records to calculate ResidualValueBooked 
    Private static Decimal CalculateclleaseTransactionAmountFrompaymentTransaction (list<cllease__Lease_Payment_Transaction__c> TransList){
        Decimal TempResidualValueBooked = 0.0;
        for(cllease__Lease_Payment_Transaction__c rs: TransList){
            TempResidualValueBooked+=rs.cllease__Transaction_Amount__c;
        }
        return TempResidualValueBooked;
    }
    private static Map<string,list<cllease__Rental_Stream__c>> GetRentalSteamMap(List<cllease__Lease_Account__c> clleaseContractsList){
        map<string,list<cllease__Rental_Stream__c>> ResMap = new Map<string,list<cllease__Rental_Stream__c>>();
        for(cllease__Rental_Stream__c rs : DMBIStaticVariables.getRentalStreams(clleaseContractsList)){
            if(!ResMap.containskey(rs.cllease__Contract__c)){
                ResMap.put(rs.cllease__Contract__c,new list<cllease__Rental_Stream__c>{rs});
            }else{
                list<cllease__Rental_Stream__c> TempList = ResMap.get(rs.cllease__Contract__c);
                TempList.add(rs);
                ResMap.put(rs.cllease__Contract__c,TempList);
            }
        }
        return ResMap;
    }
    /*------------------------------------- Agreement Payment Schedules Records creation Starts-----------------------------------------------*/
    Public static list<Int_Agreement_Payment_Schedule__c> CreateIntAgreementPaymentSchedules(list<Int_Agreement__c> AgreementsList,List<cllease__Lease_Account__c> Contracts,map<string,string> intcode){
        list<Int_Agreement_Payment_Schedule__c> AgrPaymentScheduleList = new list<Int_Agreement_Payment_Schedule__c>();
        map<string,list<cllease__Rental_Stream__c>> ResMap = GetRentalSteamMap(Contracts);
        map<string,Int_Agreement__c> AgrMap = New map<string,Int_Agreement__c>();
        for(Int_Agreement__c agr : AgreementsList){
            AgrMap.put(agr.Agreement_Number__c, agr);
        }
        for(cllease__Lease_Account__c cla : Contracts){
            list<cllease__Rental_Stream__c> ResList = new list<cllease__Rental_Stream__c>();
            if(ResMap.containskey(cla.Id)){ResList.addAll(ResMap.get(cla.Id));}
            for(cllease__Rental_Stream__c crs: ResList){
                If(crs.cllease__Date__c >= system.today()){ 
                    AgrPaymentScheduleList.add(new Int_Agreement_Payment_Schedule__c(
                        Agreement_Source_System__c = intcode.get(cla.Source_System__c)
                        ,Schedule_Start_Date__c = crs.cllease__Date__c
                        ,Payment_Type_Code__c = 'P' 
                        ,Schedule_Amount__c = crs.cllease__Capital_Recovery__c!=Null?ScaleToTwoDecimal(crs.cllease__Capital_Recovery__c):0
                        ,Schedule_Class__c = 'C' 
                        ,Currency_Code__c = 'USD'//intcode.ContainsKey(cla.cllease__Currency_Code__c)?intcode.get(cla.cllease__Currency_Code__c):'USD'
                        ,Agreement_Number__c = cla.name
                        ,Agreement_Name__c = AgrMap.containskey(cla.name)?AgrMap.get(cla.name).Id:''
                    ));
                    AgrPaymentScheduleList.add(new Int_Agreement_Payment_Schedule__c(
                        Agreement_Source_System__c = intcode.get(cla.Source_System__c)
                        ,Schedule_Start_Date__c = crs.cllease__Date__c
                        ,Payment_Type_Code__c = 'I' 
                        ,Schedule_Amount__c = crs.cllease__Lease_Income__c!=Null?ScaleToTwoDecimal(crs.cllease__Lease_Income__c):0
                        ,Schedule_Class__c = 'C' 
                        ,Currency_Code__c = 'USD'//intcode.ContainsKey(cla.cllease__Currency_Code__c)?intcode.get(cla.cllease__Currency_Code__c):'USD'
                        ,Agreement_Number__c = cla.name
                        ,Agreement_Name__c = AgrMap.containskey(cla.name)?AgrMap.get(cla.name).Id:''
                    ));
                } 
            }   
        }
        
        Return AgrPaymentScheduleList;
    }
    /*------------------------------------- Agreement Payment Schedules Records creation Ends-----------------------------------------------*/
    /*------------------------------------- AGREEMENT INTEREST Records creation start-----------------------------------------------*/
    //@METHOD: To Create Int_Agreement_Interest__c object    
    Public static list<Int_Agreement_Interest__c> CreateAgreementInterests(list<Int_Agreement__c> AgreementsList,List<cllease__Lease_Account__c> ContractsList){
        list<Int_Agreement_Interest__c> AgreementInterestsToInsert = new list<Int_Agreement_Interest__c>();
        Map<String,Int_Agreement__c> AgreementMap = New Map<string,Int_Agreement__c>();
        List<cllease__Rental_Stream__c> IncomeStrmList = New list<cllease__Rental_Stream__c>();
        List<cllease__Residual_Stream__c> ResidualStrmList = New list<cllease__Residual_Stream__c>();
        Map<String,Map<Date,Decimal>> ResStrmMap = New Map<String,Map<Date,Decimal>>();
        Map<Date,Decimal> ResInterestMap = New Map<Date,Decimal>();
        //Map<string,list<cllease__Rental_Stream__c>> AgrMap = new map<string,list<cllease__Rental_Stream__c>>();
        Map<string,list<cllease__Residual_Stream__c>> rsdMap = getResidualStreamMap(ContractsList);
        Map<string,list<cllease__Rental_Stream__c>> ResMap = GetRentalSteamMap(ContractsList);
        for(Int_Agreement__c agr : AgreementsList){
            AgreementMap.put(agr.Agreement_Number__c,agr);
            
        }
        for (cllease__Lease_Account__c cl:ContractsList){
            list<cllease__Rental_Stream__c> TempRsList = new list<cllease__Rental_Stream__c>();
            if(ResMap.containskey(cl.Id)){
                IncomeStrmList.addAll(ResMap.get(cl.Id));
            }
            list<cllease__Residual_Stream__c> TempRsdList = new list<cllease__Residual_Stream__c>();
            if(rsdMap.containskey(cl.Id)){
                ResidualStrmList.addAll(rsdMap.get(cl.Id));
            }
        }
        
        
        if(!IncomeStrmList.isEmpty() && !AgreementMap.isEmpty()){
            AgreementInterestsToInsert.addAll(CreateNewAgreementInterest(AgreementMap,IncomeStrmList,ResidualStrmList));    
        }
        return AgreementInterestsToInsert;
    }
    //@@SUBMETHOD: constructing a new Int__Agreement_Interest__c object
    Private static list<Int_Agreement_Interest__c> CreateNewAgreementInterest(Map<String,Int_Agreement__c> AgreementMap,List<cllease__Rental_Stream__c> IncomeStrmList,List<cllease__Residual_Stream__c> ResidualStrmList){
        list<Int_Agreement_Interest__c> AgrInterestList = new list<Int_Agreement_Interest__c>();
        Decimal InterestAmount = 0;
        Integer CurrentMonth = Date.today().Month();
        Integer CurrentYear = Date.today().Year();
        for (cllease__Rental_Stream__c Income : IncomeStrmList){
            InterestAmount = 0;
            
            Int_Agreement__c agr = AgreementMap.containskey(Income.cllease__Contract__r.name)?AgreementMap.get(Income.cllease__Contract__r.name):Null;
            if (agr!=NULL && (Income.cllease__Accrued_Flag__c == TRUE) && Income.cllease__Lease_Income__c!=Null && Income.cllease__Date__c.addmonths(1).Month() == CurrentMonth && Income.cllease__Date__c.addmonths(1).Year() == CurrentYear){               
                InterestAmount = Income.cllease__Lease_Income__c;
                for(cllease__Residual_Stream__c crs: ResidualStrmList){
                    If(crs.cllease__Contract__r.name != Null && crs.cllease__Date__c != Null){
                        If(crs.cllease__Contract__r.name == Income.cllease__Contract__r.name && crs.cllease__Date__c.IsSameDay(Income.cllease__Date__c) && crs.cllease__Accrued_Flag__c == True){
                            InterestAmount = InterestAmount + crs.cllease__Residual_Income__c;
                        }
                        
                    }
                }                
                AgrInterestList.add(new Int_Agreement_Interest__c(
                    Agreement_Name__c = agr.Id,
                    Agreement_Source_System__c=agr.Agreement_Source_System__c,
                    Transaction_Date__c = Income.cllease__Date__c!=Null?Income.cllease__Date__c:NULL,
                    Transaction_ID__c = Income.Name,
                    Agreement_Number__c = agr.Agreement_Number__c,
                    Interest_Amount__c = ScaleToTwoDecimal(InterestAmount>0?InterestAmount:0)
                    //Interest_Amount__c = Income.cllease__Lease_Income__c!=Null?Income.cllease__Lease_Income__c:NULL
                ));
                
            }
        }               
        return AgrInterestList;
    }
    
    /*------------------------------------- AGREEMENT INTEREST Records creation ends-----------------------------------------------*/
    /*---- Equipments map reusable ---- */
    Private static map<string,list<cllease__Contract_Equipment__c>> GetEquipments(list<cllease__Lease_Account__c> clleaseContractsList){
        Map<string,list<cllease__Contract_Equipment__c>> EquipmentMap = new map<string,list<cllease__Contract_Equipment__c>>();
        for(cllease__Contract_Equipment__c cce : DMBIStaticVariables.GetContractEquipments(clleaseContractsList)){
            if(!EquipmentMap.containskey(cce.cllease__Contract__c)){
                EquipmentMap.put(cce.cllease__Contract__c,new list<cllease__Contract_Equipment__c>{cce});
            }else{
                list<cllease__Contract_Equipment__c> TempList = EquipmentMap.get(cce.cllease__Contract__c);
                TempList.add(cce);
                EquipmentMap.put(cce.cllease__Contract__c,TempList);
            }
        }
        return EquipmentMap;
    }
    /*------------------------------------- ASSET Records creation starts -----------------------------------------------*/
    //@METHOD: To Create Int_ASSET__c object
    Public static list<Int_Asset__c> CreateAssets(list<cllease__Lease_Account__c> clleaseContractsList,map<string,string> codemap){//,list<Int_Agreement_Line__c> AgrlineRecords
        list<Int_Asset__c> AssetToInsert = new list<Int_Asset__c>();
        set<string> AssetnumberSet = new set<string>();
        Map<string,list<cllease__Contract_Equipment__c>> EqmpntMap = new map<string,list<cllease__Contract_Equipment__c>>();
        Map<String,cllease__Asset_workbench__c> AssetWBMap = New Map<String,cllease__Asset_workbench__c>();
        for(cllease__Asset_workbench__c Awb : DMBIStaticVariables.getAssetWorkbenches(clleaseContractsList)){
            AssetWBMap.put(Awb.cllease__Contract_Equipment__r.name,Awb);
        }
        for(int_asset__c asset : DMBIStaticVariables.getAssets()){
            AssetnumberSet.add(asset.Asset_Number__c);
        }
        EqmpntMap = GetEquipments(clleaseContractsList);
        for(cllease__Lease_Account__c la : clleaseContractsList){
            list<cllease__Contract_Equipment__c> CEList = new list<cllease__Contract_Equipment__c> ();
            if(EqmpntMap.containskey(la.Id)){CEList.addAll(EqmpntMap.get(la.Id));}
            AssetToInsert.addAll(CreateNewAssets(CEList,AssetWBMap,la.Source_System__c,String.valueof(la.cllease__Number_of_Pieces_of_Equipment__c),AssetnumberSet,codemap));
        }
        if(!AssetToInsert.isEmpty()){
            //Insert AssetToInsert;
            Database.insert(AssetToInsert, false);
        }
        return AssetToInsert;
    }
    //@@SUBMETHOD: constructing a new Asset object list
    Private static list<Int_Asset__c> CreateNewAssets(list<cllease__Contract_Equipment__c> CEList,Map<String,cllease__Asset_workbench__c> AssetWBMap,string SourceSystem,string NopEquipment,set<string> AssetnumberSet,map<string,string> intCodeMap){
        list<Int_Asset__c> TempAssetList = new list<Int_Asset__c>();
        string status = '';
        
        for (cllease__Contract_Equipment__c cce : CEList){
            //  string mat = intCodeMap.containsKey(cce.Master_Asset_Type__c)?intCodeMap.get(cce.Master_Asset_Type__c):'118';//cce.Master_Asset_Type__c!=Null?cce.Master_Asset_Type__c:'GMAT' ;
            Status = (AssetWBMap.containsKey(cce.name) && AssetWBMap.get(cce.name).cllease__Return_Status__c !=Null)?(intCodeMap.containsKey(AssetWBMap.get(cce.name).cllease__Return_Status__c)?intCodeMap.get(AssetWBMap.get(cce.name).cllease__Return_Status__c):''):'';
            If (status =='TRMREG'){
                status = 'REMARKETED';
            }
            TempAssetList.add( new Int_Asset__c(
                Asset_Source_System__c = intCodeMap.get(SourceSystem),
                Asset_Type__c = cce.Asset_Type_Name__c,
                Object_Category__c = cce.Object_Category_Name__c,
                Asset_Status_Code__c = Status,
                Manufacturing_Year__c = cce.cllease__Year__c,
                Used_Indicator__c = '0',
                Serial_Number__c = cce.cllease__Equipment_Serial_Number__c,
                // model__c = cce.Equipment_Description1__c,
                model__c = cce.cllease__Model__c,
                model_number__c = cce.cllease__Model__c,
                make__c = cce.Manufacturer__c,
                asset_type_Number__c = cce.Asset_Type_ID__c,
                //Inventory_Book_Value__c = ScaleToTwoDecimal(cce.cllease__Equipment_Calculated_Cost__c),
                //Inventory_Sale_Amount__c = ScaleToTwoDecimal(cce.cllease__Estimated_Selling_Price__c),
                Inventory_Book_Value__c = ScaleToTwoDecimal((AssetWBMap.containsKey(cce.name) && AssetWBMap.get(cce.name).Sale_Price__c !=Null)?AssetWBMap.get(cce.name).Sale_Price__c:Null),
                Inventory_Sale_Amount__c = ScaleToTwoDecimal((AssetWBMap.containsKey(cce.name) && AssetWBMap.get(cce.name).Sale_Price__c !=Null)?AssetWBMap.get(cce.name).Sale_Price__c:Null),
                Asset_Recording_Method_Code__c = 'GARD',
                Global_Master_Asset_Type_Code__c = intCodeMap.containsKey(cce.Master_Asset_Type__c)?intCodeMap.get(cce.Master_Asset_Type__c):'118',
                Global_Master_Asset_Type__c = cce.Master_Asset_Type__c!=Null?cce.Master_Asset_Type__c:'GMST',//mandatory
                Object_Category_Number__c = cce.Object_Category_ID__c!=Null?cce.Object_Category_ID__c:'0',//mandatory
                Asset_Number__c = cce.name,//cce.Asset_ID__c!=Null?cce.Asset_ID__c:string.valueOf(integer.valueof(math.random()*10000000)),//mandatory
                Number_Of_Units__c = '1'//NopEquipment
            ));   
        }
        return TempAssetList;
    }    
    /*------------------------------------- ASSET Records creation ends-----------------------------------------------*/
    
    /*------------------------------------- AGREEMENT FEATURE creation starts -----------------------------------------------*/
    //@METHOD: To Create Int_ASSET FEATURE__c object
    Public static list<Int_agreement_feature__c> CreateAgreementFeatures(list<Int_Agreement__c> AgrRecords,list<cllease__Lease_Account__c> Contracts,map<string,string> intcode){
        list<Int_agreement_feature__c> AgreementFeatureToInsert = new list<Int_agreement_feature__c>();
        Map<string,int_agreement__c> AgrMap = new map<string,int_agreement__c>();
        set<string> FeatureNameSet = new set<string>{'LOCALBUCODE','GROSSAR','OPENAR','ONACCOUNT','GROSSARUSGAAP'};
            for (int_agreement__c agr : AgrRecords){
                AgrMap.put(agr.Agreement_Number__c,new int_agreement__c(id=agr.Id));            
            }
        for(cllease__Lease_Account__c contract : Contracts){
            for (string FeatureName : FeatureNameSet){
                AgreementFeatureToInsert.add(CreateNewAgreementfeature(contract,AgrMap,FeatureName,intcode));    
            }
        }
        return AgreementFeatureToInsert;
    }
    
    //@@SUBMETHOD: constructing a new ASSET FEATURE  object
    Private static Int_agreement_feature__c CreateNewAgreementfeature(cllease__Lease_Account__c cla,map<string,int_agreement__c> AgrMap,string FeatureName,map<string,string> intcode){
        Return new Int_agreement_feature__c(
            Agreement_Name__c = AgrMap.get(cla.name).Id,
            Agreement_Source_System__c = intcode.get(cla.Source_System__c),
            Agreement_Number__c = cla.name
            ,Value_AlphaNumeric__c = (FeatureName=='LOCALBUCODE')?cla.Business_Unit_Name__c:NULL
            ,Value_Numeric__c = (FeatureName=='GROSSAR' || FeatureName=='GROSSARUSGAAP') 
               ? (ScaleToTwoDecimal(cla .cllease__Term__c*cla.cllease__Payment_Amount__c)) 
               : (FeatureName=='OPENAR') ? ScaleToTwoDecimal(cla.Bill_Not_Paid_Rent__c) 
               : (FeatureName=='ONACCOUNT') ? ScaleToTwoDecimal(cla.cllease__Excess__c)
               : (FeatureName=='LOCALBUCODE') ? null
               :0
            ,Feature_Name__c = FeatureName
        );
    }
    /*------------------------------------- AGREEMENT FEATURE creation ends-----------------------------------------------*/
    /*------------------------------------- AGREEMENT LINE creation starts -----------------------------------------------*/
    //@METHOD: To Create Agreementlines object
    Public static list<Int_Agreement_Line__c> CreateAgreementlines(list<Int_Agreement__c> AgrRecords,list<cllease__Lease_Account__c> contractsList,map<string,string> intcode){//,list<Int_Asset__c> AssetRecords
        list<Int_Agreement_Line__c> AgreementLinesToInsert = new list<Int_Agreement_Line__c>();
        map<string,int_agreement__c> AgrMap = new map<string,int_agreement__c>();
        Map<string,list<cllease__Contract_Equipment__c>> EquipmentMap = new map<string,list<cllease__Contract_Equipment__c>>();
        string status;
        //list<cllease__Contract_Equipment__c> equipmentList = new list<cllease__Contract_Equipment__c>();
        for(Int_Agreement__c agr : AgrRecords){
            AgrMap.put(agr.Agreement_Number__c,agr);
            //AgreementLinesToInsert.add(CreateNewAgreementLine(agr));
        }
        //Equipment map 
        EquipmentMap = GetEquipments(contractsList);
        for(cllease__Lease_Account__c contract : contractsList){
            list<cllease__Contract_Equipment__c> ceList = new list<cllease__Contract_Equipment__c>();
            if(EquipmentMap.containskey(contract.Id)){
                ceList.addAll(EquipmentMap.get(contract.Id));
            }
            for (cllease__Contract_Equipment__c eq : ceList){
                AgreementLinesToInsert.add(
                    new Int_Agreement_Line__c(
                        Agreement_Name__c = AgrMap.get(eq.cllease__Contract__r.Name).Id
                        //,Agreement_Line_Start_Date__c = contract.cllease__Contract_Date__c
                        ,Agreement_Line_Start_Date__c = eq.Invoice_Date__c
                        ,Agreement_Line_Maturity_Date__c = contract.cllease__Maturity_Date__c
                        //,Agreement_Line_Status_Code__c = status
                        ,Agreement_Line_Status_Code__c =  intcode.containsKey(eq.Contract_Status__c)?intcode.get(eq.Contract_Status__c):''
                        //,Net_Principal_Balance_Amount__c = ScaleToTwoDecimal((eq.Rent_Amount__c*CountRentalStream(contract.cllease__Rental_Streams__r))+ eq.Bill_Residual_Amount__c)
                        ,Net_Principal_Balance_Amount__c = ScaleToTwoDecimal(AgrMap.get(eq.cllease__Contract__r.Name).Net_Principal_Balance_Amount__c*(contract.cllease__Financed_Amount__c!=0?eq.cllease__Estimated_Selling_Price__c/contract.cllease__Financed_Amount__c:1))
                        ,Net_Residual_Value__c = Contract.cllease__Lease_Status__c == 'EVERGREEN'?ScaleToTwoDecimal(CalculateNetResidualAmount(contract.cllease__Residual_Streams__r,contract.cllease__Residual_Amount__c,eq.cllease__Residual_Amount__c)):Null
                        //,Hard_Costs_Amount__c = ScaleToTwoDecimal(eq.cllease__Estimated_Selling_Price__c!=Null?eq.cllease__Estimated_Selling_Price__c:0)
                        //,Soft_Costs_Amount__c = ScaleToTwoDecimal((eq.Upfront_Tax_Amount__c!=Null?eq.Upfront_Tax_Amount__c:0)-(eq.Net_Trade_Up_Amount__c!=Null?eq.Net_Trade_Up_Amount__c:0)) 
                        ,Hard_Costs_Amount__c = ScaleToTwoDecimal(eq.Dealer_Charges__c!=Null?eq.Dealer_Charges__c:0)
                        ,Soft_Costs_Amount__c = ScaleToTwoDecimal((eq.Upfront_Tax_Amount__c!=Null?eq.Upfront_Tax_Amount__c:0) + (eq.Net_Trade_Up_Amount__c!=Null?eq.Net_Trade_Up_Amount__c:0)) 
                        ,Purchase_Type_Code__c = intcode.containskey(contract.Purchase_Option__c)?intcode.get(contract.Purchase_Option__c):''
                        ,Residual_Value_Booked__c = ScaleToTwoDecimal(eq.cllease__Residual_Amount__c)
                        //,Net_Principal_Amount__c = ScaleToTwoDecimal((eq.Dealer_Charges__c!=Null?eq.Dealer_Charges__c:0) + (eq.Upfront_Tax_Amount__c!=Null?eq.Upfront_Tax_Amount__c:0))
                        ,Net_Principal_Amount__c = ScaleToTwoDecimal((eq.Dealer_Charges__c!=Null?eq.Dealer_Charges__c:0) + (eq.Upfront_Tax_Amount__c!=Null?eq.Upfront_Tax_Amount__c:0) + (eq.Net_Trade_Up_Amount__c!=Null?eq.Net_Trade_Up_Amount__c:0))
                        ,Agreement_Source_System__c = intcode.get(contract.Source_System__c)
                        ,Agreement_Number__c = contract.name
                        ,Agreement_Line_Number__c = eq.name
                    ));
            }
        }
        
        return AgreementLinesToInsert;
    }
    
    //@@SUBMETHOD - To Calculate Net Residual Value
    Private static decimal CalculateNetResidualAmount(List<cllease__Residual_Stream__c> RSList, Decimal ContractResidual,Decimal BookedResidual){
        Decimal NetResidualAmount = 0.00;
        Decimal UnearnedResidualIncome = 0.00;
        for(cllease__Residual_Stream__c RS: RSList){
            If(!RS.cllease__Accrued_Flag__c)  {
                UnearnedResidualIncome += RS.cllease__Residual_Income__c ;
            }    
        }
        NetResidualAmount = ContractResidual!=0?(BookedResidual*(1 - UnearnedResidualIncome/ContractResidual)):(BookedResidual-UnearnedResidualIncome);
            Return NetResidualAmount;
    }
    
    private static integer CountRentalStream(list<cllease__Rental_Stream__c> RSList){
        integer count = 0;
        for(cllease__Rental_Stream__c rs : RSList){
            if (!rs.cllease__Accrued_Flag__c){
                count += 1;
            }
        }
        return count;
    }
    // Creating records for AgreementLineAsset and 3 Collaterals files.
    //Public static list<sobject> CreateAgrLineFeaturesAndAssets(list<Int_Agreement_Line__c> AgreementLinesList,list<cllease__Lease_Account__c> contractsList,list<Int_Asset__c> AssetRecords){
    Public static list<sobject> CreateAgrLineAssetsAndCollaterals(list<Int_Agreement_Line__c> AgreementLinesList,list<cllease__Lease_Account__c> contractsList,list<Int_Asset__c> AssetRecords){
        list<sobject> ReturnList = new list<sobject>();
        list<int_agreement_line_asset__c> AgrLineAssetsToInsert = new list<int_agreement_line_asset__c>(); 
        //list<Int_Agreement_Line_Feature__c> AgrFeatureList = new list<Int_Agreement_Line_Feature__c>();
        list<Int_Collateral__c> CollateralsToInsert = new list<Int_Collateral__c>();
        list<Int_Collateral_Agreement__c> CollateralAgreementsToInsert = new list<Int_Collateral_Agreement__c>();
        list<Int_Collateral_Party__c> CollateralPartiesToInsert = new list<Int_Collateral_Party__c>();
        list<cllease__Contract_Equipment__c> EquipmentList = new list<cllease__Contract_Equipment__c>();
        map<string,Int_Agreement_Line__c> AgrFeatureMap = new map<string,Int_Agreement_Line__c>();
        map<string,Int_Asset__c> AgrAssetMap = new map<string,Int_Asset__c>();
        map<String,String> partyMap = new Map<String,String>();
        for (Int_Asset__c asset : AssetRecords){
            AgrAssetMap.put(asset.Asset_Number__c,new int_asset__c(id=asset.Id,Asset_Source_System__c=asset.Asset_Source_System__c,Global_Master_Asset_Type_Code__c=asset.Global_Master_Asset_Type_Code__c));
        } 
        if(!AgreementLinesList.isEmpty()){            
            for(Int_Agreement_Line__c iaf : DMBIStaticVariables.getAgreementLines(AgreementLinesList)){
                AgrFeatureMap.put(iaf.Agreement_Number__c,new Int_Agreement_Line__c(id=iaf.id,Agreement_Name__c=iaf.Agreement_Name__c,Agreement_Source_System__c=iaf.Agreement_Source_System__c,Agreement_Number__c=iaf.Agreement_Number__c,Agreement_Line_Number__c=iaf.Agreement_Line_Number__c));
            }
            Map<string,List<cllease__Contract_Equipment__c>> EquipmentMap = GetEquipments(contractsList);
            for(cllease__Lease_Account__c contract:contractsList){
                if(EquipmentMap.containskey(contract.Id)){
                    EquipmentList.addAll(EquipmentMap.get(contract.Id));
                }
                partyMap.put(contract.Name,contract.Account_Number__c);
            }
            
            for (cllease__Contract_Equipment__c equipment : EquipmentList){
                //system.debug(equipment.Name+'-->'+AgrAssetMap.get(equipment.Name).Id);
                AgrLineAssetsToInsert.add(new int_agreement_line_asset__c(
                    Agreement_Line_Name__c = AgrFeatureMap.containskey(equipment.cllease__Contract__r.name) ? AgrFeatureMap.get(equipment.cllease__Contract__r.name).Id:Null
                    ,Agreement_Line_Number__c = equipment.Name //AgrFeatureMap.containskey(equipment.cllease__Contract__r.name)?AgrFeatureMap.get(equipment.cllease__Contract__r.name).Agreement_Line_Number__c:'ALN'
                    ,Asset_Name__c = AgrAssetMap.containskey(equipment.Name)?AgrAssetMap.get(equipment.Name).Id:Null
                    ,Agreement_Source_System__c = AgrFeatureMap.containskey(equipment.cllease__Contract__r.name)?AgrFeatureMap.get(equipment.cllease__Contract__r.name).Agreement_Source_System__c:'CLCMUS'
                    // ,Asset_Number__c = equipment.Asset_ID__c//AgrAssetMap.containskey(equipment.Name)?string.valueof(AgrAssetMap.get(equipment.Name).Id):'Null'
                    ,Asset_Number__c = equipment.Name
                    ,Asset_Source_System__c = AgrAssetMap.containskey(equipment.Name)?AgrAssetMap.get(equipment.Name).Asset_Source_System__c:'CLCMUS'
                    ,Agreement_Number__c = equipment.cllease__Contract__r.name
                ));
                CollateralsToInsert.add(new Int_Collateral__c(
                    Collateral_Source_System__c = AgrFeatureMap.containskey(equipment.cllease__Contract__r.name)?AgrFeatureMap.get(equipment.cllease__Contract__r.name).Agreement_Source_System__c:'CLCMUS'                  
                    ,Collateral_Number__c = equipment.Name
                    ,Collateral_Type__c = 'LEAASS' //Default Value
                    ,Currency_Code__c = 'USD' //Default value
                    ,Colleteral_Amount__c = Null
                    ,Global_Master_Asset_Type__c = AgrAssetMap.containskey(equipment.Name)?AgrAssetMap.get(equipment.Name).Global_Master_Asset_Type_Code__c:Null
                    ,Net_Residual_Value__c = Null
                    ,Coll_Percentage__c = Null
                    ,Coll_Maturity_Date__c = Null
                    ,Coll_Original_Valuation_Date__c = Null
                    ,Coll_Valuation_Date__c = Null
                    ,Coll_Original_Amount__c = Null
                    ,Coll_Valuation_Type_Code__c = Null
                    ,Coll_Valuation_Approach_Code__c = Null
                    ,Coll_Government_Type_Code__c = Null                                        
                ));
                CollateralAgreementsToInsert.add(new Int_Collateral_Agreement__c(
                    Agreement_Source_System__c = AgrFeatureMap.containskey(equipment.cllease__Contract__r.name)?AgrFeatureMap.get(equipment.cllease__Contract__r.name).Agreement_Source_System__c:'CLCMUS'                  
                    ,Agreement_Number__c = equipment.cllease__Contract__r.name
                    ,Collateral_Source_System__c = AgrFeatureMap.containskey(equipment.cllease__Contract__r.name)?AgrFeatureMap.get(equipment.cllease__Contract__r.name).Agreement_Source_System__c:'CLCMUS'                  
                    ,Collateral_Number__c = equipment.Name
                    ,Collateral_Type__c = 'LEAASS' //Default Value                                                           
                ));
                CollateralPartiesToInsert.add(new Int_Collateral_Party__c(
                    Collateral_Source_System__c = AgrFeatureMap.containskey(equipment.cllease__Contract__r.name)?AgrFeatureMap.get(equipment.cllease__Contract__r.name).Agreement_Source_System__c:'CLCMUS'                  
                    ,Collateral_Number__c = equipment.Name
                    ,Collateral_Type__c = 'LEAASS' //Default Value
                    ,Party_Source_System__c = AgrFeatureMap.containskey(equipment.cllease__Contract__r.name)?AgrFeatureMap.get(equipment.cllease__Contract__r.name).Agreement_Source_System__c:'CLCMUS'
                    ,Party_Number__c = partyMap.containskey(equipment.cllease__Contract__r.name)?partyMap.get(equipment.cllease__Contract__r.name):Null
                    ,Party_Role_Type_Code__c = 'CNTP'   //Default Value                                                                                                                  
                ));
            }
        }
        ReturnList.addAll(AgrLineAssetsToInsert);
        if(!CollateralsToInsert.isEmpty()){
            Database.insert(CollateralsToInsert,false);
            //DMBIInterfaceJob.CalculateObjectCount(CollateralsToInsert);
        }
        if(!CollateralAgreementsToInsert.isEmpty()){
            Database.insert(CollateralAgreementsToInsert,false);
            //DMBIInterfaceJob.CalculateObjectCount(CollateralAgreementsToInsert);
        }
        if(!CollateralPartiesToInsert.isEmpty()){
            Database.insert(CollateralPartiesToInsert,false);
            //DMBIInterfaceJob.CalculateObjectCount(CollateralPartiesToInsert);
        }
        Return ReturnList;
    }
    
    /*------------------------------------- AGREEMENT LINE creation ends-----------------------------------------------*/
    private static Map<string,list<cllease__Contract_Parties__c>> getParties(list<cllease__Lease_Account__c> contracts,string key){
        Map<string,list<cllease__Contract_Parties__c>> PartiesMap = new Map<string,list<cllease__Contract_Parties__c>>();
        for(cllease__Contract_Parties__c ccp : DMBIStaticVariables.getContractParties(contracts)){
            if(key=='Id'){
                if(!PartiesMap.containskey(ccp.cllease__Contract__c )){
                    PartiesMap.put(ccp.cllease__Contract__c,new list<cllease__Contract_Parties__c>{ccp});
                }else{
                    list<cllease__Contract_Parties__c> TempList = PartiesMap.get(ccp.cllease__Contract__c);
                    TempList.add(ccp);
                    PartiesMap.put(ccp.cllease__Contract__c,TempList);
                }
            }else{
                if(!PartiesMap.containskey(ccp.cllease__Contract__r.name )){
                    PartiesMap.put(ccp.cllease__Contract__r.name,new list<cllease__Contract_Parties__c>{ccp});
                }else{
                    list<cllease__Contract_Parties__c> TempList = PartiesMap.get(ccp.cllease__Contract__r.name);
                    TempList.add(ccp);
                    PartiesMap.put(ccp.cllease__Contract__r.name,TempList);
                }
            }
            
        }return PartiesMap;
    }
    /*------------------------------------- IntParty creation Starts -----------------------------------------------*/
    Public static list<Int_Party__c> CreateParties(list<cllease__Lease_Account__c> Contracts,set<string> insertedParties,map<string,string> Codemapping){     
        // list<Int_Party__c> NewParties = new list<Int_Party__c>();
        map<string,Int_Party__c> NewPartyMap = new map<string,int_party__c>();
        list<int_party__c> NewPartyList = new list<int_party__c>();
        Map<string,list<cllease__Contract_Parties__c>> PartiesMap = getParties(Contracts,'Id');
        for (cllease__Lease_Account__c Contract : Contracts ){
            list<cllease__Contract_Parties__c> CCPList = new list<cllease__Contract_Parties__c>();
            if(PartiesMap.containskey(Contract.Id)){CCPList.addAll(PartiesMap.get(Contract.Id));}
            //system.debug(' #### ccpList --->'+CCPList.size());
            for (cllease__Contract_Parties__c cp : CCPList){
                //if(cp.cllease__Party_Account_Name__r.Account_Number__c!=Null&& !insertedParties.contains(String.valueOf((cp.cllease__Party_Account_Name__r.Account_Number__c)))){
                    NewPartyList.add(New Int_Party__c(
                        Party_Source_System__c = Codemapping.get(Contract.Source_System__c)
                        ,Party_Number__c = cp.cllease__Party_Account_Name__r.Account_Number__c
                        ,Party_Name__c = cp.cllease__Party_Account_Name__r.name
                        ,Individual_Indicator__c = '0'
                        ,Basel_Classification_Amount__c = 0
                        ,PD_Percentage__c = 0
                        ,Consolidated_Turnover_Amount__c = 0
                        ,Industry_Code__c = Contract.cllease__Account__r.Industry_Code__c!=Null?Contract.cllease__Account__r.Industry_Code__c:Null
                        ,Industry_Type_Code__c = Contract.cllease__Account__r.Industry_Code_Type__c!=Null?Contract.cllease__Account__r.Industry_Code_Type__c:Null
                        ,Party_Contract_Name__c = contract.name
                        ,PD_Rating_Score__c =  string.valueof(Contract.cllease__Account__r.genesis__Total_Risk_Score__c).substring(0,4) 
                        ,Legal_Form_Code__c = Codemapping.containskey(contract.cllease__Account__r.clcommon__Legal_Entity_Type__r.name)?Codemapping.get(contract.cllease__Account__r.clcommon__Legal_Entity_Type__r.name):''
                        //,Individual_Indicator__c = Codemapping.containskey(contract.cllease__Account__r.clcommon__Legal_Entity_Type__r.name)?'1':'0'
                    ));
                    /*NewPartyMap.put(cp.cllease__Party_Account_Name__r.Account_Number__c,New Int_Party__c(
                        Party_Source_System__c = Codemapping.get(Contract.Source_System__c)
                        ,Party_Number__c = cp.cllease__Party_Account_Name__r.Account_Number__c
                        ,Party_Name__c = cp.cllease__Party_Account_Name__r.name
                        ,Individual_Indicator__c = '0'
                        ,Basel_Classification_Amount__c = 0
                        ,PD_Percentage__c = 0
                        ,Consolidated_Turnover_Amount__c = 0
                        ,Industry_Code__c = Contract.cllease__Account__r.Industry_Code__c!=Null?Contract.cllease__Account__r.Industry_Code__c:Null
                        ,Industry_Type_Code__c = Contract.cllease__Account__r.Industry_Code_Type__c!=Null?Contract.cllease__Account__r.Industry_Code_Type__c:Null
                        ,Party_Contract_Name__c = contract.name
                        ,PD_Rating_Score__c =  string.valueof(Contract.cllease__Account__r.genesis__Total_Risk_Score__c).substring(0,4) 
                        ,Legal_Form_Code__c = Codemapping.containskey(contract.cllease__Account__r.clcommon__Legal_Entity_Type__r.name)?Codemapping.get(contract.cllease__Account__r.clcommon__Legal_Entity_Type__r.name):''
                        //,Individual_Indicator__c = Codemapping.containskey(contract.cllease__Account__r.clcommon__Legal_Entity_Type__r.name)?'1':'0'
                    ));*/
               // }
                
            }   
        } 
        //### INSERT on INT PARTY objects
        if(!NewPartyList.isEmpty()){
            Database.insert(NewPartyList,false);  
        }
        system.debug(' #### NewPartyList --->'+NewPartyList.size());
        return NewPartyList;
    }
    /*------------------------------------- IntParty creation Ends -----------------------------------------------*/
    /*------------------------------------- IntAgreementPartyfetures creation starts -----------------------------------------------*/
    //@METHOD: To Create IntAgreementParty feture object
    Public static list<Int_Party_Feature__c> CreateIntAgreementPartyFeatures(list<Int_Party__c> IntParties,list<cllease__Lease_Account__c> Contracts,map<string,string> codemapping){
        list<Int_Party_Feature__c> PartyFeturesToInsert = new list<Int_Party_Feature__c>();
        Map<string,Int_Party__c> PartyMap = new map<string,int_party__c>();
        for (Int_Party__c ip : IntParties){
            PartyMap.put(ip.Party_Contract_Name__c,ip);//Party_Contract_Name__c
        }
        for(cllease__Lease_Account__c Contract :Contracts){
            PartyFeturesToInsert.add(New Int_Party_Feature__c(
                Party_Name__c = PartyMap.get(contract.name).Id,
                Party_Number__c = Contract.Account_Number__c,
                Party_Source_System__c = codemapping.get(Contract.Source_System__c)
                //,Feature_Name__c = 'NULL'
                //Value_DateTime__c = NULL,
                //Value_Numeric__c = 'NULL'
            ));
        }
        return PartyFeturesToInsert;
    }
    //------------------------------------- IntAgreementPartyfetures creation Ends -----------------------------------------------*/
    //contract parties //
    private static map<string,list<cllease__Contract_Parties__c>> getContractparties(list<cllease__Lease_Account__c> contracts){
        map<string,list<cllease__Contract_Parties__c>> PartiesMap = new map<string,list<cllease__Contract_Parties__c>>();
        for(cllease__Contract_Parties__c cp : DMBIStaticVariables.getContractParties(contracts)){
            system.debug('*************************************** sure sure');
            if(!PartiesMap.containskey(cp.cllease__Contract__c)){
                system.debug('adding 1' + cp);
                PartiesMap.put(cp.cllease__Contract__c,new list<cllease__Contract_Parties__c>{cp});
            }else{
                list<cllease__Contract_Parties__c> TempList = PartiesMap.get(cp.cllease__Contract__c);
                system.debug('adding 2' + cp);
                TempList.add(cp);
                PartiesMap.put(cp.cllease__Contract__c,TempList);    
            }
        }
        return PartiesMap;
    }
    //------------------------------------- PartyStreetAddress creation Starts---- -----------------------------------------------*/
    PUblic static list<Int_Party_Street_Address__c> CreateIntAgreementPartyStreetAddressDetails(list<Int_Party__c> IntParties,list<cllease__Lease_Account__c> Contracts,map<string,string> CodeMap){
        //list<Int_Party_Street_Address__c> PSADList = New list<Int_Party_Street_Address__c>();
        Map<string,Int_Party_Street_Address__c> PSADMap = new Map<string,Int_Party_Street_Address__c>();
        map<string,list<cllease__Contract_Parties__c>> ContractpartiesMap =  getContractparties(Contracts);
        Map<string,Int_Party__c> PartyMap = new map<string,int_party__c>();
        for (Int_Party__c ip : IntParties){
            if(ip.id!=Null){
                PartyMap.put(ip.Party_Number__c,new int_party__c(Id=ip.Id));//Party_Contract_Name__c
            }
        }
        for(cllease__Lease_Account__c Contract :Contracts){
            List<cllease__Contract_Parties__c> ccpList = new list<cllease__Contract_Parties__c>();
            if(ContractpartiesMap.containskey(contract.Id)){
                ccpList.addAll(ContractpartiesMap.get(contract.Id));
            }
            for (cllease__Contract_Parties__c cp : ccpList){
                If(cp.cllease__Party_Account_Name__r.Account_Number__c!=Null && PartyMap.containskey(cp.cllease__Party_Account_Name__r.Account_Number__c)){ 
                    PSADMap.put(cp.cllease__Party_Account_Name__r.Account_Number__c,New Int_Party_Street_Address__c(
                        Party_Name__c = PartyMap.containskey(cp.cllease__Party_Account_Name__r.Account_Number__c)?PartyMap.get(cp.cllease__Party_Account_Name__r.Account_Number__c).Id:Null,
                        Party_Address_Type_Code__c = 'ESTA',
                        Party_Number__c = cp.cllease__Party_Account_Name__r.Account_Number__c,
                        Party_Source_System__c = CodeMap.get(Contract.Source_System__c),
                        Country_Code__c = 'US',
                        Address_Line_1__c = cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_1__c!=Null?cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_1__c: '',
                        Address_Line_2__c = cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_2__c!=Null?cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_2__c: '',
                        Address_Line_3__c = cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_3__c!=Null?cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_3__c: '',
                        Address_Line_4__c = cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_4__c!=Null?cp.cllease__Party_Account_Name__r.Primary_Address__r.Address_Line_4__c: '',                    
                        Town_Name__c = cp.cllease__Party_Account_Name__r.Primary_Address__r.City__c!=Null?cp.cllease__Party_Account_Name__r.Primary_Address__r.City__c: '',
                        Region_Name__c = cp.cllease__Party_Account_Name__r.Primary_Address__r.State__c!=Null?cp.cllease__Party_Account_Name__r.Primary_Address__r.State__c: '',
                        Post_Code__c = cp.cllease__Party_Account_Name__r.Primary_Address__r.Zip_Code__c!=Null?cp.cllease__Party_Account_Name__r.Primary_Address__r.Zip_Code__c: ''
                    ));
                }  
            } 
        }
        Return PSADMap.values();
    }    
    //------------------------------------- PartyStreetAddress creation Ends -----------------------------------------------------*/
    /*------------------------------------- PartyExternalReference creation starts -----------------------------------------------*/
    //@METHOD: To Create IntAgreementPartyExternal References object
    Public static list<Int_Party_External_Reference__c> CreateIntAgreementPartyExternalReferences(list<Int_Party__c> IntParties,list<cllease__Lease_Account__c> Contracts,map<string,string> intmap){
        list<Int_Party_External_Reference__c> IntPartyExternalRefListToInsert = New list<Int_Party_External_Reference__c>();
        map<string,Int_Party_External_Reference__c> PERMap = new map<string,Int_Party_External_Reference__c>();
        Map<string,Int_Party__c> PartyMap = new map<string,int_party__c>();
        for (Int_Party__c ip : IntParties){
            if(ip.id!=Null){
                PartyMap.put(ip.Party_Number__c,new Int_Party__c(id=ip.id));
            }    
        }
        map<string,list<cllease__Contract_Parties__c>> ContractpartiesMap = getContractparties(Contracts);
        for(cllease__Lease_Account__c Contract :Contracts){
            list<cllease__Contract_Parties__c> ccpList = new list<cllease__Contract_Parties__c>();
            //taking each list to avoid null key exception
            if(ContractpartiesMap.containskey(contract.Id)){
                ccpList.addAll(ContractpartiesMap.get(contract.Id));
            }
            for (cllease__Contract_Parties__c cp : ccpList){
                //if(contract.cllease__Account__r.EIN__c!=Null && !PERMap.containskey(contract.cllease__Account__r.EIN__c)){
                If(cp.cllease__Party_Account_Name__r.EIN__c!=Null && cp.cllease__Party_Account_Name__r.Account_Number__c!=Null && PartyMap.containskey(cp.cllease__Party_Account_Name__r.Account_Number__c)){ 
                    PERMap.put(cp.cllease__Party_Account_Name__r.Account_Number__c,New Int_Party_External_Reference__c(
                        Party_Source_System__c = intmap.get(contract.Source_System__c),
                        //External_Identifier_Type__c = contract.DLL_Reference_Number__c!=Null?'DLLUID':'',
                        //External_Identifier_Type__c = Contract.Application__r.genesis__ID_Type__c!=NULL?(Intmap.containskey(Contract.Application__r.genesis__ID_Type__c)?Intmap.get(Contract.Application__r.genesis__ID_Type__c):''):'',
                        External_Identifier_Type__c = 'FTI',
                        External_Identifier__c = cp.cllease__Party_Account_Name__r.EIN__c,
                        Party_Number__c = cp.cllease__Party_Account_Name__r.Account_Number__c,
                        Party_Name__c = PartyMap.containskey(cp.cllease__Party_Account_Name__r.Account_Number__c)?PartyMap.get(cp.cllease__Party_Account_Name__r.Account_Number__c).Id:Null
                    ));
                }   
            }
        }
        System.debug(PERMap.values().size()+'---->'+PERMap.values());
        Return PERMap.values() ;
    }
    //------------------------------------- PartyExternalReference creation Ends -----------------------------------------------//
    /*-------------------------------------IntAgreementParties creation starts---------------------------------------------------*/
    Public static list<Int_Agreement_Party__c> CreateIntAgreementParties(list<Int_Agreement__c> AgreementRecords,list<cllease__Lease_Account__c> Contracts,list<Int_Party__c> IntParties,list<Int_Party__c> InsertedParties,map<string,string> IntCodeMapping){
        Map<String,Int_party__c> IntPartyMap = new Map<String,Int_party__c>();
        //Set<Int_party__c> AllParties = new Set<Int_party__c>(IntParties);
        list<Int_Agreement_Party__c> AgrPartiesToInsert = new list<Int_Agreement_Party__c>();
        Map<String,Int_Agreement__c> AgreementMap = new map<string,Int_Agreement__c>();
        Map<String,cllease__Lease_Account__c> ContractMap = new map<string,cllease__Lease_Account__c>();
        for (Int_Party__c ip : IntParties){            
            if(ip.id!=Null){
                IntPartyMap.put(ip.Party_Number__c, new int_party__c(id=ip.id,Party_Number__c=ip.Party_Number__c));
            }
        }
        //constructing agreement map
        for(Int_Agreement__c agr : AgreementRecords){
            AgreementMap.put(agr.Agreement_Number__c,new int_agreement__c (id = agr.Id,Agreement_Source_System__c=agr.Agreement_Source_System__c,Agreement_Number__c=agr.Agreement_Number__c));
        }
        //constructing contract map
        Map<string,list<cllease__Contract_Parties__c>> PartiesMap = getParties(contracts,'Name');
        //system.debug('parties map--->'+PartiesMap.size());
        for(cllease__Lease_Account__c cla : contracts){
            ContractMap.put(cla.Name,cla);
        }
        //Consolidating all the contract parites in one list.
        for (int_agreement__c agr :AgreementRecords){
            List<cllease__Contract_Parties__c> PartiesList = new list<cllease__Contract_Parties__c>();
            system.debug('parties map:' + partiesMap);
            if(PartiesMap.containskey(agr.Agreement_Number__c)){

                for(cllease__Contract_Parties__c ccp : PartiesMap.get(agr.Agreement_Number__c)){
                    PartiesList.add(ccp);
                }
                for(cllease__Contract_Parties__c cp : PartiesList){
                    system.debug(intcodemapping + ' x ' + cp.cllease__party_type__c);
                    //if(IntCodeMapping.containskey(cp.cllease__Party_Type__c)) {
                        system.debug('creating agreement party');
                        Int_Agreement_Party__c ap = CreateNewAgreementParty(agr,cp,IntPartyMap,IntCodeMapping)!=null?CreateNewAgreementParty(agr,cp,IntPartyMap,IntCodeMapping):Null;
                        if(ap!=NULL){AgrPartiesToInsert.add(ap);}
                    //}
                } 
            }
        }   
        system.debug('parties to insert:' + agrpartiestoinsert);
        return AgrPartiesToInsert;
    }
    //@@SUBMETHOD: constructing a new Agreement Party  object 
    Private static Int_Agreement_Party__c CreateNewAgreementParty(Int_Agreement__c agr,cllease__Contract_Parties__c cp,Map<string,Int_party__c> IntPartyMap,map<string,string> IntCodeMapping){
        //set<String> PartyAgreements = new set<String>();
        Int_Agreement_Party__c Agreementparty = new Int_Agreement_Party__c();
        //Map<string,Int_Agreement_Party__c> AgrPartyMap = new map<string,Int_Agreement_Party__c>();        
        //if(IntPartyMap.containskey(String.valueof(cp.cllease__Party_Account_Name__r.Account_Number__c))){ 
            int_party__c party = new int_party__c();
            party = IntPartyMap.get(String.valueof(cp.cllease__Party_Account_Name__r.Account_Number__c));
            Agreementparty.Party_Name__c = party.Id!=Null?party.Id:'';
            Agreementparty.Party_Role_Type_Code__c = IntCodeMapping.containskey(cp.cllease__Party_Type__c)?IntCodeMapping.get(cp.cllease__Party_Type__c):'';
            Agreementparty.Agreement_Source_System__c = agr.Agreement_Source_System__c;
            Agreementparty.Agreement_Number__c = String.valueof(agr.Agreement_Number__c);
            Agreementparty.Party_Source_System__c = agr.Agreement_Source_System__c;                    
            Agreementparty.Party_Number__c = party.Party_Number__c!=Null?party.Party_Number__c:'';
            Agreementparty.Agreement_Name__c = agr.id;
        //}
        Return Agreementparty;
    }
    /*------------------------------------- IntAgreementParties creation Ends-----------------------------------------------*/
    /*------------------------------------- FILE CONTROL creation starts-----------------------------------------------*/
    Public static Int_File_Control__c createFileControlObjects(String ObjectName,integer ObjCount,Map<string,string> hashcode,datetime BatchStartTime,DateTime BatchEndTime,map<string,string> intcode){
        list<Int_File_Control__c> ControlObjectsList = new list<sobject>();
        datetime dT = system.now();
        // list<string> strlist = string.valueof(dt).split(' ')[1].split(':');
        String timestr = '000000';
        map<string,string> ObjNameMap = new map<string,string>{'Int_Agreement__c'=>'Agreement',
            'Int_Asset__c'=>'Asset',
            'Int_facility__c'=>'Facility',
            'Int_agreement_non_IFRS__c'=>'AgreementNonIFRS',
            'Int_agreement_provision'=>'AgreementProvision',
            'Int_Asset_feature__c'=>'AssetFeature',
            'Int_Agreement_Line_Feature__c'=>'AgreementLineFeature',
            'Int_Asset_Usage__c'=>'AssetUsage',
            'Int_Collateral__c'=>'Collateral',
            'Int_collateral_Agreement__c'=>'CollateralAgreement',
            'Int_Collateral_Party__c'=>'CollateralParty',
            'Int_Facility_Feature__c'=>'FacilityFeature',
            'Int_Party_feature__c'=>'PartyFeature',
            'Int_Risk_Costs_Movements__c'=>'RiskCostsMovements',
            'Int_Delivery_controle__c'=>'DeliveryControl',
            'Int_file_controle__c'=>'FileControl','Int_Agreement_Line__c'=>'AgreementLine','Int_Party__c'=>'Party','Int_Agreement_Classification__c'=>'AgreementClassification','Int_Agreement_Exposure__c'=>'AgreementExposure','Int_Agreement_Line_Feature__c'=>'AgreementLineFeature','Int_Agreement_Interest__c'=>'AgreementInterest','Int_Agreement_Line_Asset__c'=>'AgreementLineAsset','Int_Agreement_Feature__c'=>'AgreementFeature','Int_Agreement_Party__c'=>'AgreementParty','Int_Agreement_Payment_Schedule__c'=>'AgreementPaymentSchedule','Int_Party_External_Reference__c'=>'PartyExternalReference','Int_Party_Feature__c'=>'PartyFeature','Int_Party_Street_Address__c'=>'PartyStreetAddress','Int_Delivery_Control__c'=>'DeliveryControl','Int_File_Control__c'=>'FileControl','Int_Facility__c'=>'Facility','Int_Agreement_Non_IFRS__c'=>'AgreementNonIFRS','Int_Agreement_Provision__c'=>'AgreementProvision','Int_Asset_Feature__c'=>'AssetFeature','Int_Asset_Usage__c'=>'AssetUsage','Int_Collateral__c'=>'Collateral','Int_Collateral_Agreement__c'=>'CollateralAgreement','Int_Collateral_Party__c'=>'CollateralParty','Int_Facility_Feature__c'=>'FacilityFeature','Int_Facility_Party__c'=>'FacilityParty','Int_Party_Feature__c'=>'PartyFeature','Int_Risk_Costs_Movements__c'=>'RiskCostsMovements'};
                return new Int_File_Control__c(
                    Source_System__c = intcode.get(DMBIStaticVariables.SourceSystem),//contract.Source_System__c,
                    Start_DateTime_Extraction__c = String.ValueOf(BatchStartTime),
                    End_DateTime_Extraction__c = String.ValueOf(BatchEndTime),
                    Hash_Total_1__c = hashcode.containskey(ObjectName)?hashcode.get(ObjectName):'',
                    //Hash_Total_2__c= '',
                    //Hash_Total_3__c= '',
                    Number_of_Records__c = String.valueOf(ObjCount),
                    //File_Name__c = 'US~'+intcode.get(DMBIStaticVariables.SourceSystem)+'~'+ObjNameMap.get(ObjectName)+'~'+string.valueof(date.newinstance(dT.year(), dT.month(), dT.day()))+'~'+strlist[0]+strlist[1]+strlist[2]+'.dta'
                    File_Name__c = 'US~'+intcode.get(DMBIStaticVariables.SourceSystem)+'~'+ObjNameMap.get(ObjectName)+'~'+string.valueof(date.newinstance(dT.year(), dT.month(), dT.day()))+'~'+timestr+'.dta'
                    
                );           
        //return ControlObjectsList;
    } 
    /*------------------------------------- FILE CONTROL creation ends-----------------------------------------------*/
    /*------------------------------------- DELIVERY CONTROL creation Starts -----------------------------------------------*/
    Public static Int_Delivery_Control__c createDeliveryControlObjects(datetime BatchStartTime,map<string,string> intcode){
        //string sourceSystem = DMBIStaticVariables.SourceSystem;
        
        return new Int_Delivery_Control__c(
            Source_System__c = intcode.get(DMBIStaticVariables.SourceSystem),
            Extraction_DateTime__c = String.ValueOf(BatchStartTime),
            //Reporting_Date__c = system.today(),
            Reporting_Date__c = system.today().adddays(-1),
            //End_Of_Day_Indicator__c =System.now().format('am').substring(0,2)=='PM'?'1':'0' ,
            End_Of_Day_Indicator__c = calculateMonthEndIndicator()=='0'?'1':'0',
            //End_Of_Week_Indicator__c = System.now().format('EEEE')=='Friday'?'1':'0',
            End_Of_Week_Indicator__c = System.now().adddays(-1).format('EEEE')=='Friday'?'1':'0',
            //End_Of_Month_Indicator__c = Date.newInstance(system.now().year(), system.now().month(), Date.daysInMonth(system.now().year(), system.now().month()))==system.today()?'1':'0',
            End_Of_Month_Indicator__c = calculateMonthEndIndicator(),
            Interface_Version__c = '2.0'
        );
    }
    /*------------------------------------- DELIVERY CONTROL creation ends-----------------------------------------------*/
    
    //@@SUBMETHOD: Calculate Month End Indicator.
    Public static String calculateMonthEndIndicator(){
        Datetime ReportingDate = system.now().adddays(-1);
        String monthEndIndicator='0';
        If(ReportingDate.day() == Date.daysInMonth(ReportingDate.year(), ReportingDate.month())) {
            MonthEndIndicator = '1';
        }
        return MonthEndIndicator;
    }
    Public static integer CountInsertedRecords(list<sobject> sobjectList){
        integer count = 0;
        for(sobject sob: sobjectList){
            if(sob.Id != Null){
                count+=1;
            }
        }
        return count;
    }
    //THis method returned a decimal scaled to 2 decilas of input decimal value
    Public static decimal ScaleToTwoDecimal(decimal amount){
        return amount!=Null?amount.setScale(2):0.00;
    }
    //This method calculate the size of sObect
    Public static integer CalculateSize(List<sObject> sobj){
        Integer count = 0;
        for(sObject s: sobj){
            count++;    
        }
        Return count;
    }
}
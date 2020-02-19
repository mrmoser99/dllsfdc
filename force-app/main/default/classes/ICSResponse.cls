/*******************************************************************************************************************
*   This ICSReponse service is used to process the results of the call to ICS.
*	ICS will call this service asyncrhonously with the results of the ICS credit check.
*   There are two reserved words that could not be mapped to xml:  Id and Default....The caller must change these to Id_x and 
*	Default_x;
*
*	Change Log:
*	8/9/18 	- MRM Created
*   8/10/18 - MRM Added database logic to store response results
*   9/5/18 	- MRM added more repsonse storage....
*   10/1/19 - MRM added acccount update of sic code of we get one
*   1/27/20 - MRM added a line to update account with the ein if returned
*   2/17/20 - MRM added e status error message
*
********************************************************************************************************************/
global class ICSResponse {
	 
	/* Define the structure to hold the response from ICS */
	 
	
	global class SearchDataResponse {
		webservice InternalLegalEntity InternalLegalEntity; 
    	webservice ExternalLegalEntities ExternalLegalEntities;
	}
	    
	global class ObtainDecisionResponse {
		webservice Application Application;
		webservice Customer Customer;
	}
	
	global class ObtainManualDecisionResponse {
		webservice ManualApplication Application;
	 
	}
	
	global class ManualApplication {
   		webservice String ApplicationId;
   		webservice MultipleYearLGD MultipleYearLGD;
   		webservice String AppliedEADTreatment;
   		webservice MultipleYearEAD MultipleYearEAD;
   		webservice MultipleYearEL MultipleYearEL;
   		webservice LegalEntity LegalEntity;
		webservice Links Links;
		 
   	}
   	
   	global class LegalEntity {
    	webservice ids ids;
    	webservice String ExposureClass;
    	webservice String PDRequiredTreatment;
    	webservice String PDTreatmentExposureAmountInEuro;
    	webservice String FinancedAmountinEuro;
    	webservice String RiskGradeRating;
    	webservice String CREStatus;
    	webservice Default_x Default_x;
    	webservice ApplicableRating ApplicableRating;
    	 
    }
   
    global class Customer {
    	webservice InternalLegalEntity InternalLegalEntity;
    	webservice ExternalLegalEntities ExternalLegalEntities;
    	webservice DecisionData DecisionData;
    }

    global class DecisionData {
    	webservice Fields Fields;
    }
    
    global class SystemDecision {
      webservice String ScoreDecision;
      webservice String SystemDecision;
      webservice String SystemDecisionDate;
      webservice String SystemApprovalLimit;
      webservice DecisionReasons DecisionReasons;
      webservice String PolicyRuleSetCode;
   	}
    
    global class ExternalLegalEntities {
    	webservice List<ExternalLegalEntity> ExternalLegalEntity;
    }

    global class ExternalLegalEntity {
    	webservice ExternalIds ExternalIds;
   		webservice AgencyProduct AgencyProduct;
    	webservice Organization Organization;
    	webservice Address Address;
    	webservice PhoneRecords PhoneRecords;
    	webservice Fields Fields;
    }
    global class PhoneRecords {
    	webservice List<PhoneRecord> PhoneRecord;
    }

    global class PhoneRecord {
    	webservice String PhoneNumber;
    	webservice String PhoneType;
    }
    global class AgencyProduct {
    	webservice String AgencyId;
    	webservice String AgencyProductId;
    }
    
    global class Organization {
    	webservice String LegalName;
    	webservice String EstablishedYear;
    	webservice String LocalLegalFormCode;
    	webservice LocalIndustryCode LocalIndustryCode;
    }
    
    global class LocalIndustryCode {
    	webservice String IndustryCodeType;
    	webservice String IndustryCodeValue;
    }

    global class ExternalIds {
    	webservice List<ExternalId> ExternalId;
    }

    global class ExternalId {
    	webservice String ExternalIdType;
    	webservice String ExternalIdValue;
    }
  
    global class InternalLegalEntity {
    	webservice ids ids;
    	webservice String LegalName;
    	webservice String ExposureClass;
    	webservice String PDRequiredTreatment;
    	webservice String PDTreatmentExposureAmountInEuro;
    	webservice String FinancedAmountinEuro;
    	webservice String RiskGradeRating;
    	webservice String CREStatus;
    	webservice Phone Phone;
    	webservice Address Address;
    	webservice Default_x Default_x;
    	webservice ApplicableRating ApplicableRating;
    	webservice Fields Fields;
    }

    global class ApplicableRating {
    	webservice String PDratingDate;
    	webservice String PDRatingModel;
    	webservice String PDPercentage;
    	webservice String RabobankMasterscaleRating;
    	webservice String PDRatingScore; 
    	webservice String PDVintage;
    	webservice String PDPenaltyFlag;
    	webservice String CherryPickingFlag;
    	webservice String PDLookupType;
    	webservice MultiplePD MultiplePD;	
    }

    global class MultiplePD {
    	webservice List<MultipleYearPDItem> MultipleYearPDItem;
    }

    global class MultipleYearPDItem {
    	webservice String Vintage;
    	webservice String Percentage;
    }

    global class Default_x {
    	webservice String MasterscaleRating;
    	webservice String DefaultDate;
    	webservice String CurrentlyInDefaultIndicator;
    	webservice String InitialDefaultReason;
    }
    
   	global class Address {
   		webservice String AddressLine;
   		webservice String City;
   		webservice String StateProvinceCode;
   		webservice String PostalCode;
   		webservice String CountryCode;
   	}
   	
   	global class Phone {
   		webservice String PhoneNumber;
   		webservice String PhoneType;
   	}

    global class Ids {
    	webservice List<id_x> Id_x;
    }
    
    global class Id_x {
    	webservice String SourceSystem;
    	webservice String IDType;
    	webservice String IDValue;
    }
    
     global class Links {
    	webservice List<Link> Link;
    }
    
    global class Fields {
    	webservice List<Field> Field; 	
    }
    
    global class Field {
    	webservice String Name;
    	webservice String Type;
    	webservice String Value;
    }

	global class Link {
    	webservice String SourceSystem;
    	webservice String LinkType;
    	webservice String LinkValue;
    }

     global class DecisionReasons {
    	webservice List<DecisionReason> DecisionReason;
    }
    
   	global class DecisionReason {
   		webservice String ReasonCode;
   		webservice String ReasonDesc;
   	}
   	
   	global class Application {
   		webservice String ApplicationId;
   		webservice MultipleYearLGD MultipleYearLGD;
   		webservice String AppliedEADTreatment;
   		webservice MultipleYearEAD MultipleYearEAD;
   		webservice MultipleYearEL MultipleYearEL;
   		webservice SystemDecision SystemDecision;
   		webservice ScoreResult ScoreResult;
		webservice Links Links;
		webservice Fields Fields;
   	}
   	
   	global class ScoreResult {
    	webservice String ScoreDate;
    	webservice ScorecardResults ScorecardResults;
    }
    
    global class ScorecardResults {
    	webservice List<ScorecardResult> ScorecardResult;	
    }
    
    global class ScorecardResult {
    	webservice String ScorecardName;
    	webservice String ScorecardScore;
    	webservice String ScorecardForPDFlag;
    	webservice AdverseReasons AdverseReasons;
    }
  
    global class AdverseReason{
    	webservice String ScoreDeviation;
    	webservice String AdverseReasonCode;
    	webservice String AdverseReasonDesc;
    }
    
    global class AdverseReasons {
    	webservice List<AdverseReason> AdverseReason;
    }
    
   
    
   	global class MultipleYearLGD {
   		webservice List<MultipleYearLGDItem> MultipleYearLGDItem;
   	}

   	global class MultipleYearEAD {
   		webservice List<MultipleYearEADItem> MultipleYearEADItem;
   	}
   	
   	global class MultipleYearEL {
   		webservice List<MultipleYearELItem> MultipleYearELItem;
   	}

   	global class MultipleYearLGDItem {
   		webservice String Vintage;
   		webservice String Percentage;
   	}

   	global class MultipleYearEADItem {
   		webservice String Vintage;
   		webservice String Amount;
   	}
 
   	global class MultipleYearELItem {
   		webservice String Vintage;
   		webservice String Amount;
   	}
 
   	global class AdditionalAttributes{
   		webservice List<Attribute> Attribute;
   		
   	}
 
   	global class Attribute {
   		webservice String AttributeName;
   		webservice String AttributeValue;
   	}
   	
   	global class Results {
   		webservice String ReturnStatus;
   		webservice Result Result;
   	}
   	
   	global class Result {
   		webservice String CreatedByModule;
   		webservice String KeyValue;
   		webservice String MsgNumber;
   		webservice String MsgStatus;
   		webservice String MsgData;
   		webservice String MsgSourceSystem;
   		
   	}
   	global class Input {
   		
   		webservice SearchDataResponse SearchDataResponse;
   		webservice ObtainDecisionResponse ObtainDecisionResponse;
   		webservice ObtainManualDecisionResponse ObtainManualDecisionResponse;
   		webservice AdditionalAttributes AdditionalAttributes;
		webservice Results Results;								 
											   
   	}
   	
	/*******************************************************************************************************************
	*	SUBMIT ICS RESPONSE   
	*	This is the main call. Results of the ICS Response are stored in the database 
	*   The quick quote credit status will be updated as a result of this call.
	********************************************************************************************************************/
   	webService static string SubmitICSResponse(Input Input){
		
		system.debug('******************* SUBMIT ICS RESPONSE ***************************************');
		system.debug(Input.results);
		/* record types */
		List<RecordType> rList = [select id
								  ,developername 
								  from RecordType 
								  where developerName in ('List_Of_Similars', 'Decision')
								  and sObjectType = 'ICS_Application__c'];
		
		Map<String,String> rMap = new Map<String,String>();
		for (RecordType r:rList)
			rMap.put(r.developername, r.id);
			
		/* los processing */ 
		if (Input.SearchDataResponse != null){
			return handleListOfSimilars(Input.SearchDataResponse,
   								Input.AdditionalAttributes,
								Input.Results);
		}
		else{
			/* manual response processing */
			if (Input.ObtainManualDecisionResponse != null){
				return handleManualResponse(Input.ObtainManualDecisionResponse, Input.AdditionalAttributes, Input.Results);
			}
		}
		
		if (input.searchdataresponse == null && input.obtaindecisionresponse == null  
		&&	input.obtainmanualdecisionresponse == null){
			return handleResponse(Input.additionalattributes, input.results);
		}
			
		
				
		try {
		 
		// get the application  											
		genesis__Quick_Quotes__c q = [	select id 
										,name
										,genesis__Account__c
										from genesis__Quick_Quotes__c 
										where name = :Input.ObtainDecisionResponse.application.ApplicationId.Trim()
										];
		 
		Account acc = [select id from Account where id = :q.genesis__account__c];

		String messageId;
		
	
		if (Input.AdditionalAttributes!= null){
			if (Input.AdditionalAttributes.Attribute != null){
				for (Attribute a:Input.AdditionalAttributes.Attribute){
					if (a.AttributeName == 'MESSAGE-ID')
						messageId = a.AttributeValue;
				}		
			}
		}		
		system.debug('message id is: ' + messageId);
				
		ICS_Application__c a = [select id from ICS_Application__c where  message_id__c = :messageId and
					quick_quote__r.name = :Input.ObtainDecisionResponse.application.ApplicationId.Trim()];
		
		List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
		Map<String,ID> gMap = new Map<String,ID>();
		for (Group g:gList)
			gMap.put(g.developername, g.id);
			
		
		a.Score_Decision__c =  Input.ObtainDecisionResponse.application.systemdecision.scoreDecision;
		a.System_Decision__c = Input.ObtainDecisionResponse.application.systemdecision.systemDecision;
		a.System_Approval_Limit__c = decimal.valueOf(Input.ObtainDecisionResponse.application.systemdecision.systemapprovallimit);
		
		if (Input.obtaindecisionResponse.application.links.link != null){
			for (Link l:input.ObtainDecisionResponse.Application.Links.Link){
				if (l.linkType == 'Commitment')
					a.commitment_link__c = l.linkvalue;
				if (l.linkType == 'Legal_Entity')
					a.legal_entity_link__c = l.linkValue;
				if (l.linkType == 'Application & Scoring Details')
					a.app_scoring_link__c = l.linkValue;
			}
		}
		
		List<ICS_Multiple_Year_LGD__c> iLGDList = new List<ICS_Multiple_Year_LGD__c>();
		for (MultipleYearLGDItem lgd:Input.ObtainDecisionResponse.application.MultipleYearLGD.MultipleYearLGDItem){
			ICS_Multiple_Year_LGD__c ilgd = new ICS_Multiple_Year_LGD__c();
			ilgd.percent__c = decimal.valueOf(lgd.Percentage);
			ilgd.vintage__c = lgd.Vintage;
			ilgd.ICS_Application_Request__c = a.id;
			iLGDList.add(ilgd);
		}
		if (!iLGDList.isEmpty())
			insert ILGDList;

		List<ICS_Multiple_Year_EL__c> iELList = new List<ICS_Multiple_Year_EL__c>();
		for (MultipleYearELItem el:Input.ObtainDecisionResponse.application.MultipleYearEL.MultipleYearELItem){
			ICS_Multiple_Year_EL__c iel = new ICS_Multiple_Year_EL__c();
			iel.amount__c = decimal.valueOf(el.Amount);
			iel.vintage__c = el.Vintage;
			iel.ICS_Application_Request__c = a.id;
			iELList.add(iel);
		}
		if (!iELList.isEmpty())
			insert IELList;
			
		List<ICS_Multiple_Year_EAD__c> iEADList = new List<ICS_Multiple_Year_EAD__c>();
		for (MultipleYearEADItem EAD:Input.ObtainDecisionResponse.application.MultipleYearEAD.MultipleYearEADItem){
			ICS_Multiple_Year_EAD__c iEAD = new ICS_Multiple_Year_EAD__c();
			iEAD.amount__c = decimal.valueOf(EAD.Amount);
			iEAD.vintage__c = EAD.Vintage;
			iEAD.ICS_Application_Request__c = a.id;
			iEADList.add(iEAD);
		}
		if (!iEADList.isEmpty())
			insert IEADList;		
		
		a.applied_ead_treatment__c = Input.ObtainDecisionResponse.application.AppliedEADTreatment;
		
	
		ICS_Scorecard_Result__c sr = new ICS_Scorecard_Result__c();
		if (Input.ObtainDecisionResponse.application.ScoreResult != null){
			sr.name = Input.ObtainDecisionResponse.application.ScoreResult.ScorecardResults.ScorecardResult[0].ScorecardName;
			sr.score__c = decimal.valueOf(Input.ObtainDecisionResponse.application.ScoreResult.ScorecardResults.ScorecardResult[0].ScorecardScore);
			sr.pd_flag__c = boolean.valueOf(Input.ObtainDecisionResponse.application.ScoreResult.ScorecardResults.ScorecardResult[0].ScorecardForPDFlag);
		}
		sr.ICS_application_Request__c = a.id;
		insert sr;
		
		List<ICS_Scorecard_Adverse_Reason__c> arList = new List<ICS_Scorecard_Adverse_Reason__c>();
		
		if (Input.ObtainDecisionResponse.application.ScoreResult != null){
			for (AdverseReason ars:Input.ObtainDecisionResponse.application.ScoreResult.ScorecardResults.ScorecardResult[0].AdverseReasons.AdverseReason){
				ICS_Scorecard_Adverse_Reason__c sar = new ICS_Scorecard_Adverse_Reason__c();
				sar.adverse_reason_code__c = ars.AdverseReasonCode;
				sar.adverse_reason_description__c = ars.AdverseReasonDesc;
				sar.score_deviation__c = decimal.valueOf(ars.Scoredeviation);
				sar.ICS_Scorecard_Result__c = sr.id;
				arList.add(sar);
			}
			if (!arList.isEmpty())
				insert arList;
		}
		system.debug('********************************** herea');	
		
		for (Id_x i:Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Ids.Id_x){
			if (i.IDType == 'LE_ID')
				a.legal_entity_id__c = i.IDValue;
		}
		
		/*
		webservice String MasterscaleRating;
    	webservice String DefaultDate;
    	webservice String CurrentlyInDefaultIndicator;
    	webservice String InitialDefaultReason;
		*/
		if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x != null){
			system.debug('hereaxcd1');
			if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x.CurrentlyInDefaultIndicator != null)
				a.currently_in_default__c = boolean.valueOf(Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x.CurrentlyInDefaultIndicator);
			a.master_scale_rating__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x.MasterscaleRating;
			a.initial_default_reason__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x.InitialDefaultReason;
			if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x.DefaultDate != null)
				a.default_date__c = date.valueOf(Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x.DefaultDate);
			system.debug('hereaxcd');
		}
		system.debug('********************************** here0');	
		a.legal_name__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.LegalName;
		a.address_line__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Address.AddressLine;
		a.city__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Address.City;
		a.State_province_code__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Address.StateProvinceCode;
		a.postal_code__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Address.PostalCode;
		a.country_code__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Address.CountryCode;
			system.debug('********************************** here0');
		a.exposure_class__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.ExposureClass;
		a.pd_required_treatment__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.PDRequiredTreatment;
		system.debug('********************************** here0');
	
		if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.PDTreatmentExposureAmountInEuro != null
		&& Input.ObtainDecisionResponse.Customer.InternalLegalEntity.PDTreatmentExposureAmountInEuro != ''
		&& Input.ObtainDecisionResponse.Customer.InternalLegalEntity.PDTreatmentExposureAmountInEuro != 'null')
			a.PD_Treatment_Exposure_Amount_EUR__c = decimal.valueOf( Input.ObtainDecisionResponse.Customer.InternalLegalEntity.PDTreatmentExposureAmountInEuro);
		system.debug('********************************** here0');
		if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.FinancedAmountinEuro != null
		&& Input.ObtainDecisionResponse.Customer.InternalLegalEntity.FinancedAmountinEuro != ''
		&& Input.ObtainDecisionResponse.Customer.InternalLegalEntity.FinancedAmountinEuro != 'null')
			a.Financed_Amount_EUR__c =  decimal.valueOf( Input.ObtainDecisionResponse.Customer.InternalLegalEntity.FinancedAmountinEuro);
		system.debug('********************************** here0');
	
		a.risk_grade_rating__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.RiskGradeRating;
		system.debug('********************************** here0');
	
		a.cre_status__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.CREStatus;
		system.debug('********************************** here0');
		
		if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Phone != null){
			if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Phone.PhoneNumber != 'null'
			&& Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Phone.PhoneNumber != null
			&& Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Phone.PhoneNumber != '')
				a.phone__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Phone.PhoneNumber;
			system.debug('********************************** here0');
	
			a.phone_type__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Phone.PhoneType;
			system.debug('********************************** here0');
		}
		
		a.currently_in_default__c = Boolean.valueOf(Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Default_x.CurrentlyInDefaultIndicator);	
		system.debug('********************************** here0');
	
		a.pd_rating_date__c = date.valueOf(Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDRatingDate);
		system.debug('********************************** here0');
		
		a.pd_rating_model__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDRatingModel;
		system.debug('********************************** here0');
	
		if (Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDPercentage != null)
			a.pd_percent__c = decimal.valueOf(Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDPercentage);
		system.debug('********************************** here0');
	
		a.rabobank_masterscale_rating__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.RabobankMasterscaleRating;
		system.debug('********************************** here0');
	
		a.pd_rating_score__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDRatingScore;
		system.debug('********************************** here0');
	
		a.pd_vintage__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDVintage;
		system.debug('********************************** here0');
	
		a.pd_penalty_flag__c = Boolean.valueOf(Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDPenaltyFlag);
		system.debug('********************************** here0');
	
		a.cherry_picking_flag__c = Boolean.valueOf(Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.CherryPickingFlag);
		system.debug('********************************** here0');
	
		a.pd_lookup_type__c = Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.PDLookupType;
		system.debug('********************************** here0');
	
		
		List<ICS_Additional_History__c> hList = new List<ICS_Additional_History__c>();
		for (Field f:Input.ObtainDecisionResponse.Customer.InternalLegalEntity.Fields.Field){
			ICS_Additional_History__c h = new ICS_Additional_History__c();
			h.category__c = f.name;
			if (f.name == 'DRVD.CMCL.EXTL.ORSK.KnowYourCustomerCode')
				if (f.value != 'No'){
					a.kyc__c = true;
					a.kyc_code__c = f.value;
				}
					
			h.value__c = f.Value;
			h.ics_application_request__c = a.id;
			hList.add(h);
		}
		system.debug('********************************** here0');
		if(!hList.isEmpty())
			insert hList;
		 
		if (Input.ObtainDecisionResponse.Customer.ExternalLegalEntities != null
		&& Input.ObtainDecisionResponse.Customer.ExternalLegalEntities.ExternalLegalEntity != null){
			for (ExternalLegalEntity ele:Input.ObtainDecisionResponse.Customer.ExternalLegalEntities.ExternalLegalEntity){
				ICS_External_Legal_Entity__c e = new ICS_External_Legal_Entity__c();
				e.ics_application_request__c = a.id;
				e.legal_name__c = ele.Organization.LegalName;
				if (ele.organization.EstablishedYear != null)
					e.established_year__c =  ele.Organization.EstablishedYear;
				e.local_legal_form_code__c = ele.Organization.LocalLegalFormCode;
				e.industry_code_type__c = ele.Organization.LocalIndustryCode.IndustryCodeType;
				e.industry_code_value__c = ele.Organization.LocalIndustryCode.IndustryCodeValue;
				acc.sic = ele.Organization.LocalIndustryCode.IndustryCodeValue;
				e.agency_id__c = ele.agencyProduct.agencyId;
				e.agency_product_id__c = ele.agencyProduct.agencyProductId;
				e.address_line__c = ele.address.AddressLine;
				e.city__c = ele.address.City;
				e.state_province_code__c = ele.address.StateProvinceCode;
				e.postal_code__c = ele.address.PostalCode;
				e.country_code__c = ele.address.CountryCode;
			
				if (ele.PhoneRecords != null){
					for	 (PhoneRecord pr:ele.PhoneRecords.PhoneRecord){
						if (pr.phoneNumber != null)
							e.phone__c = pr.PhoneNumber;
						e.phone_type__c = pr.PhoneType;
					}
				}
				
				insert e;
			
				List<ICS_External_Id__c> eList = new List<ICS_External_Id__c>();
				for (ExternalId ei:ele.ExternalIds.ExternalId){
					ICS_External_Id__c ex = new ICS_External_Id__c();
					ex.ICS_External_Legal_Entity__c = e.id;
					ex.type__c = ei.ExternalIdType;
					if (ex.type__c == 'FEIN')
						acc.EIN__c = ei.ExternalIdValue.substring(0,2) + '-' + ei.ExternalIdValue.subString(2,9);
					ex.value__c = ei.ExternalIdValue;
					eList.add(ex);
				}
		
				if(!eList.isEmpty())
					insert eList;
			
				List<ICS_External_LE_Fields__c> fList = new List<ICS_External_LE_Fields__c>();
				for (Field f:ele.Fields.Field){
			 
					ICS_External_LE_Fields__c lef = new ICS_External_LE_Fields__c();
					lef.name__c = f.name;
					lef.value__c = f.Value;
					lef.ICS_External_Legal_Entity__c = e.id;
					fList.add(lef);  
				}
		system.debug('********************************** here0');
				if(!fList.isEmpty())
					insert fList;
					
			}
		}
		 
		List<ICS_Multiple_Year_PD__c> pdList = new List<ICS_Multiple_Year_PD__c>();
		
		for (MultipleYearPDItem pdi:Input.ObtainDecisionResponse.Customer.InternalLegalEntity.applicableRating.MultiplePD.MultipleYearPDItem){
			ICS_Multiple_Year_PD__c pd = new ICS_Multiple_Year_PD__c();
			pd.percent__c = decimal.valueOf(pdi.percentage);
			pd.vintage__c = pdi.Vintage;
			pd.ICS_Application_Request__c = a.id;
			pdList.add(pd);
		}
		if (!pdList.isEmpty())
			insert pdList;
		
		Boolean foundLC01 = false;
		
		for (DecisionReason d: Input.ObtainDecisionResponse.application.systemdecision.DecisionReasons.DecisionReason){
			if (d.ReasonCode == 'LC01'){
				foundLC01 = true;
				break;
    		}
    	}
		
		a.recordtypeid = rMap.get('Decision');
		
		if (foundLC01){
			a.status__c = 'CRE Rating Required';
			q.genesis__status__c = 'CREDIT REFERRED';
			a.ownerId = gMap.get('Credit');
		}
		else{
			if (a.system_decision__c == 'AA'){
				a.status__c = 'Auto Approve';
				q.genesis__status__c = 'CREDIT APPROVED';
				a.ownerId = gMap.get('Past_Credit');
				q.Credit_Approval_Expiration_Date__c =  date.today().addDays(90);
				ICSUtility.autoCreditApproval(a.id,q.name);
			}
			else{
				if (a.system_decision__c == 'AD'){
					a.status__c = 'Auto Decline';
					q.genesis__status__c = 'CREDIT DECLINED';
					a.ownerId = gMap.get('Past_Credit');
					if (!Test.isRunningTest()){
						ICVAsyncRemoveCommitment job = new ICVAsyncRemoveCommitment(q.id,'Decline');
       	 				System.enqueueJob(job);
					}	 
				} 
				else{
					if (a.system_decision__c == 'R'){
						a.status__c = 'Manual Review';
						//a.status__c = 'Manual Review w/LOS';
						q.genesis__status__c = 'CREDIT REFERRED';
						a.ownerId = gMap.get('Credit');
					}
					else{
						if (a.system_decision__c == 'ND'  || a.system_decision__c == null  || a.system_decision__c == ''){
							a.status__c = 'No Decision';
							//a.status__c = 'Manual Review w/LOS';
							q.genesis__status__c = 'CREDIT REFERRED';
							a.ownerId = gMap.get('Credit');
						}
					}
					
				}
			}	
		}	
		
		a.quick_quote__c = q.id;
		
		update a;
		update acc;
		
		
		q.Credit_Approval_Date__c = date.today();
		try{
			q.Approved_Credit_Amount__c = a.System_Approval_Limit__c;
		}
		catch (exception e){
			q.approved_credit_amount__c = null;
		}
		
		q.ATS_Reference_Number__c = messageId;								   
				 							   
		update q;
		
		//insert ics system decision reasons  
		ICSResponse.insertReasons(a.id,Input.ObtainDecisionResponse); 
		
		ICS_Log__c l = new ICS_Log__c();
		l.xml__c = string.valueOf(Input.ObtainDecisionResponse) + string.valueOf(Input.AdditionalAttributes);
		l.quick_quote__c = q.id;
		l.caller__c = 'ICSResponse';
		l.status__c = 'OK';
		insert l;	
		
		return 'OK';
		
		
		}
		catch (exception e){
			ICS_Log__c l = new ICS_Log__c();
			l.xml__c = string.valueOf(Input.ObtainDecisionResponse) + string.valueOf(Input.AdditionalAttributes);
			l.caller__c = 'ICSResponse';
			l.status__c = 'Fatal Error :' + e;
			insert l;	
			return 'Fatal - ' + e;
		}
		 
        return 'OK';
		        
    }
    
    /*******************************************************************************************************************
	* 	HANDLE LIST OF SIMILARS  
	*
	********************************************************************************************************************/
	static String handleListOfSimilars(SearchDataResponse SearchDataResponse,
   												AdditionalAttributes AdditionalAttributes,
												Results Results) {
		system.debug('******************* LOS PROCESSING ***************************************');
		string messageId;
		string transactionId;
		genesis__Quick_Quotes__c q; 
		
		List<RecordType> rList = [select id
								  ,developername 
								  from RecordType 
								  where developerName = 'List_Of_Similars'
								  and sObjectType = 'ICS_Application__c'];
		
		Map<String,String> rMap = new Map<String,String>();
		for (RecordType r:rList)
			rMap.put(r.developername, r.id);
			
		try{
			if (AdditionalAttributes!= null){
				if (AdditionalAttributes.Attribute != null){
					for (Attribute a:AdditionalAttributes.Attribute){
						if (a.AttributeName == 'MESSAGE-ID')
							messageId = a.AttributeValue;
						else
						if (a.AttributeName == 'TRANSACTION-ID')
							transactionId = a.AttributeValue;	
					}		
				}
			}		
				
			ICS_Application__c a = [select id 
									,quick_quote__c
									from ICS_Application__c 
									where message_id__c = :messageId
									];
			
			a.transaction_id__c = transactionId; 
			a.status__c = 'List Of Similars';
			a.recordtypeid = rMap.get('List_Of_Similars');
			
			q = [	select id 
						,name
					from genesis__Quick_Quotes__c 
					where id = :a.quick_quote__c
					];
		 
			q.genesis__status__c = 'CREDIT REFERRED';
			
			List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
			
			Map<String,ID> gMap = new Map<String,ID>();
			for (Group g:gList)
				gMap.put(g.developername, g.id);
			
			system.debug('here');
			a.ownerid = gmap.get('Credit');
			if (SearchDataResponse.ExternalLegalEntities != null){
				
				for (ExternalLegalEntity ele:SearchDataResponse.ExternalLegalEntities.ExternalLegalEntity){
					ICS_External_Legal_Entity__c e = new ICS_External_Legal_Entity__c();
					e.ics_application_request__c = a.id;
					e.legal_name__c = ele.Organization.LegalName;
					system.debug('here');
					e.established_year__c =  ele.Organization.EstablishedYear;
					e.local_legal_form_code__c = ele.Organization.LocalLegalFormCode;
					e.industry_code_type__c = ele.Organization.LocalIndustryCode.IndustryCodeType;
					system.debug('here');
					e.industry_code_value__c = ele.Organization.LocalIndustryCode.IndustryCodeValue;
					e.address_line__c = ele.address.AddressLine;
					e.city__c = ele.address.City;
					e.state_province_code__c = ele.address.StateProvinceCode;
					system.debug('here');
					e.postal_code__c = ele.address.PostalCode;
					system.debug('here');
					e.country_code__c = ele.address.CountryCode;
					system.debug('here');
			
					if (ele.PhoneRecords != null ){
						if (ele.PhoneRecords.PhoneRecord != null){
							system.debug('here');
							for	 (PhoneRecord pr:ele.PhoneRecords.PhoneRecord){
								system.debug('here');
								e.phone__c = pr.PhoneNumber;
								e.phone_type__c = pr.PhoneType;
							}
						}
					}
				
					insert e;
					system.debug('here');
					List<ICS_External_Id__c> eList = new List<ICS_External_Id__c>();
					for (ExternalId ei:ele.ExternalIds.ExternalId){
							system.debug('here');
						ICS_External_Id__c ex = new ICS_External_Id__c();
						ex.ICS_External_Legal_Entity__c = e.id;
						ex.type__c = ei.ExternalIdType;
						ex.value__c = ei.ExternalIdValue;
						eList.add(ex);
					}
			system.debug('here');
					if(!eList.isEmpty())
						insert eList;
					
				}
			}
			
			for (Id_x i:SearchDataResponse.InternalLegalEntity.Ids.Id_x){
			if (i.IDType == 'LE_ID')
				a.legal_entity_id__c = i.IDValue;
			}
				
			a.legal_name__c = SearchDataResponse.InternalLegalEntity.LegalName;
			a.address_line__c = SearchDataResponse.InternalLegalEntity.Address.AddressLine;
			a.city__c = SearchDataResponse.InternalLegalEntity.Address.City;
			a.State_province_code__c = SearchDataResponse.InternalLegalEntity.Address.StateProvinceCode;
			a.postal_code__c = SearchDataResponse.InternalLegalEntity.Address.PostalCode;
			a.country_code__c = SearchDataResponse.InternalLegalEntity.Address.CountryCode;
			
			update a;
			update q;
			
			ICS_Log__c l = new ICS_Log__c();
			l.xml__c = string.valueOf(SearchDataResponse) + string.valueOf(AdditionalAttributes) +
												string.valueOf(Results);
			l.quick_quote__c = q.id;
			l.caller__c = 'ICSResponse';
			l.status__c = 'OK';
			insert l;	
			
		}
		catch (exception e){
			ICS_Log__c l = new ICS_Log__c();
			l.xml__c = string.valueOf(SearchDataResponse) + string.valueOf(AdditionalAttributes) +
												string.valueOf(Results);
			l.caller__c = 'ICSResponse';
			//l.quick_quote__c = q.id;
			l.status__c = 'Fatal Error :' + e;
			insert l;	
			return 'Error';	
		}
		
		return 'OK';
													
	}	
	/*******************************************************************************************************************
	* 	HANDLE MANUAL RESPONSE  
	*
	********************************************************************************************************************/
	static String handleManualResponse(ObtainManualDecisionResponse ObtainManualDecisionResponse
									 ,AdditionalAttributes AdditionalAttributes
									 ,Results Results) {
		
		system.debug('******************* MANUAL RESPONSE ***************************************');
		string transactionId;
		ICS_Application__c a;
		
		try{
			if (AdditionalAttributes!= null){
				if (AdditionalAttributes.Attribute != null){
					for (Attribute att:AdditionalAttributes.Attribute){
						if (att.AttributeName == 'TRANSACTION-ID')
							transactionId = att.AttributeValue;	
					}		
				}
			}
						
			a = [select id 
				,quick_quote__c
				 from ICS_Application__c 
				 where transaction_id__c = :transactionId
				];
			
			List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
			
			Map<String,ID> gMap = new Map<String,ID>();
			for (Group g:gList)
				gMap.put(g.developername, g.id);
			
			a.ownerid = gmap.get('Past_Credit');
			
			if (Results.ReturnStatus == 'S'){
				//a.status__c = 'Manual Decision Registered';
				ICS_Log__c l = new ICS_Log__c();
				l.xml__c = string.valueOf(ObtainManualDecisionResponse) + string.valueOf(Results);
				l.quick_quote__c = a.quick_quote__c;
				l.caller__c = 'ObtainManualDecisionResponse';
				l.status__c = 'OK';
				insert l;	
			}
			else{
				a.status__c = 'Manual Decision Error';
				ICS_Log__c l = new ICS_Log__c();
				l.xml__c = string.valueOf(ObtainManualDecisionResponse) + string.valueOf(Results);
				l.quick_quote__c = a.quick_quote__c;
				l.caller__c = 'ObtainManualDecisionResponse';
				l.status__c = Results.ReturnStatus;
				insert l;	
				
			}
			update a;
						
		}
		catch (exception e){
			a.status__c = 'Manual Decision Error';
			ICS_Log__c l = new ICS_Log__c();
			l.xml__c = string.valueOf(ObtainManualDecisionResponse) + string.valueOf(Results);
			l.caller__c = 'ObtainManualDecisionResponse';
			l.quick_quote__c = a.quick_quote__c;
			l.status__c = 'Fatal Error :' + e;
			insert l;	
			update a;
			return 'Error';	
		}
		
		return 'OK';
													
	}	
	/*******************************************************************************************************************
	* 	HANDLE MANUAL RESPONSE  
	*
	********************************************************************************************************************/
	static String handleResponse(AdditionalAttributes AdditionalAttributes
							 ,Results Results) {
		
		system.debug('******************* MANUAL RESPONSE ***************************************');
		string transactionId;
		ICS_Application__c a;
		genesis__Quick_Quotes__c q;
		
		/* record types */
		List<RecordType> rList = [select id
								  ,developername 
								  from RecordType 
								  where developerName in ('List_Of_Similars', 'Decision')
								  and sObjectType = 'ICS_Application__c'];
		
		Map<String,String> rMap = new Map<String,String>();
		for (RecordType r:rList)
			rMap.put(r.developername, r.id);
			
		try{
			if (AdditionalAttributes!= null){
				if (AdditionalAttributes.Attribute != null){
					for (Attribute att:AdditionalAttributes.Attribute){
						if (att.AttributeName == 'TRANSACTION-ID')
							transactionId = att.AttributeValue;	
					}		
				}
			}
						
			a = [select id 
				,quick_quote__c
				,message_id__c
				 from ICS_Application__c 
				 where transaction_id__c = :transactionId
				];
			
			q = [	select id 
						,name
					from genesis__Quick_Quotes__c 
					where id = :a.quick_quote__c
					];
					
			List<Group> gList = [Select Id
								,developername
								 From
								 Group g 
								 where type = 'QUEUE' and developerName in ('Credit','Past_Credit','Waiting_for_Credit')
								 ];
			
			Map<String,ID> gMap = new Map<String,ID>();
			for (Group g:gList)
				gMap.put(g.developername, g.id);
			
			a.ownerid = gmap.get('Past_Credit');
			
			if (Results.ReturnStatus == 'S'){
				a.status__c = 'ICS Success';
				ICS_Log__c l = new ICS_Log__c();
				l.xml__c = string.valueOf(AdditionalAttributes) + string.valueOf(Results);
				l.quick_quote__c = a.quick_quote__c;
				l.caller__c = 'ICSResponse'  + '-' + Results.ReturnStatus;
				l.status__c = 'OK';
				insert l;	
			}
			else{ //Status == 'E'
				a.ownerid = gmap.get('Credit');
				a.status__c = 'ICS Failure';
				a.E_Status_Error_Message__c = Results.Result.MsgData;
				a.recordtypeid = rMap.get('Decision');
				ICS_Log__c l = new ICS_Log__c();
			
				l.xml__c = string.valueOf(AdditionalAttributes) + string.valueOf(Results);
				l.quick_quote__c = a.quick_quote__c;
				l.caller__c = 'ICSResponse' + '-' + Results.ReturnStatus;
				l.status__c = Results.ReturnStatus;
				l.xml_result__c = string.valueOf(Results);
				q.genesis__status__c = 'CREDIT REFERRED';
				q.ATS_Reference_Number__c = a.message_id__c;
				q.Credit_Approval_Date__c = null;
				q.Approved_Credit_Amount__c = null;
				q.ATS_Reference_Number__c = a.message_id__c;	
				q.Credit_Approval_Expiration_Date__c =  null;							   
				update q;
				insert l;	
			}
			update a;
						
		}
		catch (exception e){
			
			a.status__c = 'ICS Failure';
			ICS_Log__c l = new ICS_Log__c();
			
			String part1;
			if (additionalAttributes != null)
				part1 = string.valueOf(AdditionalAttributes);
			else
				part1 = '';
				
			String part2;
			if (Results != null)
				part2 = string.valueOf(results);
			else
				part2 = '';
						
			l.xml__c = part1 + part2;
			l.caller__c = 'ICSResponse';
			l.quick_quote__c = a.quick_quote__c;
			l.status__c = 'Fatal Error :' + e;
			q.genesis__status__c = 'CREDIT REFERRED';
			q.Credit_Approval_Date__c = null;
			q.Approved_Credit_Amount__c = null;
			q.ATS_Reference_Number__c = a.message_id__c;	
			q.Credit_Approval_Expiration_Date__c =  null;	
			update q;
			insert l;	
			update a;
			return 'Error';	
		}
		
		return 'OK';
													
	}	
    /*******************************************************************************************************************
	* 	INSERT REASONS  
	* 	This adds the reasons to the database
	*
	********************************************************************************************************************/
	static void insertReasons(ID aId,ObtainDecisionResponse ObtainDecisionResponse) {
    	
    	List<ICS_Decision_Reason__c> rList = new List<ICS_Decision_Reason__c>(); 	
		
		for (DecisionReason dr:ObtainDecisionResponse.application.systemdecision.decisionReasons.decisionReason){
			ICS_Decision_Reason__c rr = new ICS_Decision_Reason__c();
			rr.ICS_Application_Request__c = aId;
			rr.Reason_code__c = dr.reasoncode;
			rr.Reason_Description__c = dr.reasondesc;
			rList.add(rr);
		}
		if (!rList.isEmpty())
			insert rList;
    
    }
}
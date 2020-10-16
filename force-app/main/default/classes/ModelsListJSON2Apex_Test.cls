@IsTest
public class ModelsListJSON2Apex_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"meta\": {'+
		'    \"page\": 1,'+
		'    \"size\": 20,'+
		'    \"sort\": \"name:a\",'+
		'    \"itemCount\": 2162'+
		'  },'+
		'  \"data\": ['+
		'    {'+
		'      \"id\": 4030,'+
		'      \"code\": 31002218,'+
		'      \"name\": \"2015\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": false,'+
		'      \"referencePrice\": 0,'+
		'      \"brandCode\": 30001950,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000675,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3122,'+
		'      \"code\": 31001310,'+
		'      \"name\": \"7130cdn Color Printer\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 1999.989990234375,'+
		'      \"brandCode\": 30000302,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000671,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3564,'+
		'      \"code\": 31001752,'+
		'      \"name\": \"7170 Multifunction System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 19995,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 4544,'+
		'      \"code\": 31002732,'+
		'      \"name\": \"7570 Print System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 24250,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3565,'+
		'      \"code\": 31001753,'+
		'      \"name\": \"7580 Multifunction System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 26000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3566,'+
		'      \"code\": 31001754,'+
		'      \"name\": \"7590 MFP Production System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 35000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3567,'+
		'      \"code\": 31001755,'+
		'      \"name\": \"770 Multifunction System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 13995,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 4545,'+
		'      \"code\": 31002733,'+
		'      \"name\": \"7970 Print System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 31000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3568,'+
		'      \"code\": 31001756,'+
		'      \"name\": \"7980 Multifunction System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 32000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3569,'+
		'      \"code\": 31001757,'+
		'      \"name\": \"7990 MFP Production System\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 41000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3570,'+
		'      \"code\": 31001758,'+
		'      \"name\": \"850\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 28000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3571,'+
		'      \"code\": 31001759,'+
		'      \"name\": \"860\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 31000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3572,'+
		'      \"code\": 31001760,'+
		'      \"name\": \"870\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 31000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3573,'+
		'      \"code\": 31001761,'+
		'      \"name\": \"880\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 36000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3574,'+
		'      \"code\": 31001762,'+
		'      \"name\": \"890\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 42000,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3575,'+
		'      \"code\": 31001763,'+
		'      \"name\": \"970\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 43900,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3576,'+
		'      \"code\": 31001764,'+
		'      \"name\": \"980\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 46900,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 3577,'+
		'      \"code\": 31001765,'+
		'      \"name\": \"990\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 54900,'+
		'      \"brandCode\": 30000716,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000686,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 11932,'+
		'      \"code\": 31000657,'+
		'      \"name\": \"A610dn\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 550.7999877929688,'+
		'      \"brandCode\": 30001860,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000670,'+
		'      \"programCode\": 53'+
		'    },'+
		'    {'+
		'      \"id\": 11933,'+
		'      \"code\": 31000658,'+
		'      \"name\": \"A611dn\",'+
		'      \"isActive\": true,'+
		'      \"titling\": false,'+
		'      \"serialized\": true,'+
		'      \"referencePrice\": 550.7999877929688,'+
		'      \"brandCode\": 30001860,'+
		'      \"masterAssetTypeCode\": 107,'+
		'      \"assetTypeCode\": 40000670,'+
		'      \"programCode\": 53'+
		'    }'+
		'  ],'+
		'  \"links\": {'+
		'    \"self\": \"http://assetsdev4.waynemo.dll.corp:9400/api/v1/programs/53/models?sort=name%3Aa&size=20&page=1\"'+
		'  }'+
		'}';
		ModelsListJSON2Apex r = ModelsListJSON2Apex.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ModelsListJSON2Apex.Meta objMeta = new ModelsListJSON2Apex.Meta(System.JSON.createParser(json));
		System.assert(objMeta != null);
		System.assert(objMeta.page == null);
		System.assert(objMeta.size == null);
		System.assert(objMeta.sort_Z == null);
		System.assert(objMeta.itemCount == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ModelsListJSON2Apex objModelsListJSON2Apex = new ModelsListJSON2Apex(System.JSON.createParser(json));
		System.assert(objModelsListJSON2Apex != null);
		System.assert(objModelsListJSON2Apex.meta == null);
		System.assert(objModelsListJSON2Apex.data == null);
		System.assert(objModelsListJSON2Apex.links == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ModelsListJSON2Apex.Links objLinks = new ModelsListJSON2Apex.Links(System.JSON.createParser(json));
		System.assert(objLinks != null);
		System.assert(objLinks.self == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ModelsListJSON2Apex.Data objData = new ModelsListJSON2Apex.Data(System.JSON.createParser(json));
		System.assert(objData != null);
		System.assert(objData.id == null);
		System.assert(objData.code == null);
		System.assert(objData.name == null);
		System.assert(objData.isActive == null);
		System.assert(objData.titling == null);
		System.assert(objData.serialized == null);
		System.assert(objData.referencePrice == null);
		System.assert(objData.brandCode == null);
		System.assert(objData.masterAssetTypeCode == null);
		System.assert(objData.assetTypeCode == null);
		System.assert(objData.programCode == null);
	}
}
//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class ModelsDetailsJSON2Apex {

	public class Meta {
		public Integer itemCount;
	}

	public class Program {
		public Integer code;
		public String name;
	}

	public Meta meta;
	public Data data;
	public Links links;

	public class Links {
		public String self;
	}

	public class Data {
		public Integer code;
		public String name;
		//public Integer referencePrice; //ModifiedDate 2010-11-10 By. Tesh
		public Decimal referencePrice;
		public Boolean isActive;
		public Boolean isTitled;
		public Boolean isSerialized;
		public Program program;
		public Program masterAssetType;
		public Program objectCategory;
		public Program assetType;
		public Program brand;
	}

	
	public static ModelsDetailsJSON2Apex parse(String json) {
		return (ModelsDetailsJSON2Apex) System.JSON.deserialize(json, ModelsDetailsJSON2Apex.class);
	}
}
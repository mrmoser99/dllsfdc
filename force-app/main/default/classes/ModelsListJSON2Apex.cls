public class ModelsListJSON2Apex {

	public class Meta {
		public Integer page {get;set;} 
		public Integer size {get;set;} 
		public String sort_Z {get;set;} // in json: sort
		public Integer itemCount {get;set;} 

		public Meta(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'page') {
							page = parser.getIntegerValue();
						} else if (text == 'size') {
							size = parser.getIntegerValue();
						} else if (text == 'sort') {
							sort_Z = parser.getText();
						} else if (text == 'itemCount') {
							itemCount = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Meta consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Meta meta {get;set;} 
	public List<Data> data {get;set;} 
	public Links links {get;set;} 

	public ModelsListJSON2Apex(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'meta') {
						meta = new Meta(parser);
					} else if (text == 'data') {
						data = arrayOfData(parser);
					} else if (text == 'links') {
						links = new Links(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ModelsListJSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Links {
		public String self {get;set;} 

		public Links(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'self') {
							self = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Links consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public Integer id {get;set;} 
		public Integer code {get;set;} 
		public String name {get;set;} 
		public Boolean isActive {get;set;} 
		public Boolean titling {get;set;} 
		public Boolean serialized {get;set;} 
		public Integer referencePrice {get;set;} 
		public Integer brandCode {get;set;} 
		public Integer masterAssetTypeCode {get;set;} 
		public Integer assetTypeCode {get;set;} 
		public Integer programCode {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'code') {
							code = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'isActive') {
							isActive = parser.getBooleanValue();
						} else if (text == 'titling') {
							titling = parser.getBooleanValue();
						} else if (text == 'serialized') {
							serialized = parser.getBooleanValue();
						} else if (text == 'referencePrice') {
							referencePrice = parser.getIntegerValue();
						} else if (text == 'brandCode') {
							brandCode = parser.getIntegerValue();
						} else if (text == 'masterAssetTypeCode') {
							masterAssetTypeCode = parser.getIntegerValue();
						} else if (text == 'assetTypeCode') {
							assetTypeCode = parser.getIntegerValue();
						} else if (text == 'programCode') {
							programCode = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ModelsListJSON2Apex parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ModelsListJSON2Apex(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	



    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }

}
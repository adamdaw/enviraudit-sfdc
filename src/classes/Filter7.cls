public class Filter7 {
	
	public List<String> classification_type;
	public List<String> heating {get; set;}
	public List<String> lighting {get; set;}
	
	public Filter7(Building__c building) {

		this.classification_type = new List<String>{building.classification__c};
		this.heating = new List<String>{building.heating__c};
		this.lighting = new List<String>{building.lighting__c};
		
	}
}
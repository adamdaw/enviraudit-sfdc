public class Filter5 {
	
	public List<String> classification_type;
	public List<String> lighting {get; set;}
	
	public Filter5(Building__c building) {

		this.classification_type = new List<String>{building.classification__c};
		this.lighting = new List<String>{building.lighting__c};
		
	}
}
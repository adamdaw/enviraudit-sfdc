public class Filter6 {
	
	public List<String> classification_type;
	public List<String> heating {get; set;}
	
	public Filter6(Building__c building) {

		this.classification_type = new List<String>{building.classification__c};
		this.heating = new List<String>{building.heating__c};
		
	}
}
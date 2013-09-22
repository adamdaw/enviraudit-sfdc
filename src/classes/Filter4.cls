public class Filter4 {
	
	public List<String> classification_type;
	public List<String> facility_type;

	public Filter4(Building__c building) {
		this.classification_type = new List<String>{building.classification__c};
		this.facility_type = (building.facility_type__c != null) ? ((building.facility_subtype__c != null) ? new List<String>{building.facility_type__c + ' - '+building.facility_subtype__c} : new List<String>{building.facility_type__c}) : null;
	}
}
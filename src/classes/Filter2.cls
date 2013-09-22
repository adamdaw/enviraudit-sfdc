public class Filter2 {
	
	public List<String> classification_type;
	public FilterRange floor_area;
	public List<String> facility_type;

	public Filter2(Building__c building) {
		this.classification_type = new List<String>{building.classification__c};
		this.floor_area = new FilterRange(building.Floor_Area_Square_Meters__c.intValue(), (building.Floor_Area_Square_Meters__c*.2).intValue());
		this.facility_type = (building.facility_type__c != null) ? ((building.facility_subtype__c != null) ? new List<String>{building.facility_type__c + ' - '+building.facility_subtype__c} : new List<String>{building.facility_type__c}) : null;
	}

}
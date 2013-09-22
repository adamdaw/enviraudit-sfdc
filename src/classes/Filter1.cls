public class Filter1 {
	public List<String> classification_type;
	public FilterRange floor_area;

	public Filter1(Building__c building) {
		this.classification_type = new List<String>{building.classification__c};
		this.floor_area = new FilterRange(building.Floor_Area_Square_Meters__c.intValue(), (building.Floor_Area_Square_Meters__c*.2).intValue());
	}

}
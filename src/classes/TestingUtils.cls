public class TestingUtils {
	
	public static Building__c testBuilding(){
		return new Building__c(Classification__c = 'Commercial', Floor_Area_Square_Meters__c = 24000, Facility_Type__c = 'Agriculture');
	}


}
public with sharing class CompareController {
	
	public List<Building__c> myBuildings {get; set;}
	public Building__c myBuilding {get; set;}
	public String build_system {get; set;}
	public String from_system {get; set;}
	public String to_system {get; set;}

	public CompareController() {
		myBuildings = [Select Id, Building_Name__c, Image__c from Building__c];
		myBuilding = (ApexPages.currentPage().getParameters().get('id') != null) ? [Select Average_Building_Cost__c, My_EUI__c, My_Usage__c, City__c, Country__c, Image__c, Classification__c, Floor_Area_Square_Meters__c, Facility_Type__c, Facility_Subtype__c, Climate_Zone__c, Cooling__c, Heating__c, Lighting__c, Building_name__c, Building_address__c, State__c, Zip_code__c, (Select Id, Filter_Type__c, EUI__c, Peer_Group__c from EUI_Analyses__r ORDER BY Filter_Number__c ASC) from Building__c where Id = :ApexPages.currentPage().getParameters().get('id')] : new Building__c();

	}

	@RemoteAction
	public static List<String> getOptions(String build_system){
		List<String> options = new List<String>();
		if(build_system == 'heating'){
			for(Schema.PicklistEntry a : Building__c.getSObjectType().getDescribe().fields.getMap().get('Heating__c').getDescribe().getPicklistValues()){
				options.add(a.getValue());
			}

		} else if (build_system == 'cooling'){
			for(Schema.PicklistEntry a : Building__c.getSObjectType().getDescribe().fields.getMap().get('Cooling__c').getDescribe().getPicklistValues()){
				options.add(a.getValue());
			}

		} else if (build_system == 'lighting'){
			for(Schema.PicklistEntry a : Building__c.getSObjectType().getDescribe().fields.getMap().get('Lighting__c').getDescribe().getPicklistValues()){
				options.add(a.getValue());
			}

		} else if (build_system == 'air_flow_control'){
			for(Schema.PicklistEntry a : Building__c.getSObjectType().getDescribe().fields.getMap().get('Air_Flow_Control__c').getDescribe().getPicklistValues()){
				options.add(a.getValue());
			}

		} else if (build_system == 'window_glass_layers'){
			for(Schema.PicklistEntry a : Building__c.getSObjectType().getDescribe().fields.getMap().get('Window_Glass_Layer__c').getDescribe().getPicklistValues()){
				options.add(a.getValue());
			}

		} else if (build_system == 'window_glass_type'){
			for(Schema.PicklistEntry a : Building__c.getSObjectType().getDescribe().fields.getMap().get('Window_Glass_Type__c').getDescribe().getPicklistValues()){
				options.add(a.getValue());
			}

		}
		return options;
	}

	@RemoteAction
	public static List<FilterComparison> getComparisons(String buildId, String buildval, String fromval, String toval){
		List<FilterComparison> comparisons = new List<FilterComparison>();
		Building__c building = [Select Average_Building_Cost__c, My_EUI__c, My_Usage__c, City__c, Country__c, Image__c, Classification__c, Floor_Area_Square_Meters__c, Facility_Type__c, Facility_Subtype__c, Climate_Zone__c, Cooling__c, Heating__c, Lighting__c, Building_name__c, Building_address__c, State__c, Zip_code__c, (Select Id, Filter_Type__c, EUI__c, Filter_Number__c, Peer_Group__c from EUI_Analyses__r ORDER BY Filter_Number__c ASC) from Building__c where Id = :buildId];
		for(EUI_Analysis__c ea : building.EUI_Analyses__r){
			if(ea.Filter_Number__c == 5 && buildval == 'heating'){
				String buildingString = JSON.serializePretty(new Filter5(new Building__c(Classification__c = building.Classification__c, Heating__c = building.Heating__c)));
				HttpRequest compRequest = BPDUtils.comparisonRequest(buildingString, buildval, fromval, toval);
				Http http = new Http();
				HttpResponse res = http.send(compRequest);
				system.debug(res.getBody());
				ComparisonResponse thisResponse = (ComparisonResponse)JSON.deserialize(res.getBody(), ComparisonResponse.class);
				comparisons.add(new FilterComparison(building, thisResponse));
			} else if (ea.Filter_Number__c == 6 && buildval == 'lighting'){
				String buildingString = JSON.serializePretty(new Filter6(new Building__c(Classification__c = building.Classification__c, Lighting__c = building.Lighting__c)));
				HttpRequest compRequest = BPDUtils.comparisonRequest(buildingString, buildval, fromval, toval);
				Http http = new Http();
				HttpResponse res = http.send(compRequest);
				system.debug(res.getBody());
				ComparisonResponse thisResponse = (ComparisonResponse)JSON.deserialize(res.getBody(), ComparisonResponse.class);
				comparisons.add(new FilterComparison(building, thisResponse));
			}
		}
		return comparisons;
	} 

}
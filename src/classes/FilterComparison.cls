public with sharing class FilterComparison {
	public Decimal previousEUI {get; set;}
	public Decimal changeVal {get; set;}
	public Decimal newEUI {get; set;}
	public Decimal previousCost {get; set;}
	public Decimal newCost {get; set;}

	public FilterComparison(Building__c building, ComparisonResponse response){
		this.previousEUI = building.My_EUI__c;
		this.changeVal = response.histogram.change_ratio;
		this.newEUI = building.My_EUI__c * response.histogram.change_ratio;
		this.previousCost = building.Average_Building_Cost__c;
		this.newCost = building.Average_Building_Cost__c * (this.previousEUI/this.newEUI);
	}
}
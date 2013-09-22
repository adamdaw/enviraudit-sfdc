trigger BuildingAfter on Building__c (after insert, after update) {

	for(Building__c building : trigger.new){
		BPDUtils.getPeerData(building.Id);
	}

}
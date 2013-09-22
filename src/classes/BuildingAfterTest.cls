@isTest
public class BuildingAfterTest {
	
	@isTest
	public static void testBuildingAfter(){
		Building__c building = TestingUtils.testBuilding();
		Test.startTest();
		insert building;
		Test.stopTest();
	}


}
@isTest
public class TestingUtilsTest {
	
	@isTest
	public static void testTestBuilding(){
		System.assert(TestingUtils.testBuilding().Classification__c == 'Commercial');
	}



}
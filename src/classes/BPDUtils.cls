public class BPDUtils {
	
	public static AnalyzeResponse peerAnalysisResponse(HttpRequest req){
		Http http = new Http();
		System.debug(req.getBody());
		HttpResponse res = http.send(req);
		System.debug(res.getBody());
		AnalyzeResponse peerResponse = (AnalyzeResponse)JSON.deserialize(res.getBody(), AnalyzeResponse.class);
		return peerResponse;
	}

	public static HttpRequest peerAnalysisRequest(String buildingString){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://bpd.lbl.gov/api/v1/analyze/peers/?format=json');
		req.setMethod('POST');
		BPDCreds__c creds = BPDCreds__c.getInstance(); 
		req.setHeader('Content-type', 'application/json');
		req.setHeader('Authorization', 'ApiKey '+creds.username__c+':'+creds.api_key__c);
		req.setBody('{\"filters\": '+buildingString+'}');
		return req;
	}

	public static HttpRequest comparisonRequest(String filterString, String buildingSystem, String fromString, String toString){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://bpd.lbl.gov/api/v1/analyze/compare/eui/?format=json');
		req.setMethod('POST');
		BPDCreds__c creds = BPDCreds__c.getInstance(); 
		req.setHeader('Content-type', 'application/json');
		req.setHeader('Authorization', 'ApiKey '+creds.username__c+':'+creds.api_key__c);
		req.setBody('{\"filters\": '+filterString+', \"building_system\": \"'+buildingSystem+'\", \"from\": \"'+fromString+'\", \"to\": \"'+toString+'\"}');
		return req;
	}

	@future(callout = true)
	public static void getPeerData(String buildingId){
		Building__c building = [Select Classification__c, Floor_Area_Square_Meters__c, Facility_Type__c, Facility_Subtype__c, Climate_Zone__c, Heating__c, Lighting__c from Building__c where Id = :buildingId];
		List<EUI_Analysis__c> analyses = new List<EUI_Analysis__c>();
		String timestamp = String.valueOf(Datetime.now());
		for(Integer i = 1; i < 10; i++){
			String buildingString = '';
			if(i == 1){
				buildingString = JSON.serializePretty(new Filter1(new Building__c(Classification__c = building.Classification__c, Floor_Area_Square_Meters__c = building.Floor_Area_Square_Meters__c)));
				HttpRequest peerReq = BPDUtils.peerAnalysisRequest(buildingString);
				AnalyzeResponse analysisResponse = BPDUtils.peerAnalysisResponse(peerReq);
				if(analysisResponse.totals.number_of_matching_buildings != 0){
					analyses.add(new EUI_Analysis__c(Building__c = buildingId, Filter_Type__c = 'Classification and Area - '+timestamp, EUI_Value__c = analysisResponse.eui_distribution.mean, Peer_Group__c = analysisResponse.totals.number_of_matching_buildings, Filter_Number__c = i, External_Id__c = buildingId+'-'+i));		
				}
			} else if (i == 2 && building.Facility_Type__c != null){
				buildingString = JSON.serializePretty(new Filter2(new Building__c(Classification__c = building.Classification__c, Floor_Area_Square_Meters__c = building.Floor_Area_Square_Meters__c, Facility_Type__c = building.Facility_Type__c, Facility_Subtype__c = building.Facility_Subtype__c)));
				HttpRequest peerReq = BPDUtils.peerAnalysisRequest(buildingString);
				AnalyzeResponse analysisResponse = BPDUtils.peerAnalysisResponse(peerReq);
				if(analysisResponse.totals.number_of_matching_buildings != 0){
					analyses.add(new EUI_Analysis__c(Building__c = buildingId, Filter_Type__c = 'Classification, Area and Facility Type - '+timestamp, EUI_Value__c = analysisResponse.eui_distribution.mean, Peer_Group__c = analysisResponse.totals.number_of_matching_buildings, Filter_Number__c = i, External_Id__c = buildingId+'-'+i));		
				}
			} else if (i == 3 && building.Climate_Zone__c != null && building.Facility_Type__c != null){
				buildingString = JSON.serializePretty(new Filter3(new Building__c(Classification__c = building.Classification__c, Floor_Area_Square_Meters__c = building.Floor_Area_Square_Meters__c, Facility_Type__c = building.Facility_Type__c, Facility_Subtype__c = building.Facility_Subtype__c, Climate_Zone__c = building.Climate_Zone__c)));
				HttpRequest peerReq = BPDUtils.peerAnalysisRequest(buildingString);
				AnalyzeResponse analysisResponse = BPDUtils.peerAnalysisResponse(peerReq);
				if(analysisResponse.totals.number_of_matching_buildings != 0){
					analyses.add(new EUI_Analysis__c(Building__c = buildingId, Filter_Type__c = 'Classification, Area, Facility Type and Climate Zone - '+timestamp, EUI_Value__c = analysisResponse.eui_distribution.mean, Peer_Group__c = analysisResponse.totals.number_of_matching_buildings, Filter_Number__c = i, External_Id__c = buildingId+'-'+i));		
				}
			} else if (i == 4 && building.Climate_Zone__c != null){
				buildingString = JSON.serializePretty(new Filter4(new Building__c(Classification__c = building.Classification__c, Facility_Type__c = building.Facility_Type__c, Facility_Subtype__c = building.Facility_Subtype__c)));
				HttpRequest peerReq = BPDUtils.peerAnalysisRequest(buildingString);
				AnalyzeResponse analysisResponse = BPDUtils.peerAnalysisResponse(peerReq);
				if(analysisResponse.totals.number_of_matching_buildings != 0){
					analyses.add(new EUI_Analysis__c(Building__c = buildingId, Filter_Type__c = 'Classification and Facility Type - '+timestamp, EUI_Value__c = analysisResponse.eui_distribution.mean, Peer_Group__c = analysisResponse.totals.number_of_matching_buildings, Filter_Number__c = i, External_Id__c = buildingId+'-'+i));		
				}
			} else if (i == 5 && building.Heating__c != null){
				buildingString = JSON.serializePretty(new Filter5(new Building__c(Classification__c = building.Classification__c, Heating__c = building.Heating__c)));
				HttpRequest peerReq = BPDUtils.peerAnalysisRequest(buildingString);
				AnalyzeResponse analysisResponse = BPDUtils.peerAnalysisResponse(peerReq);
				if(analysisResponse.totals.number_of_matching_buildings != 0){
					analyses.add(new EUI_Analysis__c(Building__c = buildingId, Filter_Type__c = 'Classification  and Heating - '+timestamp, EUI_Value__c = analysisResponse.eui_distribution.mean, Peer_Group__c = analysisResponse.totals.number_of_matching_buildings, Filter_Number__c = i, External_Id__c = buildingId+'-'+i));		
				}
			} else if (i == 6 && building.Heating__c != null){
				buildingString = JSON.serializePretty(new Filter6(new Building__c(Classification__c = building.Classification__c, Lighting__c = building.Lighting__c)));
				HttpRequest peerReq = BPDUtils.peerAnalysisRequest(buildingString);
				AnalyzeResponse analysisResponse = BPDUtils.peerAnalysisResponse(peerReq);
				if(analysisResponse.totals.number_of_matching_buildings != 0){
					analyses.add(new EUI_Analysis__c(Building__c = buildingId, Filter_Type__c = 'Classification  and Lighting - '+timestamp, EUI_Value__c = analysisResponse.eui_distribution.mean, Peer_Group__c = analysisResponse.totals.number_of_matching_buildings, Filter_Number__c = i, External_Id__c = buildingId+'-'+i));		
				}
			} else if (i == 7 && building.Heating__c != null){
				buildingString = JSON.serializePretty(new Filter7(new Building__c(Classification__c = building.Classification__c, Heating__c = building.Heating__c, Lighting__c = building.Lighting__c)));
				HttpRequest peerReq = BPDUtils.peerAnalysisRequest(buildingString);
				AnalyzeResponse analysisResponse = BPDUtils.peerAnalysisResponse(peerReq);
				if(analysisResponse.totals.number_of_matching_buildings != 0){
					analyses.add(new EUI_Analysis__c(Building__c = buildingId, Filter_Type__c = 'Classification, Heating and Lighting - '+timestamp, EUI_Value__c = analysisResponse.eui_distribution.mean, Peer_Group__c = analysisResponse.totals.number_of_matching_buildings, Filter_Number__c = i, External_Id__c = buildingId+'-'+i));		
				}
			}

		}
		
		upsert analyses External_Id__c;
	}

	public static String getBuildingString(Building__c building){
		return JSON.serializePretty(new Filter(building));
	}

}
public class PanoptixUtils {
	
	public static void collectEnergyData(Equipment__c equipment){
		
		
		String accessToken = PanoptixUtils.getAccessToken();
		EnergyTrendProperty currProps = PanoptixUtils.getLatestProperties(equipment, accessToken);
		equipment.All_Time_Max__c = currProps.MaxValue;
		equipment.All_Time_Min__c = currProps.MinValue;
		Energy_Usage__c eu = PanoptixUtils.getUsageData(equipment, accessToken);
		equipment.Most_Recent_Average__c = eu.Avg__c;
		update equipment;
		insert eu;

	}

	public static Energy_Usage__c getUsageData(Equipment__c equipment, String accessToken){
		Energy_Usage__c eu = new Energy_Usage__c();
		eu.Equipment__c = equipment.Id;
		eu.Start__c = Datetime.now().addDays(-90);
		eu.End__c = Datetime.now();
		List<EnergyTrend> trends = PanoptixUtils.getLatestTrends(eu, equipment, accessToken);
		eu.Count__c = trends.size();
		Decimal totalVal = 0;
		Decimal maxVal = 0;
		Decimal minVal = 0;
		for(EnergyTrend trend : trends){
			totalVal += trend.Val;
			if(trend.Val > maxVal){
				maxVal = trend.Val;
			}
			if(trend.Val < minVal){
				minVal = trend.Val;
			}
		}
		eu.Avg__c = (totalVal / eu.Count__c);
		eu.Max__c = maxVal;
		eu.Min__c = minVal;
		return eu;
	}

	public static String getAccessToken(){
		PanoptixCreds__c creds = PanoptixCreds__c.getInstance(); 
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://mypanoptix.johnsoncontrols.com/identity/issue/oauth2/token?grant_type=password&username='+creds.username__c+'&password='+creds.password__c);
		req.setMethod('POST');
		Blob authValue = Blob.valueOf(creds.clientId__c+':'+creds.clientSecret__c);
		req.setHeader('Authorization', 'BASIC '+EncodingUtil.base64Encode(authValue));
		Http http = new Http();
		HttpResponse res = http.send(req);
		PanoptixAuthResponse pRes = (PanoptixAuthResponse)Json.deserialize(res.getBody(), PanoptixAuthResponse.class);
		return pRes.access_token;
	}

	public static EnergyTrendProperty getLatestProperties(Equipment__c equipment, String accessToken){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.mypanoptix.johnsoncontrols.com/v1/Energy/TrendProperties?pointurl='+equipment.PointURL__c);
		req.setMethod('GET');
		req.setHeader('Authorization', 'Bearer '+accessToken);
		Http http = new Http();
		HttpResponse res = http.send(req);
		EnergyTrendProperty props = (EnergyTrendProperty)Json.deserialize(res.getBody(), EnergyTrendProperty.class);
		return props;
	}

	public static List<EnergyTrend> getLatestTrends(Energy_Usage__c eu, Equipment__c equipment, String accessToken){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.mypanoptix.johnsoncontrols.com/v1/Energy/Trends?meterUrl='+equipment.MeterURL__c+'&pointUrl='+equipment.PointURL__c+'&startDate='+JSON.serialize(eu.Start__c)+'&endDate='+JSON.serialize(eu.End__c));
		req.setMethod('GET');
		req.setHeader('Authorization', 'Bearer '+accessToken);
		Http http = new Http();
		HttpResponse res = http.send(req);
		List<EnergyTrend> props = (List<EnergyTrend>)Json.deserialize(res.getBody(), EnergyTrendProperty.class);
		return props;
	}

}
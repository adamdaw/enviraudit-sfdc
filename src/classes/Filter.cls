public class Filter {
	
	public List<String> classification_type;
	public FilterRange floor_area;
	public List<String> facility_type;
	public List<String> climate_zone;
	public FilterRange year_built;
	public FilterRange hours_occupied;
	public FilterRange number_of_people;
	public List<String> state {get; set;}
	public List<String> zip_code {get; set;}
	public List<String> lighting {get; set;}
	public List<String> heating {get; set;}
	public List<String> cooling {get; set;}
	public List<String> window_glass_type {get; set;}
	public List<String> window_glass_layers {get; set;}
	public List<String> air_flow_control {get; set;}
	public FilterRange wall_insulation_r_value {get; set;}
	public List<String> roof_ceiling {get; set;}

	public Filter(Building__c building) {

		this.classification_type = new List<String>{building.classification__c};
		this.floor_area = new FilterRange(building.Floor_Area_Square_Meters__c.intValue(), (building.Floor_Area_Square_Meters__c*.2).intValue());
		this.facility_type = (building.facility_type__c != null) ? ((building.facility_subtype__c != null) ? new List<String>{building.facility_type__c + ' - '+building.facility_subtype__c} : new List<String>{building.facility_type__c}) : null;
		this.climate_zone = (building.climate_zone__c != null) ? new List<String>{building.climate_zone__c} : null;

		this.year_built = (building.year_built__c != null) ? new FilterRange(building.year_built__c.intValue(), 2) : null;
		this.hours_occupied = (building.hour__c != null) ? new FilterRange(building.hour__c.intValue(), 3) : null;
		this.number_of_people = (building.number_of_people__c != null) ? new FilterRange(building.number_of_people__c.intValue(), (building.Floor_Area_Square_Meters__c / 150).intValue()) : null;
		
		this.state = new List<String>{building.state__c};
		this.zip_code = new List<String>{String.valueOf(building.zip_code__c)};
		this.lighting = new List<String>{building.lighting__c};
		this.heating = new List<String>{building.heating__c};
		this.cooling = new List<String>{building.cooling__c};
		this.window_glass_type = new List<String>{building.window_glass_type__c};
		this.window_glass_layers = new List<String>{building.window_glass_layer__c};
		this.air_flow_control = new List<String>{building.air_flow_control__c};
		this.wall_insulation_r_value = (building.wall_insulation_r_value__c != null) ? new FilterRange(building.wall_insulation_r_value__c.intValue(), (building.wall_insulation_r_value__c*.2).intValue()) : null;
		this.roof_ceiling = new List<String>{building.roof_ceiling__c};
	}
}
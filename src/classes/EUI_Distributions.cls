public class EUI_Distributions {
	
	public List<Decimal> bin_centers {get; set;}
	public List<Decimal> bin_lefts {get; set;}
	public List<Decimal> bin_counts {get; set;}
	public Decimal bin_width {get; set;}
	public String eui_type {get; set;}
	public Decimal mean {get; set;}
	public Decimal median {get; set;}
	public Integer number_of_bins {get; set;}
	public Integer number_of_outliers_removed {get; set;}
	public Map<String, Decimal> quartiles {get; set;}
	public Decimal standard_deviation {get; set;}
	public Integer total_count {get; set;}
	public String units {get; set;}
	public Decimal value_max {get; set;}
	public Decimal value_min {get; set;}

}
public with sharing class FilterRange {
	
	public Integer min {get; set;}
	public Integer max {get; set;}

	public FilterRange(Integer value, Integer variance) {
		this.min = value - variance;
		this.max = value + variance;
	}
}
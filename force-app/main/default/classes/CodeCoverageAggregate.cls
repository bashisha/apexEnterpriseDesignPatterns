public without sharing class CodeCoverageAggregate {
    

    public List<Records> records {get;set;} 
    
    public class ApexClassOrTrigger {
        //public Attributes attributes {get;set;} 
        public String name {get;set;} 
    }
    
    public class Records implements Comparable{
        //public Attributes attributes {get;set;} 
        public ApexClassOrTrigger apexClassOrTrigger {get;set;} 
        public Integer numLinesCovered {get;set;} 
        public Integer numLinesUncovered {get;set;} 
        public Integer totalLines {
            get {
                return numLinesCovered + numLinesUncovered;
            }
        }
        
        public Double percCovered  {
            get {
                if(totalLines == 0) {
                    return 0;
                }
                return ((numLinesCovered*100)/totalLines);
            }
        }
        
        public Integer compareTo(Object compareTo) {
            Records compareToEmp = (Records)compareTo;
            if(percCovered == compareToEmp.percCovered){
                return 0;
            }else if(percCovered>compareToEmp.percCovered){
                return 1;
            }else {
                return -1;
            }
        }
    }    
}
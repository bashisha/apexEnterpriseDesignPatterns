public class IDR_CsvBuilder {
    private static IDR_SystemLogger logger = new IDR_SystemLogger('IDR_BATCH_JOB','IDR_CsvBuilder');
    private String LINE_BREAK = '\n';
    private String SPACER ='';
	String DELIMITER = ',';
    Map<String,String> headerMap;
    List<SObject> records;
   
     
    public IDR_CsvBuilder setDelimiter(String delimiter){
        this.DELIMITER = delimiter;
        return this;
    }
    
    //Field Name as key and field API as Value
    public IDR_CsvBuilder setHeaderMap(Map<String,String> headerMap){
        this.headerMap = headerMap;
        return this;
    }
    
    public IDR_CsvBuilder setSobjectList(List<SObject> records){
        this.records = records;
        return this;
    }
    
    public String buildCsv(){
        try{
            List<String> rows = new List<String>{String.join(this.headerMap.keySet(),this.DELIMITER)}; 
            for(SObject record:this.records){
                List<String> values= new List<String>();
                for(String fieldName:headerMap.values()){ 
                    values.add(record.get(fieldName)==null? this.SPACER: getRowValue(String.valueOf(record.get(fieldName))));
                }
                rows.add(String.join(values,this.DELIMITER));
            }
            return String.join(rows,LINE_BREAK);
        }
        catch (Exception fileException){
            logger.log(fileException, 'buildCsv');
            return null;
        }   
    } 
    
    public String getRowValue(String fieldValue){
        String regExp= '[0-9]{2}:[0-9]{2}:[0-9]{2}';
        fieldValue = fieldValue.replaceAll(',', ' ');
        fieldValue = fieldValue.replace('\n', '\\n');
        return fieldValue.replaceAll(regExp,SPACER);
    }
}

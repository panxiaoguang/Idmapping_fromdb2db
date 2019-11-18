### include some R packages
library(RCurl)
library(rjson)
library(tidyr)
### main function
bitr_db2db<-function(method,input,inputvalues,output){
  if(method=="getinputs"){
    response<-getForm(uri = "https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json",method=method)
    result<-fromJSON(response)
    result$input
  }else if(method=="getoutputsforinput"){
    response<-getForm(uri = "https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json",method=method,input=input)
    result<-fromJSON(response)
    result$output
  }else{
    method<-"db2db"
    input_lst<-paste(inputvalues,collapse=",")
    response <- getForm(uri = "https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json",method=method,format="row",input=input,inputValues=input_lst,outputs=output)
    result<-fromJSON(response)
    fin<-data.frame(from=inputvalues,to=sapply(result,function(x) x[[output]]))
    if(grep("//",as.character(fin[,2]))){ ### if one 2 more
      print("waring:your id have more than one mapping!")
      final<-separate_rows(fin,to,sep="//")
    }else{
      print("your id have 1:1 mapping!")
      final<-fin
    }
  }
}

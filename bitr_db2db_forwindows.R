library(httr)
library(rjson)
library(tidyr)
### main function
bitr_db2db<-function(method,input,inputvalues,output){
  if(method=="getinputs"){
    response<-GET("https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json",query=list(method=method),accept("application/json"))
    json<-toJSON(content(response))
    result<-fromJSON(json)
    result$input
  }else if(method=="getoutputsforinput"){
    response<-GET("https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json",query=list(method=method,input=input),accept("application/json"))
    json<-toJSON(content(response))
    result<-fromJSON(json)
    result$output
  }else{
    method<-"db2db"
    input_lst<-paste(inputvalues,collapse=",")
    response <- GET("https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json",query=list(method=method,format="row",input=input,inputValues=input_lst,outputs=output),accept("application/json"))
    json<-toJSON(content(response))
    result<-fromJSON(json)
    fin<-data.frame(from=inputvalues,to=sapply(result,function(x) x[[output]]))
    if(length(grep("//",as.character(fin[,2])))>0){ ### if one 2 more
      print("waring:your id have more than one mapping!")
      final<-separate_rows(fin,to,sep="//")
    }else{
      print("your id have 1:1 mapping!")
      final<-fin
    }
  }
}
##PS:实在是不明白为什么RCurl包在Windows下无法运行呢

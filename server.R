
getSQL=function(database,query){
    name=odbcDriverConnect(paste("DRIVER=SQL Server;SERVER=SPGSQL1;UID=vance;WSID=Rolledzf6;Trusted_Connection=yes;Database=",database,sep=""))
    SQLdb=sqlQuery(name,query)
    odbcCloseAll()
    return (SQLdb)
  }

shinyServer(function(input, output) {
  
  
baseQuery1 <- "SELECT a.[StudID] as 'Boar Stud'
,[Dest] as 'Destination'
,CAST([Date_Shipped] as Date) as Date_Shipped
,[BoarID]
,[Breed]
,a.[Doses]
,[BatchID]
FROM [Intranet].[dbo].[Boar_Distrib] a
INNER JOIN [Intranet].[dbo].[Boar_Split] b ON a.[StudID]=b.[StudID] AND a.[BatchNum]=b.[BatchNum]
WHERE a.[StudID] = "

baseQuery2<-""

act<-reactiveValues()

observe(
  act$distraw <- getSQL('Intranet',query=paste(baseQuery1,
                                               "'",
                                               input$stud,
                                               "'",
                                               "AND [Date_Shipped]>=",
                                               "'",
                                               input$date1,
                                               "'",
                                               "AND [Date_Shipped]<=",
                                               "'",
                                               input$date2,
                                               "'",
                                               "AND [Breed] = ",
                                               "'",
                                               input$breed,
                                               "'",
                                               "ORDER BY Destination DESC",
                                               sep = "")))





    output$table<-DT::renderDataTable({act$distraw %>% DT::datatable(.,options = list(dom='fltipr'))})
    
    output$download<-downloadHandler(filename = 'prismdata.csv',content = function(file){write.csv(act$distraw,file,row.names = FALSE)})
    

})

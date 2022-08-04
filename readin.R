library(shiny)
# library(tidyverse) # only use for local operation #
# library(tidyverse, lib.loc = "/usr/local/lib/vance/tidyverse")
library(readr)
library(lubridate)
library(readxl)
library(ggplot2)
library(dplyr)



data1<-read_csv('conception.csv',col_types = cols(Week = col_date(format = "%m/%d/%Y"))) %>% 
  mutate(brdwk=Week-35,
         brdwktb=Week-119,
         'Total Born'= (PBA + Stills + Mum)/`Lit Farr`) %>% 
  select(`Cost Center`,`Farm Name`,Week,brdwk,brdwktb,`Total Born`,Area,
         `RTU # Bred`,`RTU # Left`,`RTU Rate`,PBA,Stills,Mum,`Lit Farr`)

data2<-read_csv('dist.csv', col_types = cols(Accounting = col_number())) %>% 
  filter(!is.na(Accounting),
         Breed%in%c('SPG240','DNA400','PICL02','SPG120','TNLR')) %>% 
  mutate(Week=floor_date(x = Date_Shipped, unit = "week", week_start = 1)+6,
         type=ifelse(Breed=='SPG240','Commercial','Multiplication')) %>% 
  group_by(Accounting,Week,`Boar Stud`,type) %>% 
  summarise('Total Doses'=sum(Doses)) %>% 
  ungroup()


data3<-left_join(x = data1,y = data2,by=c("Cost Center"="Accounting","brdwk"="Week")) %>% 
  mutate('Response'='Conception Rate') %>% 
  filter(`RTU Rate`<1.01)

data4<-left_join(x = data1,y = data2,by=c("Cost Center"="Accounting","brdwktb"="Week")) %>% 
  mutate('Response'='Total Born') %>% 
  filter(`RTU Rate`<1.01,
         `Total Born`<30)

data5<-rbind(data3,data4) %>% 
  filter(!is.na(`Boar Stud`),
         !`Cost Center`%in%c(73601:73631))

data6<-data5 %>% 
  group_by(`Boar Stud`,Week,type) %>% 
  filter(Response=='Conception Rate') %>% 
  summarise(Trait=sum(`RTU # Left`)/sum(`RTU # Bred`)) %>% 
  mutate(key='Conception Rate')

data7<-data5 %>% 
  group_by(`Boar Stud`,Week,type) %>% 
  filter(Response=='Total Born') %>% 
  summarise(Trait=sum(PBA,Stills,Mum)/sum(`Lit Farr`)) %>% 
  mutate(key='Total Born')

data8<-rbind(data6,data7)

studlist<-c(unique(data5$`Boar Stud`)) %>% 
  sort(.,decreasing = FALSE)
weeklist<-c(unique(data5$Week))

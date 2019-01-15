list.of.packages <- c("WDI","data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

if(.Platform$OS.type == "unix"){
  prefix = "~"
}else{
  prefix = "E:"
}

wd = paste0(prefix,"/git/data_rev")
setwd(wd)

`%notin%` <- function(x,y) !(x %in% y) 

WDI_download=WDI(country="all", indicator=c("3.01.04.01.agcen","5.14.01.01.povsurv","3.11.01.01.popcen"),start=2004,end=2018,extra=T)
African=subset(WDI_download, region=="Sub-Saharan Africa "|region=="Middle East & North Africa")
African=subset(African, country %notin% c("Iran, Islamic Rep."
                                              ,"Jordan"
                                              ,"Lebanon"
                                              ,"West Bank and Gaza"
                                              ,"Syrian Arab Republic"
                                              ,"Yemen, Rep." ))


# metadata <- read.csv("code/metadata.csv",as.is=TRUE,na.strings="")
# metadata$WDI.name=metadata$Short.Name
# metadata$WDI.name[which(metadata$WDI.name=="Dem. Rep. Congo")]="Congo, Dem. Rep."
# metadata$WDI.name[which(metadata$WDI.name=="Congo")]="Congo, Rep."
# metadata$WDI.name[which(metadata$WDI.name=="Côte d'Ivoire")]="Cote d'Ivoire"
# metadata$WDI.name[which(metadata$WDI.name=="Egypt")]="Egypt, Arab Rep."
# metadata$WDI.name[which(metadata$WDI.name=="The Gambia")]="Gambia, The"
# metadata$WDI.name[which(metadata$WDI.name=="São Tomé and Principe")]="Sao Tome and Principe"
# write.csv(metadata,"code/metadata.csv",row.names=F,na="")
metadata <- read.csv("code/metadata.csv",as.is=TRUE,na.strings="")
metadata=metadata[,c("WDI.name","di_id")]
names(metadata)[1]="country"

African=merge(African,metadata,by="country")
African=African[,c("year","di_id","3.01.04.01.agcen","5.14.01.01.povsurv","3.11.01.01.popcen")]
names(African)=c("year","di_id","ag_census","pov_survey","pop_census")
ag_census=African[,c("year","di_id","ag_census")]
pov_survey=African[,c("year","di_id","pov_survey")]
pop_census=African[,c("year","di_id","pop_census")]
fwrite(ag_census,"data/ag_census.csv")
fwrite(pov_survey,"data/pov_survey.csv")
fwrite(pop_census,"data/pop_census.csv")
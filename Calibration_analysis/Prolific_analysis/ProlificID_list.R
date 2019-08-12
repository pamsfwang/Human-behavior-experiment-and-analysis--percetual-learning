dataPath = '/Volumes/Macintosh HD/Users/Pam_sf_wang/Documents/Perceptual_learning_project/Calibration/Prolificdata/newDesignV8_001/';

SameDifferent_fnames = list.files(path = dataPath,pattern = "SameDifferent")
Demo_fnames = list.files(path = dataPath,pattern = "demographics")
Post_fnames = list.files(path = dataPath,pattern = "postsurvey")
postsurvey_new_fname = "postsurvey_newDesignV8_allsubjects"

##specify variables
#for behavior information
completeFnames =list()
totalData = data.frame()
ic = 1;

#for demographic information
gender = data.frame()
age = data.frame()
ethnicity= data.frame()
race = data.frame()
subID = data.frame()

#for post survey
Postsurvey=data.frame()
Postsurvey_feature = data.frame()
prolificID = data.frame()
confirmationCode = data.frame()
PostsubID=data.frame()

##Getting data from online text output
for (ifiles in 1:length(SameDifferent_fnames)){
  tempFile = read.table(paste0(dataPath,SameDifferent_fnames[ifiles]),header = F)
  Trials = unlist(strsplit(as.character(tempFile$V1), ";"))
  
  if (length(Trials)>1){
    keyNum = data.frame()
    accuracy = data.frame()
    feature_index = data.frame()
    RT = data.frame()
    Fir_img = data.frame()
    Sec_img = data.frame()
    for (i in 1:length(Trials)){
      temp = unlist(strsplit(Trials[i],","));
      keyNum = rbind(keyNum,as.numeric(temp[2]))
      accuracy = rbind(accuracy,as.numeric(temp[4]))
      RT = rbind(RT,as.numeric(temp[5]))
      feature_index = rbind(feature_index,as.numeric(temp[6]))
      Fir_img = rbind(Fir_img,as.numeric(temp[7]))
      Sec_img = rbind(Sec_img,as.numeric(temp[8]))
    }
    data = cbind(keyNum,accuracy,RT, feature_index,Fir_img,Sec_img)
    colnames(data) = c("keys","accuracy", "rt","feature_index", "Fimg","Simg")
    data = data[-1,]
    data$subID = ifiles;
    data$trialNum = 1:dim(data)[1];
    
    totalData = rbind(totalData,data)
    
    ##Getting post-test data    
    for (ifilesDe in 1:length(Post_fnames)){
      if (unlist(strsplit(SameDifferent_fnames[ifiles],"SameDifferent"))[2]==unlist(strsplit(Post_fnames[ifilesDe],"postsurvey"))[2]){      tempPostFile = read.table(paste0(dataPath,Post_fnames[ifilesDe]),header = F)
      ###separate feedback and prolific ID
      if (dim(tempPostFile)[2]>1){
        tempPostFile$y = apply( tempPostFile[,] , 1 , paste , collapse = "" )
        Post_info = unlist(strsplit(as.character(tempPostFile$y), ";"))
      }else{
        Post_info = unlist(strsplit(as.character(tempPostFile$V1), ";"))
      }
      
      Postsurvey[ic,1]=unlist(Post_info[1])
      prolificID[ic,1] = unlist(Post_info[2])
      Postsurvey_feature[ic,1]=feature_index[2,]
      confirmationCode[ic,1]=unlist(strsplit(SameDifferent_fnames[ifiles],"SameDifferent"))[2]
      PostsubID[ic,1]=unlist(ifiles)
      }#if 
    }#for
    ic = ic+1;
  }else{
  }
}#for

#save post test survey
postsurvey = cbind(Postsurvey,Postsurvey_feature,prolificID,PostsubID,confirmationCode)
colnames(postsurvey) = c("post_surve","feature","prolificID","SubID","confirm_code")
write.csv(postsurvey, file = paste0(postsurvey_new_fname,".csv"))





% 描述： GWNN模型反演PM2.5（2015_2022八年均值）

clear
close all
clc


uid=3;
vid=4;
yid=11;
xids=5:10;
otherids=[1,2];
titles={'jing','wei','pm25'};
dataPath="..\\predict\\data_2015_2022.csv";

HLNums=[10,100,1000,2000,3000,4000,5000,10000];
for i=1:8
    HLNum=HLNums(i);
	
	outPath=sprintf("..\\predict\\predict_GN_%d.csv",HLNum);
	gwnnPath=sprintf("..\\predict\\gwnn_GN_%d.mat",HLNum);
	OMat=load(gwnnPath);
	OM=OMat.OptimalModel;
	dataNorm=BigData(dataPath,uid,vid,yid,xids,otherids);
	
    YHat = MakePY(OM,dataNorm.X',[dataNorm.u,dataNorm.v]');

    vals=[dataNorm.u,dataNorm.v,YHat'];
    OutputData2(outPath,titles,avals);
end






% 描述： 不同年度，GWNN模型反演PM2.5（从2015到2022年）

clear
close all
clc


uid=3;
vid=4;
yid=11;
xids=5:10;
otherids=[1,2];
titles={'jing','wei','pm25'};

years=2015:2022;
for i=1:8
    yr=years(i);
	
	outPath=sprintf("..\\predict\\predict_%d.csv",yr);
	gwnnPath=sprintf("..\\predict\\gwnn_%d.mat",yr);
	OMat=load(gwnnPath);
	OM=OMat.OptimalModel;
    dataPath=sprintf("..\\predict\\data_%d.csv",yr);
	dataNorm=BigData(dataPath,uid,vid,yid,xids,otherids);
	
    YHat = MakePY(OM,dataNorm.X',[dataNorm.u,dataNorm.v]');

    vals=[dataNorm.u,dataNorm.v,YHat'];
    OutputData2(outPath,titles,avals);
end












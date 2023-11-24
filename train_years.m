


% 描述： 不同年度，GWNN模型训练（从2015到2022年）

clear
close all
clc

%启动超参数调整区
HyperParameters.isNormalized=false;
HyperParameters.mbNum=8;
HyperParameters.vsRatio=0.3; %测试集比率
HyperParameters.epochNum=633;
HyperParameters.lr=0.0003; 
HyperParameters.aLoopEpochNum=3;%可早停轮数
HyperParameters.patience=33;
HyperParameters.isEarlyStopping=false;%是否启用早停
HLNum=3000;

years=2015:2022;

for i=1:8

    yr=years(i);
    uvPath="..\train\uv.mat";
    dataPath=sprintf("..\\train\\data_%d.mat",yr);
    gwrPath=sprintf("..\\train\\gwr_fg_%d.mat",yr);
    matPath=sprintf("..\\predict\\gwnn_%d.mat",yr);
    
    %GWNN模型超参数
    OMHP = MakeHP3(HLNum,dataPath,uvPath,gwrPath);
    
    %超参数具体设置
    HyperParameters.w1 = OMHP.w1;
    HyperParameters.w2 = OMHP.w2;
    HyperParameters.b1 = OMHP.b1;
    HyperParameters.b2 = OMHP.b2;
    HyperParameters.bw = OMHP.bw;
    HyperParameters.HLIndexs = OMHP.HLIndexs;
    HyperParameters.HLUV = OMHP.HLUV;
    HyperParameters.IDS = OMHP.IDS;
    HyperParameters.XORI = OMHP.XORI;
    HyperParameters.YORI = OMHP.YORI;
    HyperParameters.UV = OMHP.UV;
    HyperParameters.thGW = OMHP.thGW;
    HyperParameters.ttGW = OMHP.ttGW;
    HyperParameters.aAICc = OMHP.aAICc;%可早停AICc
    
    [FullStat,OptimalModel]= AGWNN(HyperParameters);
    OptimalModel.FullStat=FullStat;
    
    save(matPath,"OptimalModel");

end



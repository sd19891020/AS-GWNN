


% 描述： AGWNN模型训练遥感+地面监测站PM2.5数据（2023.5.1-2023.10.1均值）

clear
close all
clc

%启动超参数调整区
HyperParameters.isNormalized=false;
HyperParameters.mbNum=8;
HyperParameters.vsRatio=0.3; %测试集比率
HyperParameters.epochNum=633;
HyperParameters.lr=0.0003; %最优0.001
HyperParameters.aLoopEpochNum=3;%可早停轮数
HyperParameters.patience=33;
HyperParameters.isEarlyStopping=false;%是否启用早停
HLNum=3000;

years=2015:2022;

for i=1:8

    yr=years(i);
    uvPath="D:\仓库\博士\PM25\train\data_uv.mat";
    trainPath=sprintf("D:\\仓库\\博士\\PM25\\train\\data_train_%d.mat",yr);
    gwrPath=sprintf("D:\\仓库\\博士\\PM25\\train\\gwr_fg_%d.mat",yr);
    matPath=sprintf("D:\\仓库\\博士\\PM25\\train\\agwnn_train_%d.mat",yr);
    
    %AGWNN模型超参数
    %OMHP = MakeHP3(HLNum,trainPath,uvPath,gwrPath);
    OM=load(matPath);
    OMHP=OM.OptimalModel;
    
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
    OptimalModel.BetaHat = MakeBetaHat(OptimalModel.w1,OptimalModel.b1,OptimalModel.w2,OptimalModel.thGW);
    OptimalModel.FullStat=FullStat;
    
    % yyaxis left;plot(FullStat.aicc_history');%ylim([0,16000]);
    % yyaxis right;plot(FullStat.r2adj_history');%ylim([0.0,1.0]);
    
    save(matPath,"OptimalModel");

end



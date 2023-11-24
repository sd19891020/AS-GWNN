


% 描述： AGWNN模型训练遥感 2015-2022八年均值

clear
close all
clc


trainPath="D:\仓库\博士\PM25\train\data_train_2015_2022.mat";
uvPath="D:\仓库\博士\PM25\train\data_uv.mat";
gwrPath="D:\仓库\博士\PM25\train\gwr_fg_2015_2022.mat";


%启动超参数调整区
HyperParameters.isNormalized=false;
HyperParameters.mbNum=8;
HyperParameters.vsRatio=0.3; %测试集比率
HyperParameters.epochNum=333;
HyperParameters.lr=0.001; %最优0.001
HyperParameters.aLoopEpochNum=3;%可早停轮数
HyperParameters.patience=33;
HyperParameters.isEarlyStopping=false;%是否启用早停

HLNums=[1,10,100,1000,2000,3000,4000,5000,10000];
matPaths=[
    "D:\仓库\博士\PM25\train\2015_2022\1.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\10.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\100.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\1000.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\2000.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\3000.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\4000.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\5000.mat",...
    "D:\仓库\博士\PM25\train\2015_2022\10000.mat"
    ];

for i=1:9

    HLNum=HLNums(i);
    tic;
    OMHP = MakeHP3(HLNum,trainPath,uvPath,gwrPath);
    OptimalModel.HPTime=toc;

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

    tic;
    [FullStat,OptimalModel]= AGWNN(HyperParameters);
    OptimalModel.TrainTime=toc;
    OptimalModel.BetaHat = MakeBetaHat(OptimalModel.w1,OptimalModel.b1,OptimalModel.w2,OptimalModel.thGW);
    OptimalModel.FullStat=FullStat;

    figure(i);
    yyaxis left;plot(FullStat.aicc_history');
    yyaxis right;plot(FullStat.r2adj_history');ylim([-10.0,1.0]);

    save(matPaths(i),"OptimalModel");

end





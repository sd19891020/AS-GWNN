


% 描述： 不同GN数量条件下，GWNN模型训练（2015_2022八年均值）

clear
close all
clc


dataPath="..\train\data_2015_2022.mat";
uvPath="..\train\uv.mat";
gwrPath="..\train\gwr_fg_2015_2022.mat";


%启动超参数调整区
HyperParameters.isNormalized=false;
HyperParameters.mbNum=8;
HyperParameters.vsRatio=0.3; %测试集比率
HyperParameters.epochNum=333;
HyperParameters.lr=0.0003; 
HyperParameters.aLoopEpochNum=3;%可早停轮数
HyperParameters.patience=33;
HyperParameters.isEarlyStopping=false;%是否启用早停

HLNums=[10,100,1000,2000,3000,4000,5000,10000];
matPaths=[
    "..\predict\gwnn_10.mat",...
    "..\predict\gwnn_100.mat",...
    "..\predict\gwnn_1000.mat",...
    "..\predict\gwnn_2000.mat",...
    "..\predict\gwnn_3000.mat",...
    "..\predict\gwnn_4000.mat",...
    "..\predict\gwnn_5000.mat",...
    "..\predict\gwnn_10000.mat"
    ];

for i=1:8

    HLNum=HLNums(i);
    tic;
    OMHP = MakeHP3(HLNum,dataPath,uvPath,gwrPath);
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
    OptimalModel.FullStat=FullStat;

    figure(i);
    yyaxis left;plot(FullStat.aicc_history');
    yyaxis right;plot(FullStat.r2adj_history');

    save(matPaths(i),"OptimalModel");

end





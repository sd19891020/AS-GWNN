


% ������ GWNNģ��ѵ��ң��PM2.5����ģ�ͣ�2015-2022��

clear
close all
clc

%����������������
HyperParameters.isNormalized=false;
HyperParameters.mbNum=8;
HyperParameters.vsRatio=0.3; %���Լ�����
HyperParameters.epochNum=633;
HyperParameters.lr=0.0003; %����0.001
HyperParameters.aLoopEpochNum=3;%����ͣ����
HyperParameters.patience=33;
HyperParameters.isEarlyStopping=false;%�Ƿ�������ͣ
HLNum=3000;

years=2015:2022;

for i=1:8

    yr=years(i);
    uvPath="\PM25\train\data_uv.mat";
    trainPath=sprintf("\\PM25\\train\\data_train_%d.mat",yr);
    gwrPath=sprintf("\\PM25\\train\\gwr_fg_%d.mat",yr);
    matPath=sprintf("\\PM25\\train\\agwnn_train_%d.mat",yr);
    
    %AGWNNģ�ͳ�����
    OMHP = MakeHP3(HLNum,trainPath,uvPath,gwrPath);
    
    %��������������
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
    HyperParameters.aAICc = OMHP.aAICc;%����ͣAICc
    
    [FullStat,OptimalModel]= AGWNN(HyperParameters);
    OptimalModel.FullStat=FullStat;
    
    save(matPath,"OptimalModel");

end



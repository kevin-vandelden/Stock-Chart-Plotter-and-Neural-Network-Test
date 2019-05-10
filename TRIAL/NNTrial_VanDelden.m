%% Header Section

% Property of Kevin VanDelden
% 05/04/2019
% Purpose of code is to manipulate input/outputs of a created network for
% analysis
clear all
close all
clc

% clc

%% 

%loadtechNNdata
% data comes in the form
% 1. Open
% 2. High
% 3. Low
% 4. Close
% 5. Volume

% load('techNNdata.mat');

%% For Volume Adjusted Matrix

% NNtablevoladj=devolmat(NNtable);
% % function divides volume by 10,000 to put in closer magnitude of prices
% % change orientation of matrix so there timesteps are in columns.
% NNtablevoladj=NNtablevoladj';
% 
% NNtablevoladjend=NNtablevoladj(:,(801:end));
% NNtablevoladjtrain=NNtablevoladj(:,(1:800));
% 
% NNguess=sim(net,num2cell(NNtablevoladjend,1));
% NNguessmat=cell2mat(NNguess)';
% 
% NNguessvolfix=revolmat(NNguessmat);
% NNguessvolfix=NNguessvolfix';
% 
% NNtablevolfix=revolmat(NNtablevoladjend');
% NNtablevolfix=NNtablevolfix';
% 
% figure
% hold on
% plot(NNtablevoladjend(1,:));
% plot(NNguessvolfix(1,:));


%% For Price Adjusted Matrix
load ('wholenet.mat');

NNtablepriceadjtruncendfix=pricemagdecrease(NNtablepriceadjtruncend);
% NNTable pricea magnified, and truncated for nn size constraints, use
% demag/decrease function

NNguess=sim(BR10x800,num2cell(NNtablepriceadjtruncend,1));
% output prediction of NN given the last 36 days of the data, not used in
% the network
NNguessmat=cell2mat(NNguess);
NNguesspricefix=pricemagdecrease(cell2mat(NNguess));
% adjust the price magnification due to NN quirks

figure
hold on
plot(NNtablepriceadjtruncendfix(1,:))
plot(NNguesspricefix(1,:));
hold off

% into the future

% numdaysfuture=5;
NNguessfuturecell=NNguess;
% for i=1:numdaysfuture
    
guess1vec=[NNtablepriceadjtruncend,(NNguessmat(:,end))];
NNguess2=sim(BR10x800,num2cell(guess1vec,1));
NNguess2mat=cell2mat(NNguess2);
guess2vec=[guess1vec,NNguess2mat(:,end)];

NNguess3=sim(BR10x800,num2cell(guess2vec,1));
NNguess3mat=cell2mat(NNguess3);
guess3vec=[guess2vec,NNguess3mat(:,end)];

NNguess4=sim(BR10x800,num2cell(guess3vec,1));
NNguess4mat=cell2mat(NNguess4);
guess4vec=[guess3vec,NNguess4mat(:,end)];

NNguess5=sim(BR10x800,num2cell(guess4vec,1));
NNguess5mat=cell2mat(NNguess5);
guess5vec=[guess4vec,NNguess5mat(:,end)];

guess5vecfix=pricemagdecrease(guess5vec);


figure
hold on
plot(NNtablepriceadjtruncendfix(1,:))
plot(guess5vecfix(1,:),'o');
plot(guess5vecfix(2,:),'x');
plot(guess5vecfix(3,:),'square');
hold off












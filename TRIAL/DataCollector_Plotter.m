%% %%%%% Header Section %%%%% %%
% Kevin VanDelden 02/22/2018

%% prompt the user to either refresh the data or use existing in the workspace.

clc
clear all
close all

%% SECTION 1: INDEX DATA
cd C:\Users\Kevin\Documents\Money\Industry_Lists
% string of companies currently listed in the DOW 30
% DOWstring={'AXP','AAPL','BA','CAT','CSCO','CVX','XOM','GE','GS','HD','IBM','INTC','JNJ','KO','JPM','MCD','MMM','MRK','MSFT','NKE','PFE','PG','TRV','UNH','UTX','VZ','V','WMT','DIS','DWDP'};
[DOWnum,DOWtxt,DOWraw]=xlsread('DowJones.xlsx');
DOWtickers=DOWraw(:,3);
% picks out the DOW ticker symbols for DOWJones 30

% returns the companies listed in the S&P 500
[SP500num,SP500txt,SP500raw]=xlsread('SandP500.xlsx');
SP500tickers=SP500txt(:,1);
% picks out the ticker symbols for S&P500

[TECHnum,TECHtxt,TECHraw]=xlsread('Technology_List.xlsx');
TECHtickers=TECHtxt(:,1);

%% loader, input desired tickers and the date range only need to run to update
% to get the most recent date of the stock, split the datevec of 'today'
% into day month year, and strcat in order needed for fnct.

cd C:\Users\Kevin\Documents\Money
    
datevector=datevec(today);
datevector(4:6)=[];
dateyear=num2str(datevector(1));
datemonth=num2str(datevector(2));
datedate=num2str(datevector(3));

% enddate=strcat(datemonth,datedate,dateyear);
enddate='01052019';

startdate=char('02012016');
% to make the preset date today's current ending date
% enddate=char(datetime('today'));
% enddate=char('04112018');

% uses function getgoogledailydata
data=hist_stock_data(startdate,enddate,'VNET');
% data=getGoogleDailyData({'AVEO','CY'},startdate,enddate);

% to run as many times as there are input variables
[rowstruct,columnstruct]=size(data);

%% to change directory of the writing folder
 
[xcel_indexnum,xcel_indextext,xcel_indexraw]=xlsread('XCEL_INDEX_5000_t.xlsx');
xcel_indextext=char(xcel_indextext);


%%  Will write a specificc file of data collected

% multiplier=1;
% % xlswrite('MSFT',data(1).Date,1,xcel_indextext(1));
% 
% for i=1:columnstruct
%     % EXCLUDES DATE FROM REPETITION AND MAKES ONLY 1 COLUMN
% % xlswrite('MSFT',data(i).Date,1,xcel_indextext(multiplier));
% 
% xlswrite('MSFT',data(i).Open,1,xcel_indextext(multiplier+1));
% xlswrite('MSFT',data(i).High,1,xcel_indextext(multiplier+2));
% xlswrite('MSFT',data(i).Low,1,xcel_indextext(multiplier+3));
% xlswrite('MSFT',data(i).Close,1,xcel_indextext(multiplier+4));
% xlswrite('MSFT',data(i).AdjClose,1,xcel_indextext(multiplier+5));
% xlswrite('MSFT',data(i).Volume,1,xcel_indextext(multiplier+6));
% %  multiplier=multiplier*(7*i);
% end

daystoplot=50;

%% %%%%% Data Assignment %%%%% %%
% splitting the structure into its neccesary components for use

for i=1:columnstruct
date(:,i)=data(i).Date;
open(:,i)=data(i).Open;
high(:,i)=data(i).High;
low(:,i)=data(i).Low;
closeprice(:,i)=data(i).Close;
adjclose(:,i)=data(i).AdjClose;
volume(:,i)=data(i).Volume;
RSI(:,i)=rsindex(adjclose(:,i));
end
%% %%%%%%%%%%%%%%%%%% NN Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd C:\Users\Kevin\Documents\Money\TRIAL

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

% figure
% hold on
% plot(NNtablepriceadjtruncendfix(1,:))
% plot(NNguesspricefix(1,:));
% hold off

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

% combineguess5vecfix=[data.Open(786:799);(guess5vecfix(1,:))'];

figure(3)
hold on
plot(NNtablepriceadjtruncendfix(2,:))
plot(guess5vecfix(2,:),'o')
hold off

%% Values to Calculate
% Calculating the fifty day moving average, including the starting point
% and 49 trailing. Truncated values (Endpoints) are discarded.
fiftydayMAone=movmean(adjclose,[49 0],'Endpoints','discard');

% Bollinger Bands: standard 20,2
twentydayMA=movmean(adjclose,[19 0],'Endpoints','discard');
twentydaystdev=movstd(adjclose,[19 0],'Endpoints','discard');

bollingerupper=twentydayMA+(twentydaystdev*2);
bollingerlower=twentydayMA-(twentydaystdev*2);

[SIGNALline,MACDline]=macd(adjclose);
% RSI=rsindex(adjclose);


%% Plotting
% truncating the data being used for plotting, shortens the datsets by the
% number of days being plotted

% truncates the raw data to the number of days being plotted
truncnumber=(length(high)-daystoplot);
hightrunc=high((truncnumber+1:end),:);
lowtrunc=low((truncnumber+1:end),:);
closepricetrunc=closeprice((truncnumber+1:end),:);
opentrunc=open((truncnumber+1:end),:);
volumetrunc=volume((truncnumber+1:end),:);
RSItrunc=RSI((truncnumber+1:end),:);
SIGNALlinetrunc=SIGNALline((truncnumber+1:end),:);
MACDlinetrunc=MACDline((truncnumber+1:end),:);

% truncates calculated values by taking the last X values in the vector
fiftydayMAonetrunc=fiftydayMAone((((length(fiftydayMAone)-daystoplot)+1):end),:);
bollingeruppertrunc=bollingerupper((((length(bollingerupper)-daystoplot)+1):end),:);
bollingerlowertrunc=bollingerlower((((length(bollingerlower)-daystoplot)+1):end),:);
twentydayMAtrunc=twentydayMA((((length(twentydayMA)-daystoplot)+1):end),:);

% Candlestick plots
plotrange=(1:daystoplot);

for i=1:columnstruct
figure(i)
subplot(5,1,[2 4])
candle(hightrunc(:,i),lowtrunc(:,i),closepricetrunc(:,i),opentrunc(:,i))

hold on
plot(plotrange,fiftydayMAonetrunc(:,i),'k');
plot(plotrange,bollingeruppertrunc(:,i),'r');
plot(plotrange,bollingerlowertrunc(:,i),'r');
plot(plotrange,twentydayMAtrunc(:,i),'r');
% plot(plotrange,combineguess5vecfix,'square');

yyaxis right
bar(volumetrunc(:,i),'w')
ylim([0 (8*max(volumetrunc(:,i)))]);
title(data(i).Ticker);
hold off

subplot(5,1,1)
hold on
plot(RSItrunc(:,i))
ylim([0 100])
plot([1 daystoplot],[30 30],'--k');
plot([1 daystoplot],[70 70],'--k');
title('RSI')
ax = gca;
ax.FontSize = 6;
hold off

subplot(5,1,5)
hold on
plot(SIGNALlinetrunc(:,i),'k')
plot(MACDlinetrunc(:,i),'r')
plot([1 daystoplot],[0 0],'--k');
ylim([-1 1]);
title('MACD line');
ax = gca;
ax.FontSize = 6;
hold off

% Display names of tickers whose last day Signal Line is greater than
% MACDline
if SIGNALlinetrunc(end,i)>MACDlinetrunc(end,i) 
%     && SIGNALlinetrunc(end-12,i)<MACDlinetrunc(end-12,i)

    disp(data(i).Ticker)
else
    
end

end

%% Once Data is updated Secion




function [ NNtablevoladj ] = pricemagdecrease( input_args )
%UNTITLED2 Summary of this function goes here
%   To make volume in the same magnitude as the rest of the matricies, was
%   coming into problems with networks output 

NNtablevoladj=input_args;

[a,b]=size(NNtablevoladj);
count=1;
for i=1:a;
    
   if count==1 || count==2 || count==3 || count==4
       NNtablevoladj(i,:)=NNtablevoladj(i,:)/10000;
%        count=0;
   end
   count=count+1;
   if count==5;
       count=0;
   end
end


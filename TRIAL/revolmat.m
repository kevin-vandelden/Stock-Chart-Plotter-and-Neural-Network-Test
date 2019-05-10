function [ NNtablevoladj ] = devolmat( input_args )
%UNTITLED2 Summary of this function goes here
%   To make volume in the same magnitude as the rest of the matricies, was
%   coming into problems with networks output 

NNtablevoladj=input_args;
% NNtablevoladj=NNtablevoladj;

count=1;
for i=1:length(NNtablevoladj);
    
   if count==5
       NNtablevoladj(:,i)=NNtablevoladj(:,i)*10000;
       count=0;
   end

   count=count+1;
end


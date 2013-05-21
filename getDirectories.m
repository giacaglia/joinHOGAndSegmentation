function [ listDir ] = getDirectories( pathname )
%GETDIRECTORIES Summary of this function goes here
%   Detailed explanation goes here
    d = dir(pathname);
    isub = [d(:).isdir]; %# returns logical vector
    listDir = {d(isub).name}';
    listDir(ismember(listDir,{'.','..'})) = [];

end


function [ boolean ] = isMask( filename )
%ISMASK Summary of this function goes here
%   Detailed explanation goes here
    boolean = false;
    if strcmp(filename(size(filename,2)-8:size(filename,2)), '_mask.jpg') || strcmp(filename(size(filename,2)-8:size(filename,2)), '.DS_Store') || strcmp(filename(size(filename,2)-3:size(filename,2)),'.bmp')
        boolean = true;
    end
end


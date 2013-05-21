function [] = joinHOGAndSegmentation()
%joinHOGAndSegmentation Runs a HOG on the person
% then segments the image and then it runs
% a HOG Detector on the parts.

    %% Crops the images with the possible images of the people.
%     addpath('/Users/giu/Documents/Winston/Object-Detection/FinalModels/');
%     addpath('/Users/giu/Documents/Winston/Object-Detection/gdetect');
%     addpath('/Users/giu/Documents/Winston/Object-Detection/testImages');
%     addpath('/Users/giu/Documents/Winston/Object-Detection/features');
%     addpath('/Users/giu/Documents/Winston/Object-Detection');
%     addpath('/Users/giu/Documents/Winston/BSR/grouping/lib');
%     addpath('/Users/giu/Documents/Winston/ContourObjectDetection');
%     addpath('/Users/giu/Documents/Winston/ContourObjectDetection/TrainingExamples/');
%     addpath('/Users/giu/Documents/Winston/ContourObjectDetection/TrainingExamples/data/DistanceTransformEdgels/');
%     addpath('/Users/giu/Documents/Winston/ContourObjectDetection/SVM/');
%     addpath('/Users/giu/Documents/Winston/ContourObjectDetection/SVM/data/');
%     addpath('/Users/giu/Documents/Winston/ContourObjectDetection/chamfer_distance/');
    
    HOGOnPeople;

    %% Directory list under ./PeopleCroppedImages
    dirName = '/Users/giu/Documents/Winston/Object-Detection/testImages/PeopleCroppedImages';
    nameFolders = getDirectories(dirName);


    %% Get the cropped Images and segment them
    addpath('/Users/giu/Documents/Winston/BSR/grouping');
    for i = 1:size(nameFolders,1),
        nameFolder = nameFolders(i);
        nameFolder = nameFolder{1,1};
        dirToBeSearched = strcat(dirName, '/', nameFolder);
        croppedImages = getFilesUnderDirectory(dirToBeSearched);
        for j = 1:size(croppedImages,1),
            nameCroppedImage = croppedImages(j);
            nameCroppedImage = nameCroppedImage{1,1};
            if (~strcmp(nameCroppedImage(size(nameCroppedImage,2)-8 : size(nameCroppedImage,2)), '.DS_Store')),
                segmentImage(nameCroppedImage);
            end
        end
    end
    
    %% Get the cropped Images and check for faces, lowerbody and upperbody 
    joinedImagesDir = '/Users/giu/Documents/Winston/HOGAndBSRAndJoiningSegments/';
    for i = 1:size(nameFolders,1),
        folder = strcat(dirName, '/', nameFolders(i));
        dirNameJoinedImages = strcat(joinedImagesDir,nameFolders(i));
        mkdir(dirNameJoinedImages{1,1});
        underDirectories = getDirectories(folder{1,1});
        created = false;
        for j = 1: size(underDirectories,1),
            dirToBeSearched = strcat(folder,'/',underDirectories(j));
            dirToBeSearched = dirToBeSearched{1,1};
            fileList = getFilesUnderDirectory(dirToBeSearched);
            for k = 1:size(fileList,1),
                file = fileList(k);
                file = file{1,1};
                if ~isMask(file),
                    face = false;
                    upperBody = false;                    
                    [auxCenterBox, lowerBody] = runningHOG('lowerbody', file);
                    if lowerBody,
                        centerBox = auxCenterBox;
                    end
                    if (~lowerBody),
                        [auxCenterBox, upperBody] = runningHOG('upperbody', file);
                        if upperBody,
                            centerBox = auxCenterBox;
                        end
                        if (~upperBody),
                            [auxCenterBox, face] = runningHOG('Face', file);
                            if face,
                                centerBox = auxCenterBox;
                            end
                        end
                    end
                    
                    %% Running the Contour Object Detection
                    if (lowerBody || upperBody || face)
                        if strcmp(file(size(file,2)-3:size(file,2)), '.jpg'),
                            prefixOfImage = file(1:size(file,2)-4);
                        elseif strcmp(file(size(file,2)-4:size(file,2)), '.jpg'),
                            prefixOfImage = file(1:size(file,2)-5);
                        end
                        bmpFileName = strcat(prefixOfImage, '.bmp');
                        bdryE = imread(bmpFileName, 'bmp');
                        if max(max(max(bdryE))) == 0,
                            lowerBody = false;
                            upperBody = false;
                            face = false;
                        else
                            createEdgels(bmpFileName, centerBox, 'Segmented', true);
                            load EdgelsSegmented;
                            createDistanceOfEdgels;
                            if (lowerBody)
                                load lowerbodyXYSVM;
                                load distanceLowerBodyTemplate;
                                generateXandYForSVM;
                                lowerBody = svmclassify(svmStruct,trainingx); 
                            end;
                            if (upperBody)
                                load upperbodyXYSVM;
                                load distanceUpperBodyTemplate;
                                generateXandYForSVM;
                                upperBody = svmclassify(svmStruct,trainingx); 
                            end;
                            if (face)
                                load upperbodyXYSVM;
                                load distanceUpperBodyTemplate;
                                generateXandYForSVM;
                                face = svmclassify(svmStruct,trainingx); 
                            end
                        end
                    end
                    
                    %% Join the images
                    if (lowerBody || upperBody || face)
                        im = imread(file);
                        if ~created,
                            new_img = zeros(size(im,1), size(im,2), size(im,3), 'uint8');
                            new_img = addImages(im, new_img);
                            created = true;
                        else
                            new_img = addImages(im, new_img);
                        end
                        imwrite(new_img, strcat(dirToBeSearched, '/', 'joinedImage.jpg'));
                    end
                end    
            end
        end
    end
end


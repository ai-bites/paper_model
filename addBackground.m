% This is used to add a background image to a rendered mesh 
% Further, it also saves the final resulting image to the folder:
% object_dataset/data/Images
% It also calls the function to store the annotations to the folder:
% object_dataset/data/Annotations
%
% BEFORE RUNNING THE SCRIPT:
% 1. Make sure the objects are available in the rendered_no_bg folder.
% 2. The background images are availabe in background folder.
% 3. The background images are named "bg_<number>.jpg"

clc; clear all; close all;

% iterate all the objects
for imgNo = 1:1200

    % some Initializations
    % Image we use as foreground
    % TOSET: set object number
    img = imread(strcat('/home/isit/workspace/object_dataset/rendered_no_bg/obj5_', ...
                 int2str(imgNo), '.png'));
    % TOSET: set object class number
    objClass = 5;
    
    % The image we have to use as background 
    % choose a random background.
    bg = imread(strcat('/home/isit/workspace/object_dataset/backgrounds/bg_', ...
                        int2str(randi(50)), '.jpg'));
    % get the size of images
    [m n o] = size(img);
    [bg_m bg_n bg_o] = size(bg);

    if (rem(m,2) ~= 0)
        img(m+1,:,:) = 0;
    end
    if (rem(n,2) ~= 0)
        img(:,n+1,:) = 0;
    end
    if (rem(bg_m,2) ~= 0)
        bg(bg_m+1,:,:) = 0;
    end
    if (rem(bg_n,2) ~= 0)
        bg(:,bg_n+1,:) = 0;
    end

    if (m > bg_m && n > bg_n)
        % pad background
        padded_bg = padarray(bg,[(m-bg_m)/2,(n-bg_n)/2]);
        padded_img = img;
    end

    if (m < bg_m && n < bg_n)
       % pad img
       padded_img = padarray(img,[(bg_m-m)/2,(bg_n-n)/2]);
       padded_bg = bg;
    end

    if (m < bg_m && n > bg_n)
       % pad img and bg 
       padded_img = padarray(img,[(bg_m-m)/2,0]);
       padded_bg = padarray(bg,[0,(n-bg_n)/2]);
    end

    if (m > bg_m && n < bg_n)
        padded_img = padarray(img,[(m-bg_m)/2,0]);
        padded_bg = padarray(img,[0,(bg_n-n)/2]);
    end

    if (~exist('padded_img')) padded_img = img; end;
    if (~exist('padded_bg')) padded_bg = bg; end;

    
    if (size(padded_img,1) ~= size(padded_bg,1) || ...
        size(padded_img,2) ~= size(padded_bg,2))
        error('Sizes do not match. Please check');
    end

    % mask and add bg and img
    bg_mask = uint8(padded_img == 0);
    BG = bg_mask.*padded_bg;
    fg_mask = uint8(padded_img ~= 0);
    FG = fg_mask.*padded_img;
    imshow(FG,[]); hold on;

    % get the bounding box for the foreground
    sx = sum(FG(:,:,1),2); % sum all columns
    sy = sum(FG(:,:,1),1); % sum all rows

    f1 = find(sx ~= 0);
    f2 = find(sy ~= 0);

    plot(f2(1), f1(1), 'g*');
    plot(f2(end), f1(end), 'g*');
    hold off;

    xmin = f2(1); ymin = f1(1);
    xmax = f2(end); ymax = f1(end);

    % final combined image of both foreground and background
    res = FG+BG;

    % save the final resulting image in Images folder:
    % /home/isit/workspace/object_dataset/data/Images
    savePath = '/home/isit/workspace/object_dataset/data/Images/';
    saveName = strcat('object',int2str(objClass), '_img', int2str(imgNo), '.jpg');
    saveAs = strcat(savePath,saveName);
    imwrite(res, saveAs, 'jpg');
    
    % Save annotation for the image in the *.xml file
    xmlSavePath = '/home/isit/workspace/object_dataset/data/Annotations/';
    saveAsXml(res, saveAs, objClass, imgNo, xmlSavePath, xmin, xmax, ymin, ymax);

    % finally, save the image filename without extension in the 
    % ImageSet/train.txt file
    
    fprintf('Done with processing image No. %d \n', imgNo);
    clear all;
end % objects iteration



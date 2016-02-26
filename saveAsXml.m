function [] = saveAsXml(img, fileName, objClass, imgNo, xmlSavePath, xmin, xmax, ymin, ymax)
% Used to create annotations and store then in the 'Annotations' folder.
% Because we are doing Detection, we need annotations of bounding boxes
% corresponding to object locations.
% 
% img           - image to be stored
% filePath      - The location where to store
% objectClassNo - The number of class: we have 10 classes
% 
% Idea taken from:
% https://github.com/coldmanck/fast-rcnn/blob/master/convert_mat_to_xml/convert_mat_to_xml.m

    delimiter = '/';
    strs = strsplit(fileName, delimiter);
    for i = 1:1
        img_name(i).filename = strs(end);

        img_name(i).object.name = strcat('object_', int2str(objClass));
        img_name(i).object.bndbox = struct('xmin', xmin, 'ymin', ymin, ...
                                           'xmax', xmax, 'ymax', ymax);

        annotation = img_name(i);
        % just to be sure, this name has to be consistent with names under
        % 'Images' folder
        xml_write(strcat(xmlSavePath, 'object', int2str(objClass), '_Img', int2str(imgNo) ,'.xml'), ...
                  annotation);
    end
end
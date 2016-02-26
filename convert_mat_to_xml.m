
load('sample.mat');
delimiter = '/';

for i = 1:size(positiveInstances,2)
    strs = strsplit(positiveInstances(i).imageFilename, delimiter);
    img_name(i).filename = strs(end);
    
    s3 = positiveInstances(i).objectBoundingBoxes(3);
    s4 = positiveInstances(i).objectBoundingBoxes(4);
    
    img_name(i).object.name = 'object 1';
    img_name(i).object.bndbox = struct('xmin', positiveInstances(i).objectBoundingBoxes(1), ...
        'ymin', positiveInstances(i).objectBoundingBoxes(2), ...
        'xmax', positiveInstances(i).objectBoundingBoxes(1) + s3, ...
        'ymax', positiveInstances(i).objectBoundingBoxes(2) + s4);
    
    char = img_name(i).filename{1};
    char = strsplit(char, '.');
    annotation = img_name(i);
    xml_write(strcat(char{1}, '.xml'), annotation);
end
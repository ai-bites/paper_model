function []  = generateMeshes(total_meshes, num_rulings, num_regions)
% Using this script, we can generate random meshes to be exported and used
% elsewhere. The meshes get saved as "*.obj" files. They can be imported
% readily in tools like Blender.

% number of needed models
% num_models = 1200;
% scale the mesh so that its easy for blender
mesh_scale = 15;

for i = 1:str2num(total_meshes)
    mesh_3d = demo_randModel(0).*mesh_scale;
    % convert the mesh/model into .obj file and save it
    f_name = sprintf(strcat('/home/shrinivasan/work/defoobjinwild/dataset/temp_meshes/','mesh%d.obj'), i-1);
    saveMeshAsObj(f_name,mesh_3d(:,:,1),mesh_3d(:,:,2),mesh_3d(:,:,3));
    fprintf('Saved object %d \n', i);
end
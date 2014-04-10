function [diroutlist,scaling]=stereoreconstruction(caldata,planarjob,rectype)
%This function does both Soloff and Willert Reconstructions
%
%Inputs:-
%caldata=calibration job structure
%planarjob=prana 2d job structure
%rectype{1}='Willert'; rectype{2}='Soloff' 
%diroutlist=output directorylist where all the processings and different
%vector fields are stored.
%scaling=magnifications for soloff and willert based on dewarped grid
% 
% 
%set pulsesep in prana laser pulse separation box in Prana while setting the 2D job 
% 
% 

pulsesep=str2double(planarjob.wrsep)*(1e-6);
planarjob.wrsep='1';
% pulsesep
% planarjob.wrsep
%Planar Field Calculation
if strcmp(rectype{1},'Willert')
    fprintf('Processing for Geometric Reconstruction... \n');
    %Dewarp the camera images
    [dewarpdirlist,dewarp_grid,wil_scaling]=imagedewarp(caldata,'Willert',planarjob);
    %2D processing for camera1    
    job1=planarjob;
    job1.imdirec=dewarpdirlist.dewarpdir1;
    job1.imbase=planarjob.imbase;
    mkdir(fullfile(job1.outdirec,rectype{1},['Camera',num2str(caldata.camnumber(1)),filesep]));
    job1.outdirec=fullfile(job1.outdirec,rectype{1},['Camera',num2str(caldata.camnumber(1)),filesep]);    
    diroutlist.willert2dcam1=job1.outdirec;
    fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(1)),'\n']);
    pranaPIVcode(job1);
    clear job1;
    %2D processing for camera2
    job1=planarjob;
    job1.imdirec=dewarpdirlist.dewarpdir2;
    job1.imbase=planarjob.imbase2;
    
    if ~exist(fullfile(job1.outdirec,rectype{1},['Camera',num2str(caldata.camnumber(2)),filesep]),'dir')
        mkdir(fullfile(job1.outdirec,rectype{1},['Camera',num2str(caldata.camnumber(2)),filesep]));
    end
    
    job1.outdirec=fullfile(job1.outdirec,rectype{1},['Camera',num2str(caldata.camnumber(2)),filesep]);    
    diroutlist.willert2dcam2=job1.outdirec;
    fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(2)),'\n']);
    pranaPIVcode(job1);
    clear job1;
    
    mkdir(fullfile(planarjob.outdirec,rectype{1},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]));
    diroutlist.willert3cfields=fullfile(planarjob.outdirec,rectype{1},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]);    
    
    %stereo reconstruction
    fprintf('\n Doing Geometric Stereo Reconstructions.... \n')
    willert_vec_reconstruct_new(diroutlist,caldata,dewarp_grid,wil_scaling,pulsesep);
    scaling.wil=wil_scaling;
    %keyboard;
end


if strcmp(rectype{2},'Soloff')
    fprintf('Processing for Genaralized Reconstruction... \n');
    %2D processing for camera1
    job1=planarjob;
    job1.imdirec=planarjob.imdirec;
    job1.imbase=planarjob.imbase;
    
    if ~exist(fullfile(job1.outdirec,rectype{2},['Camera',num2str(caldata.camnumber(1)),filesep]),'dir')
        mkdir(fullfile(job1.outdirec,rectype{2},['Camera',num2str(caldata.camnumber(1)),filesep]));
    end
    
    job1.outdirec=fullfile(job1.outdirec,rectype{2},['Camera',num2str(caldata.camnumber(1)),filesep]);    
    diroutlist.soloff2dcam1=job1.outdirec;
    fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(1)),'\n']);
    pranaPIVcode(job1);
    
    clear job1;
    %2D processing for camera2
    job1=planarjob;
    job1.imdirec=planarjob.imdirec2;
    job1.imbase=planarjob.imbase2;
    mkdir(fullfile(job1.outdirec,rectype{2},['Camera',num2str(caldata.camnumber(2)),filesep]));
    job1.outdirec=fullfile(job1.outdirec,rectype{2},['Camera',num2str(caldata.camnumber(2)),filesep]);    
    diroutlist.soloff2dcam2=job1.outdirec;
    fprintf(['\nProcessing Planar Fields for Camera:',num2str(caldata.camnumber(2)),'\n']);
    pranaPIVcode(job1);
    
    mkdir(fullfile(planarjob.outdirec,rectype{2},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]));
    diroutlist.soloff3cfields=fullfile(planarjob.outdirec,rectype{2},['Camera',num2str(caldata.camnumber(1)),'Camera',num2str(caldata.camnumber(2)),'_3Cfields',filesep]);    
    
    %stereo reconstruction
    fprintf('\n Doing Generalized Stereo Reconstructions.... \n')
    [sol_scaling]=soloff_vec_reconstruction(diroutlist,caldata,pulsesep);
    scaling.sol=sol_scaling;
    
end    
    


end
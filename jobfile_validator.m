function [Data] = jobfile_validator(Data)

%Attempt to make backwards-compatible with older
%versions of prana
if ~isfield(Data,'version')
    if ~isfield(Data,'par')
        Data.par='0';
        Data.parprocessors='1';
        Data.version='1.5';
        
    else
        handles.data.version='1.9';
    end
end
if ~isfield(Data.PIV0,'zeromean')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.zeromean=''0'';']);
        eval(['Data.PIV',num2str(pass),'.peaklocator=''1'';']);
    end
end
if ~isfield(Data,'channel')
    Data.channel = 1;
end
if ~isfield(Data.PIV0,'frac_filt')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.frac_filt=''1'';']);
        if str2double(eval(['Data.PIV' num2str(pass) '.corr'])) == 3
            eval(['Data.PIV',num2str(pass),'.corr=''5'';']);
        end
    end
end
if ~isfield(Data.PIV0,'deform_min')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.deform_min=''1'';']);
        eval(['Data.PIV',num2str(pass),'.deform_max=''1'';']);
        eval(['Data.PIV',num2str(pass),'.deform_conv=''0.1'';']);
    end
end

if ~isfield(Data.PIV0,'saveplane')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.saveplane=''0'';']);
    end
end

% This performs a check to see if the job files
% contains the field 'outputpassbase' if not then it
% used the output name from the final pass.
if ~isfield(Data,'outputpassbase')
    eval(['Data.outputpassbase = Data.PIV' Data.passes '.outbase;']);
end

if ~isfield(Data,'ID')
    Data.runPIV = '1';
    
    load defaultsettings.mat defaultdata
    Data.ID=defaultdata.ID;
    Data.Size=defaultdata.Size;
    Data.Track=defaultdata.Track;
    
    if ispc
        Data.ID.save_dir        = [Data.outdirec,'\ID\'];
        Data.Size.save_dir      = [Data.outdirec,'\Size\'];
        Data.Track.save_dir     = [Data.outdirec,'\Track\'];
        Data.Track.PIVprops.load_dir       = [Data.outdirec,'\'];
    else
        Data.ID.save_dir        = [Data.outdirec,'/ID/'];
        Data.Size.save_dir      = [Data.outdirec,'/Size/'];
        Data.Track.save_dir     = [Data.outdirec,'/Track/'];
        Data.Track.PIVprops.load_dir       = [Data.outdirec,'/'];
    end
end

end
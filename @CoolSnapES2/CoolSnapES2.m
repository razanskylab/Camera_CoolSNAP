% File: CoolSnapES2.m @ CoolSnapES2
% Author: Urs Hofmann
% Mail: hofmannu@biomed.ee.ethz.ch
% Date: 22 Feb 2019
% Version: 1.0

% Description: Controls the camera CoolSnapES2 using MATLAB image acquisition
% toolbox

% How to install: 

classdef CoolSnapES2 < handle

	properties
		src;  % i dont know why we need cam and src but seems to be a matlab 
				% thing
		cam;  % variable used to store hardware interface
		exposuretime(1, 1);  % exposure time in ms
		nX;  % number of pixels in x direction 
		nY;  % number of pixels in y direction
		frame(:, :);
		flagDisplay(1, 1) logical = 1;
		flagVerbose(1, 1) logical = 1;
		thresSatPixel(1, 1) single = 1e-2;
		maxVal(1, 1) = intmax('uint16'); % saturation limit of camera
	end

	properties(Dependent)
		data; % synonym for frame
	end

	methods

		% Class constructor 
		function CoolSnapES2 = CoolSnapES2()
			fprintf('[CoolSnapES2] Creating new camera instance.\n');

			% open hardware connection to camera
			CoolSnapES2.cam = videoinput('pmimaq_2017b'); %pmimaq_2017b, 1, 'PM-Cam 1392x1040');
			CoolSnapES2.src = getselectedsource(CoolSnapES2.cam);
			CoolSnapES2.cam.FramesPerTrigger = 1;

			% get resolution of resulting images
			temp = CoolSnapES2.cam.VideoResolution;
			CoolSnapES2.nX = temp(1);
			CoolSnapES2.nY = temp(2);
			clear temp;

			% get initial exposure time from camera
			CoolSnapES2.exposuretime = CoolSnapES2.src.Exposure;
		end

		% destructor
		function delete(CoolSnapES2)
			% free memory allocated for camera
			delete(CoolSnapES2.cam);
		end

		% Set exposure time
		function set.exposuretime(cam, et)
			fprintf(['[CoolSnapES2] Setting exposure time to ',...
				num2str(et), ' ms.\n']);
			cam.src.Exposure = et;
		end

		% get exposure time
		function et = get.exposuretime(cam)
			et = cam.src.Exposure;
		end

		function data = get.data(cam)
			data = cam.frame;
		end

		% externally defined function
		Display(cam); % acquires a single image and displays 
		Adjust_Exposure_Time(cam, varargin);
		VPrintf(cam, textMsg, flagName);

		% opens a live window
		function Live(cam)
			preview(cam.cam);
		end
	end

end
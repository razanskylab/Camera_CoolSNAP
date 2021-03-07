% File: Adjust_Exposure_Time.m @ CoolSNAPES2
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 02.03.2021

% Description: adjusts the exposure time of the camera automatically

function Adjust_Exposure_Time(cam, varargin)
	
	% default arguments
	currEt = 200; % starting exposure time ms
	thresSatPixel = cam.thresSatPixel / 10; % percentage of staurated pixels allowed
	flagDisplay = cam.flagDisplay;

	for iargin=1:2:(nargin-1)
	    switch varargin{iargin}
	        case 'startExpTime'
	            currEt = varargin{iargin + 1};
	        case 'thresSatPixel'
	            thresSatPixel = varargin{iargin + 1};
	        case 'flagDisplay'
	            flagDisplay = varargin{iargin + 1};
	        otherwise
	            error('Invalid input argument passed');
	    end
	end

	cam.exposuretime = currEt;
	% Get min and max value of exposure time
	rangeEt.Minimum = 1;
	rangeEt.Increment = 1;
	rangeEt.Maximum = 10e3;

	stepSize = (currEt - rangeEt.Minimum)  / 2;
	done = 0;

	if flagDisplay
	    figure('Name', 'Automatic exposuretime adjustment');
	    cam.Acquire();
	    preview = imagesc(cam.data);
	    % colormap(cam.imscColors);
	    axis image;
	    caxis([0, cam.maxVal]);
	end

	iStep = 1;
	while (stepSize > rangeEt.Increment)

	    cam.Acquire();

	    % Update preview
	    if (flagDisplay)
	        set(preview, 'cdata', cam.data);
	        drawnow();
	    end

	    % check for satuation
	    satPixel = single(cam.data(:) >= cam.maxVal);
	    nSatPixel = sum(satPixel(:));
	    nPixel = size(cam.data, 1) * size(cam.data, 2);
	    percSatPixel(iStep) = nSatPixel / nPixel * 100;
	    expTime(iStep) = currEt;

	    if (percSatPixel(iStep) > thresSatPixel)
	        dir = -1;
	    else
	        dir = 1;
	    end

	    currEt = currEt + stepSize * dir;

	    % only decrease step size if we are in the right region
	    if (percSatPixel(iStep) < thresSatPixel)
	        stepSize = stepSize * 0.5;
	    end
	    cam.exposuretime = currEt;

	    iStep = iStep + 1;

	end
	cam.VPrintf('done\n', 0);

end
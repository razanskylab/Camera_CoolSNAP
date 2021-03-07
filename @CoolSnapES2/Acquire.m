% File: Acquire.m @ CoolSnapES2
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 02.03.2021

function frame = Acquire(cam)
	cam.frame = getsnapshot(cam.cam);
	frame = cam.frame;
end
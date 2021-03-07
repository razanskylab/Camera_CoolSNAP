% File: Display.m @ CoolSNAPES2
% Author: Urs Hofmann
% Mail: hofmannu@ethz.ch
% Date: 02.03.20201

% Description: Acquires a single snapshot and displays

function Display(cam)
	frame = cam.Acquire();

	figure();
	imagesc(frame);
	axis image;
	xlabel('x');
	ylabel('y');
	title('Snapshot - CoolSnapES2');
	colormap(bone(1024))
	colorbar

end
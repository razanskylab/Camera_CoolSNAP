% File: Vrpintf.m @ CoolSnapES2
% Author: Urs Hofmann
% Mail: hfomannu@ethz.ch
% Date: 02.03.2021

function VPrintf(cam, textMsg, flagName)

	if cam.flagVerbose
		if flagName
			textMsg = ['[CoolSnapES2] ', textMsg];
		end
		fprintf(textMsg);
	end
end
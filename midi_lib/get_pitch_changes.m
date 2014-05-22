function changes = get_pitch_changes(file_name)
% Gets the pitch wheel changes in a midi file.
%
%   changes = get_pitch_changes(file_name)
%
% INPUTS:
%   file_name - the name of the midi file
%
% OUTPUTS:
%   changes - an Nx5 array of the pitch wheel changes.  Each row
%     is a single pitch wheel change.  The columns are:
%        (1) the value of the pitch wheel in semitones (-2..2)
%        (2) the time of the command in beats
%        (3) the time of the command in seconds
%        (4) the track number
%        (5) the channel
%
% 2010-05-03 Christine Smit csmit@ee.columbia.edu
% Released under the GNU Public License v. 3


import edu.columbia.ee.csmit.MidiKaraoke.read.*;
import java.io.File;
import javax.sound.midi.*;

midiFile = File(file_name);
seq = MidiSystem.getSequence(midiFile);

% get the number of ticks/quarter note, which I assume is the
% 'beat' in the nm
ticksPerQuarterNote = seq.getResolution();

changesInMidi =  PitchWheelChangeViewParser.parse(seq);

changes = changesInMidi.getPitchWheelChangesDoubles();

% convert the pitch wheel to semitones, 0x0000..0x4000 becomes -2 .. 2
changes(:,1) = (changes(:,1) - 8192)/4096;
% convert the ticks to beats...
changes(:,2) = changes(:,2)./ticksPerQuarterNote;
% add 1 to the track number
changes(:,4) = changes(:,4)+1;
% add 1 to the channel numbers
changes(:,5) = changes(:,5)+1;


end
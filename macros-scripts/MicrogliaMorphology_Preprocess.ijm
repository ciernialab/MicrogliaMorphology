//// MicrogliaMorphology preprocessor
//// Batch-converts multi-channel z-stacks (e.g. .oir) to single-channel 2D .tif
//// suitable as input to MicrogliaMorphology_Program.ijm.
////
//// For each file in the input directory:
////   1. Open (Bio-Formats handles .oir, .czi, .nd2, etc.)
////   2. Delete all channels except the chosen microglia channel
////   3. Optionally Max-Intensity Z-project across slices
////   4. Save as <basename>.tif in the output directory

// dialog
Dialog.create("MicrogliaMorphology Preprocess");
Dialog.addMessage("Batch channel-select + Z-project for multi-channel z-stacks.");
Dialog.addNumber("Microglia channel (1-indexed):", 1, 0, 3, "");
Dialog.addCheckbox("Max-Intensity Z-project multi-slice stacks?", true);
Dialog.addCheckbox("Skip files that already exist in output folder?", true);
Dialog.show();

microglia_channel = Dialog.getNumber();
do_z_project = Dialog.getCheckbox();
skip_existing = Dialog.getCheckbox();

input_dir = getDirectory("Choose input folder");
output_dir = getDirectory("Choose output folder for projected .tif files");

files = getFileList(input_dir);
files = Array.sort(files);

setBatchMode(true);
run("Text Window...", "name=[Progress] width=70 height=3");

skipped = newArray();
for (i = 0; i < files.length; i++) {
	filename = files[i];
	if (endsWith(filename, "/") || startsWith(filename, ".")) continue;

	out_name = File.getNameWithoutExtension(input_dir + filename) + ".tif";
	out_path = output_dir + out_name;

	if (skip_existing && File.exists(out_path)) {
		print("[Progress]", "\\Update:" + (i + 1) + "/" + files.length + ": " + filename + " (exists, skipped)");
		continue;
	}

	print("[Progress]", "\\Update:" + (i + 1) + "/" + files.length + ": " + filename);

	open(input_dir + filename);
	if (nImages == 0) {
		skipped = Array.concat(skipped, filename + " (failed to open)");
		continue;
	}

	getDimensions(width, height, channels, slices, frames);

	if (microglia_channel > channels) {
		skipped = Array.concat(skipped, filename + " (only " + channels + " channels)");
		close("*");
		continue;
	}

	if (channels > 1) {
		for (c = channels; c > 0; c--) {
			Stack.setChannel(c);
			if (c != microglia_channel) {
				run("Delete Slice", "delete=channel");
			}
		}
	}

	if (do_z_project) {
		getDimensions(width, height, channels, slices, frames);
		if (slices > 1) {
			original_title = getTitle();
			run("Z Project...", "projection=[Max Intensity]");
			close(original_title);
		}
	}

	saveAs("Tiff", out_path);
	close("*");
}

setBatchMode(false);
print("[Progress]", "\\Update:Done. " + files.length + " files processed.");

if (skipped.length > 0) {
	print("Files skipped:");
	for (i = 0; i < skipped.length; i++) {
		print("  " + skipped[i]);
	}
}

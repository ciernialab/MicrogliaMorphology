// STEP 1a. Specifying final dataset-specific parameters: thresholding 

		//use file browser to choose test image
		path = File.openDialog("Open your test image");
		open(path);

		// run steps up until thresholding step
				// THRESHOLD IMAGE AND CLEAN UP FOR DOWNSTREAM PROCESSING IN ANALYZESKELETON
				run("8-bit");
				// convert to grayscale to best visualize all positive staining
				run("Grays");
				// adjust the brighness and contrast to make sure you can visualize all microglia processes
				// in ImageJ, B&C are changed by updating the image's lookup table, so pixel values are unchanged
				run("Brightness/Contrast...");
				run("Enhance Contrast", "saturated=0.35");
				// run Unsharp Mask filter to further increase contrast of image using default settings
				// this mask does not create details, but rather clarifies existing detail in image
				run("Unsharp Mask...", "radius=3 mask=0.60");
				// use despeckle function to remove salt&pepper noise generated by unsharp mask filter
				run("Despeckle");
				selectWindow("B&C");
	    		run("Close");
		
		// prompt user to use BioVoxxel plugin to figure out thresholding
	    Dialog.create("MicrogliaMorphology");
	    Dialog.addMessage("Use BioVoxxel plugin to figure out optimal thresholding parameters. Note your final parameter decisions.");
		Dialog.show();
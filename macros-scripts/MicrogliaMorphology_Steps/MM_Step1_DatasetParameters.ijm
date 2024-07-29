//// Microglia Morphology ImageJ macro
//// STEP 1: Determining dataset-specific parameters to use
//// Created by Jenn Kim on September 18, 2022
//// Updated July 29, 2024

// FUNCTIONS

// Auto thresholding 
function thresholding(input, output, filename) {
		print(input + filename);
		open(input + filename);
	
		// MEASURE AREA
		run("Set Measurements...", "area display redirect=None decimal=9");
		run("Measure");
		
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
		run("Auto Threshold", "method=&auto_method ignore_black white");
		if (roichoice){
			// exclude anything not within roi
			setBackgroundColor(0, 0, 0); 
			run("Clear Outside"); 
		}
		// use despeckle function to remove remaining single-pixel noise generated by thresholding
		run("Despeckle");
		// apply close function to connect any disconnected cell processes back to the rest of the cell
		// this function connects two dark pixels if they are separated by up to 2 pixels
		run("Close-");
		// after closing up cells, remove any outliers
		// replaces a bright or dark outlier pixel by the median pixels in the surrounding area if it deviates by more than the threshold value specified
		// here, bright outliers are targeted with pixel radius 2 and threshold of 50
		run("Remove Outliers...", "radius=2 threshold=50 which=Bright");
		// save thresholded + cleaned image -- this is the input for skeleton analysis below
		saveAs("Tiff", output + filename + "_thresholded");
		
		close();
	}
	
// Auto local thresholding 
function thresholding2(input, output, filename) {
		print(input + filename);
		open(input + filename);
		
		// MEASURE AREA
		run("Set Measurements...", "area display redirect=None decimal=9");
		run("Measure");
	
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
		run("Auto Local Threshold", "method=&autolocal_method radius=&autolocal_radius parameter_1=0 parameter_2=0 white");
		if (roichoice){
			// exclude anything not within roi
			setBackgroundColor(0, 0, 0); 
			run("Clear Outside"); 
		}
		// use despeckle function to remove remaining single-pixel noise generated by thresholding
		run("Despeckle");
		// apply close function to connect any disconnected cell processes back to the rest of the cell
		// this function connects two dark pixels if they are separated by up to 2 pixels
		run("Close-");
		// after closing up cells, remove any outliers
		// replaces a bright or dark outlier pixel by the median pixels in the surrounding area if it deviates by more than the threshold value specified
		// here, bright outliers are targeted with pixel radius 2 and threshold of 50
		run("Remove Outliers...", "radius=2 threshold=50 which=Bright");
		// save thresholded + cleaned image -- this is the input for skeleton analysis below
		saveAs("Tiff", output + filename + "_thresholded");
		
		close();
	}


// choices in drop-down prompts for MicrogliaMorphology macro
thresholding_approach = newArray("Auto thresholding", "Auto local thresholding");
thresholding_parameters = newArray("Huang","Huang2","Intermodes","IsoData","Li","MaxEntropy","Mean","MinError(I)","Minimum","Moments","Otsu","Percentile","RenyiEntropy","Shanbhag","Triangle","Yen")
thresholding_parameters2 = newArray("Bernsen","Contrast","Mean","Median","MidGrey","Niblack","Otsu","Phansalkar","Sauvola");



// MACRO STARTS HERE

//Welcome message
		Dialog.create("MicrogliaMorphology");
		Dialog.addMessage("Welcome to Microglia Morphology!");
		Dialog.addMessage("We will first specify some dataset-specific parameters before running MicrogliaMorphology.");
		Dialog.addMessage("Please make sure to use the BioVoxxel ImageJ plugin to determine your thresholding parameters prior to this step.");
		Dialog.addMessage("If you have not done this yet, please do so first and come back to MicrogliaMorphology. If you have, continue on :");
		Dialog.show();

// STEP 1a. Specifying final dataset-specific parameters: thresholding
			
		//dialog box
		Dialog.create("MicrogliaMorphology");
		Dialog.addChoice("Are you using auto thresholding or auto local thresholding?", thresholding_approach);
		Dialog.addMessage("If you are using auto thresholding:");
		Dialog.addChoice("Which method is best for your dataset?", thresholding_parameters);
		Dialog.addMessage("If you are using auto local thresholding:");
		Dialog.addChoice("Which method is best for your dataset?", thresholding_parameters2);
		Dialog.addNumber("Radius:", 100);
		Dialog.addCheckbox("Does your test image have ROIs traced?", true);
		Dialog.addMessage("Next, let's determine the area range of a single microglial cell using a test image.");
		Dialog.show();	
		
		auto_or_autolocal = Dialog.getChoice();
		auto_method = Dialog.getChoice();
		autolocal_method= Dialog.getChoice();
		autolocal_radius = Dialog.getNumber();
		roichoicetest=Dialog.getCheckbox();


// STEP 1b. Determining single cell area range using test image
		
		//use file browser to choose test image
		path = File.openDialog("Open your test image");
		open(path);
			
		// Apply all steps before you would get to single cell extractions	
			if(auto_or_autolocal == "Auto thresholding"){
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
				run("Auto Threshold", "method=&auto_method ignore_black white");
				if (roichoicetest){
					// exclude anything not within roi
					setBackgroundColor(0, 0, 0); 
					run("Clear Outside"); 
				}				
				// use despeckle function to remove remaining single-pixel noise generated by thresholding
				run("Despeckle");
				// apply close function to connect any disconnected cell processes back to the rest of the cell
				// this function connects two dark pixels if they are separated by up to 2 pixels
				run("Close-");
				// after closing up cells, remove any outliers
				// replaces a bright or dark outlier pixel by the median pixels in the surrounding area if it deviates by more than the threshold value specified
				// here, bright outliers are targeted with pixel radius 2 and threshold of 50
				run("Remove Outliers...", "radius=2 threshold=50 which=Bright");
				
				// analyze particles
				run("Set Measurements...", "area display redirect=None decimal=3");
				run("Analyze Particles...", "pixel add");
				roiManager("Show All");
			}
		
			if(auto_or_autolocal == "Auto local thresholding"){
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
				run("Auto Local Threshold", "method=&autolocal_method radius=&autolocal_radius parameter_1=0 parameter_2=0 white");
				if (roichoicetest){
					// exclude anything not within roi
					setBackgroundColor(0, 0, 0); 
					run("Clear Outside"); 
				}					
				// use despeckle function to remove remaining single-pixel noise generated by thresholding
				run("Despeckle");
				// apply close function to connect any disconnected cell processes back to the rest of the cell
				// this function connects two dark pixels if they are separated by up to 2 pixels
				run("Close-");
				// after closing up cells, remove any outliers
				// replaces a bright or dark outlier pixel by the median pixels in the surrounding area if it deviates by more than the threshold value specified
				// here, bright outliers are targeted with pixel radius 2 and threshold of 50
				run("Remove Outliers...", "radius=2 threshold=50 which=Bright");
				
				// analyze particles
				run("Set Measurements...", "area display redirect=None decimal=3");
				run("Analyze Particles...", "pixel add");
				roiManager("Show All");
			}		
				
		waitForUser("Select a particle that you would consider TOO SMALL to be a single microglia cell and click letter m on your keyboard to measure its area. Do this a total of 5 times. Don't click OK until you're done with this!");
		run("Summarize");
		area_min = getResult("Area");
		
		selectWindow("Results");
		run("Close");
		waitForUser("Select a particle that you would consider TOO BIG to be a single microglia cell and click letter m on your keyboard to measure its area. Do this a total of 5 times. Don't click OK until you're done with this!");
		run("Summarize");
		//number_rows = nResults;
		area_max = getResult("Area", nResults-2);
		
		// close everything before starting with rest of macro
		selectWindow("Results");
		run("Close");
		selectImage(nImages());
		run("Close");
		selectWindow("ROI Manager");
	    run("Close");
	    selectWindow("B&C");
	    run("Close");
	    
	    // conditional printing for saving final parameters
		if(auto_or_autolocal == "Auto thresholding"){
			finalprint = auto_method;
		}
		if(auto_or_autolocal == "Auto local thresholding"){
			finalprint = autolocal_method + ", radius = " + autolocal_radius;
		}

	    // save final image set parameters to .txt file
	    output2=File.getParent(path);
	    f = File.open(output2 + "/FinalDatasetParameters.txt");
	    print(f, auto_or_autolocal + " \n" + 
	    		 "Thresholding method = " + finalprint + " \n" +
	    		 "Lower cell area filter = " + area_min + " \n" + 
	    		 "Upper cell area filter = " + area_max);
	    File.close(f);
		
// Progress message: print summary statement of parameters
		Dialog.create("MicrogliaMorphology");
		Dialog.addMessage("Here is a summary of your dataset-specific parameters that will be applied in MicrogliaMorphology");
		Dialog.addMessage("AUTO THRESHOLDING OR AUTO LOCAL THRESHOLDING?");
		Dialog.addMessage(auto_or_autolocal);
		
		if(auto_or_autolocal == "Auto thresholding"){
			Dialog.addMessage("METHOD:");
			Dialog.addMessage(auto_method);
		}
		
		if(auto_or_autolocal == "Auto local thresholding"){
			Dialog.addMessage("METHOD:");
			Dialog.addMessage(autolocal_method);
			Dialog.addMessage("RADIUS:");
			Dialog.addMessage(autolocal_radius);
			}
		
		Dialog.addMessage("LOWER CELL AREA FILTER:");
		Dialog.addMessage(area_min);
		Dialog.addMessage("UPPER CELL AREA FILTER:");
		Dialog.addMessage(area_max);
		Dialog.show();
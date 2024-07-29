//// Microglia Morphology ImageJ macro
//// STEP 3: Generate single-cell images
//// Created by Jenn Kim on September 18, 2022
//// Updated July 29, 2024

// FUNCTIONS

//Generating Single Cell ROIs from thresholded images
function cellROI(input, output, filename, min, max){
		print(input + filename);
    	open(input + filename);
    	
    	mainTitle=getTitle();
		dirCropOutput=output;
		
	    run("ROI Manager...");
	    roiManager("Show All");
		roiManager("Deselect");
		run("Set Measurements...", "area display redirect=None decimal=3");

		run("Analyze Particles...", "pixel add");
		roiManager("Show All");
		roiManager("Measure");	
				
		for (i = 0; i < nResults(); i++) {
		//for (i = 0; i < 5; i++) {
			selectWindow("Results");
			v = getResult('Area', i);
			
			if((min < v) && (v < max)){
				selectWindow("Results");
				label = getResultString("Label", i);
				label = label.replace(':','_');
				roiManager("Select", i);
				run("Duplicate...", "title=&label");
				setBackgroundColor(0, 0, 0);
				run("Clear Outside");
				saveAs("Tiff", dirCropOutput+File.separator+label+".tif");
				print(label);
				selectWindow(label+".tif");
				run("Close");				
			}
		}
		selectWindow(mainTitle);
		run("Close");
		selectWindow("Results");
	   	run("Close");
	    selectWindow("ROI Manager");
	    run("Close");
    }


// MACRO STARTS HERE

// Progress message
		Dialog.create("MicrogliaMorphology");
		Dialog.addMessage("Now that we are done thresholding,");
		Dialog.addMessage("we will generate single-cell ROIs");
		Dialog.addNumber("What is your lower cell area filter?", 0);
		Dialog.addNumber("What is your upper cell area filter?", 10);		
		Dialog.show();
		
		area_min = Dialog.getNumber();
		area_max = Dialog.getNumber();
		
// STEP 3. Generating single-cell ROIs command

  		//use file browser to choose path and files to run plugin on
		setOption("JFileChooser",true);
		thresholded_dir=getDirectory("Choose parent folder containing thresholded images");
		thresholded_input=getFileList(thresholded_dir);
		count=thresholded_input.length;
	
		//use file browser to choose path and files to run plugin on
		setOption("JFileChooser",true);
		cellROI_output=getDirectory("Choose output folder to write single cell images to");
		
		//dialog box
		Dialog.create("MicrogliaMorphology");
		Dialog.addMessage("Processing files from directory:");
		parentname=split(thresholded_dir,"/");
		Dialog.addMessage(parentname[(parentname.length)-1]);
		Dialog.addMessage("which has this many images:");
		Dialog.addMessage(count);
		Dialog.addMessage("Select range of images you'd like to analyze");
		Dialog.addNumber("Start at Image:", 1);
		Dialog.addNumber("Stop at Image:", 1);
		Dialog.show();
		
		startAt=Dialog.getNumber();
		endAt=Dialog.getNumber();
		
		setBatchMode("show");
		for (i=(startAt-1); i<(endAt); i++){
				cellROI(thresholded_dir, cellROI_output, thresholded_input[i], area_min, area_max);
		}
		//setBatchMode(false);
		
	    print("Finished generating single cell ROIs");
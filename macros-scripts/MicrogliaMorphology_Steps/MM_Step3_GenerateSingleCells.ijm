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
		
		if (nResults > 0) {
			selectWindow("Results");
			area = Table.getColumn("Area");
			label = Table.getColumn("Label");
			close("Results");
			Array.print(area); 	
			for (i = 0; i < area.length; i++) {
		
				if((min < area[i]) && (area[i] < max)){
					label_temp = label[i];
					label_temp = label_temp.replace(':','_');
					roiManager("Select", i);
					run("Duplicate...", "title=" + label_temp);
					setBackgroundColor(0, 0, 0);
					run("Clear Outside");
					saveAs("Tiff", dirCropOutput+File.separator+label_temp+".tif");
					print(label_temp);
					print(i + "/" + area.length);
					close(label_temp+".tif");
				}
			}
			return "" ;
		} 
else {
			print("A problem occured in image " +  filename + ".");
			return(filename);
		}
		close(filename);
		roiManager("reset");
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
		
		setBatchMode(true);
		skipped_files = newArray();
		for (i=(startAt-1); i<(endAt); i++){
				skipped_files = Array.concat(skipped_files, cellROI(thresholded_dir, cellROI_output, thresholded_input[i], area_min, area_max));
		}
		skipped_files = Array.deleteValue(skipped_files, "");
		setBatchMode(false);
		

	    print("Finished generating single cell ROIs. The following files were skipped: " + String.join(skipped_files, " "));

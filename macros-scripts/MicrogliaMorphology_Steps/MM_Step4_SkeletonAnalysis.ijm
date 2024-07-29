//// Microglia Morphology ImageJ macro
//// STEP 4: Skeleton Analysis
//// Created by Jenn Kim on September 18, 2022
//// Updated July 29, 2024

// FUNCTIONS

// Skeletonize/AnalyzeSkeleton
function skeleton(input, output, output2, filename) {
        print(input + filename);
        open(input + filename);

	      // SKELETON ANALYSIS !!
	      // Skeletonize your thresholded image
	      // this process basically systematically cuts down your thresholded processes from all sides into one single trace
	      run("Skeletonize (2D/3D)");
	      // run the AnalyzeSkeleton(2D/3D) plugin 
	      // this plugin will take your skeletonized cells and tag them with useful information (junctions, length, triple/quadruple points, etc.)
	      run("Analyze Skeleton (2D/3D)", "prune=none");
	      // summarize output across all cells and append to end of output data file
	      run("Summarize");
	      // save results
	      saveAs("Results", output + filename + "_results.csv");
	      // save tagged skeleton 
	      saveAs("Tiff", output2 + filename + "_taggedskeleton");
	      //close open windows
	      close();
	      close();
    }


// MACRO STARTS HERE

// Progress message
		Dialog.create("MicrogliaMorphology");
		Dialog.addMessage("Now that we are done generating single-cell ROIs,");
		Dialog.addMessage("we will analyze their skeletons");
		Dialog.show();

// STEP 4. Skeletonize/AnalyzeSkeleton
        
        //use file browser to choose path and files to run plugin on
		setOption("JFileChooser",true);
		cell_dir=getDirectory("Choose parent folder containing single-cell images");
		cell_input=getFileList(cell_dir);
		cell_count=cell_input.length;
	
		//use file browser to choose path and files to run plugin on
		setOption("JFileChooser",true);
		skeleton_output=getDirectory("Choose output folder to write skeleton results to");
		
		//use file browser to choose path and files to run plugin on
		setOption("JFileChooser",true);
		skeleton2_output=getDirectory("Choose output folder to write skeletonized images to");
		
		//dialog box
		Dialog.create("MicrogliaMorphology");
		Dialog.addMessage("Processing files from directory:");
		parentname=split(cell_dir,"/");
		Dialog.addMessage(parentname[(parentname.length)-1]);
		Dialog.addMessage("which has this many images:");
		Dialog.addMessage(cell_count);
		Dialog.addMessage("Select range of cell images you'd like to analyze");
		Dialog.addNumber("Start at Image:", 1);
		Dialog.addNumber("Stop at Image:", 1);
		Dialog.show();
		
		startAt=Dialog.getNumber();
		endAt=Dialog.getNumber();
       
    	setBatchMode("show");
		for (i=(startAt-1); i<(endAt); i++){
				skeleton(cell_dir, skeleton_output, skeleton2_output, cell_input[i]);
		}
		
		print("Finished Analyzing Skeletons");
	    print("done!");